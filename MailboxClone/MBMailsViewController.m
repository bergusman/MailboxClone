//
//  MBMailsViewController.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMailsViewController.h"
#import "MBMailCell.h"
#import "MBMailbox.h"

@interface MBMailsViewController () <
    UITableViewDataSource,
    UITableViewDelegate,
    MBMailCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIImageView *backgroundLogo;

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) UIImage *rightImage;
@property (nonatomic, strong) UIColor *leftColor;
@property (nonatomic, strong) UIColor *rightColor;

@property (nonatomic, assign) MBMailsType leftType;
@property (nonatomic, assign) MBMailsType rightType;

@end

@implementation MBMailsViewController {
    UISearchDisplayController *s;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addMailNotification:)
                                                     name:MBMailboxDidAddMailNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = YES;
    self.view.backgroundColor = MB_RGB(227, 227, 227);
    
    self.backgroundLogo = [[UIImageView alloc] init];
    [self.view addSubview:self.backgroundLogo];
    [self setupBackgroundLogo];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.frame = self.view.bounds;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 86;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView *topTableBackground = [[UIView alloc] init];
    topTableBackground.backgroundColor = MB_RGB(210, 212, 212);
    topTableBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGFloat h = self.tableView.bounds.size.height * 1.5;
    topTableBackground.frame = CGRectMake(0, -h + 1, self.tableView.bounds.size.width, h);
    [self.tableView addSubview:topTableBackground];
    
    self.calendar = [NSCalendar currentCalendar];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bingo:(id)vc {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar;
    s = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:vc];
    searchBar.tintColor = MB_RGB(210, 210, 210);

    // Hack
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDate *currentDate = [NSDate date];
    NSUInteger components = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [self.calendar components:components fromDate:date];
    NSDateComponents *currentDateComponents = [self.calendar components:components fromDate:currentDate];
    
    if (dateComponents.year == currentDateComponents.year) {
        if (dateComponents.month == currentDateComponents.month &&
            dateComponents.day == currentDateComponents.day)
        {
            self.dateFormatter.dateFormat = @"h:mm a";
        } else {
            self.dateFormatter.dateFormat = @"MMM d";
        }
    } else {
        self.dateFormatter.dateFormat = @"MMM d, yyyy";
    }
    
    return [self.dateFormatter stringFromDate:date];
}

- (void)addMailNotification:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    MBMailsType type = [userInfo[MBMailboxToUserInfoKey] integerValue];
    if (type == self.type) {
        [self.tableView reloadData];
    }
}

#pragma mark - Mails Collection

- (NSInteger)mailCount {
    if (self.type == MBMailsTypeInbox) {
        return [[MBMailbox sharedMailbox].inboxMails count];
    } else if (self.type == MBMailsTypeArchived) {
        return [[MBMailbox sharedMailbox].archivedMails count];
    } else if (self.type == MBMailsTypeDefer) {
        return [[MBMailbox sharedMailbox].deferMails count];
    }
    return 0;
}

- (MBMail *)mailAtIndex:(NSInteger)index {
    if (self.type == MBMailsTypeInbox) {
        return [MBMailbox sharedMailbox].inboxMails[index];
    } else if (self.type == MBMailsTypeArchived) {
        return [MBMailbox sharedMailbox].archivedMails[index];
    } else if (self.type == MBMailsTypeDefer) {
        return [MBMailbox sharedMailbox].deferMails[index];
    }
    return nil;
}

#pragma mark - Setup Mails Type

- (void)setupBackgroundLogo {
    UIImage *image = nil;
    if (self.type == MBMailsTypeInbox) {
        image = [UIImage imageNamed:@"inbox-icon-background-overlay"];
    } else if (self.type == MBMailsTypeArchived) {
        image = [UIImage imageNamed:@"archive-empty-state-icon"];
    } else if (self.type == MBMailsTypeDefer) {
        image = [UIImage imageNamed:@"later-empty-state-icon"];
    }
    self.backgroundLogo.image = image;
    self.backgroundLogo.frame = CGRectMake((320 - image.size.width) / 2.0 + 0.5, 96, image.size.width, image.size.height);
}

- (void)setupCellParams {
    if (self.type == MBMailsTypeArchived) {
        self.leftImage = [UIImage imageNamed:@"swipe-defer-icon"];
        self.rightImage = [UIImage imageNamed:@"swipe-mailbox-icon"];
        self.leftColor = MB_RGB(255, 222, 71);
        self.rightColor = MB_RGB(81, 185, 219);
        self.leftType = MBMailsTypeDefer;
        self.rightType = MBMailsTypeInbox;
    } else if (self.type == MBMailsTypeDefer) {
        self.leftImage = [UIImage imageNamed:@"swipe-mailbox-icon"];
        self.rightImage = [UIImage imageNamed:@"swipe-archive-icon"];
        self.leftColor = MB_RGB(81, 185, 219);
        self.rightColor = MB_RGB(98, 217, 98);
        self.leftType = MBMailsTypeInbox;
        self.rightType = MBMailsTypeArchived;
    } else if (self.type == MBMailsTypeInbox) {
        self.leftImage = [UIImage imageNamed:@"swipe-archive-icon"];
        self.rightImage = [UIImage imageNamed:@"swipe-defer-icon"];
        self.leftColor = MB_RGB(98, 217, 98);
        self.rightColor = MB_RGB(255, 222, 71);
        self.leftType = MBMailsTypeArchived;
        self.rightType = MBMailsTypeDefer;
    }
}

- (void)setType:(MBMailsType)type {
    _type = type;
    [self setupBackgroundLogo];
    [self setupCellParams];
}

#pragma mark - MBMailCellDelegate

- (void)mailCellDidSlideFromLeft:(MBMailCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MBMail *mail = [self mailAtIndex:indexPath.row];
    [[MBMailbox sharedMailbox] deleteMail:mail from:self.type];
    [[MBMailbox sharedMailbox] addMail:mail to:self.leftType];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)mailCellDidSlideFromRight:(MBMailCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MBMail *mail = [self mailAtIndex:indexPath.row];
    [[MBMailbox sharedMailbox] deleteMail:mail from:self.type];
    [[MBMailbox sharedMailbox] addMail:mail to:self.rightType];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self mailCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"MailCell";
    MBMailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MBMailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
        cell.leftImage = self.leftImage;
        cell.rightImage = self.rightImage;
        cell.leftColor = self.leftColor;
        cell.rightColor = self.rightColor;
    }
    
    MBMail *mail = [self mailAtIndex:indexPath.row];
    cell.from = [mail.from nameString];
    cell.subject = mail.subject;
    cell.body = mail.body;
    cell.starred = mail.starred;
    cell.messages = mail.messages;
    cell.receivedAt = [self stringFromDate:mail.receivedAt];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

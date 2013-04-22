//
//  MBMainViewController.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/22/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBMailsViewController.h"
#import "MBSegmentedControl.h"

@interface MBMainViewController ()

@property (nonatomic, strong) MBMailsViewController *mails1;
@property (nonatomic, strong) MBMailsViewController *mails2;
@property (nonatomic, strong) MBMailsViewController *mails3;
@property (nonatomic, strong) NSArray *mailsControllers;
@property (nonatomic, assign) NSInteger lastSelectedSegmentIndex;

@end

@implementation MBMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MB_RGB(227, 227, 227);
    
    // Don't ask why I did it!
    UIImage *listImage = [UIImage imageNamed:@"nav-bar-list-button"];
    UIButton *listButton = [[UIButton alloc] init];
    [listButton setImage:listImage forState:UIControlStateNormal];
    listButton.frame = CGRectMake(6, 6, listImage.size.width, listImage.size.height);
    [self.navigationController.navigationBar addSubview:listButton];
    
    // Don't ask why I did it!
    UIImage *writeImage = [UIImage imageNamed:@"create-email-nav-bar-button"];
    UIButton *writeButton = [[UIButton alloc] init];
    [writeButton setImage:writeImage forState:UIControlStateNormal];
    writeButton.frame = CGRectMake(320 - writeImage.size.width - 5, 6, writeImage.size.width, writeImage.size.height);
    [writeButton addTarget:self action:@selector(clearMails:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:writeButton];
    
    MBSegmentedControl *segmentedControl = [[MBSegmentedControl alloc] init];
    [segmentedControl addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    self.mails1 = [[MBMailsViewController alloc] init];
    self.mails1.view.frame = self.view.bounds;
    self.mails1.type = MBMailsTypeDefer;
    [self.view addSubview:self.mails1.view];
    
    self.mails2 = [[MBMailsViewController alloc] init];
    self.mails2.view.frame = self.view.bounds;
    self.mails2.type = MBMailsTypeInbox;
    [self.view addSubview:self.mails2.view];
    
    self.mails3 = [[MBMailsViewController alloc] init];
    self.mails3.view.frame = self.view.bounds;
    self.mails3.type = MBMailsTypeArchived;
    [self.view addSubview:self.mails3.view];
    
    self.mailsControllers = @[self.mails1, self.mails2, self.mails3];
    
    segmentedControl.selectedSegmentIndex = 1;
    self.lastSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    
    self.mails1.view.hidden = YES;
    self.mails2.view.hidden = NO;
    self.mails3.view.hidden = YES;
    
    [self.mails1 bingo:self];
    [self.mails2 bingo:self];
    [self.mails3 bingo:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)typeAction:(MBSegmentedControl *)sender {
    [self transitionFrom:self.lastSelectedSegmentIndex to:sender.selectedSegmentIndex];
    self.lastSelectedSegmentIndex = sender.selectedSegmentIndex;
}

- (void)clearMails:(id)sender {
    [[MBMailbox sharedMailbox] clear];
    [[MBMailbox sharedMailbox] load];
}

- (void)transitionFrom:(NSInteger)from to:(NSInteger)to {
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionPush;
    transition.subtype = from > to ? kCATransitionFromLeft : kCATransitionFromRight;
    
    MBMailsViewController *currentMailsVC = self.mailsControllers[from];
    MBMailsViewController *nextMailsVC = self.mailsControllers[to];
    
    [currentMailsVC.view.layer addAnimation:transition forKey:@"transition"];
    [nextMailsVC.view.layer addAnimation:transition forKey:@"transition"];
    
    currentMailsVC.view.hidden = YES;
    nextMailsVC.view.hidden = NO;
}

@end

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

@interface MBMainViewController () <MBMailsViewControllerDelegate>

@property (nonatomic, strong) NSArray *mailsControllers;
@property (nonatomic, strong) MBSegmentedControl *segmentedControl;
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
    
    self.segmentedControl = [[MBSegmentedControl alloc] init];
    [self.segmentedControl addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    NSMutableArray *mailsVCs = [NSMutableArray arrayWithCapacity:3];
    NSArray *mailsTypes = @[@(MBMailsTypeDefer), @(MBMailsTypeInbox), @(MBMailsTypeArchived)];
    for (NSNumber *mailsType in mailsTypes) {
        MBMailsViewController *mailsVC = [[MBMailsViewController alloc] init];
        mailsVC.delegate = self;
        mailsVC.view.frame = self.view.bounds;
        mailsVC.type = [mailsType integerValue];
        [self.view addSubview:mailsVC.view];
        mailsVC.view.hidden = YES;
        [mailsVC setupSearchControllerWithContentController:self];
        [mailsVCs addObject:mailsVC];
    }
    
    self.mailsControllers = mailsVCs;
    
    self.segmentedControl.selectedSegmentIndex = 1;
    self.lastSelectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    
    MBMailsViewController *mailsVC = mailsVCs[self.segmentedControl.selectedSegmentIndex];
    mailsVC.view.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)transitionFrom:(NSInteger)from to:(NSInteger)to {
    CATransition *transition = [[CATransition alloc] init];
    transition.type = kCATransitionPush;
    transition.subtype = (from > to ? kCATransitionFromLeft : kCATransitionFromRight);
    
    MBMailsViewController *currentMailsVC = self.mailsControllers[from];
    MBMailsViewController *nextMailsVC = self.mailsControllers[to];
    
    [currentMailsVC.view.layer addAnimation:transition forKey:@"transition"];
    [nextMailsVC.view.layer addAnimation:transition forKey:@"transition"];
    
    currentMailsVC.view.hidden = YES;
    nextMailsVC.view.hidden = NO;
}

#pragma mark - Actions

- (void)changeType:(MBSegmentedControl *)sender {
    [self transitionFrom:self.lastSelectedSegmentIndex to:sender.selectedSegmentIndex];
    self.lastSelectedSegmentIndex = sender.selectedSegmentIndex;
}

- (void)clearMails:(id)sender {
    [[MBMailbox sharedMailbox] clear];
    [[MBMailbox sharedMailbox] load];
}

#pragma mark - MBMailsViewControllerDelegate 

- (void)mailsViewController:(MBMailsViewController *)mailsVC didMoveMailTo:(MBMailsType)to {
    if (to == MBMailsTypeDefer) {
        [self.segmentedControl blinkSegmentAtIndex:0];
    } else if (to == MBMailsTypeInbox) {
        [self.segmentedControl blinkSegmentAtIndex:1];
    } else if (to == MBMailsTypeArchived) {
        [self.segmentedControl blinkSegmentAtIndex:2];
    }
}

@end

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
    
    
    UIImage *image1 = [UIImage imageNamed:@"create-email-nav-bar-button"];
    UIButton *button4 = [[UIButton alloc] init];
    [button4 setImage:image1 forState:UIControlStateNormal];
    //button4.frame = CGRectMake(0, 0, image1.size.width, image1.size.height);
    button4.frame = CGRectMake(0, 0, image1.size.width, image1.size.height);
    
    //UIView *view2 = [[UIView alloc] init];
    //view2.bounds = button4.bounds;
    //[view2 addSubview:button4];
    //UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:view2];
    //self.navigationItem.rightBarButtonItem = item1;
    
    UIImage *image2 = [UIImage imageNamed:@"nav-bar-list-button"];
    UIButton *button5 = [[UIButton alloc] init];
    [button5 setImage:image2 forState:UIControlStateNormal];
    //button5.frame = CGRectMake(0, 0, image2.size.width + 2, image2.size.height);
    button5.frame = CGRectMake(6, 6, image2.size.width + 2, image2.size.height);
    [self.navigationController.navigationBar addSubview:button5];
    
    //UIView *view3 = [[UIView alloc] init];
    //view3.bounds = button5.bounds;
    //[view3 addSubview:button5];
    //UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:button5];
    //self.navigationItem.leftBarButtonItem = item2;
    
    
    MBSegmentedControl *segmentedControl = [[MBSegmentedControl alloc] init];
    [segmentedControl addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    
    self.mails1 = [[MBMailsViewController alloc] init];
    self.mails1.view.frame = self.view.bounds;
    [self.view addSubview:self.mails1.view];
    
    self.mails2 = [[MBMailsViewController alloc] init];
    self.mails2.view.frame = self.view.bounds;
    [self.view addSubview:self.mails2.view];
    
    self.mails3 = [[MBMailsViewController alloc] init];
    self.mails3.view.frame = self.view.bounds;
    [self.view addSubview:self.mails3.view];
    
    self.mailsControllers = @[self.mails1, self.mails2, self.mails3];
    
    segmentedControl.selectedSegmentIndex = 1;
    self.lastSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)typeAction:(MBSegmentedControl *)sender {
    [self transitionFrom:self.lastSelectedSegmentIndex to:sender.selectedSegmentIndex];
    self.lastSelectedSegmentIndex = sender.selectedSegmentIndex;
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

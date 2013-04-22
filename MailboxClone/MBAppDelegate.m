//
//  MBAppDelegate.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MBMainViewController.h"
#import "MBMailsViewController.h"
#import "MBMailbox.h"

@interface MBAppDelegate ()

@property (nonatomic, strong) UINavigationController *nc;

@end

@implementation MBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearance];
    
    [[MBMailbox sharedMailbox] load];
    
    UIViewController *wrapController = [[UIViewController alloc] init];
    
    MBMainViewController *vc1 = [[MBMainViewController alloc] init];
    //MBMailsViewController *vc2 = [[MBMailsViewController alloc] init];
    self.nc = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    [wrapController.view addSubview:self.nc.view];
    self.nc.view.frame = wrapController.view.bounds;
    
    self.nc.view.layer.cornerRadius = 8;
    self.nc.view.layer.masksToBounds = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = wrapController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupAppearance {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar-background"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    
    [searchBar setBackgroundImage:[UIImage imageNamed:@"search-bar-background"]];
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search-input-field-background"]
                                    forState:UIControlStateNormal];
    [searchBar setSearchFieldBackgroundPositionAdjustment:UIOffsetMake(0, 1)];
    [searchBar setSearchTextPositionAdjustment:UIOffsetMake(0, -1)];
    [searchBar setImage:[UIImage imageNamed:@"search-magnifying-glass-icon"]
            forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    
    [searchBar setTintColor:MB_RGB(210, 210, 210)];
}

@end

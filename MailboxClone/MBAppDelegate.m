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

@interface MBAppDelegate ()

@property (nonatomic, strong) UINavigationController *nc;

@end

@implementation MBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav-bar-background"] forBarMetrics:UIBarMetricsDefault];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageNamed:@"search-bar-background"]];
    
    UIViewController *wrapController = [[UIViewController alloc] init];
    
    MBMainViewController *vc1 = [[MBMainViewController alloc] init];
    MBMailsViewController *vc2 = [[MBMailsViewController alloc] init];
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

@end

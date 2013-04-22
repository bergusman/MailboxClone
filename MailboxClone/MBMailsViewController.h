//
//  MBMailsViewController.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBMailbox.h"

@protocol MBMailsViewControllerDelegate;

@interface MBMailsViewController : UIViewController

@property (nonatomic, weak) id<MBMailsViewControllerDelegate> delegate;
@property (nonatomic, assign) MBMailsType type;

- (void)bingo:(id)vc;

@end

@protocol MBMailsViewControllerDelegate <NSObject>

@optional
- (void)mailsViewController:(MBMailsViewController *)mailsVC didMoveMailTo:(MBMailsType)to;

@end

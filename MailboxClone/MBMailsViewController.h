//
//  MBMailsViewController.h
//  RBTest1
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MBMailsType) {
    MBMailsTypeInbox,
    MBMailsTypeArchived,
    MBMailsTypeDefer
};

@interface MBMailsViewController : UIViewController

@property (nonatomic, assign) MBMailsType type;

@end

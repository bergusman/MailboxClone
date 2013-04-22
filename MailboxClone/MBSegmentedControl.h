//
//  MBSegmentedControl.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBSegmentedControl : UIControl

@property (nonatomic, assign) NSInteger selectedSegmentIndex;

- (void)blinkSegmentAtIndex:(NSInteger)index;

@end

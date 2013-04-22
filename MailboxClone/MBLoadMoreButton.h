//
//  MBLoadMoreButton.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/22/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBLoadMoreButton : UIButton

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailText;

@property (nonatomic, readonly, getter=isLoading) BOOL loading;

- (void)beginLoading;
- (void)endLoading;

@end

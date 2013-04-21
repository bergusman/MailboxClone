//
//  MBMailCell.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBMailCellDelegate;

@interface MBMailCell : UITableViewCell

@property (nonatomic, weak) id<MBMailCellDelegate> delegate;

@property (nonatomic, retain) UIColor *leftColor;
@property (nonatomic, retain) UIColor *rightColor;

@property (nonatomic, retain) UIImage *leftImage;
@property (nonatomic, retain) UIImage *rightImage;

@property (nonatomic, copy) NSString *from;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) NSInteger messages;
@property (nonatomic, copy) NSString *receivedAt;

@property (nonatomic, assign) BOOL unread;
@property (nonatomic, assign) BOOL starred;

@end

@protocol MBMailCellDelegate <NSObject>

- (void)mailCellDidSlideFromLeft:(MBMailCell *)cell;
- (void)mailCellDidSlideFromRight:(MBMailCell *)cell;

@end
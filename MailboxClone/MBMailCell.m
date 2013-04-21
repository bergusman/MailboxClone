//
//  MBMailCell.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/20/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMailCell.h"

#define OFFSET 65.0f

@interface MBMailCell () <UIGestureRecognizerDelegate>

@end

@implementation MBMailCell {
    UIGestureRecognizer *_panGestureRecognizer;
    UIImageView *_leftImageView;
    UIImageView *_rightImageView;
    UIColor *_leftColor;
    UIColor *_rightColor;
    UIColor *_normalColor;
    UIView *_separator;
    
    UILabel *_fromLabel;
    UILabel *_subjectLabel;
    UILabel *_bodyLabel;
    UILabel *_dateLabel;
    
    UIImageView *_unreadIcon;
    UIImageView *_starIcon;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _leftColor = MB_RGB(98, 217, 98);
    _rightColor = MB_RGB(255, 222, 71);
    _normalColor = MB_RGB(227, 227, 227);
    
    _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe-archive-icon"]];
    _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"swipe-defer-icon"]];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:_panGestureRecognizer];
    
    CGSize contentSize = self.contentView.bounds.size;
    
    _separator = [[UIView alloc] init];
    _separator.backgroundColor = MB_RGB(199, 199, 199);
    _separator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _separator.frame = CGRectMake(0, contentSize.height - 1, contentSize.width, 1);
    [self.contentView addSubview:_separator];
    
    UIImage *leftShadowImage = [UIImage imageNamed:@"swipe-shadow-left"];
    leftShadowImage = [leftShadowImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    UIImageView *leftShadow = [[UIImageView alloc] init];
    leftShadow.image = leftShadowImage;
    leftShadow.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    leftShadow.frame = CGRectMake(-2, 0, 2, contentSize.height);
    [self.contentView addSubview:leftShadow];
    
    UIImage *rightShadowImage = [UIImage imageNamed:@"swipe-shadow-right"];
    rightShadowImage = [rightShadowImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    
    UIImageView *rightShadow = [[UIImageView alloc] init];
    rightShadow.image = rightShadowImage;
    rightShadow.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    rightShadow.frame = CGRectMake(contentSize.width, 0, 2, contentSize.height);
    [self.contentView addSubview:rightShadow];
    
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = _normalColor;
    self.backgroundView = backgroundView;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    selectedBackgroundView.backgroundColor = MB_RGB(162, 162, 162);
    self.selectedBackgroundView = selectedBackgroundView;
    
    UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more-arrow"]
                                                   highlightedImage:[UIImage imageNamed:@"more-arrow-white"]];
    accessoryView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    accessoryView.center = CGPointMake(contentSize.width - 8 - accessoryView.frame.size.width / 2, contentSize.height / 2);
    [self.contentView addSubview:accessoryView];
    
    _fromLabel = [[UILabel alloc] init];
    _fromLabel.backgroundColor = [UIColor clearColor];
    _fromLabel.textColor = MB_RGB(54, 57, 58);
    _fromLabel.highlightedTextColor = [UIColor whiteColor];
    _fromLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_fromLabel];
    
    _subjectLabel = [[UILabel alloc] init];
    _subjectLabel.backgroundColor = [UIColor clearColor];
    _subjectLabel.textColor = MB_RGB(54, 57, 58);
    _subjectLabel.highlightedTextColor = [UIColor whiteColor];
    _subjectLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:_subjectLabel];
    
    _bodyLabel = [[UILabel alloc] init];
    _bodyLabel.backgroundColor = [UIColor clearColor];
    _bodyLabel.textColor = MB_RGB(134, 134, 134);
    _bodyLabel.highlightedTextColor = [UIColor whiteColor];
    _bodyLabel.font = [UIFont systemFontOfSize:14];
    _bodyLabel.numberOfLines = 2;
    [self.contentView addSubview:_bodyLabel];
    
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.backgroundColor = [UIColor clearColor];
    _dateLabel.textColor = MB_RGB(136, 136, 136);
    _dateLabel.highlightedTextColor = [UIColor whiteColor];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textAlignment = UITextAlignmentRight;
    [self.contentView addSubview:_dateLabel];
    
    [self.backgroundView addSubview:_leftImageView];
    [self.backgroundView addSubview:_rightImageView];
    
    _unreadIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unread-button"]
                                    highlightedImage:[UIImage imageNamed:@"new-message-dot-white"]];
    _unreadIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _unreadIcon.center = CGPointMake(15, contentSize.height / 2);
    [self.contentView addSubview:_unreadIcon];
    
    _starIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inbox-star-icon"]
                                  highlightedImage:[UIImage imageNamed:@"inbox-star-icon-white"]];
    _starIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _starIcon.center = CGPointMake(16, contentSize.height / 2 - 1);
    [self.contentView addSubview:_starIcon];
    
    _unreadIcon.hidden = YES;
    _starIcon.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _separator.backgroundColor = MB_RGB(199, 199, 199);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    _separator.backgroundColor = MB_RGB(199, 199, 199);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.height -= 1;
    self.selectedBackgroundView.frame = frame;
    
    CGSize contentSize = self.contentView.bounds.size;
    
    CGSize s = [_dateLabel sizeThatFits:CGSizeMake(100, 0)];
    //NSLog(@"%@", NSStringFromCGSize(s));
    
    _fromLabel.frame = CGRectMake(30, 6, 200, 18);
    
    _subjectLabel.frame = CGRectMake(30, 24, 260, 19);
    
    //CGSize bodySize = [_bodyLabel.text sizeWithFont:_bodyLabel.font constrainedToSize:CGSizeMake(200, 0) lineBreakMode:UILineBreakModeWordWrap];
    //CGSize bodySize = [_bodyLabel sizeThatFits:CGSizeMake(200, 0)];
    CGSize bodySize = [_bodyLabel.text sizeWithFont:_bodyLabel.font constrainedToSize:CGSizeMake(200, 0) lineBreakMode:UILineBreakModeWordWrap];
    //NSLog(@"%@", NSStringFromCGSize(bodySize));
    CGRect rect = [_bodyLabel textRectForBounds:CGRectMake(0, 0, 200, 50) limitedToNumberOfLines:2];
    //NSLog(@"%@", NSStringFromCGRect(rect));
    _bodyLabel.frame = CGRectMake(30, 43, bodySize.width, bodySize.height);
    
    
    _dateLabel.frame = CGRectMake(320 - 23 - 80, 6, 80, 18);
    
    
    
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // No operation
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.contentView];
        CGPoint center = self.contentView.center;
        center.x += translation.x;
        self.contentView.center = center;
        [gestureRecognizer setTranslation:CGPointZero inView:self.contentView];
        
        CGFloat offset = center.x - self.bounds.size.width / 2;
        self.backgroundView.backgroundColor = [self backgroundColorWithOffset:offset];
        
        if (offset > 0) {
            _leftImageView.hidden = NO;
            _rightImageView.hidden = YES;
            _leftImageView.center = [self leftImageCenterWithOffset:offset];
            _leftImageView.alpha = [self sideImageAlphaWithOffset:offset];
        } else {
            _leftImageView.hidden = YES;
            _rightImageView.hidden = NO;
            _rightImageView.center = [self rightImageCenterWithOffset:offset];
            _rightImageView.alpha = [self sideImageAlphaWithOffset:offset];
        }
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint center = self.contentView.center;
        CGFloat offset = center.x - self.bounds.size.width / 2;
        
        if (fabs(offset) > OFFSET) {
            [UIView animateWithDuration:0.25 animations:^{
                CGFloat width = self.contentView.bounds.size.width;
                CGPoint center = self.contentView.center;
                center.x = width / 2 + copysignf(width + OFFSET, offset);
                self.contentView.center = center;
                if (offset > 0) {
                    _leftImageView.center = [self leftImageCenterWithOffset:width + OFFSET];
                } else {
                    _rightImageView.center = [self rightImageCenterWithOffset:width + OFFSET];
                }
                
            } completion:^(BOOL finished) {
                if (offset > 0) {
                    [self.delegate mailCellDidSlideFromLeft:self];
                } else {
                    [self.delegate mailCellDidSlideFromRight:self];
                }
            }];
        } else {
            _leftImageView.hidden = YES;
            _rightImageView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint center = self.contentView.center;
                CGFloat bouncingDepth = [self bouncingDepthWithOffset:offset];
                center.x = self.contentView.bounds.size.width / 2 - copysignf(bouncingDepth, offset);
                self.contentView.center = center;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    CGPoint center = self.contentView.center;
                    center.x = self.contentView.bounds.size.width / 2;
                    self.contentView.center = center;
                } completion:nil];
            }];
        }
    }
}

- (CGPoint)leftImageCenterWithOffset:(CGFloat)offset {
    return CGPointMake(MAX(OFFSET, fabsf(offset)) - OFFSET / 2,
                       self.contentView.bounds.size.height / 2);
}

- (CGPoint)rightImageCenterWithOffset:(CGFloat)offset {
    CGSize contentSize = self.contentView.bounds.size;
    return CGPointMake(contentSize.width - MAX(OFFSET, fabsf(offset)) + OFFSET / 2,
                       contentSize.height / 2);
}

- (UIColor *)backgroundColorWithOffset:(CGFloat)offset {
    if (offset > OFFSET) {
        return _leftColor;
    } else if (offset < -OFFSET) {
        return _rightColor;
    } else {
        return _normalColor;
    }
}

- (CGFloat)sideImageAlphaWithOffset:(CGFloat)offset {
    return MAX(0, MIN(1, (fabsf(offset) - 15) / (OFFSET - 15)));
}

- (CGFloat)bouncingDepthWithOffset:(CGFloat)offset {
    if (offset < OFFSET / 2) {
        return 3;
    } else if (offset < OFFSET) {
        return 4;
    } else if (offset < OFFSET * 2) {
        return 6;
    } else {
        return 10;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _panGestureRecognizer) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.superview];
        return fabs(translation.x / translation.y) > 1;
    }
    return NO;
}

#pragma mark - Properties

- (void)setUnread:(BOOL)unread {
    _unread = unread;
    [self setupStarAndUnreadIcons];
}

- (void)setStarred:(BOOL)starred {
    _starred = starred;
    [self setupStarAndUnreadIcons];
}

- (void)setupStarAndUnreadIcons {
    _starIcon.hidden = !(!_unread && _starred);
    _unreadIcon.hidden = !_unread;
}

- (void)setFrom:(NSString *)from { _fromLabel.text = from; }
- (NSString *)from { return _fromLabel.text; }

- (void)setSubject:(NSString *)subject { _subjectLabel.text = subject; }
- (NSString *)subject { return _subjectLabel.text; }

- (void)setBody:(NSString *)body { _bodyLabel.text = body; }
- (NSString *)body { return _bodyLabel.text; }

- (void)setReceivedAt:(NSString *)receivedAt { _dateLabel.text = receivedAt; }
- (NSString *)receivedAt { return _dateLabel.text; }

- (void)setLeftImage:(UIImage *)leftImage { _leftImageView.image = leftImage; }
- (UIImage *)leftImage { return _leftImageView.image; }

- (void)setRightImage:(UIImage *)rightImage { _rightImageView.image = rightImage; }
- (UIImage *)rightImage { return _rightImageView.image; }

@end

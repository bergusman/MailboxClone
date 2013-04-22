//
//  MBLoadMoreButton.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/22/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBLoadMoreButton.h"

@implementation MBLoadMoreButton {
    UIActivityIndicatorView *_spinner;
    UILabel *_textLabel;
    UILabel *_detailTextLabel;
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
    [self sizeToFit];
    
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundColor = [UIColor whiteColor];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.center = CGPointMake(15, 43);
    [self addSubview:_spinner];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textLabel.frame = CGRectMake(30, 25, self.bounds.size.width - 40, 18);
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = MB_RGB(83, 186, 218);
    _textLabel.highlightedTextColor = [UIColor whiteColor];
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    _detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _detailTextLabel.frame = CGRectMake(30, 43, self.bounds.size.width - 40, 18);
    _detailTextLabel.backgroundColor = [UIColor clearColor];
    _detailTextLabel.textColor = MB_RGB(134, 134, 134);
    _detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    _detailTextLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_detailTextLabel];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = MB_RGB(199, 199, 199);
    separator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    separator.frame = CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width, 1);
    [self addSubview:separator];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _textLabel.highlighted = highlighted;
    _detailTextLabel.highlighted = highlighted;
    if (highlighted) {
        self.backgroundColor = MB_RGB(162, 162, 162);
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(320, 86);
}

- (void)touchUp:(id)sender {
    [self beginLoading];
}

#pragma mark - Loading

- (void)beginLoading {
    _loading = YES;
    [_spinner startAnimating];
    self.userInteractionEnabled = NO;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endLoading {
    _loading = NO;
    [_spinner stopAnimating];
    self.userInteractionEnabled = YES;
}

#pragma mark - Properties

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (NSString *)text {
    return _textLabel.text;
}

- (void)setDetailText:(NSString *)detailText {
    _detailTextLabel.text = detailText;
}

- (NSString *)detailText {
    return _detailTextLabel.text;
}

@end

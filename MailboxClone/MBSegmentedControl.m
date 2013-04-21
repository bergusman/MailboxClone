//
//  MBSegmentedControl.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBSegmentedControl.h"

@implementation MBSegmentedControl {
    NSArray *_buttons;
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)init {
    self = [super init];
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
    _button1 = [[UIButton alloc] init];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"defer-button-background"] forState:UIControlStateNormal];
    [_button1 setBackgroundImage:[UIImage imageNamed:@"defer-button-background-active"] forState:UIControlStateSelected];
    _button1.frame = CGRectMake(0, 0, 54, 32);
    [self addSubview:_button1];
    
    _button2 = [[UIButton alloc] init];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"inbox-button-background"] forState:UIControlStateNormal];
    [_button2 setBackgroundImage:[UIImage imageNamed:@"inbox-button-background-active"] forState:UIControlStateSelected];
    _button2.frame = CGRectMake(54, 0, 54, 32);
    [self addSubview:_button2];
    
    _button3 = [[UIButton alloc] init];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"archive-button-background"] forState:UIControlStateNormal];
    [_button3 setBackgroundImage:[UIImage imageNamed:@"archive-button-background-active"] forState:UIControlStateSelected];
    _button3.frame = CGRectMake(108, 0, 54, 32);
    [self addSubview:_button3];
    
    [_button1 addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button2 addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [_button3 addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _buttons = @[_button1, _button2, _button3];
    
    _selectedSegmentIndex = UISegmentedControlNoSegment;
    
    [self sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(162, 32);
}

- (void)touchUpInsideAction:(UIButton *)button {
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
    button.selected = YES;
    _selectedSegmentIndex = [_buttons indexOfObject:button];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
    if (selectedSegmentIndex >= 0 && selectedSegmentIndex < 3) {
        UIButton *button = _buttons[selectedSegmentIndex];
        button.selected = YES;
    }
}

@end

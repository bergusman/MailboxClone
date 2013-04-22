//
//  MBSegmentedControl.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBSegmentedControl.h"
#import <QuartzCore/QuartzCore.h>

@implementation MBSegmentedControl {
    NSArray *_buttons;
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
    [self sizeToFit];
    
    UIButton *button1 = [[UIButton alloc] init];
    [button1 setBackgroundImage:[UIImage imageNamed:@"defer-button-background"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed:@"defer-button-background-active"] forState:UIControlStateSelected];
    [button1 addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(0, 0, 54, 32);
    [self addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setBackgroundImage:[UIImage imageNamed:@"inbox-button-background"] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[UIImage imageNamed:@"inbox-button-background-active"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(54, 0, 54, 32);
    [self addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] init];
    [button3 setBackgroundImage:[UIImage imageNamed:@"archive-button-background"] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:@"archive-button-background-active"] forState:UIControlStateSelected];
    [button3 addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(108, 0, 54, 32);
    [self addSubview:button3];
    
    _buttons = @[button1, button2, button3];
    _selectedSegmentIndex = UISegmentedControlNoSegment;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(162, 32);
}

- (void)touchUpInside:(UIButton *)button {
    for (UIButton *button in _buttons) {
        button.selected = NO;
    }
    button.selected = YES;
    NSInteger index = [_buttons indexOfObject:button];
    if (_selectedSegmentIndex != index) {
        _selectedSegmentIndex = index;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
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

- (void)blinkSegmentAtIndex:(NSInteger)index {
    CALayer *blinkLayer = [CALayer layer];
    UIImage *blinkImage = nil;
    CGFloat scale = 0;
    
    // Cannot set position dynamically
    if (index == 0) {
        blinkImage = [UIImage imageNamed:@"defer-blink-icon"];
        blinkLayer.frame = CGRectMake(22, 8, blinkImage.size.width, blinkImage.size.height);
        scale = 1.25;
    } else if (index == 1) {
        blinkImage = [UIImage imageNamed:@"inbox-blink-icon"];
        blinkLayer.frame = CGRectMake(72, 8, blinkImage.size.width, blinkImage.size.height);
        scale = 1.15;
    } else if (index == 2) {
        blinkImage = [UIImage imageNamed:@"archive-blink-icon"];
        blinkLayer.frame = CGRectMake(125, 9, blinkImage.size.width, blinkImage.size.height);
        scale = 1.2;
    }
    
    blinkLayer.contents = (__bridge id)blinkImage.CGImage;
    blinkLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.layer addSublayer:blinkLayer];

    CABasicAnimation *blinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    blinkAnimation.fromValue = @(1);
    blinkAnimation.toValue = @(scale);
    blinkAnimation.duration = 0.11;
    blinkAnimation.autoreverses = YES;
    blinkAnimation.fillMode = kCAFillModeBackwards;
    blinkAnimation.delegate = self;
    [blinkAnimation setValue:blinkLayer forKey:@"blinkLayer"];
    
    [blinkLayer addAnimation:blinkAnimation forKey:@"blink"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"blinkLayer"];
    [layer removeFromSuperlayer];
}

@end

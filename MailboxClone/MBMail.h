//
//  MBMail.h
//  RBTest1
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBAddress.h"

@interface MBMail : NSObject

@property (nonatomic, copy) NSString *mailID;
@property (nonatomic, strong) MBAddress *from;
@property (nonatomic, strong) NSArray *to;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSDate *receivedAt;
@property (nonatomic, assign) BOOL starred;
@property (nonatomic, assign) NSUInteger messages;

+ (NSArray *)mailsWithAttributes:(NSArray *)attributes;
+ (MBMail *)mailWithAttributes:(NSDictionary *)attributes;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end

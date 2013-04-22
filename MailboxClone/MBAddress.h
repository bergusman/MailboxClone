//
//  MBAddress.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBAddress : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;

+ (NSArray *)addressesWithAddressString:(NSString *)addressString;
+ (MBAddress *)addressWithAddressString:(NSString *)addressString;

- (id)initWithAddressString:(NSString *)addressString;

- (NSString *)addressString;
- (NSString *)nameString;

@end

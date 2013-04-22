//
//  MBAddress.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBAddress.h"

@implementation MBAddress

+ (NSArray *)addressesWithAddressString:(NSString *)addressString {
    NSMutableArray *addresses = [NSMutableArray array];
    NSArray *addressComponents = [addressString componentsSeparatedByString:@","];
    for (NSString *addressComponent in addressComponents) {
        MBAddress *address = [MBAddress addressWithAddressString:addressComponent];
        if (address) {
            [addresses addObject:address];
        }
    }
    return addresses;
}

+ (MBAddress *)addressWithAddressString:(NSString *)addressString {
    return [[MBAddress alloc] initWithAddressString:addressString];
}

- (id)initWithAddressString:(NSString *)addressString {
    self = [super init];
    if (self) {
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<.*>" options:0 error:nil];
        NSTextCheckingResult *result =[regExp firstMatchInString:addressString options:0 range:NSMakeRange(0, [addressString length])];
        if (result) {
            NSString *email = [addressString substringWithRange:result.range];
            self.email = [email substringWithRange:NSMakeRange(1, [email length] - 2)];
            addressString = [addressString stringByReplacingOccurrencesOfString:email withString:@""];
            self.name = [addressString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        } else {
            self.email = addressString;
        }
    }
    return self;
}

- (NSString *)addressString {
    if ([self.name length] > 0) {
        return [NSString stringWithFormat:@"%@ <%@>", self.name, self.email];
    } else {
        return self.email;
    }
}

- (NSString *)nameString {
    if ([self.name length] > 0) {
        return self.name;
    } else {
        return self.email;
    }
}

@end

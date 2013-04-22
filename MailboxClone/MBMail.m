//
//  MBMail.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMail.h"

@implementation MBMail

+ (NSArray *)mailsWithAttributes:(NSArray *)attributes {
    NSMutableArray *mails = [NSMutableArray arrayWithCapacity:[attributes count]];
    for (NSDictionary *mailAttributes in attributes) {
        if ([mailAttributes isKindOfClass:[NSDictionary class]]) {
            MBMail *mail = [MBMail mailWithAttributes:mailAttributes];
            if (mail) {
                [mails addObject:mail];
            }
        }
    }
    return mails;
}

+ (MBMail *)mailWithAttributes:(NSDictionary *)attributes {
    return [[MBMail alloc] initWithAttributes:attributes];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.mailID = [attributes[@"id"] stringValue];
        self.from = [MBAddress addressWithAddressString:attributes[@"from"]];
        self.to = [MBAddress addressesWithAddressString:attributes[@"to"]];
        self.subject = attributes[@"subject"];
        self.body = attributes[@"body"];
        self.receivedAt = [[MBMail dateFormatter] dateFromString:attributes[@"received_at"]];
        self.starred = [attributes[@"starred"] boolValue];
        self.messages = [attributes[@"messages"] unsignedIntegerValue];
    }
    return self;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
        _dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    }
    return _dateFormatter;
}

@end

//
//  MBMailBox.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMailbox.h"

NSString * const MBMailboxDidAddMailNotification = @"MBMailboxDidAddMailNotification";
NSString * const MBMailboxToUserInfoKey = @"MBMailboxToUserInfoKey";

@interface MBMailbox ()

@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, assign) BOOL full;
@property (nonatomic, strong) NSMutableArray *allMails;
@property (nonatomic, strong) NSMutableArray *deferMails;
@property (nonatomic, strong) NSMutableArray *inboxMails;
@property (nonatomic, strong) NSMutableArray *archivedMails;

@end

@implementation MBMailbox

- (id)init {
    self = [super init];
    if (self) {
        [self clear];
        [self load];
    }
    return self;
}

- (void)addMail:(MBMail *)mail to:(MBMailsType)to {
    if (to == MBMailsTypeInbox) {
        [self.inboxMails insertObject:mail atIndex:0];
    } else if (to == MBMailsTypeArchived) {
        [self.archivedMails insertObject:mail atIndex:0];
    } else if (to == MBMailsTypeDefer) {
        [self.deferMails insertObject:mail atIndex:0];
    }
    
    NSDictionary *userInfo = @{MBMailboxToUserInfoKey: [NSNumber numberWithInteger:to]};
    [[NSNotificationCenter defaultCenter] postNotificationName:MBMailboxDidAddMailNotification
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)deleteMail:(MBMail *)mail from:(MBMailsType)from {
    if (from == MBMailsTypeInbox) {
        [self.inboxMails removeObject:mail];
    } else if (from == MBMailsTypeArchived) {
        [self.archivedMails removeObject:mail];
    } else if (from == MBMailsTypeDefer) {
        [self.deferMails removeObject:mail];
    }
}

- (void)clear {
    self.total = 0;
    self.full = NO;
    self.allMails = [NSMutableArray array];
    self.inboxMails = [NSMutableArray array];
    self.archivedMails = [NSMutableArray array];
    self.deferMails = [NSMutableArray array];
}

- (void)load {
    [self loadWithCompletion:nil];
}

- (void)loadWithCompletion:(void (^)(BOOL success))completion {
    
    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:@"emails.json" withExtension:@""];
    NSData *data = [NSData dataWithContentsOfURL:dataURL];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.allMails = [[MBMail mailsWithAttributes:json] mutableCopy];
    self.inboxMails = self.allMails;
    
    self.total = 100;
    
    
    if (completion) {
        completion(YES);
    }
}

+ (MBMailbox *)sharedMailbox {
    static MBMailbox *_sharedMailbox;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMailbox = [[MBMailbox alloc] init];
    });
    return _sharedMailbox;
}

@end

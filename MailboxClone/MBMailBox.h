//
//  MBMailBox.h
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMail.h"

typedef NS_ENUM(NSInteger, MBMailsType) {
    MBMailsTypeInbox,
    MBMailsTypeArchived,
    MBMailsTypeDefer
};

extern NSString * const MBMailboxDidAddMailNotification;
extern NSString * const MBMailboxToUserInfoKey;

@interface MBMailbox : NSObject

@property (nonatomic, strong) NSMutableArray *allMails;
@property (nonatomic, strong) NSMutableArray *deferMails;
@property (nonatomic, strong) NSMutableArray *inboxMails;
@property (nonatomic, strong) NSMutableArray *archivedMails;

- (void)addMail:(MBMail *)mail to:(MBMailsType)to;
- (void)deleteMail:(MBMail *)mail from:(MBMailsType)from;

+ (MBMailbox *)sharedMailbox;

@end

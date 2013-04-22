//
//  MBMailBox.m
//  MailboxClone
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import "MBMailbox.h"
#import "AFNetworking.h"

NSString * const MBMailboxDidAddMailNotification = @"MBMailboxDidAddMailNotification";
NSString * const MBMailboxToUserInfoKey = @"MBMailboxToUserInfoKey";

@interface MBMailbox ()

@property (nonatomic, assign) NSUInteger total;
@property (nonatomic, strong) NSMutableArray *allMails;
@property (nonatomic, strong) NSMutableArray *deferMails;
@property (nonatomic, strong) NSMutableArray *inboxMails;
@property (nonatomic, strong) NSMutableArray *archivedMails;

@property (nonatomic, copy) NSString *server;

@property (nonatomic, assign) NSInteger perPage;

@end

@implementation MBMailbox

- (id)init {
    self = [super init];
    if (self) {
        self.server = @"http://rocket-ios.herokuapp.com";
        [self clear];
    }
    return self;
}

- (BOOL)isFull {
    return [self.allMails count] == self.total;
}

- (void)addMail:(MBMail *)mail to:(MBMailsType)to {
    if (to == MBMailsTypeInbox) {
        [self.inboxMails insertObject:mail atIndex:0];
    } else if (to == MBMailsTypeArchived) {
        [self.archivedMails insertObject:mail atIndex:0];
    } else if (to == MBMailsTypeDefer) {
        [self.deferMails insertObject:mail atIndex:0];
    }
    
    [self postAddNotificationForType:to];
}

- (void)postAddNotificationForType:(MBMailsType)type {
    NSDictionary *userInfo = @{MBMailboxToUserInfoKey:@(type)};
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
    self.allMails = [NSMutableArray array];
    self.inboxMails = [NSMutableArray array];
    self.archivedMails = [NSMutableArray array];
    self.deferMails = [NSMutableArray array];
    
    // TODO: change post method
    [self postAddNotificationForType:MBMailsTypeInbox];
    [self postAddNotificationForType:MBMailsTypeDefer];
    [self postAddNotificationForType:MBMailsTypeArchived];
}

- (void)load {
    [self loadWithCompletion:nil];
}

- (void)loadWithCompletion:(void (^)(BOOL success))completion {
    NSNumber *page = nil;
    if (self.total > 0) {
        NSLog(@"%d", [self.allMails count]);
        page = @([self.allMails count] / self.perPage);
        NSLog(@"%@", page);
    }
    
    [self loadMailsWithPage:page success:^(id JSON) {
        // Trust to answer!
        
        self.perPage = [JSON[@"pagination"][@"per_page"] integerValue];
        self.total = [JSON[@"pagination"][@"total"] integerValue];
        
        NSArray *mails = [MBMail mailsWithAttributes:JSON[@"emails"]];
        
        [self.allMails addObjectsFromArray:mails];
        [self.inboxMails addObjectsFromArray:mails];
        
        [self postAddNotificationForType:MBMailsTypeInbox];
        
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error, id JSON) {
        if (completion) {
            completion(NO);
        }
    }];
    
    /*
    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:@"emails.json" withExtension:@""];
    NSData *data = [NSData dataWithContentsOfURL:dataURL];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.allMails = [[MBMail mailsWithAttributes:json] mutableCopy];
    self.inboxMails = self.allMails;
    
    self.total = 100;
    */
}

#pragma mark - Networking

- (void)loadMailsWithPage:(NSNumber *)page
                  success:(void (^)(id JSON))success
                  failure:(void (^)(NSError *error, id JSON))failure
{
    NSString *method = @"emails.json";
    NSString *path = method;
    if (page) {
        path = [NSString stringWithFormat:@"%@?page=%d", method, [page integerValue]];
    }
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:self.server]];
    //NSLog(@"%@", [url absoluteString]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:8];
    
    AFJSONRequestOperation *requestOperation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            success(JSON);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(error, JSON);
        }
    }];
    
    [requestOperation start];
}

#pragma mark - Singleton

+ (MBMailbox *)sharedMailbox {
    static MBMailbox *_sharedMailbox;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMailbox = [[MBMailbox alloc] init];
    });
    return _sharedMailbox;
}

@end

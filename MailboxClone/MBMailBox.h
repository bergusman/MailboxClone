//
//  MBMailBox.h
//  RBTest1
//
//  Created by Vitaliy Berg on 4/21/13.
//  Copyright (c) 2013 Vitaliy Berg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBMail.h"

@interface MBMailBox : NSObject

@property (nonatomic, strong) NSMutableArray *allMails;
@property (nonatomic, strong) NSMutableArray *deferMails;
@property (nonatomic, strong) NSMutableArray *inboxMails;
@property (nonatomic, strong) NSMutableArray *archivedMails;

@end

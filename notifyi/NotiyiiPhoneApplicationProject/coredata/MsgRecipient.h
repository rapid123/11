//
//  MsgRecipient.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 9/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inbox;

@interface MsgRecipient : NSManagedObject

@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSNumber * recipientId;
@property (nonatomic, retain) NSString * recipientName;
@property (nonatomic, retain) Inbox *inboxMessageID;

@end

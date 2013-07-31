//
//  MsgRecipient.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 11/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inbox;

@interface MsgRecipient : NSManagedObject

@property (nonatomic, retain) NSString * docterName;
@property (nonatomic, retain) NSNumber * isCC;
@property (nonatomic, retain) NSNumber * recipientId;
@property (nonatomic, retain) Inbox *inboxMessageID;

@end

//
//  Inbox.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 10/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Directory, MsgRecipient;

@interface Inbox : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * deleteFrom;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSNumber * msgType;
@property (nonatomic, retain) NSDate * patientDOB;
@property (nonatomic, retain) NSString * patientFirstName;
@property (nonatomic, retain) NSString * patientLastName;
@property (nonatomic, retain) NSNumber * readStatus;
@property (nonatomic, retain) NSNumber * senderID;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * textMessageBody;
@property (nonatomic, retain) NSString * route;
@property (nonatomic, retain) NSString * alert;
@property (nonatomic, retain) NSString * coverage;
@property (nonatomic, retain) NSSet *recipientContacts;
@property (nonatomic, retain) NSSet *recipientmessageID;
@end

@interface Inbox (CoreDataGeneratedAccessors)

- (void)addRecipientContactsObject:(Directory *)value;
- (void)removeRecipientContactsObject:(Directory *)value;
- (void)addRecipientContacts:(NSSet *)values;
- (void)removeRecipientContacts:(NSSet *)values;

- (void)addRecipientmessageIDObject:(MsgRecipient *)value;
- (void)removeRecipientmessageIDObject:(MsgRecipient *)value;
- (void)addRecipientmessageID:(NSSet *)values;
- (void)removeRecipientmessageID:(NSSet *)values;

@end

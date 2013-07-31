//
//  Directory.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Rapidvalue on 11/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Inbox;

@interface Directory : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * communicationPreference;
@property (nonatomic, retain) NSString * contactInfo;
@property (nonatomic, retain) NSNumber * coverageStatus;
@property (nonatomic, retain) NSString * faxNumber;
@property (nonatomic, retain) NSNumber * faxStatus;
@property (nonatomic, retain) NSString * hospitalName;
@property (nonatomic, retain) NSNumber * inboxStatus;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSNumber * physicianId;
@property (nonatomic, retain) NSString * physicianImage;
@property (nonatomic, retain) NSString * physicianName;
@property (nonatomic, retain) NSString * practice;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSSet *inbox;
@end

@interface Directory (CoreDataGeneratedAccessors)

- (void)addInboxObject:(Inbox *)value;
- (void)removeInboxObject:(Inbox *)value;
- (void)addInbox:(NSSet *)values;
- (void)removeInbox:(NSSet *)values;

@end

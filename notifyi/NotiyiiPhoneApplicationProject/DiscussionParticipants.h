//
//  DiscussionParticipants.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 26/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TouchBase;

@interface DiscussionParticipants : NSManagedObject

@property (nonatomic, retain) NSNumber * participantId;
@property (nonatomic, retain) NSString * participantName;
@property (nonatomic, retain) TouchBase *touchBaseParticipantsID;

@end

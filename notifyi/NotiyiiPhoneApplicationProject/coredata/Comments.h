//
//  Comments.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 03/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TouchBase;

@interface Comments : NSManagedObject

@property (nonatomic, retain) NSDate * commentDate;
@property (nonatomic, retain) NSNumber * commentPersonId;
@property (nonatomic, retain) NSString * commentPersonName;
@property (nonatomic, retain) NSString * comments;
@property (nonatomic, retain) NSNumber * commentsId;
@property (nonatomic, retain) NSNumber * commentStatus;
@property (nonatomic, retain) NSNumber * discussionId;
@property (nonatomic, retain) TouchBase *touchBaseDiscussionID;

@end

//
//  Comments.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 20/12/12.
//
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
@property (nonatomic, retain) NSString * commentStatus;
@property (nonatomic, retain) NSNumber * discussionId;
@property (nonatomic, retain) TouchBase *touchBaseDiscussionID;

@end

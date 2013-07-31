//
//  TouchBase.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 13/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comments, DiscussionParticipants;

@interface TouchBase : NSManagedObject

@property (nonatomic, retain) NSDate * discussionDate;
@property (nonatomic, retain) NSString * discussionId;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * textDiscussion;
@property (nonatomic, retain) NSString * discussionOwner;
@property (nonatomic, retain) NSSet *commentID;
@property (nonatomic, retain) NSSet *participantsID;
@end

@interface TouchBase (CoreDataGeneratedAccessors)

- (void)addCommentIDObject:(Comments *)value;
- (void)removeCommentIDObject:(Comments *)value;
- (void)addCommentID:(NSSet *)values;
- (void)removeCommentID:(NSSet *)values;

- (void)addParticipantsIDObject:(DiscussionParticipants *)value;
- (void)removeParticipantsIDObject:(DiscussionParticipants *)value;
- (void)addParticipantsID:(NSSet *)values;
- (void)removeParticipantsID:(NSSet *)values;

@end

//
//  DataManger.h
//  coredataSample
//
//  Created by Nithin George on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataHandler.h"
#import "Inbox.h"
#import "TouchBase.h"

@interface DataManager : NSObject<NSFetchedResultsControllerDelegate>
{
    
}

//creation, saving and deletion
+(id)createEntityObject:(NSString *)entityName;
+(BOOL)saveContext;
+(BOOL)deleteMangedObject:(id)managedObject;

//insertion of objects
//-(BOOL)insertObjectIntoDataBase:(Inbox *)inboxObject;
//fetching of objects
+(NSArray *)getInboxDetails:(int)msgType startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
-(NSArray *)getWholeInboxDetails:(int)msgType;
+(NSArray *)getWholeEntityDetails:(NSString *)entityName sortBy:(NSString *)attributeName;
+(NSArray *)fetchExistingDeletedServerInboxEntityObject:(NSString *)entityName messageID:(int)messageID; 

+(id)fetchDirectoryObjectForEntity:(NSString *)entityName selectBy:(int)directoryID;
+(id)fetchExistingInboxEntityObject:(NSString *)entityName messageID:(int)messageID messageType:(int)messageType;
+(id)fetchExistingEntityObject:(NSString *)entityName attributeName:(NSString*)attibute selectBy:(int)attributeValue;
#warning want to remove
+(id)fetchExistingEntityTouchBaseObject:(NSString *)entityName discussionId:(NSString*)discussionId;
//detetion of objects

+(id)fetchDirectoryObjectsForEntity:(NSString *)entityName selectByName:(NSString *)physiciansName;

- (BOOL) deleteAllObjects: (NSString *) entityDescription;
+(id)fetchDiscussionParticipantsObjectForEntity:(NSString *)entityName selectBy:(int)participantId;

- (NSFetchedResultsController *)fetchedResultsController;

//+ (BOOL)saveDashResources:(TouchBase*)touchBase;
@end



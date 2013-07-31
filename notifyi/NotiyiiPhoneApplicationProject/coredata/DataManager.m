 //
//  DataManger.m
//  coredataSample
//
//  Created by Nithin George on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "Inbox.h"
#import "Comments.h"

@interface DataManager ()


@end

NSFetchedResultsController *fetchedResultsController;;

@implementation DataManager

#pragma mark- For creating blank data for entity
+(id)createEntityObject:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[[CoreDataHandler sharedHandler] managedObjectContext]];
}

#pragma mark- saveContext
+(BOOL)saveContext
{
    NSError *error;
    BOOL isSuccess = NO;
    isSuccess = [[[CoreDataHandler sharedHandler] managedObjectContext] save:&error];
    
    if(error)
    {
        
        NSLog(@"Error In saving ManagedObject  Reason : %@",[error description]);
    }
    
    return isSuccess;    
}
#pragma mark- Delete given managed object
+(BOOL)deleteMangedObject:(id)managedObject
{
    BOOL isSuccess = NO;
    
    @try {
        [[[CoreDataHandler sharedHandler] managedObjectContext] deleteObject:managedObject];
        isSuccess = YES;
    }
    @catch (NSException *exception) {
        isSuccess = NO;
    }
    @finally {
        
        return isSuccess;
    }
    
}

//#pragma mark - Get Inbox details from the DataBase
//
//-(BOOL)insertObjectIntoDataBase:(Inbox *)inboxObject
//{   
//    BOOL isDeleted;
//    Inbox *inbox = [DataManager createEntityObject:@"Inbox"];
//    MsgRecipient *msgRecipient = [DataManager createEntityObject:@"MsgRecipient"];
//    
//    inbox.patientFirstName = inboxObject.patientFirstName;
//    inbox. patientLastName = inboxObject.patientLastName;
//    inbox. patientDOB = inboxObject.patientDOB;
//    inbox.subject = inboxObject.subject;
//    inbox.textMessageBody = inboxObject.textMessageBody;
//    
//    NSArray *temp = [inboxObject.recipientmessageID allObjects];
//    int arrayCount = [temp count];
//    for (int i = 0; i < arrayCount; i++)
//    {
//        msgRecipient = (MsgRecipient *)[temp objectAtIndex:i];
//        NSLog(@"msgRecipient == %@",msgRecipient);
//        
//    }
//    
//    BOOL isSaved = [DataManager saveContext];
//    
//    if(isSaved)
//    {
//        isDeleted = TRUE;
//    }
//    else 
//    {
//        isDeleted = FALSE;
//    }
//    
//    return isDeleted;
//}

#pragma mark -object fetching
-(NSArray *)getWholeInboxDetails:(int)msgType 
{
    NSLog(@"msgType == %d",msgType);
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Inbox"];
    NSPredicate *predicate;
    if(msgType != 3)//inbox, sent and draft
    {
    predicate = [NSPredicate predicateWithFormat:@"SELF.messageType = %d",msgType];
    }
    else // Trash either from sent message or from inbox message
    {
        predicate = [NSPredicate predicateWithFormat:@"SELF.messageType = %d AND (SELF.deleteFrom = 0 || SELF.deleteFrom = 1)",msgType];
    }
    fetchRequest.predicate = predicate;

	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    dateSortDescriptor = nil;
    sortDescriptors = nil;
    
   NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
    {
        NSLog(@"Success ROW Count::: %d",[result count]);
    }
    NSLog(@"msgType == %d",msgType);
    NSLog(@"result count == %d",[result count]);

//    NSLog(@"result array == %@",result);
    return result;
    
}

+(NSArray *)getInboxDetails:(int)msgType startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Inbox"];
    NSPredicate *predicate;
    if(msgType != 3)//inbox, sent and draft
    {
        NSLog(@"%@",startDate);
//        predicate = [NSPredicate predicateWithFormat:@"SELF.messageType = %d AND (SELF.date <= %@ AND SELF.date >= %@)",msgType,startDate,endDate];
    predicate = [NSPredicate predicateWithFormat:@"SELF.date <= %@ AND SELF.date >= %@",startDate,endDate];
    }
    else // Trash
    {
        predicate = [NSPredicate predicateWithFormat:@"SELF.messageType = %d AND (SELF.deleteFrom = 0 || SELF.deleteFrom = 1)",msgType];
    }
    fetchRequest.predicate = predicate;
    
	NSSortDescriptor *dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:dateSortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    dateSortDescriptor = nil;
    sortDescriptors = nil;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
    {
        NSLog(@"Success ROW Count::: %d",[result count]);
    }
    NSLog(@"result count == %d",[result count]);
    
    //    NSLog(@"result array == %@",result);
    return result;
}

+(NSArray *)getWholeEntityDetails:(NSString *)entityName sortBy:(NSString *)attributeName
{
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray *result  = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    return result;
}

+(NSArray *)fetchExistingDeletedServerInboxEntityObject:(NSString *)entityName messageID:(int)messageID 
{
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageId = %d",messageID];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    

    return result;
}

+(id)fetchDirectoryObjectForEntity:(NSString *)entityName selectBy:(int)directoryID
{
    NSLog(@"directoryID == %d",directoryID);
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.physicianId = %@",[NSNumber numberWithInt:directoryID]];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}


//
+(id)fetchDirectoryObjectsForEntity:(NSString *)entityName selectByName:(NSString *)physiciansName   {
    
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.physicianName = %@",physiciansName];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}
//



+(id)fetchDiscussionParticipantsObjectForEntity:(NSString *)entityName selectBy:(int)participantId
{
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.participantId = %@",[NSNumber numberWithInt:participantId]];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}

+(id)fetchExistingEntityObject:(NSString *)entityName attributeName:(NSString*)attibute selectBy:(int)attributeValue
{
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSString *attribute = [NSString stringWithFormat:@"%@",attibute];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.%@ = %@",attribute,[NSNumber numberWithInt:attributeValue]];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}

+(id)fetchExistingInboxEntityObject:(NSString *)entityName messageID:(int)messageID messageType:(int)messageType 
{
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageId = %d AND SELF.messageType = %d",messageID,messageType];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}



+(id)fetchExistingEntityTouchBaseObject:(NSString *)entityName discussionId:(NSString*)discussionId 
{
    NSError *error;
    id managedObject = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.discussionId = %@",discussionId];
    fetchRequest.predicate = predicate;
    
    NSArray *result = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if(error)
        NSLog(@"Error while fetching managedObject Reason : %@",[error description]);
    
    if([result count]>0 && error==nil)
        managedObject = [result lastObject];
    
    return managedObject;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (fetchedResultsController != nil)
    {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoverageCalendar" inManagedObjectContext:[[CoreDataHandler sharedHandler] managedObjectContext]];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[CoreDataHandler sharedHandler] managedObjectContext] sectionNameKeyPath:@"date" cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
	fetchedResultsController = aFetchedResultsController;
	
	return fetchedResultsController;
}

#pragma mark - entity object deletion
- (BOOL) deleteAllObjects: (NSString *) entityDescription 
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[[CoreDataHandler sharedHandler] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[[CoreDataHandler sharedHandler] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    fetchRequest = nil;
    
    NSLog(@"DELETE ARRAY COUNT %d :::::",[items count]);
    for (NSManagedObject *managedObject in items) {
        [[[CoreDataHandler sharedHandler] managedObjectContext] deleteObject:managedObject];
//        NSLog(@"%@ object deleted",entityDescription);
    }
    
    BOOL isSaved = [DataManager saveContext];
    return isSaved;
}

- (void)dealloc
{
    fetchedResultsController = nil;
}
@end

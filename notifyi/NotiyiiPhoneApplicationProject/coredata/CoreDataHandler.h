//
//  CoreDataHandler.h

//  coredataSample
//
//  Created by Nithin George on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataHandler : NSObject
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
+(id)sharedHandler;
- (void)resetPersistentStoreCoordinator;
@end

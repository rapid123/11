//
//  CoreDataHandler.m
//  coredataSample
//
//  Created by Nithin George on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "CoreDataHandler.h"

static id sharedHandler = nil;

@interface CoreDataHandler ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end

@implementation CoreDataHandler

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

#pragma mark - Shared
+(id)sharedHandler
{
    if(sharedHandler==nil)
        sharedHandler = [[[self class] alloc] init];
    
    return sharedHandler;
}

- (void)resetPersistentStoreCoordinator
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/NotifyDataBase.sqlite"];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[storeURL path]])
    {
        
        [fileManager removeItemAtURL:storeURL error:NULL];
        
        sharedHandler = nil;
        _managedObjectModel = nil;
        _managedObjectContext = nil;
        _persistentStoreCoordinator = nil;
        
    }
        
}

#pragma mark -
#pragma mark Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    NSURL *storeURL = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"NotifyDataBase.sqlite"]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"NotifyDataBase" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
}

@end

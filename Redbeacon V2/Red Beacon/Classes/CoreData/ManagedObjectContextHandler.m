//
//  ManagedObjectContextHandler.m
//  myCoreData
//
//  Created by Jayahari V on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectContextHandler.h"
#import "Occupation.h"
#import "Cities.h"
#import "OccupationModel.h"

@implementation ManagedObjectContextHandler

//static NSString * databaseName = @"RedBeaconDB.sqlite";
static NSString * dbName = @"RedBeaconDB";
static NSString * dbExtention =@"sqlite";

#pragma mark - Initialization
//Entity Names
static NSString * kOccupationEntityName = @"Occupation";
static NSString * kKeyOccupationDisplayName = @"display_name";
static NSString * kKeyOccupationInternalName = @"internal_name";
static NSString * kCitiesEntityName = @"Cities";

//Singleton class!
+(id)sharedInstance {
	static id master = nil;
	
	@synchronized(self)
	{
		if (master == nil)
			master = [self new];
	}
    
    return master;
}

#pragma mark - Helper methods

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
#pragma mark - Core Data stack

/*******************************************************************************
 *  Function Name:managedObjectContext
 *  Purpose:  Returns the managed object context for the application.
 *  Parametrs:nil
 *  Return Values:Managed object context
 ********************************************************************************/

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/*******************************************************************************
 *  Function Name:managedObjectModel
 *  Purpose: Returns the managed object model for the application.
 *  Parametrs:nil
 *  Return Values:Managed object model
 ********************************************************************************/

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/*******************************************************************************
 *  Function Name:persistentStoreCoordinator
 *  Purpose:Returns the persistent store coordinator for the application.
 *  Parametrs:nil
 *  Return Values:Persistent store coordinator
 ********************************************************************************/

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString * applicationDBPath = [[NSBundle mainBundle] pathForResource:dbName ofType:dbExtention];
    NSString * fullNameDb = [dbName stringByAppendingFormat:@".%@",dbExtention];
    NSString * documentsDBPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fullNameDb];
    NSError * error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:applicationDBPath 
                                            toPath:documentsDBPath 
                                             error:&error];
    
    NSURL *storeUrl = [NSURL fileURLWithPath:documentsDBPath];
	
//    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
								  initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}    
	
	return persistentStoreCoordinator;
}

#pragma mark - Occupations
/*******************************************************************************
 *  Function Name   :saveOccupations
 *  Purpose         :To save occupation list
 *  Parametrs       :array of occupations(dictionary)
 *  Return Values   :success or not
 ********************************************************************************/
- (BOOL)saveOccupations:(NSMutableArray*)occupations {
    
    BOOL success = NO;
    @try {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        Occupation * occupationEntity;
        NSError *error;
        
        //delete existing
        NSEntityDescription *entity = [NSEntityDescription entityForName:kOccupationEntityName
                                                  inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSArray *dataStore = [context executeFetchRequest:request error:&error];
        [request release];
        if (!dataStore){
            NSLog(@"Error occured fetching OccupationsEntity objects: %@, %@", error, [error userInfo]);
            return NO;
        }
        for (Occupation *tmp in dataStore){
            [context deleteObject:tmp];
        }
        if (![context save:&error]){
            NSLog(@"Error on OccupationEntity context save after delete: %@, %@", error, [error userInfo]);
            return NO;
        }

        
        //insertion
        for (NSDictionary * occupation in occupations) {
            occupationEntity = (Occupation *)[NSEntityDescription insertNewObjectForEntityForName:kOccupationEntityName
                                                                           inManagedObjectContext:context];
            [occupationEntity setDisplay_name:[occupation valueForKey:kKeyOccupationDisplayName]];
            [occupationEntity setInternal_name:[occupation valueForKey:kKeyOccupationInternalName]];
        }
        
        //save context
        if (![context save:&error]) {
            NSLog(@"Error on OccupationsEntity context save: %@, %@", error, [error userInfo]);
            success = NO;
        }        
        success = YES;
    }
    @catch (NSException * e) {
        
        success = NO;
    }    
    return success;    
}

- (NSMutableArray*)fetchAllOccupations {
    NSMutableArray * occupations = [[NSMutableArray alloc] init];
    
    OccupationModel * occupationModel;    
    NSManagedObjectContext *context = [self managedObjectContext];    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kOccupationEntityName
                                              inManagedObjectContext:context];    
    [request setEntity:entity];
    NSError *error;
    
    //get all objects
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    [request release];
    Occupation *occupationEntity;
    
    //parse
    for(int i=0;i<[mutableFetchResults count];i++)
    {        
        occupationModel = [[OccupationModel alloc] init];
        occupationEntity = [mutableFetchResults objectAtIndex:i];
        occupationModel.displayName = occupationEntity.display_name;
        occupationModel.internalName = occupationEntity.internal_name;
        [occupations addObject:occupationModel];
        [occupationModel release];
    }
    [mutableFetchResults release];
    return [occupations autorelease];
}

- (NSString*)getInternalNameForDisplayName:(NSString*)displayName {
    
    NSString * internalName = @"";
    Occupation * occupationEntity = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kOccupationEntityName
                                              inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    //set condition
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"display_name = %@",displayName];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    [request release];
    
    if (fetchResults.count > 0){
        occupationEntity = (Occupation *)[fetchResults objectAtIndex:0];
    }
    if(occupationEntity)
        internalName = occupationEntity.internal_name;
    return internalName;
}

#pragma mark - Zipcode methods
/*******************************************************************************
 *  Function Name   :saveZipCodes
 *  Purpose         :To save zipcode list
 *  Parametrs       :array of zips(numbers)
 *  Return Values   :success or not
 ********************************************************************************/
- (BOOL)saveCities:(NSMutableDictionary*)cities {
    
    BOOL success = NO;
    @try {
        
        NSManagedObjectContext *context = [self managedObjectContext];
        Cities * citiesEntity;
        NSError *error;
        
        //delete existing
        NSEntityDescription *entity = [NSEntityDescription entityForName:kCitiesEntityName 
                                                  inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSArray *dataStore = [context executeFetchRequest:request error:&error];
        [request release];
        if (!dataStore){
            NSLog(@"Error occured fetching Cities objects: %@, %@", error, [error userInfo]);
            return NO;
        }
        for (Cities *tmp in dataStore){
            [context deleteObject:tmp];
        }        
        if (![context save:&error]){
            NSLog(@"Error on Cities context save after delete: %@, %@", error, [error userInfo]);
            return NO;
        }
        
        NSArray * keys = [cities allKeys];
        //insertion
        for (NSString * key in keys) {
            
            NSArray * zipcodes = [cities objectForKey:key];
            for (NSString * zipcode in zipcodes) 
            {
                citiesEntity = (Cities *)[NSEntityDescription insertNewObjectForEntityForName:kCitiesEntityName
                                                                       inManagedObjectContext:context];
                [citiesEntity setZipcode:zipcode];
                [citiesEntity setCity:key];
            }
            
        }
        
        //save context
        if (![context save:&error]) {
            NSLog(@"Error on Cities context save: %@, %@", error, [error userInfo]);
            success = NO;
        }        
        success = YES;
    }
    @catch (NSException * e) {
        
        success = NO;
    }    
    return success;    
}

- (BOOL)isZipcodeExists:(NSString*)zipcode {
    BOOL zipExists = NO;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCitiesEntityName
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    
    //set condition
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"zipcode = %@",zipcode];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    [request release];
    
    if (fetchResults.count > 0){
        zipExists = YES;
    }
    else {
        zipExists = NO;
    }
    return zipExists;
    
}

- (NSString*)getCityNameForZipcode:(NSString*)zipcode 
{
    NSString * cityName = @"";
    Cities * citiesEntity;
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:kCitiesEntityName
                                              inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    //set condition
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"zipcode = %@",zipcode];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:request error:&error];
    [request release];
    
    if (fetchResults.count > 0){
        citiesEntity = (Cities *)[fetchResults objectAtIndex:0];
        cityName = citiesEntity.city;
    }
    
    return cityName;
}

@end

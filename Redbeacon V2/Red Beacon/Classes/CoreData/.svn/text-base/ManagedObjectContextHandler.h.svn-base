//
//  ManagedObjectContextHandler.h
//  myCoreData
//
//  Created by Jayahari V on 02/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ManagedObjectContextHandler : NSObject {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;       
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(id)sharedInstance;

//occupation
- (BOOL)saveOccupations:(NSMutableArray*)occupations;
- (NSString*)getInternalNameForDisplayName:(NSString*)displayName;
- (NSMutableArray*)fetchAllOccupations;
//zipcode
- (BOOL)saveCities:(NSMutableDictionary*)city;
- (BOOL)isZipcodeExists:(NSString*)zipcode;
- (NSString*)getCityNameForZipcode:(NSString*)zipcode;

@end

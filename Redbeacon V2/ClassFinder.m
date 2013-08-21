//
//  ClassFinder.m
//
//  Created by sudeep on 07/02/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "ClassFinder.h"


@implementation ClassFinder


static NSMutableDictionary *objectInstances = nil;

/*!
 Return an instance of the named class. If all allocations of that
 class are done via this method, then there will be only one instance
 of the class. The instance is instantiated if necessary, and uses
 the no-parameter init method only.
 
 Callers must not release the returned object. To forcefully remove
 an instance located here from memory, use the unload: method.
 */
+(id)locate:(NSString *)className
{
    id object = nil;
    @synchronized(self) {
        if (!objectInstances) {
            objectInstances = [[NSMutableDictionary alloc] init];
        }
        object = [objectInstances objectForKey:className];
        if (!object) {
            object = [[NSClassFromString(className) alloc] init];
            if (object) [objectInstances setObject:object forKey:className];
            [object release];
        }
    }
    return object;
}

/*!
 Remove an instance of the named class from the locator cache.
 The next call to locate: will result in a new instance being created.
 */
+(void)unload:(NSString *)className
{
    @synchronized(self) {
        [objectInstances removeObjectForKey:className];
    }
}

/*!
 Release all cache resources.
 */
+(void)releaseInstances
{
    @synchronized(self) {
        if(objectInstances) {
            [objectInstances release];
            objectInstances = nil;
        }
    }
}



@end

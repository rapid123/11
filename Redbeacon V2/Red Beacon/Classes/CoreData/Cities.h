//
//  Cities.h
//  Red Beacon
//
//  Created by Jayahari V on 14/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cities : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zipcode;

@end

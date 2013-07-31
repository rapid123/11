//
//  GeneralClass.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Veena on 20/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface Global : NSObject {

	NSString *messageType;
}

@property(nonatomic, retain) NSString *messageType;

+(Global*)getInstance;

@end

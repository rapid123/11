//
//  RBNetworkQueueDelegate.h
//  Red Beacon
//
//  Created by RapidValue Solutions on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RBNetworkQueueDelegate <NSObject>
    -(void)queueFinished:(ASIHTTPRequest *)request;
@end

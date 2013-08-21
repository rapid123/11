//
//  LocationManager.m
//  BrightonMcom
//
//  Created by Rapidvalue on 06/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager

@synthesize locationManager;
@synthesize delegate;

static LocationManager *m_objLocationManager;

+(LocationManager*)sharedManager{
	if (!m_objLocationManager) {
		m_objLocationManager=[[LocationManager alloc] init];
	}
	return m_objLocationManager;
}

- (id) init {
	self = [super init];
	if (self != nil) {
        
        CLLocationManager *location = [[CLLocationManager alloc] init];
		self.locationManager = location;
        [location release];
	
        self.locationManager.delegate = self; // send loc updates to myself
		
		
		if([[[UIDevice currentDevice] systemVersion] intValue]<4.0)	{
			
			if (self.locationManager.locationServicesEnabled == NO) {
				UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[servicesDisabledAlert show];
				[servicesDisabledAlert release];
			}
		}
		
		else{
			
			//iPhone OS 4.0
			if([locationManager locationServicesEnabled]==NO){
				UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[servicesDisabledAlert show];
				[servicesDisabledAlert release];
			}
		}
		
	}
	return self;
}

-(void)startGPSScan{
	[self.locationManager startUpdatingLocation];
}

-(void)stopGPSScan{
	[self.locationManager stopUpdatingLocation];
}

/*-(void)checkLocationServicesEnabled {
	if([[[UIDevice currentDevice] systemVersion] intValue]<4.0) {
		
		if (self.locationManager.locationServicesEnabled == NO) {
			UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[servicesDisabledAlert show];
			[servicesDisabledAlert release];
		}
	}
	
	else{
		
		//iPhone OS 4.0
		if([CLLocationManager locationServicesEnabled]==NO){
			UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[servicesDisabledAlert show];
			[servicesDisabledAlert release];
		}
	}
}*/

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self.delegate locationUpdate:newLocation];
	//[locationManager stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)dealloc {
    
	self.locationManager = nil;
    [super dealloc];
}

@end

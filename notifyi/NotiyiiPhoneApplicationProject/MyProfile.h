//
//  MyProfile.h
//  NotiyiiPhoneApplicationProject
//
//  Created by Amal T on 20/12/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyProfile : NSManagedObject

@property (nonatomic, retain) NSString * communicationPreference;
@property (nonatomic, retain) NSString * contactInfo;
@property (nonatomic, retain) NSNumber * coverageStatus;
@property (nonatomic, retain) NSNumber * faxStatus;
@property (nonatomic, retain) NSString * hospital;
@property (nonatomic, retain) NSString * imagepath;
@property (nonatomic, retain) NSNumber * inboxStatus;
@property (nonatomic, retain) NSString * practice;
@property (nonatomic, retain) NSString * speciality;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * state;

@end

//
//  JobBids.m
//  Red Beacon
//
//  Created by Nithin George on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobBids.h"
#import "RBCurrentJobResponse.h"

//*****************************RBSCORE*********************
#pragma mark - JobRBScore

@implementation JobRBScore

@synthesize information;
@synthesize reputation;
@synthesize total;

- (void)dealloc
{
  
    [super dealloc];
}

@end


//*****************************Review*********************
#pragma mark - Review

@implementation Review

@synthesize rating;
@synthesize review_id;
@synthesize profile_id;
@synthesize author;
@synthesize content;
@synthesize date;

- (void)dealloc
{
    
    [author release];
    [content release];
    [date release];
    
    [super dealloc];
}

@end

//*****************************WorkImage*********************
#pragma mark - WorkImage


@implementation WorkImage

@synthesize thumbnail_url;
@synthesize image_url;

- (void)dealloc
{
    
    [thumbnail_url release];
    [image_url release];
    
    [super dealloc];
}

@end


//*****************************JobBidProfile*********************
#pragma mark - JobBidProfile

@implementation JobBidProfile

@synthesize phone;
@synthesize  website;
@synthesize  best_name;
@synthesize  profile_id;
@synthesize  review_count;
@synthesize  license_number;
@synthesize  location;
@synthesize  average_rating;
@synthesize  insured_amt;
@synthesize  avatar_url;
@synthesize  text_rating;
@synthesize  integer_rating;
@synthesize  occupation;
@synthesize  bonded_amt;
@synthesize  rbScore;

@synthesize is_insured;
@synthesize is_bonded;
@synthesize is_licensed;
@synthesize is_active;

@synthesize details;
@synthesize workImages;
@synthesize reviews;

@synthesize rateDistribution;

-(int)numberOfFeatures {
    
    int count = 0;
    if(self.is_bonded)
        count ++ ;
    if (self.is_insured) 
        count ++ ;
    if (self.is_licensed)
        count ++ ;
    
    return count;
}

-(NSArray *)profileDetailsToDisplay {
    
    NSMutableDictionary *detailDescription ;
    NSMutableArray *detailDescriptionArray = [[NSMutableArray alloc] init];

    detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.rbScore,RBSCORE_KEY, nil];
    [detailDescriptionArray addObject:detailDescription];
    [detailDescription release];
    detailDescription=nil;
    
    if(self.is_bonded){
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.bonded_amt,BONDED_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    if (self.is_insured) {
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.insured_amt,INSURED_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    if (self.is_licensed) {
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.license_number,LICENSED_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    if([self.workImages count] > 0) {
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.workImages,WORK_IMAGES_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    if([self.details count] > 0) {
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.details,DETAILS_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    if([self.website length]>0) {
        detailDescription = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.website,WEBSITE_KEY, nil];
        [detailDescriptionArray addObject:detailDescription];
        [detailDescription release];
        detailDescription=nil;
    }
    [detailDescription release];
    detailDescription = nil;
    
    return (NSArray *)[detailDescriptionArray autorelease];
        
}

- (void)dealloc
{
    [phone release];
    [website release];
    [best_name release];
    [profile_id release];
    [review_count release];
    [license_number release];
    [location release];
    [average_rating release];
    [insured_amt release];
    [avatar_url release];
    [text_rating release];
    [integer_rating release];
    [occupation release];
    [bonded_amt release];
    
    [rbScore release];
    
    [details release];
    [workImages release];
    [reviews release];
    
    [rateDistribution release];
    
    [super dealloc];
}

@end



//*****************************JobPrivateMessage*********************
#pragma mark - JobPrivateMessage


@implementation JobPrivateMessage


@synthesize message;
@synthesize sender;
@synthesize timeCreated;
@synthesize is_provider;
@synthesize messageId;
@synthesize has_been_read_by_consumer;

- (void)dealloc
{
    
    [message release];
    [sender release];
    [timeCreated release];
    [super dealloc];
}

@end




//*****************************JobBids*********************
#pragma mark - JobBids

@implementation JobBids

@synthesize bidID;
@synthesize number_of_minutes;
@synthesize number_of_hours;
@synthesize estimate_high;
@synthesize total_price;
@synthesize flat_rate;
@synthesize hourly_rate;
@synthesize estimate_low;
@synthesize require_onsite;
@synthesize is_parts_excluded;
@synthesize description;
@synthesize time_created_fuzzy;
@synthesize eta;
@synthesize winning;
@synthesize rejected_by_consumer;

@synthesize jobProfile;
@synthesize privateMessages;


- (void)dealloc
{

   [description release];
   [time_created_fuzzy release];
   [eta release];
   [winning release];
   [jobProfile release];
   [privateMessages release];
   [super dealloc];
    
}

-(BOOL)hasPrivateMessages {
    
    BOOL hasPvtMessages = NO;
    if([self.privateMessages count]>0)
        hasPvtMessages = YES;
    
    return hasPvtMessages;
}
-(BOOL)messageReadStatus {
    
    NSLog(@"Count:- %d",[self.privateMessages count]);
    BOOL mesageStatus = NO;
    JobPrivateMessage *jobPrivateMessage;
    for (int i =0; i<[self.privateMessages count]; i++) {
        
        jobPrivateMessage = [self.privateMessages objectAtIndex:i];
        if (!jobPrivateMessage.has_been_read_by_consumer) {
            
            mesageStatus = YES;
            break;
        }
    }
        
    
    return mesageStatus;
}

-(BOOL)hasJobDetail {
    
    BOOL hasDetailDescription = NO;
    if([self.description length] > 0)
        hasDetailDescription = YES;
    
    return hasDetailDescription;
    
}

-(NSString *)lastPrivateMessage {
    
    NSString *displayString = @"";
    if([self hasPrivateMessages]){
        
        NSArray *privatemessages = [self privateMessages];
        JobPrivateMessage *prvateMessage = [privatemessages lastObject];
        if(prvateMessage.message)
            displayString = [prvateMessage message];
    }
    else {
        displayString = self.description;
    }
    
    return displayString;
}


#pragma mark - appointed date

-(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];  
    NSString* dateAndTimeString = [formatter stringFromDate:date];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:@" @ "];
    [formatter setDateFormat:@"h:mmaa"];
    dateAndTimeString = [dateAndTimeString stringByAppendingString:[formatter stringFromDate:date]];
    [formatter release];
    return dateAndTimeString;
    
}

-(NSString *)originalAppointmentDate {   // 
    
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    NSString * type = jobDetail.auctionType;
    NSString * name = nil;
    if (type)  // if its shcheduled date type
    {
        if ([type isEqualToString:SCHEDULE_TYPE_DATE]) 
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            NSDate * date = jobDetail.startDate;
            [formatter setDateFormat:@"h:mm aa, MMMM dd, yyyy"];
            name = [formatter stringFromDate:date];
            [formatter release];
            formatter = nil;
            
        }
    }
    return name;
}

-(NSString *)appointedDate {
    
    NSString *appointedDate = nil;
    RBCurrentJobResponse *rBCurrentJobResponse = LOCATE(RBCurrentJobResponse);
    JobResponseDetails *jobDetail=[rBCurrentJobResponse jobResponse];
    
    if([jobDetail.winningBidIDs count] == 0)
        return nil;
    
    int winningBidID = [[jobDetail.winningBidIDs objectAtIndex:0] intValue];
    if(winningBidID == self.bidID) {
        appointedDate =  [self dateToString:jobDetail.appointmentedDate withFormat:@"EE., MMM dd"];
    }
    return appointedDate;
}

#pragma mark - 

-(NSString *)lastPrivatemessageDate {
    
    NSString *converseDate = @"";
    if([self hasPrivateMessages]){
        
        NSArray *privatemessages = [self privateMessages];
        JobPrivateMessage *prvateMessage = [privatemessages lastObject];
        if(prvateMessage.message)
            converseDate = [self dateToString:[prvateMessage timeCreated] withFormat:@"MMM dd"];
    }
    
    return converseDate;
}


@end

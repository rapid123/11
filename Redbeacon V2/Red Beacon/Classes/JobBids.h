//
//  JobBids.h
//  Red Beacon
//
//  Created by Nithin George on 07/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//**********************JobRBScore*******************
#pragma mark - JobRBScore

@interface JobRBScore : NSObject {

    int information;
    int reputation;
    int total;
    
}
@property (nonatomic) int information;
@property (nonatomic) int reputation;
@property (nonatomic) int total;

@end

//**********************WorkImage*******************
#pragma mark - WorkImage

@interface WorkImage : NSObject {
    
    NSString *thumbnail_url;
    NSString *image_url;
    
}
@property (nonatomic, retain) NSString *thumbnail_url;
@property (nonatomic, retain) NSString *image_url;

@end

//**********************Review*******************
#pragma mark - Review

@interface Review : NSObject {
    
    int rating;
    int review_id;
    int profile_id;
    NSString *author;
    NSString *content;
    NSDate *date;
    
}

@property (nonatomic) int rating;
@property (nonatomic) int review_id;
@property (nonatomic) int profile_id;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *date;

@end


//**********************JobBidProfile*******************
#pragma mark - JobBidProfile

@interface JobBidProfile : NSObject {
    
    NSString * website;
    NSString * best_name;
    NSString * profile_id;
    NSString * review_count;
    
    NSString * license_number;
    NSString * location;
    
    NSString * average_rating;
    NSString * insured_amt;
    NSString * avatar_url;
    
    NSString * text_rating;
    NSString * integer_rating;
    NSString * occupation;
    NSString * bonded_amt;
    NSString *phone;
    
    BOOL is_insured;
    BOOL is_bonded;
    BOOL is_licensed;
    BOOL is_active;
    
    JobRBScore * rbScore;
    
    NSArray *details;
    NSArray *workImages;
    NSArray *reviews;
    
    NSDictionary *rateDistribution;
}

@property (nonatomic) BOOL is_insured;
@property (nonatomic) BOOL is_bonded;
@property (nonatomic) BOOL is_licensed;
@property (nonatomic) BOOL is_active;

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * best_name;
@property (nonatomic, retain) NSString * profile_id;
@property (nonatomic, retain) NSString * review_count;
@property (nonatomic, retain) NSString * license_number;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * average_rating;
@property (nonatomic, retain) NSString * insured_amt;
@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * text_rating;

@property (nonatomic, retain) NSString * integer_rating;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * bonded_amt;

@property (nonatomic, retain) JobRBScore *rbScore;

@property (nonatomic, retain) NSArray *details;
@property (nonatomic, retain) NSArray *workImages;
@property (nonatomic, retain) NSArray *reviews;

@property (nonatomic, retain) NSDictionary *rateDistribution;

-(int)numberOfFeatures ;
-(NSArray *)profileDetailsToDisplay;

@end


//**********************JobPrivateMessage*******************
#pragma mark - JobPrivateMessage

@interface JobPrivateMessage : NSObject {
    
    NSString * message;
    NSString * sender;
    NSDate   * timeCreated;
    
    BOOL has_been_read_by_consumer;
    BOOL is_provider;
    int messageId;
    
}
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSDate * timeCreated;
@property (nonatomic) BOOL has_been_read_by_consumer;
@property (nonatomic) BOOL is_provider;
@property (nonatomic) int messageId;

@end




//**********************JobBids*******************
#pragma mark - JobBids

@interface JobBids : NSObject {
    
    int bidID;
    int number_of_minutes;
    int number_of_hours;
    
    float estimate_high;
    int total_price;
    float flat_rate;
    float hourly_rate;
    float estimate_low;
    
    BOOL require_onsite;
    BOOL is_parts_excluded;
    BOOL rejected_by_consumer;
    
    NSString * description;
    NSString * time_created_fuzzy;
    
    NSString * eta;
    NSString * winning;
    
    JobBidProfile *jobProfile;
    
    NSMutableArray *privateMessages;
    
}


@property (nonatomic) int bidID;
@property (nonatomic) int number_of_minutes;
@property (nonatomic) int number_of_hours;

@property (nonatomic) float estimate_high;
@property (nonatomic) int total_price;
@property (nonatomic) float flat_rate;
@property (nonatomic) float hourly_rate;
@property (nonatomic) float estimate_low;

@property (nonatomic) BOOL require_onsite;
@property (nonatomic) BOOL is_parts_excluded;
@property (nonatomic) BOOL rejected_by_consumer;

@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * time_created_fuzzy;

@property (nonatomic, retain) NSString * eta;
@property (nonatomic, retain) NSString * winning;

@property (nonatomic, retain) JobBidProfile *jobProfile;
@property (nonatomic, retain) NSMutableArray *privateMessages;


-(BOOL)messageReadStatus;
-(BOOL)hasPrivateMessages ;
-(BOOL)hasJobDetail ;
-(NSString *)lastPrivateMessage;
-(NSString *)appointedDate;
-(NSString *)originalAppointmentDate;
-(NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;
-(NSString *)lastPrivatemessageDate;
@end
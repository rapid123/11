//
//  JobResponseDetails.h
//  Red Beacon
//
//  Created by Nithin George on 03/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobDocuments : NSObject {
    
    NSString * urlOfImage;
    NSString * thumbnailUrl;
    NSString * job_id;
    NSString * ogg_file;
    NSString * file_type;
    NSString * ogv_file;
    NSString * mp3_file;
    NSString * urlId;
    NSString * mp4_file;
    NSString * webm_file;
    int duration_in_ms;
    
    
}

@property (nonatomic, retain) NSString * urlOfImage;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * job_id;
@property (nonatomic, retain) NSString * ogg_file;
@property (nonatomic, retain) NSString * file_type;
@property (nonatomic, retain) NSString * ogv_file;
@property (nonatomic, retain) NSString * mp3_file;
@property (nonatomic, retain) NSString * urlId;
@property (nonatomic, retain) NSString * mp4_file;
@property (nonatomic, retain) NSString * webm_file;
@property (nonatomic) int duration_in_ms;


@end


@interface JobImages : JobDocuments {
    
}

@end


//**********************JOBQAS*******************
#pragma mark - JOBQAS

@interface JOBQAS : NSObject {
    
    NSString * question;
    NSString * answer;
    NSDate   * time_created;
    NSDate   * time_answered;
    
    BOOL has_been_read_by_consumer;
    int question_id;
    
}
@property (nonatomic, retain) NSString * question;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSDate * time_created;
@property (nonatomic, retain) NSDate   * time_answered;
@property (nonatomic) BOOL has_been_read_by_consumer;
@property (nonatomic) int question_id;

@end



//**********************JOBUPDATES*******************
#pragma mark - JobUpdates

@interface JobUpdates : NSObject {
    
    NSString * details;
    NSDate   * time_updated;
    int update_id;
    
}
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSDate * time_updated;
@property (nonatomic) int update_id;

@end

//**********************JobResponseDetails*******************

#pragma mark - JobResponseDetails

@interface JobResponseDetails : NSObject {
    
    NSString * jobType;
    NSString * status;
    NSString * status_mobile;
    NSString * auctionType;
    NSString * jobRequestName;
    NSString * jodDetails;
    NSString * jobLocationID;
    NSString * jobID;
    int bid_count;
    int jobImageCount;
    JobDocuments *jobDocument;
    JobImages *jobImage;
    
    NSMutableArray *jobDocuments;
    NSMutableArray *jobImages;
    
    NSString *attachmentDetail;
    
    NSDate *startDate;
    NSDate *endDate;
    NSDate *appointmentedDate;
    NSDate *timeBooked;
    
    NSString *time_begin_fuzzy;
    
    NSArray *jobBids;
    NSArray *winningBidNames;
    NSMutableArray *winningBidIDs;
    
    UIImage *jobIcon;
    BOOL hasVideo;
    BOOL hasAudio;
    BOOL appointmentAccepted;
    BOOL rejected_by_consumer;
    BOOL location_in_launched_zips;    
    
    
    NSMutableArray *jobQAS;
    NSMutableArray *updates;
    NSString *fileDuration;
    
}

@property (nonatomic) BOOL hasVideo;
@property (nonatomic) BOOL hasAudio;
@property (nonatomic) BOOL appointmentAccepted;
@property (nonatomic, retain) NSString * jobType;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * status_mobile;
@property (nonatomic, retain) NSString * auctionType;
@property (nonatomic, retain) NSString * jobRequestName;
@property (nonatomic, retain) NSString * jodDetails;
@property (nonatomic, retain) NSString * jobLocationID;
@property (nonatomic, retain) NSString * jobID;
@property (nonatomic, retain) NSString *attachmentDetail;
@property (nonatomic) int bid_count;
@property (nonatomic) int jobImageCount;

@property (nonatomic, retain) JobDocuments *jobDocument;
@property (nonatomic, retain) JobImages *jobImage;

@property (nonatomic, retain) NSMutableArray *jobDocuments;
@property (nonatomic, retain) NSMutableArray *jobImages;

@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSDate *appointmentedDate;
@property (nonatomic, retain) NSDate *timeBooked;

@property (nonatomic, retain) NSString *time_begin_fuzzy;

@property (nonatomic, retain) NSArray *jobBids;
@property (nonatomic, retain) NSArray *winningBidNames;
@property (nonatomic, retain) NSMutableArray *winningBidIDs;
@property (nonatomic) BOOL rejected_by_consumer;
@property (nonatomic) BOOL location_in_launched_zips;

@property (nonatomic, retain) UIImage *jobIcon;
@property (nonatomic, retain) NSMutableArray *jobQAS;

@property (nonatomic, retain) NSString *fileDuration;
@property (nonatomic, retain) NSMutableArray *updates;


- (BOOL)isAudioDescriptionPresent ;
- (BOOL)isVideoDescriptionPresent ;
- (BOOL)doesImageExists ;
- (BOOL)hasJobQAS;
- (BOOL)hasUpdates;
- (BOOL)isJobCancelledOrKilled;
- (BOOL)isReviewed;
- (BOOL)isJobExpired;

- (int)getBidIndexOfBidId:(int)bidId;
- (NSString *)getFileDuration ;
- (int)getImageCount;
- (NSString *)audioUrl ;
- (NSString *)videoUrl ;
- (JobImages *) getFirstImage ;
- (NSString *)jobServicerName ;
- (JobDocuments *)getVideoDocument ;



@end

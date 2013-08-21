//
//  JobResponseDetails.m
//  Red Beacon
//
//  Created by Nithin George on 03/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JobResponseDetails.h"
#import "JobBids.h"


@implementation JobDocuments

@synthesize urlOfImage;
@synthesize thumbnailUrl;
@synthesize job_id;
@synthesize ogg_file;
@synthesize file_type;
@synthesize ogv_file;
@synthesize mp3_file;
@synthesize urlId;
@synthesize mp4_file;
@synthesize webm_file;
@synthesize duration_in_ms;

- (void)dealloc
{
    [urlOfImage release];
    [thumbnailUrl release];
    [job_id release];
    [ogg_file release];
    [file_type release];
    [ogv_file release];
    [mp3_file release];
    [urlId release];
    [mp4_file release];
    [webm_file release];
    //[duration_in_ms release];
    
    [super dealloc];
}

@end


@implementation JobImages

- (void)dealloc {
    
    [super dealloc];
}

@end



//*****************************JOBQAS*********************
#pragma mark - JOBQAS


@implementation JOBQAS


@synthesize question;
@synthesize answer;
@synthesize time_created;
@synthesize time_answered;
@synthesize has_been_read_by_consumer;
@synthesize question_id;

- (void)dealloc
{
    [time_created release];
    [time_answered release];
    [answer release];
    [question release];
    
    [super dealloc];
}

@end

//*****************************JobUpdates*********************
#pragma mark - JobUpdates


@implementation JobUpdates

@synthesize details;
@synthesize time_updated;
@synthesize update_id;

- (void)dealloc
{
    [details release];
    [time_updated release];
    
    [super dealloc];
}

@end


@implementation JobResponseDetails
 
@synthesize jobType;
@synthesize status;
@synthesize status_mobile;
@synthesize auctionType;
@synthesize jobRequestName;
@synthesize jodDetails;
@synthesize jobLocationID;
@synthesize jobID;
@synthesize bid_count;
@synthesize jobImageCount;

@synthesize jobDocument;
@synthesize jobImage;
@synthesize jobDocuments;
@synthesize jobImages;

@synthesize attachmentDetail;
@synthesize time_begin_fuzzy;

@synthesize startDate;
@synthesize endDate;
@synthesize appointmentedDate;
@synthesize timeBooked;
@synthesize jobBids;
@synthesize jobIcon;

@synthesize hasVideo;
@synthesize hasAudio;
@synthesize appointmentAccepted;
@synthesize winningBidNames;
@synthesize winningBidIDs;
@synthesize rejected_by_consumer;
@synthesize location_in_launched_zips;

@synthesize jobQAS;
@synthesize updates;
@synthesize fileDuration;

- (void)dealloc
{
    [jobType release];
    [status release];
    [status_mobile release];
    
    [auctionType release];
    [jobRequestName release];
    [jodDetails release];
    [jobLocationID release];
    [jobID release];
    
    [jobDocument release];
    [jobImage release];
    
    [jobImages release];
    [jobDocuments release];
    [attachmentDetail release];
    
    [startDate release];
    [endDate release];
    [appointmentedDate release];
    [timeBooked release];
    
    [time_begin_fuzzy release];
    [jobBids release];
    
    [jobIcon release];

    [winningBidNames release];
    [winningBidIDs release];
    
    [jobQAS release];
    [updates release];
    [fileDuration release];
    
    [super dealloc];
}

#pragma mark - checkers

-(BOOL)isAudioDescriptionPresent {
    
    self.hasAudio = NO;
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"audio"]) {
            self.hasAudio = YES;
            break;
        }
    }
    return self.hasAudio;
}

-(BOOL)isVideoDescriptionPresent {
    
    self.hasVideo = NO;
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"video"]) {
            self.hasVideo = YES;
            break;
        }
    }
    return self.hasVideo;
}

- (BOOL)doesImageExists {
    
    return ([self.jobImages count] > 0);
}


-(BOOL)hasJobQAS {
    
    BOOL hasQAS = NO;
    if([self.jobQAS count]>0)
        hasQAS = YES;
    
    return hasQAS;
    
}

-(BOOL)hasUpdates {
    
    BOOL hasUpdate = NO;
    if([self.updates count]>0)
        hasUpdate = YES;
    
    return hasUpdate;
}

-(BOOL)isJobCancelledOrKilled {
    
    BOOL isCancelled = NO;
    
    NSString *jobStatus = [self status];
    if([jobStatus isEqualToString:JOB_STATUS_CANCELLED] || [jobStatus isEqualToString:JOB_STATUS_KILLED])
        isCancelled = YES;
    else if([[self status_mobile] isEqualToString:JOB_MOBILE_STATUS_CANCELLED])
        isCancelled = YES;
    
    return isCancelled;
}

-(BOOL)isJobExpired {
    
    BOOL isExpired = NO;
    
    NSString *jobStatus = [self status];
    if([jobStatus isEqualToString:JOB_STATUS_EXPIRED])
        isExpired = YES;
    
    return isExpired;
}


-(BOOL)isReviewed {
    
    BOOL hasBeenReviewed = NO;
    if([self.status_mobile isEqualToString:JOB_REVIEWED]) 
        hasBeenReviewed  = YES;
    
    return hasBeenReviewed;
}

#pragma mark - getters

-(int)getBidIndexOfBidId:(int)bidId {
    
    int index = -1;
    for(int i=0;i<[self.jobBids count];i++){
        JobBids *jobBid = [self.jobBids objectAtIndex:i];
        if(jobBid.bidID == bidId) {
            index = i;
            break;
        }
    }
    return index;
}

-(JobDocuments *)getVideoDocument {
    
    JobDocuments *document = nil;
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"video"]) {
            document = jobdocument;
            break;
        }
    }
    return document;
}


- (NSString *)getFileDuration {
    
    if(self.fileDuration)
        return fileDuration;
    
    self.fileDuration = @"";
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"video"] || [jobdocument.file_type isEqualToString:@"audio"]) {
            if(!jobdocument.duration_in_ms)
                break;
            if(jobdocument.duration_in_ms == 60)
                self.fileDuration = @"1:00 ";

            else{
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setPositiveFormat:@"00"];
                NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:jobdocument.duration_in_ms]];
                self.fileDuration = [NSString stringWithFormat:@":%@ ",formattedNumberString];
                [numberFormatter release];
                numberFormatter = nil;
            }
            break;
        }
            
    }
    return fileDuration;
}

-(int)getImageCount {
    
    return [self.jobImages count];
}

-(NSString *)audioUrl {
    
    NSString *urlString=nil;
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"audio"]) {
            urlString=jobdocument.mp3_file;
            self.hasAudio = YES;
            break;
        }
    }
    
    return urlString;
}


-(NSString *)videoUrl {
    
    NSString *urlString=nil;
    NSArray *documents = self.jobDocuments;
    for (int i=0; i<[documents count]; i++) {
        
        JobDocuments *jobdocument=[documents objectAtIndex:i];
        if ([jobdocument.file_type isEqualToString:@"video"]) {
            urlString=jobdocument.mp4_file;
            self.hasVideo = YES;
            break;
        }
    }
    
    return urlString;
}

- (JobImages *) getFirstImage {
    
    JobImages *image = [self.jobImages objectAtIndex:0];
    return image;
}


-(NSString *)jobServicerName {
    
    NSArray *jobServices = self.winningBidNames;
    NSString *jobServiceName = [jobServices objectAtIndex:0];  // We display the first servicer
    return jobServiceName;
}

@end

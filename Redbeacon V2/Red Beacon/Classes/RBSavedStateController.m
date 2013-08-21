//
//  SavedStateController.m
//  Redbeacon
//
//  Created by Jayahari V on 06/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RBSavedStateController.h"

NSString * const kRBSavedDataKey = @"data";	 //key for savedData data from NSUserDefaults
NSString * const kRBStateFile = @"RedBeaconSavedState.plist";
NSString * const kRBMediaKey = @"Media";
NSString * const kRBJobCategoryKey = @"JobCategory";
NSString * const kRBJobRequestKey = @"JobRequest";
NSString * const kRBJobResponseKey = @"JobResponse";
NSString * const kRBTextKey = @"Text";
NSString * const kRBScheduleTypeKey = @"ScheduleType";
NSString * const kRBScheduleDateKey = @"ScheduleDate";
NSString * const kRBLocationKey = @"Location";

@implementation RBSavedStateController

//Singleton class!
static RBSavedStateController *master = nil;

+(RBSavedStateController *)sharedInstance 
{
	//this is the reference implementation of singleton... it's thread safe.
	//don't try to synch for thread safety unless the we actually need to 
	//to instantiate.
	if (master == nil)
    {
		@synchronized(self)
		{
			//have to do a second check here to make sure another thread hasn't already instantiated master.
			if (master == nil)
				master = (RBSavedStateController *)[self new];
		}
    }
    return master;
}

-(id)init
{
	self = [super init];
	if (self)
	{
		NSDictionary *stateDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:[RBSavedStateController persistancePath]];
		
		if (stateDictionary)
        {
			NSLog(@"stateDictionary loaded...");
			savedData = [[stateDictionary valueForKey:kRBSavedDataKey] mutableCopy];		
		}
		else
        {
			NSLog(@"unable to load file...");
		}
		
	}
	return self;
}

- (NSMutableDictionary *)savedData 
{
	if (!savedData)
    {
		savedData = [[NSMutableDictionary alloc] init];
	}		
	return savedData;
}

- (BOOL)persistToDisk
{
	NSLog(@"Redbeacon persistToDisk called");
	NSLog(@"%@", [RBSavedStateController persistancePath]);
	NSDictionary *toSave = [NSDictionary dictionaryWithObjectsAndKeys:savedData,kRBSavedDataKey, nil];
	NSLog(@"toSave: %@", toSave);
	if (![NSKeyedArchiver archiveRootObject:toSave toFile:[RBSavedStateController persistancePath]])
    {
		NSLog(@"state not persisted");
	}
	else
    {
		NSLog(@"state persisted.");
	}
	return TRUE;
}

- (BOOL) purgeState
{
	NSLog(@"Redbeacon purgeState called");
	
	[savedData release];
	savedData = nil;
	
	//delete file.
	NSFileManager * fm = [NSFileManager defaultManager];
	NSError * error = nil;
	
	if ([fm removeItemAtPath:[RBSavedStateController persistancePath] error:&error]){
		NSLog(@"Successfully removed state file.");
	}
	
	return YES;
}

+ (NSString *)persistancePath 
{
	static NSString *path = nil;
	if (!path){
		NSLog(@"Initializing Path");
		NSArray *paths = NSSearchPathForDirectoriesInDomains
		(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsPath = [paths objectAtIndex:0]; 
		
		path = [[documentsPath stringByAppendingPathComponent:kRBStateFile] retain];
		NSLog(@"Path is: %@", path);
	}
	NSLog(@"returning path.");
	return path;
}

- (void)dealloc
{
	[savedData release];
	savedData = nil;
	[super dealloc];
}

#pragma mark - Methods to Save & Restore

- (void)saveJobRequest:(JobRequest*)jobRequest
{
    if (self.savedData)
    {
        [self.savedData setObject:jobRequest forKey:kRBJobRequestKey];
    }
}

- (JobRequest*)jobRequest
{
    JobRequest* jobRequest = nil;
    
    if (self.savedData)
    {
        jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
    }
    
    return jobRequest;
}

- (void)clearJobRequest
{
    [self.savedData removeObjectForKey:kRBJobRequestKey];
}

#pragma mark-
#pragma mark Current Selected Job Response

- (void)saveJobResponse:(JobResponseDetails *)jobResponse
{
    if (self.savedData)
    {
        [self.savedData setObject:jobResponse forKey:kRBJobResponseKey];
    }
}

- (JobResponseDetails*)jobResponse
{
    JobResponseDetails* jobResponse = nil;
    
    if (self.savedData)
    {
        jobResponse = [self.savedData objectForKey:kRBJobResponseKey];
    }
    
    return jobResponse;
}

- (void)clearJobResponse
{
    [self.savedData removeObjectForKey:kRBJobResponseKey];
}

/*- (void)addJobRequestWithName:(NSString*)jobName
{
    if (self.savedData)
    {
        NSMutableDictionary * jobReqDetails = [[NSMutableDictionary alloc] init];
        [jobReqDetails setObject:jobName forKey:kRBJobCategoryKey];
        
        [self.savedData setObject:jobReqDetails forKey:kRBJobRequestKey];
        [jobReqDetails release];
        jobReqDetails = nil;
    }
}

- (void)saveTextMessage:(NSString*)textMessage
{
    do 
    {
        if (!self.savedData)
        {
            break;
        }
           
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
            
        if (!jobRequest)
        {
            break;
        }
        
        [jobRequest setObject:textMessage forKey:kRBTextKey];
        
    } while (0);
}

- (void)saveScheduleWithType:(NSString*)scheduleType andDate:(NSString*)scheduleDate
{
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        [jobRequest setObject:scheduleType forKey:kRBScheduleTypeKey];
        [jobRequest setObject:scheduleDate forKey:kRBScheduleDateKey];
        
    } while (0);
}

- (NSString*)getScheduleType
{
    NSString * scheduleType = nil;
    
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        scheduleType = [jobRequest objectForKey:kRBScheduleTypeKey];
             
    } while (0);
    
    return scheduleType;
}

- (NSString*)getScheduleDate
{
    NSString * scheduleDate = nil;
    
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        scheduleDate = [jobRequest objectForKey:kRBScheduleDateKey];
        
    } while (0);
    
    return scheduleDate;
}

- (NSString*)getLocationCode
{
    NSString * locationCode = nil;
    
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        locationCode = [jobRequest objectForKey:kRBLocationKey];
        
    } while (0);
    
    return locationCode;
}

- (void)saveLocationCode:(NSString*)zipCode
{
    
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        [jobRequest setObject:zipCode forKey:kRBLocationKey];
        
    } while (0);
}*/

/*- (void)purgeImageMediaData
{
    do
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
        
        if (!savedMedia)
        {
            break;
        }
        
        NSArray * allKeys = [savedMedia allKeys];
        int count = [allKeys count];
        
        
        NSEnumerator *enumerator = [allKeys objectEnumerator];
        NSString * key = nil;
        
        while ((key = [enumerator nextObject])) 
        {
            RBMediaStatusTracker * mediaObject = [savedMedia objectForKey:key];
            if (mediaObject.mediaType == kImage)
            {
                [savedMedia removeObjectForKey:key];
                
            }
        }

        
        for (int i = 0; i < count; i++)
        {
            NSString * key = [allKeys objectAtIndex:i];
            RBMediaStatusTracker * mediaObject = [savedMedia objectForKey:key];
            if (mediaObject.mediaType == kImage)
            {
                [savedMedia removeObjectForKey:key];

            }
        }
        
        
    } while (0);

}*/

/*- (NSString*)getTextMessage
{
    NSString* textMessage = nil;
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        textMessage = [jobRequest objectForKey:kRBTextKey];
        
    } while (0);
    
    return textMessage;
}

// To pass the sufficient criteria atleast a text description or any media information should be available
- (BOOL)isSufficientDataForJobRequestAvailable
{
    BOOL dataSufficient = NO;
    
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSString * textMessage = [jobRequest objectForKey:kRBTextKey];
        if (textMessage)
        {
            dataSufficient = YES;
            break;
        }
        
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
        
        if (savedMedia)
        {
            dataSufficient = YES;
            break;
        }
        
    } while (0);
    
    return dataSufficient;
}

- (void)saveMediaObject:(RBMediaStatusTracker*)statusTracker
{
    do
    {
        if (self.savedData)
        {
            NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
            
            if (!jobRequest)
            {
                break;
            }
            
            NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
            
            if (!savedMedia)
            {
                savedMedia = [[NSMutableDictionary alloc] init];
                [savedMedia setObject:statusTracker forKey:statusTracker.mediaUrl];
                [jobRequest setObject:savedMedia forKey:kRBMediaKey];
                [savedMedia release];
                savedMedia = nil;
            }
            else
            {
                [savedMedia setObject:statusTracker forKey:statusTracker.mediaUrl];
            }
            
            NSLog(@"SAVE: savedState: %@", self.savedData);
        
        }
    }
    while (0);
}

- (void)updateStatusOfMediaObject:(RBMediaStatusTracker*)statusTracker
{
    do
    {
        if (!self.savedData)
        {
            break;
        }
            
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
            
        if (savedMedia)
        {
            RBMediaStatusTracker * mediaObject = [savedMedia objectForKey:statusTracker.mediaUrl];
            if (mediaObject)
            {
                mediaObject.mediaStatus = statusTracker.mediaStatus;
                mediaObject.mediaId = statusTracker.mediaId;
                mediaObject.thumbnailUrl = statusTracker.thumbnailUrl;
            }
        }
        else
        {
            break;
        }

    } while (0);
}


- (BOOL)areAllMediaSuccessfullyUploaded
{
    BOOL allMediaUploadedStatus = YES;
    
    do
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
            
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
            
        if (!savedMedia)
        {
            allMediaUploadedStatus = NO;
            break;
        }
        
        NSArray * allKeys = [savedMedia allKeys];
        int count = [allKeys count];
        
        for (int i = 0; i < count; i++)
        {
            NSString * key = [allKeys objectAtIndex:i];
            RBMediaStatusTracker * mediaObject = [savedMedia objectForKey:key];
            if (mediaObject.mediaStatus != kUploadSuccess)
            {
                allMediaUploadedStatus = NO;
                break;
            }
        }

    
    } while (0);
    
    return allMediaUploadedStatus;
}

- (NSString*)getMediaIdString
{
    NSString * mediaIdString = nil;
    

    do
    {
        if (!self.savedData)
        {
            break;
        }
            
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
            
        if (!savedMedia)
        {
            
            break;
        }
        
        NSArray * allKeys = [savedMedia allKeys];
        int count = [allKeys count];
        
        NSMutableArray * mediaIds = [[NSMutableArray alloc] init];
        for (int i = 0; i < count; i++)
        {
            NSString * key = [allKeys objectAtIndex:i];
            RBMediaStatusTracker * mediaObject = [savedMedia objectForKey:key];
            if (mediaObject.mediaStatus == kUploadSuccess)
            {
                
                [mediaIds addObject:mediaObject.mediaId];
                break;
            }
        }
        
        mediaIdString = [mediaIds componentsJoinedByString:@","];
        
        [mediaIds release];
        mediaIds = nil;

        
    } while (0);
    
    return mediaIdString;
}


// We need to remove all media files
// and purge the savedstate infor
- (void)purgeJobRequestInformation
{
    do
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSMutableDictionary * savedMedia = [jobRequest objectForKey:kRBMediaKey];
        
        if (!savedMedia)
        {
            break;
        }
        
        NSArray * allKeys = [savedMedia allKeys];
        int count = [allKeys count];
        
        for (int i = 0; i < count; i++)
        {
            NSString * key = [allKeys objectAtIndex:i];
            [RBConstants deleteMediaFile:key];
        }
        
        [self.savedData removeObjectForKey:kRBJobRequestKey];
        
    } while (0);
}

- (void)purgeStateOfMediaForKey:(NSString*)key 
{
    do 
    {
        if (!self.savedData)
        {
            break;
        }
        
        NSMutableDictionary * jobRequest = [self.savedData objectForKey:kRBJobRequestKey];
        
        if (!jobRequest)
        {
            break;
        }
        
        NSMutableDictionary * mediaDictionary = [jobRequest valueForKey:kRBMediaKey];
        
        if (!mediaDictionary)
        {
            break;
        }
        
        [mediaDictionary removeObjectForKey:key];
        
        
    } while (0);
    
}*/

#pragma mark -

@end

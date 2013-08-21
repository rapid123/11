//
//  RBAsyncImage.m
//  Red Beacon
//
//  Created by sudeep on 06/10/11.
//  Copyright 2011 Rapid Value Solutions. All rights reserved.
//

#import "RBAsyncImage.h"
#import "UIImage+Resize.h"


#define ACTIVITYINDICATOR_TAG 999
#define ACTIVITY_FRAME CGRectMake(17, 17, 10, 10)
#define ACTIVITY_FRAME_NOT_HOME CGRectMake(33, 30, 10, 10)
#define VIDEO_THUMBNAIL_FRAME CGRectMake(12, 12, 20, 20)
#define VIDEO_THUMBNAIL_TAG 998
#define VIDEO_THUMBNAIL_IMAGE @"videoPlayerPlayButton.png"

@implementation RBAsyncImage

@synthesize onReady;
@synthesize target;
@synthesize jobResponseDetail;

-(void)showVideoIcon {
    
   UIImageView *imageThumbnail=[[UIImageView alloc]init];
   imageThumbnail.frame=VIDEO_THUMBNAIL_FRAME;
   imageThumbnail.tag = VIDEO_THUMBNAIL_TAG;
   //imageThumbnail.center=self.center;
   imageThumbnail.backgroundColor=[UIColor clearColor];
   imageThumbnail.image=[UIImage imageNamed:VIDEO_THUMBNAIL_IMAGE]; 
   [imageThumbnail setContentMode:UIViewContentModeScaleAspectFit];
   [self addSubview:imageThumbnail];
   [imageThumbnail release];
   imageThumbnail=nil;
}


-(void)loadExistingImage:(UIImage *)image {
    
    UIImageView* imageView = [[[UIImageView alloc] init] autorelease];
    imageView.frame = CGRectMake(2, 3, self.frame.size.width-4, self.frame.size.height-8); 
    imageView.image = image;     
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:imageView];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
}

- (void)loadImageFromURL:(NSURL*)url isFromHome:(BOOL)isHome{
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=ACTIVITY_FRAME;
    //If we are comming from Home tab we have a different frame or else its different.
    if(!isHome)
    {
       activityIndicator.frame=ACTIVITY_FRAME_NOT_HOME;
       //activityIndicator.center=self.center;
    }
    activityIndicator.tag = ACTIVITYINDICATOR_TAG;
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
    
    if (connection!=nil) { [connection release]; }
    if (data!=nil) { [data release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
	
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImageView* imageView = [[[UIImageView alloc] init] autorelease];
    imageView.frame = CGRectMake(2, 3, self.frame.size.width-4, self.frame.size.height-8); 
    imageView.image = [[UIImage imageWithData:data] imageByScalingAndCroppingForSize:CGSizeMake(self.frame.size.width-2, self.frame.size.height-8)];     
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
   
    [self addSubview:imageView];
    [imageView setNeedsLayout];
    [self setNeedsLayout];
       
    UIImage *imageFromDate = [[UIImage alloc] initWithData:data]; 
    UIImage *image = [imageFromDate imageByScalingAndCroppingForSize:CGSizeMake(self.frame.size.width-2, self.frame.size.height-8)];
    
    jobResponseDetail.jobIcon = image;  // save the image to avoid multiple downloads
    
    [data release];
    data=nil;
    
    if(jobResponseDetail.hasVideo){
        [self showVideoIcon];
    }

    [imageFromDate release];
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:ACTIVITYINDICATOR_TAG];
    [activity removeFromSuperview];
    
}
    
- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
    
    self.jobResponseDetail=nil;
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

@end
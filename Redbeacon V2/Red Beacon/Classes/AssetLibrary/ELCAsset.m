//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "RBAlertMessageHandler.h"
#import "RBSavedStateController.h"
#import "JobRequest.h"
#import "RBMediaStatusTracker.h"
#import "RBAssetsTablePicker.h"

@implementation ELCAsset

@synthesize asset;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (NSNumber*)myAssetReferenceID {
    NSURL * url =  [[self.asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[self.asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
    NSString * querry = [url query];
    NSArray* componenets = [querry componentsSeparatedByString:@"&"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS 'id='"];
    NSArray * filteredArray = [componenets filteredArrayUsingPredicate:predicate];
    NSString * object = [filteredArray objectAtIndex:0];
    NSString * stringIdentifier = [object stringByReplacingOccurrencesOfString:@"id=" withString:@""];
    long  number = [stringIdentifier longLongValue];
    return [NSNumber numberWithLongLong:number];
}

- (void)checkForAlreadySelectedAsset {

    //get the current searching image;
    JobRequest * jRequest = [[RBSavedStateController sharedInstance] jobRequest];
    NSNumber * currentSearchImageID = [jRequest currentSearchingImageID];
    long currentId = [currentSearchImageID longLongValue];
    if(currentSearchImageID!=nil)
    {
       //get myId
       long myId = [[self myAssetReferenceID] longLongValue];
    
       //if they are equal make him selected
       if (currentId==myId) {
           [overlayView setHidden:NO];
           //got one searchItem
           [jRequest gotOneSearchItem];
        }
    }
}

-(id)initWithAsset:(ALAsset*)_asset {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
	if (self) {
		
		self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		[assetImageView release];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
       
       [self checkForAlreadySelectedAsset];
    }    
	return self;	
}

-(void)toggleSelection {
    
    overlayView.hidden = !overlayView.hidden;
    if([(RBAssetsTablePicker*)self.parent totalSelectedAssets] > 5) 
    {
        
       [RBAlertMessageHandler showAlert:@"You can add a maximum of 5 photos to a job."
                         delegateObject:nil];
        
        overlayView.hidden = !overlayView.hidden;
        return;
    }
    
}


-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}

- (void)dealloc 
{    
    [overlayView removeFromSuperview];
    overlayView.image = nil;
    self.asset = nil;
	[overlayView release];
    [super dealloc];
}

@end


//  Copyright 2010 Rhythm NewMedia. All rights reserved.


#define IMAGE_CACHE_NAME @"images"

@protocol VImageViewDelegate;

@interface VImageView : UIView {
	CGImageRef imageMasked;
    UIImageView* imageView;
    NSString* url;
	BOOL isMaterialized;
    BOOL ready;
    NSOperation* loadOperation;
    id<VImageViewDelegate> delegate;
    
	BOOL showSpinnerWhenLoading;
    BOOL shouldFadeIn;
    int cornerFactor;
    BOOL sizeToImage;
    BOOL preventsCrop;
    BOOL touchesHasBeenHandled;
    
    NSURLConnection* connection;
    NSMutableData* imageData;
}

@property (nonatomic, copy) NSString* url;
@property (readonly) UIImageView* imageView;
@property (retain) id<VImageViewDelegate> delegate;
@property (nonatomic, assign) BOOL showSpinnerWhenLoading;
@property (nonatomic, assign) BOOL shouldFadeIn;
@property (nonatomic, assign) int cornerFactor;
@property (nonatomic, assign, getter=shouldSizeToImage) BOOL sizeToImage;
@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, assign) BOOL preventsCrop;

- (void) materializeAtPriority: (NSOperationQueuePriority) priority;
- (void) vaporize;

- (void) resize: (CGRect) rect;
- (void) sizeToRect: (CGRect) rect;

- (void) removeGlass;
- (void) cancel;

- (void)loadImageWithPath;

+ (void) setCropImage: (BOOL) enabled;

@end

@protocol VImageViewDelegate <NSObject>

- (void) imageLoaded: (VImageView*) imageView;
- (void) didClickImageView: (VImageView*) imageView;

@optional
- (void) didDoubleClickImageView: (VImageView*) imageView tapPoint: (CGPoint) tapPoint;
- (void) didPressAndHoldImageView: (VImageView*) imageView;

@end

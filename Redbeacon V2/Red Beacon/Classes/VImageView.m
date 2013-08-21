//  Copyright 2010 Rhythm NewMedia. All rights reserved.

#import "VImageView.h"
#import "UIImage+Resize.h"

#define V_GLASS_VIEW_TAG 1618
#define V_CACHE_SIZE_CUTOFF 1024*128 
#define V_PRESS_AND_HOLD_INTERVAL 1.5
#define THUMBNAIL_MISSING_IMG DEFAULT_THUMBNAIL_IMAGE

@interface VImageView ()

- (void) showImage;
- (void)loadThumbnailWithurl:(NSURL *)URL ;

@end

@implementation VImageView

static BOOL cCropImage = NO;

@synthesize url;
@synthesize imageView;
@synthesize delegate;
@synthesize showSpinnerWhenLoading;
@synthesize shouldFadeIn;
@synthesize cornerFactor;
@synthesize sizeToImage;
@synthesize ready;
@synthesize preventsCrop;

+ (void) setCropImage: (BOOL) enabled {
    cCropImage = enabled;
}

+(UIImage *)glassImage {
	static UIImage *glassImage = nil;
#ifdef THUMBNAIL_OVERLAY_IMG
	@synchronized(self) {
		if (!glassImage) {
			glassImage = [[UIImage alloc] initWithContentsOfFile:
                          [[NSBundle mainBundle] pathForResource:THUMBNAIL_OVERLAY_IMG ofType:@"png"]];
		}
	}
#endif
	return glassImage;
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor blackColor];
        imageView = nil;
        isMaterialized = NO;
        ready = NO;
        shouldFadeIn = YES;
        showSpinnerWhenLoading = YES;
        cornerFactor = 25;

		UIImageView *glassView = [[UIImageView alloc] initWithFrame:self.bounds];
		glassView.image = [VImageView glassImage];
        glassView.tag = V_GLASS_VIEW_TAG;
		[self addSubview:glassView];
        [glassView release];
    }
    return self;
}

-(void)removeGlass
{
    [[self viewWithTag:V_GLASS_VIEW_TAG] removeFromSuperview];
}

- (void) showDefaultImage {
#ifdef THUMBNAIL_MISSING_IMG

    if (imageView != nil) {
        UIImage* image = imageView.image;
        [image retain];
        [imageView removeFromSuperview];
        [imageView release];
        [image release];
    }
        
    imageView = [[UIImageView alloc] initWithFrame: self.bounds];
    imageView.image = [UIImage imageNamed: THUMBNAIL_MISSING_IMG];

    [self showImage];
#endif
}
/*
- (void) setUrl: (NSString*) the_url {
    [url release];
    url = [the_url copy];

    UIImage* cachedImage = [[VLRUCache sharedCache: IMAGE_CACHE_NAME] objectForKey: url];
    
    if (cachedImage && CGSizeEqualToSize (cachedImage.size, self.frame.size)) {
        if (imageView != nil) {
            UIImage* image = imageView.image;
            [image retain];
            [imageView removeFromSuperview];
            [imageView release];
            [image release];
        }
            
        imageView = [[UIImageView alloc] initWithFrame: self.bounds];
        imageView.image = cachedImage;
        isMaterialized = YES;
 
        [self addSubview: imageView];
            
        if (sizeToImage) {
            [self resize:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageView.image.size.width, imageView.image.size.height)];
        }
        ready = YES;
        [delegate imageLoaded:self];
    }
}

- (NSData*) cachedImageData {
	if (url == nil) return nil; 
    
    return [[RYAPILocator api] getContent: url
                               timeout: 30
                               cachePolicy: NSURLRequestReturnCacheDataDontLoad];
}
*/
- (CGRect) drawRectAspect: (CGSize) viewSize imageSize: (CGSize) imageSize {
    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;

    float viewAspect = viewSize.width / viewSize.height;
    float imageAspect = w / h;
        
    if (imageAspect > viewAspect && viewSize.width < w) {
        w = viewSize.width;
        h = w / imageAspect;
    } else {
        // image height is the primary scale axis to fit completely on the view
        if (viewSize.height < h) {
            h = viewSize.height;
            w = h * imageAspect;
        }
    }

    float x = (viewSize.width - w) / 2;
    float y = (viewSize.height - h) / 2;

    return CGRectMake (x, y, w, h);
}

// similar to drawRectAspect:imageSize: except this one crops the image to fit the viewSize
- (CGRect) drawRectAspectFit: (CGSize) viewSize imageSize: (CGSize) imageSize {
    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;

    float viewAspect = viewSize.width / viewSize.height;
    float imageAspect = w / h;
    float y = 0;

    if (imageAspect > viewAspect) {
        h = viewSize.height;
        w = h * imageAspect;
    }
    else {
        w = viewSize.width;
        h = w / imageAspect;
        y = viewSize.height - h;
    }

    return CGRectMake (0, y, w, h);
}

- (CGRect) drawRect: (CGSize) viewSize imageSize: (CGSize) imageSize {
    if (preventsCrop || cCropImage == NO) {
        return [self drawRectAspect: (CGSize) viewSize imageSize: imageSize];
    }
    else {
        return [self drawRectAspectFit: (CGSize) viewSize imageSize: imageSize];
    }
}

- (void) createAndShowImage: (NSData*) data {
	UIImage* imageUnmasked = [[UIImage alloc] initWithData:data];
    
    if (imageUnmasked.size.width == 0 || imageUnmasked.size.height == 0) {
        [imageUnmasked release];
        [self showDefaultImage];
    }
    else {
        CGSize viewSize = self.frame.size;
        CGRect draw_rect = [self drawRect: viewSize imageSize: imageUnmasked.size];

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context 
            = CGBitmapContextCreate(NULL, viewSize.width, viewSize.height, 8, 
                                    4 * viewSize.width, colorSpace, 
                                    kCGImageAlphaPremultipliedFirst);
        
        if (cornerFactor) {

            CGContextBeginPath (context);
            CGContextClosePath (context);
            CGContextClip (context);
        }
        
        CGContextDrawImage (context, draw_rect, imageUnmasked.CGImage);
        
        imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        [imageUnmasked release];
        
        if (imageView) {
            UIImage *image = imageView.image;
            [image retain];
            [imageView removeFromSuperview];
            [imageView release];
            [image release];
        }
            
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        UIImage *scaledImage = [[UIImage imageWithCGImage:imageMasked] imageByScalingAndCroppingForSize:CGSizeMake(50, 50)];
        imageView.image = scaledImage;
            
        if (sizeToImage) {
            [self resize:CGRectMake(self.frame.origin.x, self.frame.origin.y, imageView.image.size.width, imageView.image.size.height)];
        }
        
        [self showImage];
    }
}

- (void) loadImageFromData: (NSData*) data {
    if (data == nil) { // couldn't load thumbnail image data
        [self showDefaultImage];
    } else {
        [self createAndShowImage: data];
    }
}

// This is the only method that's supposed to be called on a secondary thread
- (void) loadDataFromURL: (NSString*) the_url {
    [loadOperation release];
    loadOperation = nil;

    if (isMaterialized == NO) return;
    if ([url isEqualToString: the_url] == NO) return;
    NSData* data = nil;// = [[RYAPILocator api] getContent:the_url timeout:60];

    if (isMaterialized == NO) return;
    if ([url isEqualToString: the_url] == NO) return;
    [self performSelectorOnMainThread: @selector (loadImageFromData:) withObject: data waitUntilDone: NO];
}

- (void) materializeAtPriority: (NSOperationQueuePriority) priority {
    if (isMaterialized) return;
    isMaterialized = YES;
        
    //if (showSpinnerWhenLoading) {
    //    [self showActivityIndicator];
    //}
        
   // NSData* imageData = [self cachedImageData];
    //if (imageData != nil) {
    //    [self createAndShowImage: imageData];
   // }
   // else if (url == nil) {
       [self showDefaultImage];
   // }
   // else {
   //     NSString* load_url = [[NSString alloc] initWithString: url];
   //     loadOperation = [VUtil newJobOnTarget: self selector: @selector (loadDataFromURL:) object: load_url priority: priority];
   //     [load_url release];
   // }
}

-(void)loadImageWithPath{
    
    NSURL *URL = [[NSURL alloc] initWithString:self.url];
    [self loadThumbnailWithurl:URL];
    [URL release];
}


-(void)loadThumbnailWithurl:(NSURL *)URL {
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=CGRectMake(10,10,10,10);
    activityIndicator.tag = 999;
    [self addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
    
    if (connection!=nil) { [connection release]; }
    if (imageData!=nil) { [imageData release]; }
    NSURLRequest* request = [NSURLRequest requestWithURL:URL
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
    
    
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (imageData==nil) {
		imageData =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [imageData appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	
    [connection release];
    connection=nil;
    if (imageData != nil) 
        [self createAndShowImage: imageData];
        
    UIActivityIndicatorView *activityindicator = (UIActivityIndicatorView *)[self viewWithTag:999];
    [activityindicator removeFromSuperview];
    
}

 

- (void) vaporize {
    if (loadOperation != nil) {
        [loadOperation cancel];
        [loadOperation release];
        loadOperation = nil;
    }

    if (isMaterialized == NO) return;

    ready = NO;
        
    if (imageView != nil) {
        UIImage* image = imageView.image;
        [image retain];
        [imageView removeFromSuperview];
        [imageView release];
        [image release];
        imageView = nil;
    }
        
    //[self removeActivityIndicator];
        
    if (imageMasked) {
        CGImageRelease(imageMasked);
        imageMasked = nil;
    }

    [self setNeedsDisplay];
        
    isMaterialized = NO;
}

- (void) showImage {
    if (isMaterialized == NO) return;
    imageView.opaque = NO;
        
    [self addSubview: imageView];
    [self sendSubviewToBack: imageView];
   // [self removeActivityIndicator];

    ready = YES;
    [delegate imageLoaded: self];
        
    // cache the image
   // if (![[VLRUCache sharedCache:IMAGE_CACHE_NAME] containsKey:url]) {
    //    UIImage *i = imageView.image;
        // until further research, don't cache big images
     //   if ([i byteCount] <= V_CACHE_SIZE_CUTOFF) {
    //        [[VLRUCache sharedCache:IMAGE_CACHE_NAME] setObject:i forKey:url];
    //    }
   // }
		
    imageView.alpha = 0.;
        
    if (shouldFadeIn) {
        [UIView beginAnimations:@"showImage" context:self];
        [UIView setAnimationDuration:0.2];
        imageView.alpha = 1.;
        [UIView commitAnimations];
    } else {
        imageView.alpha = 1.;
    }
    [self setNeedsDisplay];
}

-(void)resize:(CGRect)rect
{
    self.frame = rect;
   // activityIndicator.center = CGPointMake(self.bounds.size.width/2, 
   //                                        self.bounds.size.height/2);
    [[self viewWithTag:V_GLASS_VIEW_TAG] setFrame:self.bounds];
    [imageView setFrame:self.bounds];
}

-(void)sizeToRect:(CGRect)rect
{
    UIImage *image = imageView.image;
    if (image) {
        CGSize viewSize = rect.size;
        float viewAspect = viewSize.width / viewSize.height;
        float imageAspect = image.size.width / image.size.height;
        float w, h;
        if (imageAspect > viewAspect) {
            // image width is the primary scale axis to fit completely on the view
            if (viewSize.width > image.size.width) {
                // image is smaller than the view, don't scale
                w = image.size.width;
            } else {
                w = viewSize.width;
            }
            h = w / imageAspect;
        } else {
            // image height is the primary scale axis to fit completely on the view
            if (viewSize.height > image.size.height) {
                // image is smaller than the view, don't scale
                h = image.size.height;
            } else {
                h = viewSize.height;
            }
            w = h * imageAspect;
        }
        float x = (viewSize.width - w) / 2;
        float y = (viewSize.height - h) / 2;
        
        [self resize:CGRectMake(x, y, w, h)];
    }
}

- (void) cancel {
    if (loadOperation != nil) {
        [loadOperation cancel];
        [loadOperation release];
        loadOperation = nil;
    }
    isMaterialized = NO;
    ready = NO;
    self.delegate = nil;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%.0f %.0f %.0f %.0f %@", 
                     self.bounds.origin.x,
                     self.bounds.origin.y, 
                     self.bounds.size.width, 
                     self.bounds.size.height,
                     self.url];
}

- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event {
    if (delegate == nil) return;

    [NSObject cancelPreviousPerformRequestsWithTarget: self];
    if ([delegate respondsToSelector: @selector (didPressAndHoldImageView:)]) {
        [self performSelector: @selector (handlePressAndHold) withObject: nil afterDelay: V_PRESS_AND_HOLD_INTERVAL];
    }
    touchesHasBeenHandled = NO;
}

- (void) touchesMoved: (NSSet*) touches withEvent: (UIEvent*) event {
    // do nothing
}

- (void) touchesEnded: (NSSet*) touches withEvent: (UIEvent*) event {
    if (delegate == nil || touchesHasBeenHandled) return;

    UITouch* touch = [touches anyObject];

	if (touch.phase == UITouchPhaseEnded) {
        if (touch.tapCount == 1) {
            [self performSelector: @selector (handleSingleTap) withObject: nil afterDelay: 0.3];
        }
        else if (touch.tapCount == 2) {
            if ([delegate respondsToSelector: @selector (didDoubleClickImageView:tapPoint:)]) {
                @synchronized (self) {
                    [delegate didDoubleClickImageView: self tapPoint: [touch locationInView: self]];
                }
            }
        }
    }
    touchesHasBeenHandled = YES;
}

- (void) touchesCancelled: (NSSet*) touches withEvent: (UIEvent*) event {
    if (delegate == nil) return;

    [NSObject cancelPreviousPerformRequestsWithTarget: self];
}

- (void) handlePressAndHold {
    if (touchesHasBeenHandled) return;

    @synchronized (self) {
        [delegate didPressAndHoldImageView: self];
    }
    touchesHasBeenHandled = YES;
}

- (void) handleSingleTap {
    @synchronized(self) {
        [delegate didClickImageView: self];
    }
}

- (void)dealloc {
    UIImage *image = imageView.image;
    
    [loadOperation cancel];
    [loadOperation release];
    
    [image retain];
    [imageView removeFromSuperview];
    [imageView release];
    imageView = nil;
    [image release];
    [[self viewWithTag:V_GLASS_VIEW_TAG] removeFromSuperview];
    //[activityIndicator release];
    [url release];
    url = nil;
    CGImageRelease(imageMasked);
    self.delegate = nil;
    [super dealloc];
}

@end

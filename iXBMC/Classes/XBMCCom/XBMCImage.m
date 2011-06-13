//
//  XBMCImage.m
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCImage.h"
#import "XBMCHttpInterface.h"
//#import "UIImage+Resize.h"

@interface XBMCImage()
- (void) downloadImage:(NSDictionary*)params;
-(void) imageLoaded:(NSDictionary*)object;
+ (UIImage*) getCachedImage:(NSString*)url thumbnailSize:(NSInteger)size;
@end

@implementation XBMCImage
static XBMCImage *sharedInstance = nil;

+ (XBMCImage *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

- (id) init
{
    self = [super init];
    if (self)
    {
		_queue = dispatch_queue_create("com.ixbmc.imagedownload", NULL);
		_valid = TRUE;
//		_downloadQueue = [NSOperationQueue new];
//		[_downloadQueue setMaxConcurrentOperationCount:5];
//        _downloadingImages = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

- (void)dealloc
{
//    [_downloadingImages release];
//	[_downloadQueue release];
	_valid = FALSE;
	// wait for queue to empty
	dispatch_sync(_queue, ^{});
	dispatch_release(_queue);
	
    [super dealloc];
}

+ (BOOL) hasCachedImage:(NSString*)url  thumbnailSize:(NSInteger)size
{
    NSString* realUrl = url;
    if (size != -1)
    {
        realUrl = [realUrl stringByAppendingString:[[NSNumber numberWithInt:size] stringValue]];
    }
    return ([[TTURLCache sharedCache] hasDataForURL:realUrl]
//			|| [[TTURLCache sharedCache] hasImageForURL:realUrl fromDisk:NO]
            );
}

+ (BOOL) hasCachedImage:(NSString*)url
{
    return [XBMCImage hasCachedImage:url thumbnailSize:-1];
}

+ (UIImage*) cachedImage:(NSString*)url
{
    return [XBMCImage getCachedImage:url thumbnailSize:-1];
}

+ (UIImage*) cachedImage:(NSString*)url thumbnailSize:(NSInteger)size
{
    return [XBMCImage getCachedImage:url thumbnailSize:size];
}

+ (UIImage*) getCachedImage:(NSString*)url thumbnailSize:(NSInteger)size
{
    NSString* realUrl = url;
    if (size != -1)
    {
        realUrl = [realUrl stringByAppendingString:[[NSNumber numberWithInt:size] stringValue]];
    }

    UIImage* image = nil;
//    image = [[TTURLCache sharedCache] imageForURL:realUrl];
//    if (image == nil)
//    {
        NSData* data = [[TTURLCache sharedCache] dataForURL:realUrl];
        if (data != nil)
        {
            image = [UIImage imageWithData:data];            
        }
//    }
//
//    if (image && ![[TTURLCache sharedCache] hasImageForURL:realUrl fromDisk:NO])
//    {
//        [[TTURLCache sharedCache] storeImage:image forURL:realUrl];
//    }
    
    return image;
}


-(void) imageLoaded:(NSDictionary*)object
{
    id <NSObject> obj = [object objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[object objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelector:aSel withObject:[object objectForKey:@"image"]];
    }
}

- (void) downloadImage:(NSDictionary*)params
{
    NSString* url = [params valueForKey:@"url"];
    
    NSString* xbmcURL = [XBMCHttpInterface getUrlFromSpecial:url];
//	NSLog(@"downloading %@", xbmcURL);
    NSInteger thumbnailSize = [[params valueForKey:@"thumbnailSize"] integerValue];
    UIImage* image = nil;
    NSData *imageData = nil;

    if (thumbnailSize != -1)
    {
        url = [url stringByAppendingString:[[NSNumber numberWithInt:thumbnailSize] stringValue]];
    }
        
//    image = [[TTURLCache sharedCache] imageForURL:url];
//    if (image == nil)
//    {
        imageData = [[[TTURLCache sharedCache] dataForURL:url] retain];
        if (imageData == nil)
        {
            imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:xbmcURL]];
            if(imageData)
            {
                image = [UIImage imageWithData:imageData]; 
                [imageData release];
                if (image && thumbnailSize != -1 && thumbnailSize < MAX(image.size.width,image.size.height))
                {
                    //CGSize itemSize = CGSizeMake(width, width*image.size.height/image.size.width);
                    UIGraphicsBeginImageContextWithOptions(image.size, YES, thumbnailSize / MAX(image.size.width,image.size.height));
                    CGRect imageRect = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
                    [image drawInRect:imageRect];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
//                    image = [image thumbnailImage:thumbnailSize transparentBorder:0 cornerRadius:radius interpolationQuality:kCGInterpolationHigh];
                    
                }
                [[TTURLCache sharedCache] storeData:UIImagePNGRepresentation(image) forURL:url];
            }
            else
            {
                return;
            }
        }
        else
        {
            image = [UIImage imageWithData:imageData]; 
            [imageData release];
        }
        
//        if (![[TTURLCache sharedCache] hasImageForURL:url fromDisk:NO])
//        {
//            [[TTURLCache sharedCache] storeImage:image forURL:url];
//        }
//    }  
    
    id  obj = [params objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[params objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelectorOnMainThread:aSel 
                                  withObject:[NSDictionary 
                                              dictionaryWithObjectsAndKeys:image, @"image"
                                              , [params valueForKey:@"url"], @"url", nil] 
                               waitUntilDone:NO];
    }
}

-(void) addDownloadImageOP:(NSString*)url object:(NSObject*)object selector:(SEL)sel thumbnailSize:(NSInteger)size
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                             url, @"url",
                            [NSNumber numberWithInt:size], @"thumbnailSize",
                             object, @"object",
                             [NSValue valueWithPointer:sel], @"selector",
                             nil];
//    
////    NSOperationQueue *queue = [NSOperationQueue new];
//    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
//                                        initWithTarget:[XBMCImage sharedInstance]
//                                        selector:@selector(downloadImage:) 
//                                        object:params];
//    [_downloadQueue addOperation:operation]; 
////    [queue release];
	
	dispatch_async(_queue, ^{[self downloadImage:params];});

//    [operation release];
}

+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel thumbnailSize:(NSInteger)size
{
    [[XBMCImage sharedInstance] addDownloadImageOP:url object:object selector:sel thumbnailSize:size];
}

+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel
{
    [[XBMCImage sharedInstance] addDownloadImageOP:url object:object selector:sel thumbnailSize:-1];
}


@end

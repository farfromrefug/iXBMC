//
//  XBMCImage.h
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XBMCImage : NSObject {
    NSMutableArray* _downloadingImages;
//	NSOperationQueue* _downloadQueue;
	dispatch_queue_t _queue;

	BOOL _valid;
}

+ (XBMCImage *) sharedInstance;

+ (BOOL) hasCachedImage:(NSString*)url;
+ (BOOL) hasCachedImage:(NSString*)url  thumbnailHeight:(NSInteger)height;
+ (UIImage*) cachedImage:(NSString*)url;
+ (UIImage*) cachedImage:(NSString*)url thumbnailHeight:(NSInteger)height;
+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel;
+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel thumbnailHeight:(NSInteger)height;


@end

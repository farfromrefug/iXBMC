//
//  XBMCImage.h
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XBMCImage : NSObject {
    NSMutableArray* _downloadingImages;
	NSOperationQueue* _downloadQueue;
}

+ (XBMCImage *) sharedInstance;

+ (BOOL) hasCachedImage:(NSString*)url;
+ (BOOL) hasCachedImage:(NSString*)url  thumbnailSize:(NSInteger)size;
+ (UIImage*) cachedImage:(NSString*)url;
+ (UIImage*) cachedImage:(NSString*)url thumbnailSize:(NSInteger)size;
+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel;
+ (void) askForImage:(NSString*)url object:(NSObject*)object selector:(SEL)sel thumbnailSize:(NSInteger)size;


@end

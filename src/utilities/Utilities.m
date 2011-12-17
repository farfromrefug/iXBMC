//
//  Utilities.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#define TMP NSTemporaryDirectory()

@implementation Utilities

+ (void) cacheFile: (NSString *) FileURLString
{
    NSURL *FileURL = [NSURL URLWithString: FileURLString];
    
    // Generate a unique path to a resource representing the image you want
    NSString *filename = [FileURLString lastPathComponent];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        NSLog(@"getting %@", FileURL);
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: FileURL];
        [data writeToFile:uniquePath atomically:TRUE];
        [data release];
//        UIImage *image = [[UIImage alloc] initWithData: data];
        
        // Do we want to round the corners?
//        image = [self roundCorners: image];
//        
//        // Is it PNG or JPG/JPEG?
//        // Running the image representation function writes the data from the image to a file
//        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
//        {
//            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
//        }
//        else if(
//                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || 
//                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
//                )
//        {
//            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
//        }
    }
}

+ (NSData *) getCachedFile: (NSString *) ImageURLString
{
    NSString *filename = [ImageURLString lastPathComponent];
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    NSData *data;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        data = [NSData dataWithContentsOfFile:uniquePath]; // this is the cached file
    }
    else
    {
        // get a new one
        [Utilities cacheFile: ImageURLString];
        data = [NSData dataWithContentsOfFile:uniquePath];
    }
    
    return data;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *) roundCorners: (UIImage*) img
{
    int w = img.size.width;
    int h = img.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    [img release];
    
    UIImage* result = [UIImage imageWithCGImage:imageMasked];
    CFRelease(imageMasked);
    
    return result;
}

@end
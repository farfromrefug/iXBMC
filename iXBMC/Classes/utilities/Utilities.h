#import <Foundation/Foundation.h>

@interface Utilities : NSObject {
    
}

// Methods
+ (void) cacheFile: (NSString *) FileURLString;
+ (NSData *) getCachedFile: (NSString *) FileURLString;
+ (UIImage *) roundCorners: (UIImage*) img;

@end
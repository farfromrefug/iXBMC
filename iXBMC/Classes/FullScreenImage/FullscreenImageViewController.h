
#import <UIKit/UIKit.h>

@interface FullscreenImageViewController : TTViewController 
{
    NSString* _url;
    UIImageView* _image;
    UIActivityIndicatorView *_activityIndicator;
}

- (id)initWithImageUrl:(NSString *)url;

@end

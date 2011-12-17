
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

@class FadingImageView;

@interface FadingImageLayer : CALayer {
  FadingImageView* _override;
}

@property (nonatomic, assign) FadingImageView* override;

@end

//
#import "FadingImageLayer.h"

// UI
#import "FadingImageView.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FadingImageLayer

@synthesize override = _override;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)display {
  if (nil != _override)
  {
      if (nil != _override.image) 
      {
          self.contents = (id)_override.image.CGImage;
      }
      else
      {
          self.contents = (id)_override.defaultImage.CGImage;          
      }

  } else {
    return [super display];
  }
}


@end
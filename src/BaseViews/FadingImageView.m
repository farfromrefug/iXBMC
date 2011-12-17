#import "FadingImageView.h"

#import "FadingImageLayer.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FadingImageView

@synthesize image               = _image;
@synthesize defaultImage        = _defaultImage;
@synthesize autoresizesToImage  = _autoresizesToImage;


///////////////////////////////////////////////////////////////////////////////////////////////////

- (id)initWithoutAnimation:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _autoresizesToImage = NO;
        _image = nil;
        _defaultImage = nil;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        //        _newImageView = [[[FadingImageView alloc] init] retain];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
      _autoresizesToImage = NO;
      _image = nil;
      _defaultImage = nil;
      _newImageView = [[[FadingImageView alloc] initWithoutAnimation:frame] retain];
  }
  return self;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_newImageView);
    TT_RELEASE_SAFELY(_image);
    TT_RELEASE_SAFELY(_defaultImage);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (Class)layerClass {
  return [FadingImageLayer class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
  if (self.style) {
    [super drawRect:rect];
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawContent:(CGRect)rect {
  if (nil != _image) {
    [_image drawInRect:rect contentMode:self.contentMode];

  } else {
    [_defaultImage drawInRect:rect contentMode:self.contentMode];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTStyleDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawLayer:(TTStyleContext*)context withStyle:(TTStyle*)style {
  if ([style isKindOfClass:[TTContentStyle class]]) {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);

    CGRect rect = context.frame;
    [context.shape addToPath:rect];
    CGContextClip(ctx);

    [self drawContent:rect];

    CGContextRestoreGState(ctx);
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)unsetImage {
  self.image = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resizeWithImage:(UIImage*)image {
    CGRect frame = self.frame;
    if (_autoresizesToImage) {
        self.width = image.size.width;
        self.height = image.size.height;
        
    } else {
        // Logical flow:
        // If no width or height have been specified, then autoresize to the image.
        if (!frame.size.width && !frame.size.height) {
            self.width = image.size.width;
            self.height = image.size.height;
            
            // If a width was specified, but no height, then resize the image with the correct aspect
            // ratio.
            
        } else if (frame.size.width && !frame.size.height) {
            self.height = floor((image.size.height/image.size.width) * frame.size.width);
            
            // If a height was specified, but no width, then resize the image with the correct aspect
            // ratio.
            
        } else if (frame.size.height && !frame.size.width) {
            self.width = floor((image.size.width/image.size.height) * frame.size.height);
        }
        
        // If both were specified, leave the frame as is.
    }
    
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateLayer {
    FadingImageLayer* layer = (FadingImageLayer*)self.layer;
    if (self.style) {
        layer.override = nil;
        
    } else {
        // This is dramatically faster than calling drawRect.  Since we don't have any styles
        // to draw in this case, we can take this shortcut.
        layer.override = self;
    }
    [layer setNeedsDisplay];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDefaultImage:(UIImage*)theDefaultImage {
    if (_defaultImage != theDefaultImage) {
        [_defaultImage release];
        _defaultImage = [theDefaultImage retain];
        
        [self updateLayer];
        
        [self resizeWithImage:_defaultImage];
    }    
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setImage:(UIImage*)image {
    if (image != _image) {
        [_image release];
        _image = [image retain];
        
        [self updateLayer];
        
        [self resizeWithImage:_image];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setStyle:(TTStyle*)style {
    if (style != _style) {
        [super setStyle:style];
        [self updateLayer];
    }
}


- (void)animateNewImage:(UIImage*)image
{
    if (_newImageView == nil) return;
    
    [_newImageView retain];
    _newImageView.frame = CGRectMake(0, 0, self.width, self.height);
    _newImageView.style = self.style;
    _newImageView.contentMode = self.contentMode;
    _newImageView.clipsToBounds = self.clipsToBounds;
    _newImageView.backgroundColor = self.backgroundColor;
    _newImageView.contentScaleFactor = self.contentScaleFactor;
    _newImageView.contentStretch = self.contentStretch;
    _newImageView.alpha = 0.0;
    _newImageView.defaultImage = image?image:_defaultImage;
    [self insertSubview:_newImageView atIndex:0];
    
    [UIView beginAnimations:nil context:_newImageView];
    [UIView setAnimationDuration:TT_TRANSITION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
    
    _newImageView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    self.image = _newImageView.defaultImage;
    [_newImageView removeFromSuperview];
    [_newImageView release];
}

@end

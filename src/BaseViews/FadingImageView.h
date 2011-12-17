
@interface FadingImageView : TTView
{
    UIImage*      _image;
    UIImage*      _defaultImage;
    FadingImageView*      _newImageView;
    BOOL          _autoresizesToImage;

}

/**
 * The default image that is displayed until the image has been downloaded. If no urlPath is
 * specified, this image will be displayed indefinitely.
 */
@property (nonatomic, retain) UIImage* defaultImage;

/**
 * The image that is currently being displayed.
 */
@property (nonatomic, retain) UIImage* image;

/**
 * Override the default sizing operation and resize the frame of this view with the size of
 * the image.
 *
 * @default NO
 */
@property (nonatomic) BOOL autoresizesToImage;


/**
 * Remove the image, and redraw the view.
 */
- (void)unsetImage;

- (void)animateNewImage:(UIImage*)image;

@end

#import "FullscreenImageViewController.h"
#import "XBMCImage.h"
#import "XBMCStateListener.h"


@implementation FullscreenImageViewController

/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (id)initWithImageUrl:(NSString *)url
{
	// Initialize and create movie URL
    self = [super init];
  if (self)
  {
      _url = [url retain];
//      [self.navigationController setNavigationBarHidden:YES animated:YES];
  }
	return self;
}

- (void) exit
{    
	[self dismissModalViewControllerAnimated:YES];	
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_url);
	[super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (!_url || [_url length] == 0
        || (![XBMCStateListener connected] && ![XBMCImage hasCachedImage:_url]))
    {
        TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:@"Can't load Image"
                                                            subtitle:@"iXBMC appears not to be Connected"
                                                               image:TTIMAGE(@"bundle://thumbnailNone.png")] 
                                  autorelease];
        errorView.backgroundColor = [UIColor clearColor];
        errorView.frame = self.view.frame;
        [self.view addSubview:errorView];
    }
    
	[[self view] setBackgroundColor:[UIColor blackColor]];
    
    _image = [[[UIImageView alloc] initWithFrame:self.view.frame] autorelease];
    _image.alpha = 0.0;
    _image.contentMode = UIViewContentModeScaleAspectFit;
    _image.clipsToBounds = YES;
    [self.view addSubview:_image];
    _activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                  UIActivityIndicatorViewStyleWhite] autorelease];
    _activityIndicator.size = CGSizeMake(40, 40);
    _activityIndicator.center = _image.center;
    _activityIndicator.hidesWhenStopped = YES;
    [self.view insertSubview:_activityIndicator belowSubview:_image];
    
    if (![XBMCStateListener connected])
    {
        _image.image = [XBMCImage cachedImage:_url];
        if (_image.image != nil)
        {
            _image.alpha = 1.0;            
        }
    }
    else
    {
        [_activityIndicator startAnimating];
        [XBMCImage askForImage:_url 
                        object:self selector:@selector(imageLoaded:)];
    }
    
}

- (void)imageLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {        
        [UIView beginAnimations:nil context:_image];
        [UIView setAnimationDuration:0.3];
        //    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:_photo cache:YES];
        [UIView setAnimationDelegate:self];
        
        //    int height = CELL_HEIGHT;
        //    _photo.defaultImage = [_tempImage resizedImage:CGSizeMake(height*_tempImage.size.width/_tempImage.size.height,height) 
        //                              interpolationQuality:kCGInterpolationHigh];
        //    
        _image.image = [result objectForKey:@"image"];
        _image.alpha = 1.0;
        
        [UIView commitAnimations];
        [_activityIndicator stopAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    _image.frame = self.view.frame;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self exit];
}
@end

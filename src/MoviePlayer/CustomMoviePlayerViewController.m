#import "CustomMoviePlayerViewController.h"
#import "CustomTitleView.h"

@implementation CustomMoviePlayerViewController

- (id)initWithUrl:(NSString *)moviePath name:(NSString*)name
{
	// Initialize and create movie URL
    self = [super init];
    if (self)
    {
        movieURL = [NSURL URLWithString:moviePath];    
        [movieURL retain];
        self.title = @"Trailer";
		
		_titleBackground = [[[CustomTitleView alloc] init] retain];
		
		_titleBackground.title = @"Trailer";
		_titleBackground.subtitle = name;
		[_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
		
		self.navigationItem.titleView = _titleBackground;
		
		
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] 
                                       initWithTitle:@"Cancel" 
                                       style:UIBarButtonItemStyleDone 
                                       target:self 
                                       action:@selector(moviePlayBackDidFinish:)];
        self.navigationItem.leftBarButtonItem = cancelItem;
        [cancelItem release];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                              UIActivityIndicatorViewStyleWhite];
        UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        self.navigationItem.rightBarButtonItem = barButton;
        //Memory clean up
        [activityIndicator release];
        [barButton release];
    }
	return self;
}


/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mp loadState] != MPMovieLoadStateUnknown)
  {
  	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

    // When tapping movie, status bar will appear, it shows up
    // in portrait mode by default. Set orientation to landscape
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
//
//		// Rotate the view for landscape playback
//	  [[self view] setBounds:CGRectMake(0, 0, 480, 320)];
//		[[self view] setCenter:CGPointMake(160, 240)];
//		[[self view] setTransform:CGAffineTransformMakeRotation(M_PI / 2)]; 
//
//		// Set frame of movieplayer
//		[[mp view] setFrame:self.view.frame];
    
    // Add movie player as subview

		// Play the movie
      [self.navigationController setNavigationBarHidden:YES animated:YES];
      //Send startAnimating message to the view
      [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
		[mp play];
	}
}


/*---------------------------------------------------------------------------
* 
*--------------------------------------------------------------------------*/
- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
    TT_RELEASE_SAFELY(mp);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

 	// Remove observer
  [[NSNotificationCenter 	defaultCenter] 
  												removeObserver:self
  		                   	name:MPMoviePlayerPlaybackDidFinishNotification 
      		               	object:nil];

	[self dismissModalViewControllerAnimated:YES];	
}

/*---------------------------------------------------------------------------
*
*--------------------------------------------------------------------------*/
- (void) readyPlayer
{
    //Send startAnimating message to the view
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
 	mp =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    mp.view.frame = self.view.frame;
    mp.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                  | UIViewAutoresizingFlexibleHeight);
    [[self view] addSubview:[mp view]];   
    [mp.view setHidden:FALSE];

  	// Set movie player layout
  	[mp setControlStyle:MPMovieControlStyleFullscreen];
    [mp setFullscreen:YES];
    
    // Register that the load state changed (movie is ready)
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayerLoadStateChanged:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:nil];

		// May help to reduce latency
		[mp prepareToPlay];

		

  // Register to receive a notification when the movie has finished playing. 
  [[NSNotificationCenter defaultCenter] addObserver:self 
                        selector:@selector(moviePlayBackDidFinish:) 
                        name:MPMoviePlayerPlaybackDidFinishNotification 
                        object:nil];
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_titleBackground);
    TT_RELEASE_SAFELY(mp);
    TT_RELEASE_SAFELY(movieURL);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void) viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor blackColor]];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
} 

@end

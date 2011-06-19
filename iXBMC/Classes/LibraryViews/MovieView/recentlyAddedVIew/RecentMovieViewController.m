#import "RecentMovieViewController.h"
#import "RecentMovieView.h"
#import "AppDelegate.h"
#import "XBMCStateListener.h"
#import "XBMCCommand.h"
#import "XBMCImage.h"

@implementation RecentMovieViewController

@synthesize poster;
@synthesize fanart;
@synthesize watched;
@synthesize title;
@synthesize movieid;
@synthesize trailer;
@synthesize imdb;
@synthesize file;
@synthesize index;
@synthesize posterURL = _posterURL;
@synthesize fanartURL = _fanartURL;

// load the view nib and initialize the pageNumber ivar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		index = -1;
        _mainView = [[[RecentMovieView alloc] init] autorelease];
        self.view = _mainView;
        self.view.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *taprecognizer;
		taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self 
																action:@selector(showTrailer:)];
		taprecognizer.numberOfTapsRequired = 1;
		[self.view addGestureRecognizer:taprecognizer];
		[taprecognizer release];
		
		UILongPressGestureRecognizer *longpress;
		longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
		[self.view addGestureRecognizer:longpress];
		[longpress release];
    }
    return self;
}

- (void)dealloc
{  
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (UIImage *)poster
{
    return _mainView.poster;
}

- (void)setPoster:(UIImage *)var
{
    _mainView.poster = var;
}

- (CGFloat)posterHeight
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(movieCellMaxHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
	return height;
}

- (UIImage *)fanart
{
    return _mainView.fanart;
}

- (void)setFanart:(UIImage *)var
{
    _mainView.fanart = var;
}

- (CGFloat)fanartHeight
{
	return [self posterHeight];
}

- (BOOL)watched
{
    return _mainView.watched;
}

- (void)setWatched:(BOOL) var
{
    _mainView.watched = var;
}

- (NSString *)title
{
    return _mainView.title;
}

- (void)setTitle:(NSString *) var
{
    _mainView.title = var;
}

- (NSNumber *)movieid
{
    return _mainView.movieid;
}

- (void)setMovieid:(NSNumber *) var
{
    _mainView.movieid = var;
}

- (NSString *)trailer
{
    return _mainView.trailer;
}

- (void)setTrailer:(NSString *) var
{
    _mainView.trailer = var;
}

- (NSString *)imdb
{
    return _mainView.imdb;
}

- (void)setImdb:(NSString *) var
{
    _mainView.imdb = var;
}

- (void)showTrailer:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) 
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) 
		 showTrailer:self.trailer
		 name:self.title];
    }
}

- (void)showImdb:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) 
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showImdb:self.imdb];
    }
}

- (void)showMoreInfo:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) 
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showMovieDetails:self.movieid];
    }
}

- (void)thumbnailLoaded:(NSDictionary*) result
{   
	if ([[result valueForKey:@"url"] isEqualToString:_posterURL]
        && [result objectForKey:@"image"])
    {
		self.poster = nil;
		self.poster = [[result objectForKey:@"image"] retain];
		[_mainView setNeedsDisplay];
    }
}

- (void)fanartLoaded:(NSDictionary*) result
{   
    if ([[result valueForKey:@"url"] isEqualToString:_fanartURL]
        && [result objectForKey:@"image"])
    {
		self.fanart = nil;
		self.fanart = [[result objectForKey:@"image"] retain];
		[_mainView setNeedsDisplay];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;

	NSMutableArray* titles = [NSMutableArray array];
	[titles addObject:@"Details"];
	[titles addObject:@"Imdb"];
	if (![self.trailer isEqualToString:@""])
	{
		[titles addObject:@"Trailer"];
	}
	if ([XBMCStateListener connected])
	{
		[titles addObject:@"Play"];
		[titles addObject:@"Enqueue"];
	}
	else
	{
	}
	
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:[self.title uppercaseString]
															delegate:self cancelButtonTitle:@"Cancel" 
											  destructiveButtonTitle:nil otherButtonTitles:nil];
	alert.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	for (NSString * tt in titles) { [alert addButtonWithTitle:tt]; }
	[alert showInView:[self.view window]];
	[alert release];
}
//
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Details"]) {
		[((AppDelegate*)[UIApplication sharedApplication].delegate) showMovieDetails:self.movieid];
	} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Imdb"]) {
		[((AppDelegate*)[UIApplication sharedApplication].delegate) showImdb:self.imdb];
	} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Trailer"]) {
		[((AppDelegate*)[UIApplication sharedApplication].delegate) 
		 showTrailer:self.trailer
		 name:self.title];
	} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Play"]) {
		[XBMCStateListener play:self.file];
	}
}
@end

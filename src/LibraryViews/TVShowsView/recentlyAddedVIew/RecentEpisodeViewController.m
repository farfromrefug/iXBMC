#import "RecentEpisodeViewController.h"
#import "RecentEpisodeView.h"
#import "AppDelegate.h"
#import "XBMCStateListener.h"
#import "XBMCCommand.h"
#import "XBMCImage.h"

@implementation RecentEpisodeViewController

@synthesize poster;
@synthesize fanart;
@synthesize watched;
@synthesize title;
@synthesize episodeid;
@synthesize episode;
@synthesize season;
@synthesize tvshow;
@synthesize file;
@synthesize index;
@synthesize posterURL = _posterURL;
@synthesize fanartURL = _fanartURL;

// load the view nib and initialize the pageNumber ivar
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		index = -1;
        _mainView = [[[RecentEpisodeView alloc] init] autorelease];
        self.view = _mainView;
        self.view.userInteractionEnabled = YES;
		
		
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
	CGFloat height = TTSTYLEVAR(episodeCellMaxHeight);
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

- (NSNumber *)episodeid
{
    return _mainView.episodeid;
}

- (void)setEpisodeid:(NSNumber *) var
{
    _mainView.episodeid = var;
}

- (NSString *)episode
{
    return _mainView.episode;
}

- (void)setEpisode:(NSString *) var
{
    _mainView.episode = var;
}

- (NSString *)season
{
    return _mainView.season;
}

- (void)setSeason:(NSString *) var
{
    _mainView.season = var;
}

- (NSString *)tvshow
{
    return _mainView.tvshow;
}

- (void)setTvshow:(NSString *) var
{
    _mainView.tvshow = var;
}

- (void)showMoreInfo:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) 
    {
//        [((AppDelegate*)[UIApplication sharedApplication].delegate) showEpisodeDetails:self.episodeid];
    }
}

- (void)thumbnailLoaded:(NSDictionary*) result
{   
	if ([[result valueForKey:@"url"] isEqualToString:_posterURL]
        && [result objectForKey:@"image"])
    {
		self.poster = nil;
		self.poster = [result objectForKey:@"image"];
		[_mainView setNeedsDisplay];
    }
}

- (void)fanartLoaded:(NSDictionary*) result
{   
    if ([[result valueForKey:@"url"] isEqualToString:_fanartURL]
        && [result objectForKey:@"image"])
    {
		self.fanart = nil;
		self.fanart = [result objectForKey:@"image"];
		[_mainView setNeedsDisplay];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;

	NSMutableArray* titles = [NSMutableArray array];
	if ([XBMCStateListener connected])
	{
		[titles addObject:@"Play"];
		[titles addObject:@"Enqueue"];
	}
	else
	{
	}
	
	NSString* alertTitle = [NSString stringWithFormat:@"%@ : S%02dE%02d", self.tvshow
							, [self.season intValue]
							, [self.episode intValue]];
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:[alertTitle uppercaseString]
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
	} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Play"]) {
		[XBMCCommand play:self.file];
	}
}
@end

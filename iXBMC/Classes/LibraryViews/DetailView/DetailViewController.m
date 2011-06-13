#import "DetailViewController.h"
#import "ActiveManager.h"
#import "DetailView.h"

#import "Movie.h"
#import "ActorRole.h"
#import "Actor.h"

#import "XBMCStateListener.h"
#import "XBMCImage.h"

#import "CustomTitleView.h"

#import "FadingImageView.h"


@implementation DetailViewController
@synthesize entity = _entity;
@synthesize entityId = _entityId;
@synthesize coverUrl = _coverUrl;
@synthesize fanartUrl = _fanartUrl;
@synthesize trailerUrl = _trailerUrl;
@synthesize fileUrl = _fileUrl;
@synthesize imdbId = _imdbId;
@synthesize info = _info;
@synthesize cast = _cast;
@synthesize plot = _plot;


#pragma mark - View lifecycle

- (id)initWithEntity:(NSString *)entity id:(NSString *)entityId {
    self = [super init];
    if (self)
    {		
		_start = [[NSDate date] retain];
        self.entity = entity;
        self.entityId = entityId;

        NSArray *array = [[[ActiveManager shared] managedObjectContext] fetchObjectsForEntityName:_entity withPredicate:
						  [NSPredicate predicateWithFormat:@"movieid == %@", _entityId]];
        
        if (array == nil || [array count] ==0) {
            TTErrorView* errorView = [[[TTErrorView alloc] initWithTitle:@"Error"
                                                                subtitle:@"Could not find item in Database"
                                                                   image:TTIMAGE(@"bundle://error.png")] 
                                      autorelease];
            errorView.backgroundColor = RGBCOLOR(0, 0, 0);
            self.view = errorView;
            return self;
        }
		NSLog(@"1time took: %f", -[_start timeIntervalSinceNow]);
		
		//create new uiview with a background image
        UIImageView * backgroundView = [[[UIImageView alloc] 
							initWithImage:TTIMAGE(@"bundle://detailsback.png")] autorelease];
		backgroundView.backgroundColor = [UIColor clearColor];
		backgroundView.frame = self.view.frame;

        //add background view and send it to the back
        [self.view addSubview:backgroundView];
        
        Movie* movie = (Movie*)[array objectAtIndex:0];
        self.title =  movie.label;
		
		self.fileUrl = movie.file;
		self.trailerUrl = movie.trailer;
		self.imdbId = movie.imdbid;
		
		self.coverUrl = movie.thumbnail;
        self.fanartUrl = movie.fanart;
        
		_watched = ([movie.playcount intValue] != 0);
        
		NSLog(@"2time took: %f", -[_start timeIntervalSinceNow]);
        
        //INFOS
        NSString* infoText = @"";
        if (movie.director)
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Director:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", movie.director]; 
        }
        if (movie.writer)
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Writer:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", movie.writer]; 
        }
        if ([movie.year integerValue] != 0)
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Year:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [movie.year stringValue]]; 
        }
        if (movie.runtime)
        {
            NSString* runtime = [NSString stringWithString:movie.runtime];
            NSRange foundRange = [runtime rangeOfString:@"min"];
            
            if ((foundRange.length == 0) ||
                (foundRange.location == 0))
            {
                runtime = [runtime stringByAppendingString:@" min"];
            }
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Runtime:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", runtime]; 
        }
//        if ([movie.rating floatValue] != 0.0)
        {            
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Imdb Rating: </span>\
<img src=\"bundle://star.%.1f.png\" width=\"100\" height=\"20\"/>\n\n", [movie.rating floatValue]]; 
//            <span class=\"whiteText\">%.1f</span>\n\n", [movie.rating floatValue]]; 
        }
        
		self.info = infoText;
        
        NSString* plotText = @"";
        if (movie.plot)
        {
            plotText = [plotText stringByAppendingFormat:@"\
<span class=\"whiteText\">%@</span>\n\n", movie.plot]; 
        }
 		self.plot = plotText;
        
        
        ///ACTORS
        NSString* castText = @"";
        for (ActorRole* role in movie.MovieToRole)
        {
//            NSLog(@"role: %@ - %@", role.RoleToActor.name, role.role);
            castText = [castText stringByAppendingFormat:@"\
<img src=\"bundle://defaultPerson.png\" width=\"25\" height=\"25\"/>\
<span class=\"whiteText\">  %@ </span>\
<span class=\"grayText\">  %@</span>\n\n", role.RoleToActor.name, role.role]; 
        }
 		self.cast = castText;
		
		NSLog(@"3time took: %f", -[_start timeIntervalSinceNow]);
        
		////toolbar
		_toolBar = [self createToolbar];
		[self.view addSubview:_toolBar];
		
		_titleBackground = [[[CustomTitleView alloc] init] retain];
		
		_titleBackground.title = movie.label;
		_titleBackground.subtitle = movie.genre;
		[_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
		
		self.navigationItem.titleView = _titleBackground;
		
		UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] 
												initWithTarget:self 
												action:@selector(handleSwipe:)];
		recognizer.direction = UISwipeGestureRecognizerDirectionRight;
		[self.view addGestureRecognizer:recognizer];
		[recognizer release];
		NSLog(@"4time took: %f", -[_start timeIntervalSinceNow]);
    }
    return self ;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(_start);
    TT_RELEASE_SAFELY(_coverUrl);
    TT_RELEASE_SAFELY(_fanartUrl);
    TT_RELEASE_SAFELY(_entityId);
    TT_RELEASE_SAFELY(_entity);
    TT_RELEASE_SAFELY(_fileUrl);
    TT_RELEASE_SAFELY(_trailerUrl);
    TT_RELEASE_SAFELY(_imdbId);
    TT_RELEASE_SAFELY(_toolbarButtons);
    TT_RELEASE_SAFELY(_titleBackground);
    
	[super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
	[super viewDidLoad];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"time took: %f", -[_start timeIntervalSinceNow]);
	
	if (_detailView) return;
		
	_detailView = [[[DetailView alloc] init] autorelease];
	_detailView.frame  = self.view.frame;
	_detailView.alpha = 0.0;
	[self.view insertSubview:_detailView belowSubview:_toolBar];

	[_detailView setInfo:_info];
	[_detailView setPlot:_plot];
	[_detailView setCast:_cast];

	if (!_watched)
	{
		_detailView.newFlag.hidden = FALSE;
	}
	
	if (_coverUrl)
	{
		CGFloat coverHeight = TTSTYLEVAR(movieDetailsViewCoverHeight)*[UIScreen mainScreen].scale;
		UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)];
		[_detailView.cover addGestureRecognizer:tapgr];
		[tapgr release];    
		[XBMCImage askForImage:_coverUrl 
						object:self selector:@selector(coverLoaded:) 
				 thumbnailSize:coverHeight];
	}
	
	if (_fanartUrl)
	{
		[XBMCImage askForImage:_fanartUrl 
						object:self selector:@selector(fanartLoaded:) 
				 thumbnailSize:TTScreenBounds().size.width*2];
	}
	
	[UIView beginAnimations:nil context:_detailView];
    [UIView setAnimationDuration:0.2];
	_detailView.alpha = 1.0;
    [UIView commitAnimations];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideToolbar];
}

#pragma mark -
#pragma mark Toolbar

- (TTView*) createToolbar
{
	_playButton = nil;
	_imdbButton = nil;
	_trailerButton = nil;
	_enqueueButton = nil;
	_toolbarButtons = [[NSMutableArray alloc] init];
	
    TTView* toolbar = [[[TTView alloc] initWithFrame:CGRectMake(0, -41, self.view.width, 41)] autorelease];
    toolbar.backgroundColor = [UIColor clearColor];
    toolbar.style = TTSTYLEVAR(tableToolbar);
	
	if (![_imdbId isEqualToString:@""])
	{
		_imdbButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Imdb"];
		_imdbButton.frame = CGRectMake(0, 0, 60, 30);
		[_imdbButton addTarget:self action:@selector(imdb:) forControlEvents:UIControlEventTouchUpInside];
		[toolbar addSubview:_imdbButton];
	}
    
    _playButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Play"];
    _playButton.frame = CGRectMake(0, 0, 50, 30);
    [_playButton addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_playButton];
    
    _enqueueButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Enqueue"];
    _enqueueButton.frame = CGRectMake(0, 0, 80, 30);
    [_enqueueButton addTarget:self action:@selector(enqueue:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:_enqueueButton];
    
	if (![_trailerUrl isEqualToString:@""])
	{
		_trailerButton = [TTButton buttonWithStyle:@"embossedButton:" title:@"Trailer"];
		_trailerButton.frame = CGRectMake(0, 0, 70, 30);
		[_trailerButton addTarget:self action:@selector(showTrailer:) forControlEvents:UIControlEventTouchUpInside];
		[toolbar addSubview:_trailerButton];
	}
	
    return toolbar;
}

- (void) hideToolbar
{
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:0.2];
    _toolBar.bottom =  0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void) toggleToolbar
{
	
    if (_toolBar.bottom == 0)
	{
		[_toolbarButtons removeAllObjects];
        
        if ([XBMCStateListener connected])
        {
            _playButton.hidden = FALSE;
            _enqueueButton.hidden = FALSE;
            [_toolbarButtons addObject:_playButton];
            [_toolbarButtons addObject:_enqueueButton];
        }
        else
        {
            _playButton.hidden = TRUE;
            _enqueueButton.hidden = TRUE;
        }
        
        if (_trailerButton != nil)
        {
            _trailerButton.hidden = FALSE;
            [_toolbarButtons addObject:_trailerButton];
        }
        else
        {
            _trailerButton.hidden = TRUE;
        }
        
        if (_imdbButton != nil)
        {
            _imdbButton.hidden = FALSE;
            [_toolbarButtons addObject:_imdbButton];
        }
        else
        {
            _imdbButton.hidden = TRUE;
        }
		
		int nbButtons = [_toolbarButtons count];
		int buttonWidth = (_toolBar.width)/(nbButtons);
		int i = 0;
		for(TTButton *button in _toolbarButtons)
		{
			button.frame = CGRectMake(buttonWidth * i + buttonWidth/2 - button.width/2
									  , 5
									  , button.width
									  , button.height);
			i += 1;
			
		}
	}
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:0.2];
    if (_toolBar.top == 0)
        _toolBar.bottom = 0;
    else _toolBar.top = 0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Poster + Fanart

- (void)coverLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_detailView.cover animateNewImage:[result objectForKey:@"image"]];
    }
}

- (void)fanartLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_detailView.fanart animateNewImage:[result objectForKey:@"image"]];
    }
}

-(void)tapCover:(UITapGestureRecognizer *)gesture
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate) showFullscreenImage:_coverUrl];
}

#pragma mark -
#pragma mark Notifications

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
	//if we disconnect make sure the toolbar gets hidden so that we dont
	// have unwanted buttons
    [self hideToolbar];
}

#pragma mark -
#pragma mark Gestures

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Buttons

-(void) showTrailer:(id)sender
{
	[((AppDelegate*)[UIApplication sharedApplication].delegate) 
	 showTrailer:_trailerUrl name:_titleBackground.title];
}
-(void) play:(id)sender
{
	[XBMCStateListener play:_fileUrl];
}
-(void) enqueue:(id)sender
{
//  [delegate Movie:movie action:@"enqueue"];
}

-(void) imdb:(id)sender
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate) showImdb:_imdbId];
}
@end

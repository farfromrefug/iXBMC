//
//  RemoteViewController.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RemoteViewController.h"
#import "XBMCCommand.h"
#import "XBMCStateListener.h"
#import "LibraryUpdater.h"
#import "XBMCImage.h"
#import "AppDelegate.h"

#import "FadingImageView.h"
#import "CustomTitleView.h"
#import "PlayingOSDView.h"


@implementation RemoteViewController
@synthesize itemId = _id;
@synthesize imdb = _imdb;
@synthesize type = _type;

- (TTView*) createToolbar
{
    TTView* toolbar = [[[TTView alloc] initWithFrame:CGRectMake(0, -41, self.view.width, 41)] autorelease];
    toolbar.backgroundColor = [UIColor clearColor];
    toolbar.style = TTSTYLEVAR(tableToolbar);
    TTButton* button = [TTButton buttonWithStyle:@"embossedButton:" title:@"Imdb"];
    button.frame = CGRectMake(15, 10, 61, 25);
    [button addTarget:self action:@selector(showImdb:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:button];
    
    TTButton* button2 = [TTButton buttonWithStyle:@"embossedButton:" title:@"Details"];
    button2.frame = CGRectMake(button.right + 10, 10, 71, 25);
    [button2 addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:button2];
    
    return toolbar;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
//        self.title = @"Remote";
//        self.tabBarItem.image = [UIImage imageNamed:@"156-controlpad.png"];
        
        // Configure the add button.
//        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toggleToolbar)];
//        self.navigationItem.rightBarButtonItem = menuButton;
//        [menuButton release];
    
    }
    return self;
}

- (void)dealloc
{    
    TT_RELEASE_SAFELY(_titleBackground);
//    TT_RELEASE_SAFELY(_buttonsView);
    //    TT_RELEASE_SAFELY(_recentlyAddedMovies);
    TT_RELEASE_SAFELY(_type);
    TT_RELEASE_SAFELY(_id);
    TT_RELEASE_SAFELY(_imdb);

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) addButtons
{
    //ok
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_buttonsView.centerX - 35, _buttonsView.centerY - 60, 70, 70);
    button.opaque = FALSE;
    button.tag = 0;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:TTIMAGE(@"bundle://OSDOKNF.png") 
                      forState:UIControlStateNormal];
    [button setImage:TTIMAGE(@"bundle://OSDOKFO.png") 
                      forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button];
    
    //back
    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.left - 70, button.bottom, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 1;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDBackNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDBackFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //ESC
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.bottom, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 2;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDEscNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDEscFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
	//GUI
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top - 70, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 15;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDVideoNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDVideoFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
	
    //up
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.left, button.top - 70, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 3;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDUpNF.png") 
                      forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDUpFO.png") 
                      forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //down
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.left, button.bottom, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 4;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDDownNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDDownFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //right
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 5;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDRightNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDRightFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //left
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.left - 70, button.top, 70, 70);
    button2.opaque = FALSE;
    button2.tag = 6;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDLeftNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDLeftFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //prev
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, _buttonsView.height - 80, 70, 70);
    button.opaque = FALSE;
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    button.tag = 7;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:TTIMAGE(@"bundle://OSDPrevTrackNF.png") 
            forState:UIControlStateNormal];
    [button setImage:TTIMAGE(@"bundle://OSDPrevTrackFO.png") 
            forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button];
    
    //play
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top, 70, 70);
    button2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    button2.opaque = FALSE;
    button2.tag = 8;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDPlayNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDPlayFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //next
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(button2.right, button2.top, 70, 70);
    button.opaque = FALSE;
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    button.tag = 9;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:TTIMAGE(@"bundle://OSDNextTrackNF.png") 
            forState:UIControlStateNormal];
    [button setImage:TTIMAGE(@"bundle://OSDNextTrackFO.png") 
            forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button];
    
    //stop
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top, 70, 70);
    button2.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    button2.opaque = FALSE;
    button2.tag = 10;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDStopNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDStopFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //subtitles
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 10, 70, 70);
    button.opaque = FALSE;
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.tag = 11;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:TTIMAGE(@"bundle://OSDSubtitlesNF.png") 
            forState:UIControlStateNormal];
    [button setImage:TTIMAGE(@"bundle://OSDSubtitlesFO.png") 
            forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button];
    
    //info
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top, 70, 70);
    button2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button2.opaque = FALSE;
    button2.tag = 12;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDInfoNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDInfoFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
    
    //osd
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(button2.right, button2.top, 70, 70);
    button.opaque = FALSE;
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button.tag = 13;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:TTIMAGE(@"bundle://OSDOSDNF.png") 
            forState:UIControlStateNormal];
    [button setImage:TTIMAGE(@"bundle://OSDOSDFO.png") 
            forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button];
    
    //menu
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(button.right, button.top, 70, 70);
    button2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    button2.opaque = FALSE;
    button2.tag = 14;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setImage:TTIMAGE(@"bundle://OSDMenuNF.png") 
             forState:UIControlStateNormal];
    [button2 setImage:TTIMAGE(@"bundle://OSDMenuFO.png") 
             forState:UIControlStateHighlighted];
    [_buttonsView addSubview:button2];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizesSubviews = TRUE;
    _imdb = @"";
    _type = @"";
    _id = @"";
    
    //        [_titleLabel setText:@""];
    
    self.view.backgroundColor = [UIColor clearColor];
    //create new uiview with a background image
//    _backgroundView = [[[UIImageView alloc] 
//                        initWithImage:TTIMAGE(@"bundle://detailsback.png")] autorelease];
//    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //add background view and send it to the back
    
    _infosView = [[[TTView alloc] init] autorelease];
    _infosView.backgroundColor = [UIColor clearColor];
    _infosView.autoresizingMask = UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleTopMargin
                                    | UIViewAutoresizingFlexibleBottomMargin;
    _infosView.autoresizesSubviews = YES;
    _infosView.alpha = 0.0;
    
    _buttonsView = [[[UIView alloc] initWithFrame:TTNavigationFrame()] autorelease];
    _buttonsView.backgroundColor = [UIColor clearColor];
    _buttonsView.opaque = YES;        
    _buttonsView.autoresizingMask = UIViewAutoresizingFlexibleHeight
                                    | UIViewAutoresizingFlexibleBottomMargin;
    _buttonsView.userInteractionEnabled= YES;

    [self addButtons];
    
    
//    _backgroundView.frame = self.view.frame;
    _infosView.frame = self.view.frame;
    _buttonsView.frame = self.view.frame;
	
	_fanart = [[[FadingImageView alloc] init] autorelease];
	_fanart.contentMode = UIViewContentModeScaleAspectFill;
	_fanart.clipsToBounds = YES;
	_fanart.alpha = 0.1;
    _fanart.frame = _infosView.frame;
    
//    _cover = [[[FadingImageView alloc] init] autorelease];
//    _cover.defaultImage = TTIMAGE(@"bundle://thumbnailNone.png");        
//    _cover.contentMode = UIViewContentModeScaleToFill;
//    _cover.clipsToBounds = YES;
//    _cover.backgroundColor = [UIColor clearColor];
//    _cover.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
//                    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:10 offset:CGSizeMake(0, 0) next:
//                     [TTContentStyle styleWithNext:nil]]];
//    
    _infoLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
    //        _infoLabel.font = [UIFont systemFontOfSize:12];
    _infoLabel.backgroundColor = [UIColor clearColor];
    
    [_infosView addSubview:_fanart]; 
    [_infosView addSubview:_infoLabel]; 
//    [_infosView addSubview:_cover];

//    [self.view addSubview:_backgroundView];  
    [self.view addSubview:_infosView];
    
    [self.view addSubview:_buttonsView];

    PlayingOSDView* osdView = [[[PlayingOSDView alloc] initWithFrame:self.view.frame] autorelease];
    //        mainView.frame  = self.view.frame;
    [self.view addSubview:osdView];

   
    ////toolbar
    _toolBar = [self createToolbar];
    [self.view addSubview:_toolBar];
    
    _titleBackground = [[[CustomTitleView alloc] init] retain];
    
    _titleBackground.title = @"Remote";
    _titleBackground.subtitle = @"Controls";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
    //gestures
//    [self cleanPlayingInfo];
    
//    _recentlyAddedMovies = [[RecentlyAddedViewController alloc] init];
//    [_recentlyAddedMovies.view setFrame:CGRectMake(10, 10, 280, 120)];
//    [self updateRecentlyAddedMovies:nil];
//  [self.view insertSubview:_recentlyAddedMovies.view belowSubview:_gestureView];
    

    
//    menu = [[DropDownMenuViewController alloc] initWithNibName:@"DropDownMenuView" bundle:nil];
//    menu.view.hidden = TRUE;

    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
	
    [center
     addObserver:self
     selector:@selector(playingStarted:)
     name:@"playingStarted"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playingStopped:)
     name:@"playingStopped"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playingPaused:)
     name:@"playingPaused"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playingUnpaused:)
     name:@"playingUnpaused"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(gotPlayingInfo:)
     name:@"nowPlayingInfo"
     object:nil ];
    
    [center addObserver:self
               selector:@selector(applicationDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(applicationWillResignActive:)
                   name:UIApplicationWillResignActiveNotification
                 object:nil];
    
    [super viewDidLoad];
	
	UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] 
											initWithTarget:self 
											action:@selector(handleSwipe:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:recognizer];
	[recognizer release];
    
    if ([[XBMCStateListener sharedInstance] playing])
    {
        [self updatePlayingInfo:[[XBMCStateListener sharedInstance] playingInfo]];
    }
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void) hideToolbar
{
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
    _toolBar.bottom =  0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void) toggleToolbar
{
    [UIView beginAnimations:nil context:_toolBar];
    [UIView setAnimationDuration:TTSTYLEVAR(toolbarAnimationDuration)];
    if (_toolBar.top == 0)
        _toolBar.bottom = 0;
    else _toolBar.top = 0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideToolbar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)cleanPlayingInfo
{
    _imdb = @"";
    _type = @"";
    _id = @"";
    _titleBackground.title= @"Remote";
    _titleBackground.subtitle = @"Controls";
    
    [UIView beginAnimations:@"cleanAnimation" context:_infosView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
    [UIView setAnimationDelegate:self];   
    _infosView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    if ([animationID isEqualToString:@"cleanAnimation"])
    {
//        _cover.image = nil;        
        _fanart.image = nil;        

        _infoLabel.text = [TTStyledText textFromXHTML:@"" lineBreaks:YES URLs:YES];
    }
}

-(void)updatePlayingInfo: (NSDictionary *) item
{ 
    _infosView.frame = self.view.frame;
    _fanart.frame = _infosView.frame;
    self.type = [item valueForKey:@"type"];
    self.itemId = [item valueForKey:@"id"];
    self.imdb = [item objectForKey:@"imdbnumber"]; 
    
    _titleBackground.title = [item valueForKey:@"title"];
    
    if ([_type isEqualToString:@"movie"])
    {
        _titleBackground.subtitle = [item valueForKey:@"genre"];
    }
    else if ([_type isEqualToString:@"episode"])
    {
        _titleBackground.subtitle = [NSString stringWithFormat:@"Season %@ ● Episode %@",[item objectForKey:@"season"]
                                     ,[item objectForKey:@"episode"]];
	}
	
	if ([item objectForKey:@"fanart"] != nil  && [(NSString*)[item valueForKey:@"fanart"] compare:@""] != NSOrderedSame)
    {
        [self performSelector:@selector(downloadFanart:) 
                   withObject:[item objectForKey:@"fanart"]
                   afterDelay:0];
    }
	else
	{
		[_fanart animateNewImage:nil];
	}
	
	[UIView beginAnimations:nil context:_infosView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];   
    _infosView.alpha = 1.0;
    [UIView commitAnimations];
}

	-(void)gotPlayingInfo: (NSNotification *) notification
{    
    NSDictionary* item = [notification userInfo];
    if (item == nil) return;  
    
    [self updatePlayingInfo:item];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
	[super disconnectedFromXBMC:notification];
    [self cleanPlayingInfo];
}

- (void)playingStarted: (NSNotification *) notification 
{
    self.title = @"Playing";
//    [self updatePlayingInfo];
}

- (void)coverLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_cover animateNewImage:[result objectForKey:@"image"]];
    }
}

-(void)downloadCover:(NSString*)url
{
//    [XBMCImage askForImage:url
//                    object:self selector:@selector(coverLoaded:) 
//             thumbnailHeight:self.view.width];

}

- (void)fanartLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_fanart animateNewImage:[result objectForKey:@"image"]];
    }
}

-(void)downloadFanart:(NSString*)url
{
    NSInteger height = TTScreenBounds().size.height;
    [XBMCImage askForImage:url 
					object:self selector:@selector(fanartLoaded:) 
		   thumbnailHeight:height];
}

- (void)playingStopped: (NSNotification *) notification 
{
    self.title = @"Remote";
    [self cleanPlayingInfo];
}

- (void)playingPaused: (NSNotification *) notification 
{
    self.title = @"Paused";
}

- (void)playingUnpaused: (NSNotification *) notification 
{
    self.title = @"Playing";
}

- (void)buttonPressed:(id)sender 
{
    switch (((UIButton*)sender).tag)
    {
        case 0:
            [XBMCCommand send:@"select"];
            break;
        case 1:
            [XBMCCommand send:@"back"];
            break;
        case 2:
            [XBMCCommand send:@"esc"];
            break;
        case 3:
            [XBMCCommand send:@"up"];
            break;
        case 4:
            [XBMCCommand send:@"down"];
            break;
        case 5:
            [XBMCCommand send:@"right"];
            break;
        case 6:
            [XBMCCommand send:@"left"];
            break;
        case 7:
            [XBMCCommand send:@"previous"];
            break;
        case 8:
            [XBMCCommand send:@"pause"];
            break;
        case 9:
            [XBMCCommand send:@"next"];
            break;
        case 10:
            [XBMCCommand send:@"stop"];
            break;
        case 11:
            [XBMCCommand send:@"subtitles"];
            break;
        case 12:
            [XBMCCommand send:@"info"];
            break;
        case 13:
            [XBMCCommand send:@"osd"];
            break;
        case 14:
            [XBMCCommand send:@"menu"];
            break;
		case 15:
            [XBMCCommand send:@"showgui"];
            break;
        default:
            break;
    }
}

- (void)showImdb:(id)sender
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate) showImdb:_imdb];    
}

- (void)showDetails:(id)sender
{
    if ([_type isEqualToString:@"movie"])
    {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) showMovieDetails:[NSNumber numberWithInt:[_id intValue]]];
    }   
}

- (void)applicationWillResignActive: (NSNotification *) notification 
{
}

- (void)applicationDidBecomeActive: (NSNotification *) notification 
{
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

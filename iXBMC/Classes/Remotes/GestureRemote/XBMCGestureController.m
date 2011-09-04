//
//  XBMCGestureViewController.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCGestureController.h"
#import "XBMCTouchView.h"
#import "XBMCCommand.h"
#import "XBMCStateListener.h"
//#import "XBMCJSONCommunicator.h"
#import "RecentlyAddedMoviesViewController.h"
#import "LibraryUpdater.h"
#import "XBMCImage.h"

#import "LambdaAlert.h"

#import "FadingImageView.h"
#import "PlayingOSDView.h"
#import "CustomTitleView.h"

#import	"BCTab.h"

@implementation XBMCGestureController
@synthesize itemId = _id;
@synthesize imdb = _imdb;
@synthesize type = _type;
@synthesize tabButton= _tabButton;

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
    
    TTButton* button3 = [TTButton buttonWithStyle:@"embossedButton:" title:@"Remote"];
    button3.frame = CGRectMake(button2.right + 10, 10, 71, 25);
    [button3 addTarget:self action:@selector(showRemote:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:button3];
    
    return toolbar;
}

- (void) addGestures
{
    UIPanGestureRecognizer *panrecognizer;
    panrecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    panrecognizer.delaysTouchesBegan = YES;
    //[_gestureView addGestureRecognizer:panrecognizer];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    //    [recognizer canPreventGestureRecognizer:panrecognizer];
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
    recognizer.numberOfTouchesRequired = 2;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    recognizer.numberOfTouchesRequired = 2;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    recognizer.numberOfTouchesRequired = 2;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    recognizer.numberOfTouchesRequired = 2;
    [_gestureView addGestureRecognizer:recognizer];
    [recognizer release];
    
    UITapGestureRecognizer *doubletaprecognizer;
    doubletaprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubletaprecognizer.numberOfTapsRequired = 2;
    [_gestureView addGestureRecognizer:doubletaprecognizer];
    
    UITapGestureRecognizer *taprecognizer;
    taprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [taprecognizer requireGestureRecognizerToFail:doubletaprecognizer];
    [_gestureView addGestureRecognizer:taprecognizer];
    [doubletaprecognizer release];
    [taprecognizer release];
    
    UITapGestureRecognizer *doubletouchtaprecognizer;
    doubletouchtaprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTouchTap:)];
    doubletouchtaprecognizer.numberOfTouchesRequired = 2;
    [_gestureView addGestureRecognizer:doubletouchtaprecognizer];
    [doubletouchtaprecognizer release];
    
    UILongPressGestureRecognizer *longpress;
    longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_gestureView addGestureRecognizer:longpress];
    [longpress release];
    
    [panrecognizer release];
}

- (NSString *)iconImageName {
	return @"iconRemote.png";
}

- (NSString *)selectedIconImageNameSuffix
{
	return @"On";
}

- (void)setTabBarButton:(BCTab*) tabBarButton
{
	self.tabButton = tabBarButton;
	
	UILongPressGestureRecognizer *longpress;
    longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnTab:)];
    [self.tabButton addGestureRecognizer:longpress];
    [longpress release];
}

- (NSString *)iconTitle {
	return @"Remote";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{    
    TT_RELEASE_SAFELY(_titleBackground);
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

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    _imdb = @"";
    _type = @"";
    _id = @"";
        
    //create new uiview with a background image
    UIImageView* back = [[[UIImageView alloc] 
                        initWithImage:TTIMAGE(@"bundle://gestureGlass.png")] autorelease];
    back.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	back.frame = self.view.frame;
	[self.view addSubview:back];  

	
	_fanart = [[[FadingImageView alloc] init] autorelease];
	_fanart.contentMode = UIViewContentModeScaleAspectFill;
    _fanart.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	_fanart.clipsToBounds = YES;
	_fanart.alpha = 0.1;
    
    _infosView = [[[TTView alloc] init] autorelease];
    _infosView.backgroundColor = [UIColor clearColor];
    _infosView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _infosView.autoresizesSubviews = YES;
    _infosView.alpha = 0.0;
    
    _gestureView = [[[UIImageView alloc] initWithFrame:TTNavigationFrame()] autorelease];
    _gestureView.backgroundColor = [UIColor clearColor];
//    _gestureView.image = TTIMAGE(@"bundle://gestureGlass.png");        
    _gestureView.opaque = YES;        
    _gestureView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _gestureView.userInteractionEnabled= YES;
    
//    _backgroundView.frame = self.view.frame;
    _infosView.frame = self.view.frame;
    _fanart.frame = _infosView.frame;
    _gestureView.frame = self.view.frame;
    
    _cover = [[[FadingImageView alloc] init] autorelease];
    _cover.defaultImage = TTIMAGE(@"bundle://thumbnailNoneBig.png");        
    _cover.contentMode = UIViewContentModeScaleToFill;
    _cover.clipsToBounds = YES;
    _cover.backgroundColor = [UIColor clearColor];
    _cover.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
                    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:10 offset:CGSizeMake(0, 0) next:
                     [TTContentStyle styleWithNext:nil]]];
    
    _infoLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
	_infoLabel.font = [UIFont systemFontOfSize:12];
    _infoLabel.backgroundColor = [UIColor clearColor];
    
    _plotLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
    _plotLabel.backgroundColor = [UIColor clearColor];
    
	[_infosView addSubview:_fanart];
    [_infosView addSubview:_infoLabel]; 
    [_infosView addSubview:_plotLabel]; 
    [_infosView addSubview:_cover];

//    [self.view addSubview:_backgroundView];  
    [self.view addSubview:_infosView]; 
    
    [self.view addSubview:_gestureView];

    PlayingOSDView* osdView = [[[PlayingOSDView alloc] initWithFrame:self.view.frame] autorelease];
    [self.view addSubview:osdView];
    
   
    ////toolbar
    _toolBar = [self createToolbar];
    [self.view addSubview:_toolBar];
    
    _titleBackground = [[[CustomTitleView alloc] init] retain];
    
    _titleBackground.title = @"Remote";
    _titleBackground.subtitle = @"Gestures";
    [_titleBackground addTarget:self action:@selector(toggleToolbar) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _titleBackground;
    
    //gestures
    [self addGestures];
    
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
     selector:@selector(updatePlayingInfo:)
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

	[super viewDidLoad]; //we do it after to get the notconnected view correctly on top
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
	_infosView.frame = self.view.frame;
    _fanart.frame = _infosView.frame;
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
    _titleBackground.subtitle = @"Gestures";
    
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
        _cover.image = nil;        
        _fanart.image = nil;        

        _infoLabel.text = [TTStyledText textFromXHTML:@"" lineBreaks:YES URLs:YES];
        _plotLabel.text = [TTStyledText textFromXHTML:@"" lineBreaks:YES URLs:YES];    
    }
}

-(void)updatePlayingInfo: (NSNotification *) notification
{    
    NSDictionary* item = [notification userInfo];
	NSLog(@"got now playing %@", item);
    
    if (item == nil) return;    
    
    self.type = [item valueForKey:@"type"];
    self.itemId = [item valueForKey:@"id"];
    self.imdb = [item objectForKey:@"imdbnumber"]; 
    
    _titleBackground.title= [item valueForKey:@"title"];
    
    if ([_type isEqualToString:@"movie"])
    {
        _titleBackground.subtitle = [item valueForKey:@"genre"];
        //INFOS
        NSString* infoText = @"";
        if ([item valueForKey:@"director"] && ![(NSString*)[item valueForKey:@"director"] isEqualToString:@""])
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Director:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [item valueForKey:@"director"]]; 
        }
        if ([item valueForKey:@"writer"] && ![(NSString*)[item valueForKey:@"writer"] isEqualToString:@""])
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Writer:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [item valueForKey:@"writer"]]; 
        }
        if ([[item valueForKey:@"year"] integerValue] != 0)
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Year:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [[item valueForKey:@"year"] stringValue]]; 
        }
        if ([item valueForKey:@"runtime"])
        {
            NSString* runtime = [NSString stringWithString:[item valueForKey:@"runtime"]];
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
        
        infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Imdb Rating: </span>\
<img src=\"bundle://star.%.1f.png\" width=\"100\" height=\"20\"/>\n\n", [[item valueForKey:@"rating"] floatValue]]; 
        
        _infoLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];    
        
        CGFloat coverHeight = TTSTYLEVAR(movieDetailsViewCoverHeight);
        
        _cover.frame = CGRectMake(5, 5, coverHeight*2/3, coverHeight);
        
        _infoLabel.frame = CGRectMake(0, 5, self.view.width , self.view.height);
        _infoLabel.contentInset = UIEdgeInsetsMake(5, 5 + _cover.right, 5, 5);
        [_infoLabel layoutSubviews];
        [_infoLabel sizeToFit];
        [_infoLabel setHeight:MAX(_infoLabel.height, _cover.bottom + 5)];
        
        infoText = @"";
        if ([item valueForKey:@"plot"] && ![(NSString*)[item valueForKey:@"plot"] isEqualToString:@""])
        {
			// define the range you're interested in
			NSRange stringRange = {0, MIN([[item valueForKey:@"plot"] length], 200)};
			
			// adjust the range to include dependent chars
			stringRange = [[item valueForKey:@"plot"] rangeOfComposedCharacterSequencesForRange:stringRange];
            NSString * plotString = [[item valueForKey:@"plot"] 
									 substringWithRange:stringRange];
			if (stringRange.length < [[item valueForKey:@"plot"] length])
			{
				plotString = [plotString
							  stringByAppendingString:@"..."];
			}
			infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Plot:</span>\n\
<span class=\"plotText\">%@</span>\n\n", plotString]; 
        }
        _plotLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
        _plotLabel.frame = CGRectMake(0, _infoLabel.bottom + 10
                                      , _infosView.width
                                      , _infosView.height);
        _plotLabel.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [_plotLabel layoutSubviews];
        [_plotLabel sizeToFit];
    }
    else if ([_type isEqualToString:@"episode"])
    {
        _titleBackground.subtitle = [NSString stringWithFormat:@"Season %@ ● Episode %@",[item objectForKey:@"season"]
                                     ,[item objectForKey:@"episode"]];
        CGFloat coverHeight = TTSTYLEVAR(movieDetailsViewCoverHeight);
        
        _cover.frame = CGRectMake(self.view.width - coverHeight -5
                                  , 25
                                  , coverHeight, coverHeight*3/5);
        
        NSString* infoText = @"";
        if ([item valueForKey:@"showtitle"])
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"bigWhiteText\">%@</span>\n", [[item valueForKey:@"showtitle"] stringByReplacingOccurrencesOfString:@"&" withString:@"and"]]; 
        }
        infoText = [infoText stringByAppendingFormat:@"\
<img src=\"bundle://star.%.1f.png\" width=\"100\" height=\"20\"/>\n\n", [[item valueForKey:@"rating"] floatValue]];
        
        if ([item valueForKey:@"director"] && ![(NSString*)[item valueForKey:@"director"] isEqualToString:@""])
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Director:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [item valueForKey:@"director"]]; 
        }
        if ([item valueForKey:@"writer"] && ![(NSString*)[item valueForKey:@"writer"] isEqualToString:@""])
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Writer:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [item valueForKey:@"writer"]]; 
        }
        if ([[item valueForKey:@"firstaired"] integerValue] != 0)
        {
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Aired:</span>\n\
<span class=\"whiteText\">%@</span>\n\n", [item valueForKey:@"firstaired"]]; 
        }
        if ([item valueForKey:@"runtime"])
        {
            NSString* runtime = [NSString stringWithString:[item valueForKey:@"runtime"]];
            NSRange foundRange = [runtime rangeOfString:@"min"];
            
            if ((foundRange.length == 0) ||
                (foundRange.location == 0))
            {
                runtime = [runtime stringByAppendingString:@" min"];
            }
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Runtime:</span>\n\
<span class=\"whiteText\">%@</span>\n", runtime]; 
        }
        
        _infoLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
        _infoLabel.frame = CGRectMake(0, 0
                                      , _cover.left
                                      , _infosView.height);
        _infoLabel.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [_infoLabel layoutSubviews];
        [_infoLabel sizeToFit];
        
        infoText = @"";
        if ([item valueForKey:@"plot"] && ![(NSString*)[item valueForKey:@"plot"] isEqualToString:@""])
        {
			// define the range you're interested in
			NSRange stringRange = {0, MIN([[item valueForKey:@"plot"] length], 200)};
			
			// adjust the range to include dependent chars
			stringRange = [[item valueForKey:@"plot"] rangeOfComposedCharacterSequencesForRange:stringRange];
            
            infoText = [infoText stringByAppendingFormat:@"\
<span class=\"grayText\">Plot:</span>\n\
<span class=\"plotText\">%@</span>\n\n", [[[item valueForKey:@"plot"] 
																   substringWithRange:stringRange]
																  stringByAppendingString:@"..."]]; 
        }
        _plotLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
        _plotLabel.frame = CGRectMake(0, MAX(_infoLabel.bottom, _cover.bottom) + 10
                                      , _infosView.width
                                      , _infosView.height);
        _plotLabel.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [_plotLabel layoutSubviews];
		[_plotLabel sizeToFit];
    }
    
    if ([item objectForKey:@"thumbnail"] != nil  && [(NSString*)[item valueForKey:@"thumbnail"] compare:@""] != NSOrderedSame)
    {
        [self performSelector:@selector(downloadCover:) 
                   withObject:[item objectForKey:@"thumbnail"]
                   afterDelay:0];
    }
	else
	{
		[_cover animateNewImage:nil];
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

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
	[super disconnectedFromXBMC:notification];
    [self cleanPlayingInfo];
}

- (void)playingStarted: (NSNotification *) notification 
{
    [self.tabButton setButtonTitle:@"Playing"];
}

- (void)coverLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_cover animateNewImage:[result objectForKey:@"image"]];
    }
}

- (void)fanartLoaded:(NSDictionary*) result
{
    if ([result objectForKey:@"image"])
    {
        [_fanart animateNewImage:[result objectForKey:@"image"]];
    }
}

-(void)downloadCover:(NSString*)url
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTSTYLEVAR(movieDetailsViewCoverHeight);
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
   [XBMCImage askForImage:url
                    object:self selector:@selector(coverLoaded:) 
             thumbnailHeight:height];

}

-(void)downloadFanart:(NSString*)url
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	CGFloat height = TTScreenBounds().size.height;
	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
	{
		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
	}
    [XBMCImage askForImage:url 
					object:self selector:@selector(fanartLoaded:) 
			 thumbnailHeight:height];
}

- (void)playingStopped: (NSNotification *) notification 
{
    [self.tabButton setButtonTitle:@"Remote"];
    [self cleanPlayingInfo];
}

- (void)playingPaused: (NSNotification *) notification 
{
	[self.tabButton setButtonTitle:@"Paused"];
}

- (void)playingUnpaused: (NSNotification *) notification 
{
    [self.tabButton setButtonTitle:@"Playing"];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) 
    {
        [XBMCCommand send:@"down"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) 
    {
        [XBMCCommand send:@"up"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
        [XBMCCommand send:@"left"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) 
    {
        [XBMCCommand send:@"right"];
    }
}

- (void)handleDoubleSwipe:(UISwipeGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) 
    {
        [XBMCCommand send:@"info"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) 
    {
        [XBMCCommand send:@"subtitles"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) 
    {
        [XBMCCommand send:@"previous"];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
    {
        [XBMCCommand send:@"next"];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    if ([[XBMCStateListener sharedInstance] playing])
    {
        [XBMCCommand send:@"osd"];
    }
    else
    {
        [XBMCCommand send:@"back"];
    }
}

- (void)handleDoubleTouchTap:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    if ([[XBMCStateListener sharedInstance] playing])
    {
    }
    else
    {
        [XBMCCommand send:@"esc"];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    {
        [XBMCCommand send:@"select"];
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
    
    if ([[XBMCStateListener sharedInstance] playing])
    {
        [XBMCCommand send:@"stop"];
    }
    else
    {
        [XBMCCommand send:@"menu"];
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer 
{
    if ([[XBMCStateListener sharedInstance] playing])
    {
        return;
    }
    int factor = 100000;
    int value = 0; 
    CGPoint velocity = [recognizer velocityInView:_gestureView];
    CGPoint translation = [recognizer translationInView:_gestureView];
    if (fabs(velocity.x) > fabs(velocity.y))
    {
        value =fabs(factor/ ( translation.x));
        
    }
    NSLog(@"state %d %d, %@, %@", recognizer.state, value, NSStringFromCGPoint(velocity) , NSStringFromCGPoint(translation));
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
//        [[XBMCHttpInterface sharedInstance] sendCommand:[NSString stringWithFormat:@"KeyRepeat(%d)", value]];
        if (fabs(velocity.x) > fabs(velocity.y))
        {
            if (translation.x >0)
            {
                [XBMCCommand send:@"right"];
            }
            else if (translation.x <0)
            {
                [XBMCCommand send:@"left"];
            }
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
//        [[XBMCHttpInterface sharedInstance] sendCommand:[NSString stringWithFormat:@"KeyRepeat(%d)", value]];
//        if (fabs(velocity.x) > fabs(velocity.y))
//        {
//            if (translation.x >0)
//            {
//                [[XBMCHttpInterface sharedInstance] sendCommand:@"SendKey(273)"];
//            }
//            else if (translation.x <0)
//            {
//                [[XBMCHttpInterface sharedInstance] sendCommand:@"SendKey(272)"];
//            }
//        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded
             || recognizer.state == UIGestureRecognizerStateCancelled
             || recognizer.state == UIGestureRecognizerStateFailed)
    {
//        [[XBMCHttpInterface sharedInstance] sendCommand:@"KeyRepeat(0)"];        
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

- (void)showRemote:(id)sender
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate) openURL:@"tt://remote"];
}

- (void)applicationWillResignActive: (NSNotification *) notification 
{
    //    [self cleanPlayingInfo];
}

- (void)applicationDidBecomeActive: (NSNotification *) notification 
{
//    if ([[XBMCStateListener sharedInstance] playing])
//    {
//        [self updatePlayingInfo];
//    }
}

- (void)handleLongPressOnTab:(UILongPressGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateBegan) return;
	
	if ([XBMCStateListener connected])
	{
		LambdaAlert *alert = [[LambdaAlert alloc]
							  initWithTitle:@"iXBMC"
							  message:@"System Menu"];
		
		[alert addButtonWithTitle:@"Settings" block:^{ [XBMCCommand send:@"settings"]; }];
		[alert addButtonWithTitle:@"Update Library" block:^{ [[LibraryUpdater sharedInstance] updateLibrary]; }];
		[alert addButtonWithTitle:@"Exit XBMC" block:^{ [XBMCCommand send:@"exit"]; }];
		[alert addButtonWithTitle:@"Shutdown Menu" block:^{ [XBMCCommand send:@"shutdownmenu"]; }];
		[alert addButtonWithTitle:@"Cancel" block:NULL];
		[alert show];
		[alert release];
	}
	else
	{
		LambdaAlert *alert = [[LambdaAlert alloc]
							  initWithTitle:@"iXBMC"
							  message:@"Not Connected"];
		
		[alert addButtonWithTitle:@"Settings" block:^{ [XBMCCommand send:@"settings"]; }];
		[alert addButtonWithTitle:@"Cancel" block:NULL];
		[alert show];
		[alert release];
	}
}

@end

//
//  NPWidgetController.m
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NPWidgetController.h"
#import "XBMCCommand.h"
#import "XBMCStateListener.h"
#import "XBMCHttpInterface.h"

#import "FadingImageView.h"
#import "PlayingOSDView.h"

@implementation NPWidgetController
@synthesize type = _type;

- (void) addGestures
{
    
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
    
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionDown;
//    recognizer.numberOfTouchesRequired = 2;
//    [_gestureView addGestureRecognizer:recognizer];
//    [recognizer release];
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    recognizer.numberOfTouchesRequired = 2;
//    [_gestureView addGestureRecognizer:recognizer];
//    [recognizer release];
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    recognizer.numberOfTouchesRequired = 2;
//    [_gestureView addGestureRecognizer:recognizer];
//    [recognizer release];
//    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleSwipe:)];
//    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    recognizer.numberOfTouchesRequired = 2;
//    [_gestureView addGestureRecognizer:recognizer];
//    [recognizer release];
    
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
    
//    UITapGestureRecognizer *doubletouchtaprecognizer;
//    doubletouchtaprecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTouchTap:)];
//    doubletouchtaprecognizer.numberOfTouchesRequired = 2;
//    [_gestureView addGestureRecognizer:doubletouchtaprecognizer];
//    [doubletouchtaprecognizer release];
    
    UILongPressGestureRecognizer *longpress;
    longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [_gestureView addGestureRecognizer:longpress];
    [longpress release];
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
    TT_RELEASE_SAFELY(_type);

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
    TTView* bgView = [[[TTView alloc] init] autorelease];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.autoresizesSubviews = YES;
	bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	bgView.style = [TTFourBorderStyle styleWithTop:TTSTYLEVAR(navBarBorderColor) width:2.0 next:nil];
	self.view = bgView;

    _type = @"";
	
//	_fanart = [[[FadingImageView alloc] init] autorelease];
//	_fanart.contentMode = UIViewContentModeScaleAspectFill;
//    _fanart.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//	_fanart.clipsToBounds = YES;
//	_fanart.alpha = 0.1;
    
    _infosView = [[[TTView alloc] init] autorelease];
    _infosView.backgroundColor = [UIColor clearColor];
    _infosView.clipsToBounds = YES;
    _infosView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _infosView.autoresizesSubviews = YES;
    _infosView.style = 
                     [TTContentStyle styleWithNext:[TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:6.0f offset:CGSizeMake(0.0f, 0.0f) next:nil]];
    _infosView.alpha = 0.0;
    
    _gestureView = [[[UIImageView alloc] init] autorelease];
    _gestureView.backgroundColor = [UIColor clearColor];
    _gestureView.contentMode = UIViewContentModeScaleToFill;
    _gestureView.image = TTIMAGE(@"bundle://testNPWidget.png");        
    _gestureView.alpha = 0.5;        
    _gestureView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _gestureView.opaque =  YES;        
    _gestureView.userInteractionEnabled= YES;
    
//    _backgroundView.frame = self.view.frame;

    
    _cover = [[[NINetworkImageView alloc] init] autorelease];
    _cover.contentMode = UIViewContentModeScaleAspectFill;
//    _cover.clipsToBounds = YES;
    _cover.alpha = 0.5;
    _cover.delegate  =self;
    _cover.backgroundColor = [UIColor clearColor];
//	_cover.style = [TTSolidBorderStyle styleWithColor:[UIColor grayColor] width:2.0 next:nil];

//    _cover.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
//                    [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:10 offset:CGSizeMake(0, 0) next:
//                     [TTContentStyle styleWithNext:nil]]];
    
    _infoLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
	_infoLabel.font = [UIFont systemFontOfSize:12];
    _infoLabel.backgroundColor = [UIColor clearColor];
    
//	[_infosView addSubview:_fanart];
    [_infosView addSubview:_cover];
    [_infosView addSubview:_infoLabel]; 

//    [self.view addSubview:_backgroundView];  
    [self.view addSubview:_infosView]; 
    
    [self.view addSubview:_gestureView];

//    PlayingOSDView* osdView = [[[PlayingOSDView alloc] initWithFrame:self.view.frame] autorelease];
//    [self.view addSubview:osdView];
        
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
     selector:@selector(playingStopped:)
     name:@"playingStopped"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playerStarted:)
     name:@"playerStarted"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playerPaused:)
     name:@"playerPaused"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(playerUnpaused:)
     name:@"playerUnpaused"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(updatePlayingInfo:)
     name:@"playerInfo"
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

- (void)viewWillAppear:(BOOL)animated 
{
	_infosView.frame = _gestureView.frame = CGRectMake(0, 2, self.view.width, self.view.height - 2);
//    _fanart.frame = _infosView.frame;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)cleanPlayingInfo
{
    _type = @"";
    
    [UIView beginAnimations:@"NPWcleanAnimation" context:_infosView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(animationFinished: finished: context:)];
    [UIView setAnimationDelegate:self];   
    _infosView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    if ([animationID isEqualToString:@"NPWcleanAnimation"])
    {
        _cover.image = nil;        
//        _fanart.image = nil;        

        _infoLabel.text = [TTStyledText textFromXHTML:@"" lineBreaks:YES URLs:YES];
    }
}

-(void)layout
{ 
//	CGFloat coverHeight = self.view.height - 10;
    _cover.frame = _infosView.bounds;
//    if ([_type isEqualToString:@"movie"])
//    {
//    }
//    else if ([_type isEqualToString:@"episode"])
//    {
//        _cover.frame = CGRectMake(self.view.width - coverHeight -5
//                                  , 25
//                                  , coverHeight, coverHeight*3/5);
//    }
	_infoLabel.frame = CGRectMake(0, _infosView.height -_infoLabel.height, _infosView.width, _infoLabel.height);
//	_infoLabel.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
}

-(void)updatePlayingInfo: (NSNotification *) notification
{    
    NSDictionary* item = [[notification userInfo] objectForKey:@"info"];
    
    if (item == nil) return;    
    
    self.type = [item valueForKey:@"type"];
//    self.itemId = [item valueForKey:@"id"];
//    self.imdb = [item objectForKey:@"imdbnumber"]; 
        
    if ([_type isEqualToString:@"movie"])
    {
        //INFOS
        NSString* infoText = @"";
		
		infoText = [infoText stringByAppendingFormat:@"\
					<span class=\"NPWTitle\">%@</span>\
					<span class=\"NPWSubtitle\">%@</span>\n\n"
					, [item valueForKey:@"label"]
					, [item valueForKey:@"year"]]; 

        _infoLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];    
        

    }
    else if ([_type isEqualToString:@"episode"])
    {
        NSString* infoText = @"";
		
		infoText = [infoText stringByAppendingFormat:@"\
					<span class=\"NPWTitle\">%@</span>\n\
					<span class=\"NPWSubtitle\">%@</span>"
					, [item valueForKey:@"showtitle"]
					, [item valueForKey:@"label"]]; 
		
        _infoLabel.text = [TTStyledText textFromXHTML:infoText lineBreaks:YES URLs:YES];
        [_infoLabel layoutSubviews];
        [_infoLabel sizeToFit];
	}
    
    if ([item objectForKey:@"thumbnail"] != nil  && [(NSString*)[item valueForKey:@"thumbnail"] compare:@""] != NSOrderedSame)
    {
        [_cover setPathToNetworkImage:
         [XBMCHttpInterface getUrlFromSpecial:[item objectForKey:@"thumbnail"]]];
        ;
    }
	else
	{
		[_cover setImage:nil];
	}

	[self layout];
    
    [UIView beginAnimations:nil context:_infosView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];   
    _infosView.alpha = 1.0;
    [UIView commitAnimations];
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [self cleanPlayingInfo];
}

- (void)playerStopped: (NSNotification *) notification 
{
    [self cleanPlayingInfo];
}

//- (void)coverLoaded:(NSDictionary*) result
//{
//    if ([result objectForKey:@"image"])
//    {
//        [_cover animateNewImage:[result objectForKey:@"image"]];
//    }
//}

//-(void)downloadCover:(NSString*)url
//{
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	CGFloat height = TTSTYLEVAR(movieDetailsViewCoverHeight);
//	if ([[defaults valueForKey:@"images:highQuality"] boolValue])
//	{
//		height *= (CGFloat)TTSTYLEVAR(highQualityFactor);
//	}
//   [XBMCImage askForImage:url
//                    object:self selector:@selector(coverLoaded:) 
//             thumbnailHeight:height];
//
//}

- (void)playerStarted: (NSNotification *) notification 
{
    if ([[[XBMCStateListener sharedInstance] currentPlayers] count] == 0)
        [self cleanPlayingInfo];
}

- (void)playerPaused: (NSNotification *) notification 
{
}

- (void)playerUnpaused: (NSNotification *) notification 
{
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
//
//- (void)handleDoubleSwipe:(UISwipeGestureRecognizer *)recognizer 
//{
//    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
//    
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) 
//    {
//        [XBMCCommand send:@"info"];
//    }
//    else if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) 
//    {
//        [XBMCCommand send:@"subtitles"];
//    }
//    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) 
//    {
//        [XBMCCommand send:@"previous"];
//    }
//    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) 
//    {
//        [XBMCCommand send:@"next"];
//    }
//}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer 
{
    if (recognizer.state != UIGestureRecognizerStateRecognized) return;
    if ([[[XBMCStateListener sharedInstance] currentPlayers] count] == 0)
    {
        [XBMCCommand send:@"osd"];
    }
    else
    {
//        [XBMCCommand send:@"back"];
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
    
    if ([[[XBMCStateListener sharedInstance] currentPlayers] count] == 0)
    {
        [XBMCCommand send:@"stop"];
    }
    else
    {
//        [XBMCCommand send:@"menu"];
    }
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

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)networkImageView:(NINetworkImageView *)imageView didLoadImage:(UIImage *)image {
    [_cover setNeedsDisplay];
}

@end

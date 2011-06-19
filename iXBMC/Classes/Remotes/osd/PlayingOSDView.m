//
//  PlayingOSDView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayingOSDView.h"
#import "XBMCStateListener.h"

@implementation PlayingOSDView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = FALSE;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _pausedOSD = [[[UIImageView alloc] init] autorelease];
        _pausedOSD.frame = CGRectMake(self.width / 2 - 80, -20, 160, 20);
        _pausedOSD.backgroundColor = [UIColor clearColor];
        
        _pausedOSD.image = TTIMAGE(@"bundle://osdPausedBack.png");
        
        UILabel *pausedLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        pausedLabel.frame = CGRectMake(0,0,_pausedOSD.width,_pausedOSD.height);
        pausedLabel.font = [UIFont systemFontOfSize:14];
        pausedLabel.textColor = [UIColor blackColor];
        pausedLabel.backgroundColor = [UIColor clearColor];
        pausedLabel.textAlignment = UITextAlignmentCenter;
        pausedLabel.adjustsFontSizeToFitWidth = NO;
        pausedLabel.numberOfLines = 1;
        pausedLabel.userInteractionEnabled = FALSE;
        pausedLabel.text = @"Paused";
        [_pausedOSD addSubview:pausedLabel]; 
        
        _timeOSD = [[[UIImageView alloc] initWithFrame:CGRectMake(30, 
                                                                  self.height
                                                                  , self.width - 60, 20)] 
                    autorelease];
        _timeOSD.backgroundColor = [UIColor clearColor];
        _timeOSD.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
        | UIViewAutoresizingFlexibleBottomMargin;
        
        _timeOSD.image = TTIMAGE(@"bundle://osdTimeBack.png");
        
        _timeBackBar = [[[TTView alloc] initWithFrame:CGRectZero] autorelease];
        _timeBackBar.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
                              [TTSolidBorderStyle styleWithColor:RGBACOLOR(255,255,255,0.4) width:1 next:
                               [TTSolidFillStyle styleWithColor:[UIColor clearColor] next:nil]]];
        [_timeOSD addSubview:_timeBackBar];
        _timeCurrentBar = [[[TTView alloc] initWithFrame:CGRectZero] autorelease];
        _timeCurrentBar.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:3] next:
                                 [TTSolidFillStyle styleWithColor:RGBACOLOR(255,255,255,1.0) next:nil]];
        [_timeBackBar addSubview:_timeCurrentBar]; 
        _currentTimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        _currentTimeLabel.frame = CGRectMake(5,0,_timeOSD.width,_timeOSD.height);
        _currentTimeLabel.font = [UIFont boldSystemFontOfSize:11];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.textAlignment = UITextAlignmentCenter;
        _currentTimeLabel.adjustsFontSizeToFitWidth = NO;
        _currentTimeLabel.numberOfLines = 1;
        _currentTimeLabel.userInteractionEnabled = FALSE;
        _currentTimeLabel.text = @"";
        [_timeOSD addSubview:_currentTimeLabel];
        _totalTimeLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        _totalTimeLabel.frame = CGRectMake(5,0,_timeOSD.width,_timeOSD.height);
        _totalTimeLabel.font = [UIFont boldSystemFontOfSize:11];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.backgroundColor = [UIColor clearColor];
        _totalTimeLabel.textAlignment = UITextAlignmentCenter;
        _totalTimeLabel.adjustsFontSizeToFitWidth = NO;
        _totalTimeLabel.numberOfLines = 1;
        _totalTimeLabel.userInteractionEnabled = FALSE;
        _totalTimeLabel.text = @"";
        [_timeOSD addSubview:_totalTimeLabel];
        
        [self addSubview:_pausedOSD];
        [self addSubview:_timeOSD]; 
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
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
         selector:@selector(gotNowPlayingTime:)
         name:@"nowPlayingTime"
         object:nil ];
        
        if ([[XBMCStateListener sharedInstance] paused])
        {
            [self showPausedOSD];
            [[XBMCStateListener sharedInstance] askForTime];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) showPausedOSD
{
    [UIView beginAnimations:nil context:_pausedOSD];
    [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
    _pausedOSD.top = 0;
    [UIView commitAnimations];
}

- (void) hidePausedOSD
{
    [UIView beginAnimations:nil context:_pausedOSD];
    [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
    _pausedOSD.bottom = 0;
    [UIView commitAnimations];
}

- (void) showTimeOSD
{
    _timeOSD.top = self.height;
    //    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    [UIView beginAnimations:nil context:_timeOSD];
    [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
    _timeOSD.bottom = self.height;
    [UIView commitAnimations];
}

- (void) hideTimeOSD
{
    //    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    [UIView beginAnimations:nil context:_timeOSD];
    [UIView setAnimationDuration:TT_FAST_TRANSITION_DURATION];
    _timeOSD.top = self.height;
    [UIView commitAnimations];
}

-(void)gotNowPlayingTime: (NSNotification *) notification
{    
    //    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    //    [_recentlyAddedMovies.view setHidden:YES];
    NSDictionary* result = [[notification userInfo] objectForKey:@"result"];
    //    NSLog(@"got now time %@", result);
    if (result == nil) return; 
    
    int currentTimeSec = 0;
    NSString* currentTime = @"";
    if (![[[[result objectForKey:@"time"] objectForKey:@"hours"] stringValue] isEqualToString:@"0"])
    {
        currentTime = [currentTime stringByAppendingFormat:@"%@:",[[[result objectForKey:@"time"] objectForKey:@"hours"] stringValue]];
        currentTimeSec += [[[result objectForKey:@"time"] objectForKey:@"hours"] integerValue]*3600;
    }
    currentTime = [currentTime stringByAppendingFormat:@"%.2d:",[[[result objectForKey:@"time"] objectForKey:@"minutes"] integerValue]];
    currentTimeSec += [[[result objectForKey:@"time"] objectForKey:@"minutes"] integerValue]*60;
    currentTime = [currentTime stringByAppendingFormat:@"%.2d",[[[result objectForKey:@"time"] objectForKey:@"seconds"] integerValue]];
    currentTimeSec += [[[result objectForKey:@"time"] objectForKey:@"seconds"] integerValue];
    
    int totalTimeSec = 0;
    NSString* totalTime = @"";
    if (![[[[result objectForKey:@"total"] objectForKey:@"hours"] stringValue] isEqualToString:@"0"])
    {
        totalTime = [totalTime stringByAppendingFormat:@"%@:",[[[result objectForKey:@"total"] objectForKey:@"hours"] stringValue]];
        totalTimeSec += [[[result objectForKey:@"total"] objectForKey:@"hours"] integerValue]*3600;
    }
    totalTime = [totalTime stringByAppendingFormat:@"%.2d:",[[[result objectForKey:@"total"] objectForKey:@"minutes"] integerValue]];
    totalTimeSec += [[[result objectForKey:@"total"] objectForKey:@"minutes"] integerValue]*60;
    
    totalTime = [totalTime stringByAppendingFormat:@"%.2d",[[[result objectForKey:@"total"] objectForKey:@"seconds"] integerValue]];
    totalTimeSec += [[[result objectForKey:@"total"] objectForKey:@"seconds"] integerValue];
    
    
    _currentTimeLabel.text = currentTime;
    [_currentTimeLabel sizeToFit];
    _currentTimeLabel.frame = CGRectMake(7,4,_currentTimeLabel.width,_currentTimeLabel.height);
    _totalTimeLabel.text = totalTime;
    [_totalTimeLabel sizeToFit];
    _totalTimeLabel.frame = CGRectMake(_timeOSD.width - _totalTimeLabel.width - 7,4
                                       ,_totalTimeLabel.width,_totalTimeLabel.height);
    
    NSInteger seekWidth = _totalTimeLabel.left - _currentTimeLabel.right - 20;
    _timeBackBar.frame = CGRectMake(_currentTimeLabel.right + 10,8
                                    ,seekWidth,_timeOSD.height - 12);
    _timeCurrentBar.frame = CGRectMake(1,1
                                       ,seekWidth*currentTimeSec/totalTimeSec,_timeBackBar.height - 2);
    [self showTimeOSD];
}

- (void)playingStarted: (NSNotification *) notification 
{
    [self hidePausedOSD];
    [self hideTimeOSD];
}

- (void)playingStopped: (NSNotification *) notification 
{
    [self hidePausedOSD];
    [self hideTimeOSD];
}

- (void)playingPaused: (NSNotification *) notification 
{
    [self showPausedOSD];
    [[XBMCStateListener sharedInstance] askForTime];
}

- (void)playingUnpaused: (NSNotification *) notification 
{
    [self hidePausedOSD];
    [self hideTimeOSD];
}

@end

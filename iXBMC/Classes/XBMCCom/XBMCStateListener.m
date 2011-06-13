//
//  XBMCStateListener.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCStateListener.h"

#import "XBMCJSONCommunicator.h"
#import "JSONKit.h"
#import "CJSONSerializer.h"


@implementation XBMCStateListener
@synthesize connected;
@synthesize playing;
@synthesize paused;
@synthesize connectionTimer;
@synthesize playingInfo;

static XBMCStateListener *sharedInstance = nil;

+ (XBMCStateListener *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

+ (bool)connected
{
    return sharedInstance.connected;
}

- (id)init
{
    self = [super init];
    if (self) {
        _needsUpdate = false;
        _playingInfo = nil;
        started = false;
        currentPlayer = @"";
        lifes = 0;
        // Custom initialization
        [self stop];	
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(applicationDidBecomeActive:)
                       name:UIApplicationDidBecomeActiveNotification
                     object:nil];
        [center addObserver:self
                   selector:@selector(applicationWillResignActive:)
                       name:UIApplicationWillResignActiveNotification
                     object:nil];
        [[XBMCTCP sharedInstance] setDelegate:self];
    }
    return self;
}

- (void)dealloc 
{
    [self stop];
    TT_RELEASE_SAFELY(_playingInfo);
    TT_RELEASE_SAFELY(currentPlayer);
    videoPlayerAvailable = false;
    audioPlayerAvailable = false;
    picturePlayerAvailable = false;
    [super dealloc];
}

-(NSDictionary*) playingInfo
{
    if (_playingInfo)
    {
//        NSError *error = nil;
//        NSData *serializedData = [_playingInfo dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dictionary = [_playingInfo objectFromJSONData];
        return dictionary;
    }
    else
    {
        return [NSDictionary dictionary];
    }
}

- (void)gotIntrospect:(id)result
{
    NSLog(@"result: %@", result);
}

- (void)connect 
{
    connected = true;
    NSLog(@"Connected!");
    lifes = 2;
    NSDictionary *dict = [ NSDictionary
                          dictionaryWithObject:[[NSUserDefaults standardUserDefaults] 
                                                valueForKey:@"currenthost"] forKey:@"server" ];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectedToXBMC" 
                                                        object:nil userInfo:dict];
//    NSDictionary *request = [[[NSDictionary alloc] initWithObjectsAndKeys:
//                              @"JSONRPC.Introspect", @"cmd", [NSArray array], @"params"
//                              ,nil] autorelease];
//    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotIntrospect:)];    

    playing = false;
    paused = false;
    currentPlayer  =@"";
    
//    if (connectionTimer != nil)
//    {
//        [connectionTimer invalidate];
//        connectionTimer = nil;
//    }
}

- (void)disconnect 
{
    connected = false;
	TT_RELEASE_SAFELY(_playingInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisconnectedFromXBMC" object:nil];
    [[XBMCTCP sharedInstance] disconnect];
}


- (void)XBMCTCPConnected
{
    [self connect];
}

- (void)XBMCTCPDisconnected
{
    [self disconnect];
}

- (void)XBMCTCPReceivedData:(NSDictionary*)data
{
    NSLog(@"got data through TCP: %@", data);
    
    if ([data objectForKey:@"method"])
    {
        if ([[data objectForKey:@"method"] isEqualToString:@"Player.PlaybackResumed"])
        {
            paused = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playingUnpaused" 
                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         currentPlayer, @"player",nil]];
        }
        else if ([[data objectForKey:@"method"] isEqualToString:@"Player.PlaybackPaused"])
        {
            paused = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playingPaused" 
                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         currentPlayer, @"player",nil]];
        }
    }
}


- (void)start
{
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                       target: self
                                                     selector: @selector(checkStateTimerFunc:)
                                                     userInfo: nil repeats:TRUE];
    started = true;
}

- (void)stop
{
    started = false;
	if (connectionTimer != nil)
    {
        [connectionTimer invalidate];
        connectionTimer = nil;
    }
    if (connected)
    {
        [self disconnect];
    }
    playing = false;
    paused = false;
    currentPlayer = @"";
    //	
}


- (void) checkStateTimerFunc: (NSTimer *) theTimer
{
    //NSLog(@"checkStateTimerFunc connected %d", connected);
    [self checkPlayersAvailibility];
}

-(void) checkPlayersAvailibility
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Player.GetActivePlayers", @"cmd", [NSArray array], @"params"
                              ,nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(onPlayerAvailibilityResponse:)];    
}

- (void)gotNowPlayingInfo:(id)result
{
//    NSLog(@"gotNowPlayingInfo: %@", result);
    bool playingstatus = playing;
    bool pausedstatus = paused;
    if ([[result objectForKey:@"failure"] boolValue])
    {
        playing = false;
        paused = false;
        if (playingstatus || pausedstatus)
        {
            NSLog(@"playing stopped");
            TT_RELEASE_SAFELY(_playingInfo);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playingStopped" object:nil];
            return;
        }
    }
    else
    {
        playing = [[[[result objectForKey:@"result"] objectForKey:@"state"] objectForKey:@"playing"] boolValue];
        paused = [[[[result objectForKey:@"result"] objectForKey:@"state"] objectForKey:@"paused"] boolValue];
    }
   
    if ((playingstatus != playing || _needsUpdate) && playing)
    {
        NSLog(@"%@ playing",currentPlayer);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playingStarted" 
                                                            object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     currentPlayer, @"player",nil]];
    }

    if (pausedstatus != paused)
    {
        if (paused)
        {
            NSLog(@"%@ paused",currentPlayer);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playingPaused" 
                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         currentPlayer, @"player",nil]];
        }
        else
        {
            NSLog(@"%@ playing",currentPlayer);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playingUnpaused" 
                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        currentPlayer, @"player",nil]];
        }
    }
        
    NSInteger current = [[[[result objectForKey:@"result"] 
                           objectForKey:@"state"] 
                          objectForKey:@"current"] 
                         integerValue];
    NSDictionary* item = [[[result objectForKey:@"result"] 
                           objectForKey:@"items"] 
                          objectAtIndex:current];
    if (item)
    {
        NSData * info = [item JSONData];

        if (playing && info != nil 
            && (_playingInfo == nil || ![_playingInfo isEqualToData:info]))
        {
            TT_RELEASE_SAFELY(_playingInfo);
            _playingInfo = [info retain];
            [[NSNotificationCenter defaultCenter] 
             postNotificationName:@"nowPlayingInfo" object:nil userInfo:item];
        }
    }    
    _needsUpdate = false;
}

- (void)onPlayerAvailibilityResponse:(id)result
{
    @synchronized(self)
    {
        bool connectedstatus = connected;
        if ([[result objectForKey:@"failure"] boolValue])
        {     
//            NSLog(@"Error: %@", result);
            videoPlayerAvailable = false;
            audioPlayerAvailable = false;
            picturePlayerAvailable = false;
            playing = false;
            paused = false;
            
            if (connectedstatus)
            {
                if (lifes == 0)
                {
                    [self disconnect];
                }
                else
                {
                    lifes -= 1;
                }
            }
        }
        else
        {
           if (!connectedstatus)
            {
//                [self connect];
                [[XBMCTCP sharedInstance] connect];
            }
            bool videoplayerstatus = videoPlayerAvailable;
            bool audioplayerstatus = audioPlayerAvailable;
            videoPlayerAvailable = [[[result objectForKey:@"result"] objectForKey:@"video"] boolValue];
            audioPlayerAvailable = [[[result objectForKey:@"result"] objectForKey:@"audio"] boolValue];
            picturePlayerAvailable = [[[result objectForKey:@"result"] objectForKey:@"picture"] boolValue];
            
            if (((videoplayerstatus != videoPlayerAvailable)
                && !videoPlayerAvailable) ||
                ((audioplayerstatus != audioPlayerAvailable)
                 && !audioPlayerAvailable)
                 && playing)
            {
                playing = false;
                NSLog(@"stopping playing");
                TT_RELEASE_SAFELY(_playingInfo);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playingStopped" object:nil];
                return;
            }
            else if (picturePlayerAvailable)
            {
                
            }
            
            NSString* command;
//            NSString* player;
            if (videoPlayerAvailable)
            {
                command = @"VideoPlaylist.GetItems";
                currentPlayer = @"video";
            }
            else if (audioPlayerAvailable)
            {
                command = @"AudioPlaylist.GetItems";
                currentPlayer = @"audio";
            }
            else
            {
                currentPlayer = @"";
                return;
            }
            NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSArray arrayWithObjects:@"genre", @"year", @"runtime", @"rating"
                                             , @"tagline", @"plot", @"imdbnumber", @"season", @"episode", @"firstaired"
                                             , @"showtitle", @"director", @"writer", @"title", @"thumbnail", @"fanart", nil]
                                            , @"fields", nil];
            
            NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [[command copy] autorelease], @"cmd", 
                                      requestParams, @"params",
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       currentPlayer, @"player",nil], @"info",nil];
            [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotNowPlayingInfo:)];
        }
    }
    
}

+ (void)play:(NSString *) url
{
    NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                    url
                                    , @"file", nil];
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"XBMC.Play", @"cmd", 
                              requestParams, @"params",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request];

}

- (void)applicationDidBecomeActive: (NSNotification *) notification 
{
    if (started && connectionTimer == nil)
    {
		TT_RELEASE_SAFELY(_playingInfo);
        connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                       target: self
                                                     selector: @selector(checkStateTimerFunc:)
                                                     userInfo: nil repeats:TRUE];
        [[XBMCTCP sharedInstance] connect];
    }

}

- (void)applicationWillResignActive: (NSNotification *) notification 
{
    if (connectionTimer != nil)
    {
        [connectionTimer invalidate];
        connectionTimer = nil;
    }
    TT_RELEASE_SAFELY(_playingInfo);
    _needsUpdate = true;
    [[XBMCTCP sharedInstance] disconnect];
}

//- (IBAction)sendTest:(id)sender
//{
//    //send data
//    NSString* test = @"{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.GetMovies\", \"params\": { \"start\": 0, \"end\": 100, \"sortorder\":\"ascending\", \"fields\": [\"genre\",\"year\"] }, \"id\": 1}";
//    const uint8_t *rawString=(const uint8_t *)[test UTF8String];
//    int len;
//    
//    //[outputStream open];
//    len = [oStream write:rawString maxLength:[test length]];
//    if (len > 0)
//    {
//        NSLog(@"Command send");
//    }
//}


- (void)gotNowPlayingTime:(id)result
{
    if (![[result objectForKey:@"failure"] boolValue])
    {
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"nowPlayingTime" object:nil userInfo:result];
    }
}

-(void)askForTime
{
    NSString* command;
//    NSString* player;
    if (videoPlayerAvailable)
    {
        command = @"VideoPlayer.GetTime";
//        player = @"video";
    }
    else if (audioPlayerAvailable)
    {
        command = @"AudioPlayer.GetTime";
//        player = @"audio";
    }
    else
    {
        return;
    }
    
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                              command, @"cmd", [NSArray array], @"params"
                              ,nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotNowPlayingTime:)];  
}
@end

//
//  XBMCStateListener.m
//  iHaveNoName
//
//  Created by Martin Guillon on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCStateListener.h"

#import "XBMCJSONCommunicator.h"


@implementation XBMCStateListener
@synthesize connected;
@synthesize connectionTimer;
@synthesize currentPlayers = _currentPlayers;

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
        started = false;
        self.currentPlayers = [NSMutableDictionary dictionary];
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
    [_currentPlayers removeAllObjects];
    TT_RELEASE_SAFELY(_currentPlayers);
    [super dealloc];
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
    [self.currentPlayers removeAllObjects];
    
//    if (connectionTimer != nil)
//    {
//        [connectionTimer invalidate];
//        connectionTimer = nil;
//    }
}

- (void)disconnect 
{
    connected = false;
    for (id playerid in self.currentPlayers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" object:nil  userInfo:[self.currentPlayers objectForKey:playerid]];
    }
    [self.currentPlayers removeAllObjects];
    
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
    
//    if ([data objectForKey:@"method"])
//    {
//        if ([[data objectForKey:@"method"] isEqualToString:@"Player.PlaybackResumed"])
//        {
//            paused = false;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"playerUnpaused" 
//                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                         self.currentPlayer, @"player",nil]];
//        }
//        else if ([[data objectForKey:@"method"] isEqualToString:@"Player.PlaybackPaused"])
//        {
//            paused = true;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"playerPaused" 
//                                                                object:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                         self.currentPlayer, @"player",nil]];
//        }
//    }
}

- (void)printResult:(id)result
{
	NSLog(@"printResult: %@", result);
}

- (void)start
{
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                       target: self
                                                     selector: @selector(checkStateTimerFunc:)
                                                     userInfo: nil repeats:TRUE];
    started = true;
	
//	NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
//							 @"JSONRPC.Introspect", @"cmd"
//							 , [NSDictionary dictionaryWithObjectsAndKeys:
//															   [NSDictionary dictionaryWithObjectsAndKeys:
//																	@"VideoPlaylist", @"id", 
//																	@"namespace", @"type", nil]
//															 , @"filter", nil], @"params"
//							 ,nil];
//    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(printResult:)];    

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
    for (id playerid in self.currentPlayers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" object:nil  userInfo:[self.currentPlayers objectForKey:playerid]];
    }
    [self.currentPlayers removeAllObjects];
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

-(BOOL) playing
{
    if ([self.currentPlayers count] == 0) return NO;
    for (id playerid in self.currentPlayers)
    {
        if ([[[self.currentPlayers objectForKey:playerid] objectForKey:@"speed"] integerValue] != 0)
            return YES;
    }
    return NO;
}

-(BOOL) paused
{
    if ([self.currentPlayers count] == 0) return NO;
    for (id playerid in self.currentPlayers)
    {
        if ([[[self.currentPlayers objectForKey:playerid] objectForKey:@"speed"] integerValue] != 0)
            return NO;
    }
    return YES;
}


- (void)gotPlayerProperties:(id)result
{
    id playerid = [[result objectForKey:@"info"] objectForKey:@"playerid"];
//    NSLog(@"gotPlayerProperties :%@", result);
    if ([[result objectForKey:@"failure"] boolValue])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" 
                    object:nil  
                    userInfo:[self.currentPlayers objectForKey:playerid]];
        [self.currentPlayers removeObjectForKey:playerid];
        return;
    }
    else
    {
        NSInteger oldSpeed = [[[self.currentPlayers objectForKey:playerid] objectForKey:@"speed"] integerValue];
        NSInteger speed = [[[result objectForKey:@"result"] objectForKey:@"speed"] integerValue];
        [[self.currentPlayers objectForKey:playerid] 
         setObject:[[result objectForKey:@"result"] objectForKey:@"speed"] 
         forKey:@"speed"];
        
        if (speed != oldSpeed)
        {
            if (speed == 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playerPaused" 
                                                                    object:nil userInfo:[self.currentPlayers objectForKey:playerid]];
            }
            else if (oldSpeed == 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playerUnpaused" 
                                                                    object:nil userInfo:[self.currentPlayers objectForKey:playerid]];
            }
            else if (oldSpeed == -1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStarted" 
                                                                    object:nil userInfo:[self.currentPlayers objectForKey:playerid]];
            }
            [self askForPlayerInfo:playerid];
        }
        
        NSDictionary* oldtime = [NSDictionary dictionaryWithDictionary:[[self.currentPlayers objectForKey:playerid] objectForKey:@"time"]];
        [[self.currentPlayers objectForKey:playerid] 
         setObject:[[result objectForKey:@"result"] objectForKey:@"time"] 
         forKey:@"time"];
        [[self.currentPlayers objectForKey:playerid] 
         setObject:[[result objectForKey:@"result"] objectForKey:@"totaltime"] 
         forKey:@"totaltime"];
        
        if (![[[self.currentPlayers objectForKey:playerid] objectForKey:@"time"] isEqualToDictionary:oldtime])
        {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playerTime" 
                                                                    object:nil userInfo:[self.currentPlayers objectForKey:playerid]];            
        }
        
    }
}

- (void)gotplayerInfo:(id)result
{
//    NSLog(@"gotplayerInfo: %@", result);
    if ([[result objectForKey:@"failure"] boolValue])
    {
//        for (NSString* player in self.currentPlayers)
//        {
//            [self.playingInfo setObject:nil forKey:player];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" 
//                    object:nil  
//                    userInfo:[NSDictionary 
//                    dictionaryWithObjectsAndKeys:player, @"player",nil]];
//        }
//        self.currentPlayers = nil;
//        paused = false;
        return;
    }
    else
    {
        id playerid = [[result objectForKey:@"info"] objectForKey:@"playerid"];
        
        [[self.currentPlayers objectForKey:playerid] 
            setObject:[[result objectForKey:@"result"] objectForKey:@"item"] 
         forKey:@"info"];
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"playerInfo" object:nil 
         userInfo:[self.currentPlayers objectForKey:playerid]];

    }
 }

- (void)onPlayerAvailibilityResponse:(id)result
{
    @synchronized(self)
    {
        bool connectedstatus = connected;
        if ([[result objectForKey:@"failure"] boolValue])
        {
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
//			NSLog(@"player available: %@", result);
           if (!connectedstatus)
            {
//                [self connect];
                [[XBMCTCP sharedInstance] connect];
            }
            
            NSMutableArray* newPlayersIds = [NSMutableArray array];
            NSMutableDictionary* newPlayers = [NSMutableDictionary dictionary];
            
            if ([result objectForKey:@"result"] && [[result objectForKey:@"result"] isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *player in [result objectForKey:@"result"])
                {
                    [newPlayersIds addObject:[player objectForKey:@"playerid"]];
                    [newPlayers setObject:player forKey:[player objectForKey:@"playerid"]];
                }
            }
            NSSet *existingPlayersSet = [NSSet setWithArray:[self.currentPlayers allKeys]];
            NSSet *newPlayersSet = [NSSet setWithArray:newPlayersIds];
            
            // Determine which items were added
            NSMutableSet *addedPlayers = [NSMutableSet setWithSet:newPlayersSet];
            [addedPlayers minusSet:existingPlayersSet];
            
            // Determine which items were removed
            NSMutableSet *removedPlayers = [NSMutableSet setWithSet:existingPlayersSet];
            [removedPlayers minusSet:newPlayersSet];       
            
            NSEnumerator *enumerator = [removedPlayers objectEnumerator];            
            id anObject = [enumerator nextObject];
            while (anObject) 
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" object:nil  userInfo:[self.currentPlayers objectForKey:anObject]];
                [self.currentPlayers removeObjectForKey:anObject];
                anObject = [enumerator nextObject];
            }
            
            //we ask for nowplaying infos of new players!
            enumerator = [addedPlayers objectEnumerator];            
            anObject = [enumerator nextObject];
            while (anObject) 
            {
                [self.currentPlayers setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                [NSArray array], @"info"
                                                , [[newPlayers objectForKey:anObject] objectForKey:@"type"], @"type"
                                                , [NSNumber numberWithInt:-1], @"speed"
                                                , [NSDictionary dictionary], @"time"
                                                , [NSDictionary dictionary], @"totaltime"
                                                ,nil] forKey:anObject];
                anObject = [enumerator nextObject];
            }
            
            //we ask for states of all players
            NSString* command = @"Player.GetProperties";
            for (id playerid in self.currentPlayers)
            {
                NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSArray arrayWithObjects:@"speed", @"time", @"totaltime", nil]
                                               , @"properties"
                                               , playerid, @"playerid", nil];
                
                NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                         command, @"cmd", 
                                         requestParams, @"params",
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          playerid, @"playerid",nil], @"info",nil];
                [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotPlayerProperties:)];
            }
            
            
        }
    }
    
}

- (void)askForPlayerInfo:(NSNumber*)  playerId 
{
    if ([self.currentPlayers objectForKey:playerId])
    {
        NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSArray arrayWithObjects:@"genre", @"year", @"runtime", @"rating"
                                        , @"tagline", @"plot", @"imdbnumber", @"season", @"episode", @"firstaired"
                                        , @"showtitle", @"director", @"writer", @"title", @"thumbnail", @"fanart", nil]
                                       , @"properties"
                                       , playerId, @"playerid", nil];
        
        NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Player.GetItem", @"cmd", 
                                 requestParams, @"params",
                                 [NSDictionary dictionaryWithObjectsAndKeys:
                                  playerId, @"playerid",nil], @"info",nil];
        [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request target:self selector:@selector(gotplayerInfo:)];
    }
}


- (void)applicationDidBecomeActive: (NSNotification *) notification 
{
    if (started && connectionTimer == nil)
    {
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
//    [self.currentPlayers removeAllObjects];
    for (id playerid in self.currentPlayers)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playerStopped" object:nil  userInfo:[self.currentPlayers objectForKey:playerid]];
    }
    [self.currentPlayers removeAllObjects];
    [[XBMCTCP sharedInstance] disconnect];
}

//- (IBAction)sendTest:(id)sender
//{
//    //send data
//    NSString* test = @"{\"jsonrpc\": \"2.0\", \"method\": \"VideoLibrary.GetMovies\", \"params\": { \"start\": 0, \"end\": 100, \"sortorder\":\"ascending\", \"properties\": [\"genre\",\"year\"] }, \"id\": 1}";
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

@end

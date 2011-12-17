//
//  XBMCStateListener.h
//  iHaveNoName
//
//  Created by Martin Guillon on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XBMCTCP.h"


@interface XBMCStateListener : NSObject<XBMCTCPDelegate> {
    BOOL started;
    
    NSMutableDictionary* _currentPlayers;
    BOOL connected;
    int lifes;
        

    NSTimer * connectionTimer;
}
+ (XBMCStateListener *) sharedInstance;
+ (bool)connected;

@property (nonatomic, retain) NSTimer * connectionTimer;
@property (nonatomic, retain) NSMutableDictionary * currentPlayers;

@property (nonatomic, readonly) BOOL connected;

- (void) checkStateTimerFunc: (NSTimer *) theTimer;
-(void) checkPlayersAvailibility;

- (void)askForPlayerInfo:(NSNumber*)  playerId ;

- (void) onPlayerAvailibilityResponse:(id)result;

- (void)start;
- (void)stop;
-(BOOL)playing;
-(BOOL) paused;

- (void)applicationDidBecomeActive: (NSNotification *) notification; 
- (void)applicationWillResignActive: (NSNotification *) notification; 

@end


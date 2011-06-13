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
    
    NSString* currentPlayer;
    BOOL playing;
    BOOL paused;
    BOOL videoPlayerAvailable;
    BOOL audioPlayerAvailable;
    BOOL picturePlayerAvailable;
    BOOL connected;
    int lifes;
    
    BOOL _needsUpdate;
    
    NSString* _playingInfo;

    NSTimer * connectionTimer;
}
+ (XBMCStateListener *) sharedInstance;
+ (bool)connected;

@property (nonatomic, retain) NSTimer * connectionTimer;
@property (nonatomic, retain) NSDictionary * playingInfo;

@property (nonatomic, readonly) BOOL connected;
@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, readonly) BOOL paused;

- (void) checkStateTimerFunc: (NSTimer *) theTimer;
//-(void) checkState; 
-(void) checkPlayersAvailibility;

- (void) onPlayerAvailibilityResponse:(id)result;
//- (void) onPlayerStateResponse:(id)result;

- (void)start;
- (void)stop;

+ (void)play:(NSString *) url;

-(void)askForTime;


- (void)applicationDidBecomeActive: (NSNotification *) notification; 
- (void)applicationWillResignActive: (NSNotification *) notification; 

@end


//
//  XBMCCommand.m
//  iXBMC
//
//  Created by Martin Guillon on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCCommand.h"
#import "XBMCHttpInterface.h"

static XBMCCommand *sharedInstance = nil;


@implementation XBMCCommand

+ (XBMCCommand *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

-(id)init{
    self = [super init];
    _commandList = [[NSDictionary alloc] initWithObjectsAndKeys:
                    @"play", @"play"
                    ,@"playpause", @"pause"
                    ,@"stop", @"stop"
                    ,@"PlayNext", @"next"
                    ,@"PlayPrev", @"previous"
                    ,@"SendKey(272)", @"left"
                    ,@"SendKey(273)", @"right"
                    ,@"SendKey(270)", @"up"
                    ,@"SendKey(271)", @"down"
                    ,@"SendKey(256)", @"select"
                    ,@"SendKey(61513)", @"info"
                    ,@"SendKey(261)", @"menu"
                    ,@"SendKey(274)", @"osd"
                    ,@"Action(25)", @"subtitles"
                    ,@"SendKey(10004)", @"settings"
                    ,@"SendKey(0xF008)", @"back"
                    ,@"SendKey(275)", @"esc"
                    ,@"Exit()", @"exit"
                    ,@"SendKey(0xF053)", @"shutdownmenu"
                    ,@"Action(18)", @"showgui"
                    ,nil];
	
	return self;	
}

- (void)dealloc;
{
    TT_RELEASE_SAFELY(_commandList);
	[super dealloc];
}

+(void)send:(NSString*)cmd
{
    [[XBMCCommand sharedInstance] internalSend:cmd];
}

-(void)internalSend:(NSString*)cmd
{
    if ([_commandList objectForKey:cmd])
    {
        [[XBMCHttpInterface sharedInstance] sendCommand:[_commandList objectForKey:cmd]];
    }
}


@end

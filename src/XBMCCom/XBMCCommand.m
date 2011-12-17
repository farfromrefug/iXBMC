//
//  XBMCCommand.m
//  iXBMC
//
//  Created by Martin Guillon on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCCommand.h"
#import "XBMCHttpInterface.h"
#import "XBMCJSONCommunicator.h"

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

+ (NSArray*)getEnqueueCmd:(id)items
{
	NSString* itemType;
	NSString* itemid;
	NSString* command = @"VideoPlaylist.Add";
	
	NSMutableArray* cmds = [NSMutableArray array];
	
	if ([items isKindOfClass:[NSString class]])
	{
		itemType = @"file";
		itemid = items;
		
		NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
									   [NSDictionary dictionaryWithObjectsAndKeys:
										itemid, itemType, nil]
									   , @"item", nil];
		
		[cmds addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 command, @"cmd", 
						 requestParams, @"params",nil] ];
	}
	else if ([items isKindOfClass:[NSDictionary class]])
	{
		if ([[items valueForKey:@"type"] isEqualToString:@"movie"])
		{
			itemType = @"movieid";
		}
		else if ([[items valueForKey:@"type"] isEqualToString:@"episode"])
		{
			itemType = @"episodeid";
		}
		else if ([[items valueForKey:@"type"] isEqualToString:@"file"])
		{
			itemType = @"file";
		}
		else return cmds;
		
		NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
									   [NSDictionary dictionaryWithObjectsAndKeys:
										[items valueForKey:@"id"]
										, itemType, nil]
									   , @"item", nil];
		
		[cmds addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 command, @"cmd", 
						 requestParams, @"params",nil] ];
	}
	else if ([items isKindOfClass:[NSArray class]])
	{
		
		for (NSDictionary* it in items)
		{			
			if ([[it valueForKey:@"type"] isEqualToString:@"movie"])
			{
				itemType = @"movieid";
			}
			else if ([[it valueForKey:@"type"] isEqualToString:@"episode"])
			{
				itemType = @"episodeid";
				NSLog(@"got an episode");
			}
			else if ([[it valueForKey:@"type"] isEqualToString:@"file"])
			{
				itemType = @"file";
			}
			else continue;
			
			NSDictionary *requestParams = [NSDictionary dictionaryWithObjectsAndKeys:
										   [NSDictionary dictionaryWithObjectsAndKeys:
											[it valueForKey:@"id"]
											, itemType, nil]
										   , @"item", nil];
			
			[cmds addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 command, @"cmd", 
							 requestParams, @"params",nil] ];
		}	
	}
	return cmds;
}


+ (void)enqueue:(id)items
{
	NSArray* cmds = [XBMCCommand getEnqueueCmd:items];
	if ([cmds count] > 0)
	{
		[[XBMCJSONCommunicator sharedInstance] addJSONRequest:[NSDictionary dictionaryWithObjectsAndKeys:cmds, @"cmds", nil]];
	}
}

+ (void)setVideoPlaylistAndPlay:(id) items
{
	NSArray* itemsToAdd = [XBMCCommand getEnqueueCmd:items];
	if ([itemsToAdd count] > 0)
	{
		NSMutableArray* cmds = [NSMutableArray array];
		
		[cmds addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 @"VideoPlaylist.Clear", @"cmd", 
						 [NSArray array], @"params",nil] ];
		
		[cmds addObjectsFromArray:itemsToAdd];
		
		[cmds addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 @"VideoPlaylist.Play", @"cmd", 
						 [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt:0]
						  , @"item", nil], @"params",nil] ];
				
		[[XBMCJSONCommunicator sharedInstance] addJSONRequest:[NSDictionary dictionaryWithObjectsAndKeys:cmds, @"cmds", nil]];
	}
	
}

+ (void)clearVideoPlaylist
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
							 @"VideoPlaylist.Clear", @"cmd", 
							 [NSArray array], @"params",nil];
    [[XBMCJSONCommunicator sharedInstance] addJSONRequest:request];
	
}

@end

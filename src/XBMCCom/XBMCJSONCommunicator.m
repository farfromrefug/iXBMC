//
//  XBMCCommunicator.m
//  TheElements
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCJSONCommunicator.h"
#import "JsonRpcClient.h"
#import <Three20/Three20.h>



@implementation XBMCJSONCommunicator
@synthesize json;
@synthesize fulladdress = _fulladdress;
static XBMCJSONCommunicator *sharedInstance = nil;

#pragma mark -
#pragma mark Initialisation


+ (XBMCJSONCommunicator *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

- (void) setAddress:(NSString*)address port:(NSString*)port login:(NSString*)log password:(NSString*)pwd
{
    NSLog(@"fulladdress before: %@", _fulladdress);
    NSString* newfulladdress = [NSString stringWithFormat:@"%@:%@@%@:%@",log,pwd,address,port];
    if (_fulladdress != nil && [newfulladdress compare:_fulladdress] == NSOrderedSame) return;
    //    fulladdress = @"test";
    self.fulladdress = newfulladdress;
    if (json == nil)
    {
        json = [[JsonRpcClient alloc] initWithUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/jsonrpc",_fulladdress]]  delegate:self];
        [json setRequestId:@"1"];
    }
    else
    {
        [json setUrl:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/jsonrpc",_fulladdress]]];
    }
    NSLog(@"fulladdress: %@", _fulladdress);
    //[newfulladdress release];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.fulladdress = @"";
        json = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc;
{
    TT_RELEASE_SAFELY(_fulladdress);
    TT_RELEASE_SAFELY(json);
	[super dealloc];
}


-(void)addJSONRequest:(NSDictionary*)rq target:(NSObject*)object selector:(SEL)sel 
{
    if (self.fulladdress != nil)
    {
		if ([rq objectForKey:@"cmds"])
		{
			[json requestWithArray:[rq objectForKey:@"cmds"] 
							   info:[rq objectForKey:@"info"]
							 target:object selector:sel];
		}
		else if ([rq objectForKey:@"cmd"] && [rq objectForKey:@"params"])
		{
			[json requestWithMethod:[rq objectForKey:@"cmd"] 
                         params:[rq objectForKey:@"params"]
                         info:[rq objectForKey:@"info"]
                        target:object selector:sel];
		}
    }
    
}

-(void)addJSONRequest:(NSDictionary*)rq 
{
    [self addJSONRequest:rq target:nil selector:nil];
}

- (void)jsonRpcClient:(JsonRpcClient *)client didReceiveResult:(id)result tag:(NSDictionary *)tag
{
    
    NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:[result objectForKey:@"error"] != nil], @"failure", 
//                                [result objectForKey:@"error"], @"error", 
                                [tag objectForKey:@"id"], @"request", 
                                [result objectForKey:@"result"], @"result",
                                [tag objectForKey:@"info"], @"info",nil];
    id <NSObject> obj = [tag objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[tag objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelector:aSel withObject:resultDict];
    }
}

- (void)jsonRpcClient:(JsonRpcClient *)client didFailWithErrorCode:(NSNumber *)code message:(NSDictionary *)message tag:(NSDictionary *)tag
{
    NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:TRUE], @"failure"
                                , message, @"info",nil];
    id <NSObject> obj = [tag objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[tag objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelector:aSel withObject:resultDict];
    }
}


@end

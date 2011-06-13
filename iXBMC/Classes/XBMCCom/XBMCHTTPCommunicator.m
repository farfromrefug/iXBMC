//
//  XBMCCommunicator.m
//  TheElements
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "XBMCHTTPCommunicator.h"


@implementation XBMCHTTPCommunicator
@synthesize requestQueue;
@synthesize fulladdress;
static XBMCHTTPCommunicator *sharedInstance = nil;

#pragma mark -
#pragma mark Initialisation


+ (XBMCHTTPCommunicator *) sharedInstance {
	return ( sharedInstance ? sharedInstance : ( sharedInstance = [[self alloc] init] ) );
}

- (void) setAddress:(NSString*)address port:(NSString*)port login:(NSString*)log password:(NSString*)pwd
{
//    fulladdress = @"test";
    fulladdress = [NSString stringWithFormat:@"http://%@:%@@%@:%@/xbmcCmds/xbmcHttp?command=",log,pwd,address,port];
    NSLog(@"fulladdress: %@", fulladdress);
}

- (id) init
{
    self = [super init];
    if (self)
    {
        currentRequest = nil;
        requestQueue = [[NSMutableArray arrayWithCapacity:0] retain];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc;
{
	[super dealloc];
    [requestQueue removeAllObjects];
    [fulladdress release];
    [currentRequest release];

}

-(void)processNextHTTPRequest
{
    if (currentRequest == nil && [requestQueue count] > 0)
    {
        currentRequest = [requestQueue lastObject];
        [requestQueue removeLastObject];

        
        NSLog(@"fulladdress: %@", fulladdress);
        NSLog(@"cmd: %@", [[currentRequest objectForKey:@"request"] objectForKey:@"cmd"]);
        NSURL* test = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", fulladdress,[[currentRequest objectForKey:@"request"] objectForKey:@"cmd"]]];
        

        NSLog(@"url: %@", test);
        NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest: [NSURLRequest 
                                                                                  requestWithURL: test 
                                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                                  timeoutInterval:1.0] delegate: self];
        
        if (theConnection) 
        {
            // Create the NSMutableData to hold the received data.
            // receivedData is an instance variable declared elsewhere.
            receivedData = [[NSMutableData data] retain];
        } else 
        {
            // Inform the user that the connection failed.
        }
        [theConnection release];
    }
}

#pragma mark -
#pragma mark Parsing

-(BOOL)isNumeric:(NSString*)str
{
    int anInteger;
    NSScanner *aScanner = [NSScanner scannerWithString:str];
    return [aScanner scanInt:&anInteger];
}

-(int)getNumericResponse: (NSString*) resp
{
    NSLog(@"getNumericResponse");
    int returnVal;
    NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
    if([self getLines: resp lines: theLines] > 0)
    {
        NSString *identifier = [theLines objectAtIndex:0];
        if ([self isNumeric: identifier])
        {
            NSLog(@"getNumericResponse: identifier = %@", identifier);
            returnVal = [identifier intValue];
        }
        else{
            returnVal = -2;
        }
    }
    else
    {
        returnVal = -2;
    }
    [theLines release];
    NSLog(@"getNumericResponse: returning = %d", returnVal);
    return returnVal;
}

-(NSString*)getStringResponse: (NSString*)resp
{
    NSString *theString;
	NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
    if([self getLines: resp lines: theLines] > 0)
    {
        theString = [theLines objectAtIndex:0];
	}
	else
	{
        theString = @"";
	}
	[theLines release];
	return theString;
}

-(int)getLines: (NSString*) text lines: (NSMutableArray*)theLines
{
    // Note: uncomment this to see the text
    //NSLog(@"getLines:  %@", text);
    int p, p1;
    NSString* tmp;
    p = (int)[text rangeOfString:@"<li>"].location;
    while((p!=NSNotFound))
    {
        NSString *s = [NSString stringWithFormat:@"%C", 0xa];
        p1 = (int)[text rangeOfString:s options:NSLiteralSearch range: NSMakeRange(p, [text length] - p)].location;
        if (p1 == NSNotFound)
        {
            p1 = [text length];
        }
        tmp = [text substringWithRange:NSMakeRange(p+4,p1-p-4)];
        if ([[tmp substringWithRange:NSMakeRange([tmp length]-1,1)] compare: @">"] == NSOrderedSame)
        {
            p = [tmp rangeOfString:@"<" options:NSBackwardsSearch ].location;
            if (p != NSNotFound)
            {
                tmp = [tmp substringWithRange:NSMakeRange(0, p)];
            }
        }
        //NSLog(@"found a line: %@", tmp);
        [theLines addObject: tmp];
        p = (int)[text rangeOfString:@"<li>" options:NSCaseInsensitiveSearch range: NSMakeRange(p1, [text length] - p1)].location;
    }
    NSLog(@"getLines:  done");
    return ([theLines count] > 0);
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [receivedData setLength:0];
}
    
    
// NSURLConnection delegates
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)newData {
    [receivedData appendData: newData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 

{
    [self XBMCHTTPCommunicator:self didFailWithErrorCode:[NSNumber numberWithInt:[error code]] message:[error localizedDescription]];
    [connection release];
}
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
//    CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	
	NSError *error = nil;
    
    // convert tostring
    NSString* page = [[[NSString alloc] initWithData: receivedData encoding:[NSString defaultCStringEncoding]] autorelease];
    if ([page rangeOfString:@"xbmcHttp is not defined"].location != NSNotFound)
    {
        page = @"Err: xbmcHTTP not found";
    }
	
	// Handle parse error
	if(error) {
		[self XBMCHTTPCommunicator:self didFailWithErrorCode:[NSNumber numberWithInt:[error code]] message:@"Unable to parse server response" data: receivedData];
	}	
	// Handle error from server
//	else if([dictionary objectForKey:@"error"]) {
//		NSDictionary *serverError = [dictionary objectForKey:@"error"];
//		[self XBMCHTTPCommunicator:self didFailWithErrorCode:[serverError objectForKey:@"code"] message:[serverError objectForKey:@"message"] data: receivedData];
//		return;
//	}
	else
    {    
        // Handle success
        [self XBMCHTTPCommunicator:self didReceiveResult:page];
    }
    // release the connection, and the data object
    [connection release];
    [receivedData release];
}
    
    
-(void)addHTTPRequest:(NSObject*)object selector:(SEL)sel request:(NSDictionary*)rq
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             rq, @"request", [NSValue valueWithPointer:sel], @"selector"
                             , object, @"object",nil];
    [requestQueue insertObject:request atIndex:0];
    [self processNextHTTPRequest];  
    
}

- (void)XBMCHTTPCommunicator:(XBMCHTTPCommunicator *)client didReceiveResult:(id)result 
{
    

    NSDictionary *resultDict = nil;
    
    if ([[[currentRequest objectForKey:@"request"] objectForKey:@"cmd"] caseInsensitiveCompare:@"GetCurrentlyPlaying"] == NSOrderedSame)
    {
        int i;
        NSMutableDictionary *itemInfo = [NSMutableDictionary alloc];
        NSMutableArray *theLines = [[NSMutableArray alloc] initWithCapacity:10];
        NSMutableArray *paramArray = [[NSMutableArray alloc] initWithCapacity:1];
        [paramArray addObject:@"q:\\web\\thumb.jpg"];
        [self getLines: result lines: theLines];
        [paramArray release];
        for (i=0; i<[theLines count]; ++i)
        {
            int p = (int)[[theLines objectAtIndex:i] rangeOfString:@":"].location;
            if (p!=NSNotFound)
            {
                [itemInfo setValue:[[theLines objectAtIndex:i] substringFromIndex:p+1] forKey:[[theLines objectAtIndex:i] substringToIndex:p]];
            }
        }
        if ([[itemInfo valueForKey:@"Filename"] caseInsensitiveCompare: @"[Nothing Playing]"] == NSOrderedSame)
        {
            [itemInfo setValue:[NSNumber numberWithBool:FALSE] forKey:@"playing"];
        }
        else
        {
            [itemInfo setValue:[NSNumber numberWithBool:TRUE] forKey:@"playing"];
        }
        [itemInfo autorelease];
        [theLines release];
        resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:FALSE], @"failure"
                       , [currentRequest objectForKey:@"request"], @"request"
                       , itemInfo, @"result",nil]; 
    }
    
      
    
    id <NSObject> obj = [currentRequest objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[currentRequest objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelector:aSel withObject:resultDict];
    }
    
    [result release];
    
    [currentRequest release];
    currentRequest = nil;
    if ([requestQueue count] != 0)
    {
        [self processNextHTTPRequest];
    }
}

- (void)XBMCHTTPCommunicator:(XBMCHTTPCommunicator *)client didFailWithErrorCode:(NSNumber *)code message:(NSString *)message
{
    NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithBool:TRUE], @"failure"
                                , [currentRequest objectForKey:@"request"], @"request"
                                , code, @"code", message, @"message",nil];
    
    id <NSObject> obj = [currentRequest objectForKey:@"object"];
    if (obj) {
        SEL aSel = [[currentRequest objectForKey:@"selector"] pointerValue];
        if ([obj respondsToSelector:aSel])
            [obj performSelector:aSel withObject:resultDict];
    }
    
    
    [currentRequest release];
    currentRequest = nil;
    if ([requestQueue count] != 0)
    {
        [self processNextHTTPRequest];
    }
}

// Fail delegate with data (for debugging purpose)
- (void)XBMCHTTPCommunicator:(XBMCHTTPCommunicator *)client didFailWithErrorCode:(NSNumber *)code message:(NSString *)message data:(NSData *)responseData 
{
//	NSLog("Error Data %@", responseData);
	
	// Call also the delegate without data
	[self XBMCHTTPCommunicator:self didFailWithErrorCode:code message:message];
}


-(void)getCurrentPlaying:(NSObject*)object selector:(SEL)sel
{
    NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"GetCurrentlyPlaying", @"cmd", [NSArray array], @"params"
                             ,nil];
    [self addHTTPRequest:object selector:sel request:request]; 
}

-(void)sendCommand:(NSObject*)object selector:(SEL)sel command:(NSString*)cmd;
{
	NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                             cmd, @"cmd", [NSArray array], @"params"
                             ,nil];
    [self addHTTPRequest:object selector:sel request:request];
}

-(void)sendCommand:(NSString*)cmd;
{
    [self sendCommand:nil selector:nil command:cmd];
}


@end

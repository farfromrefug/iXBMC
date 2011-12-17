//
//  JsonRpcClient.m
//
//  Created by mstegmann on 28.07.09.
//

#import "JsonRpcClient.h"
#import "JSONKit.h"

@implementation CustomURLConnection

@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSDictionary*)tg {
    self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
    
    if (self) {
        self.tag = [tg retain];
    }
    return self;
}

- (void)dealloc {
    [tag release];
    [super dealloc];
}

@end

@implementation JsonRpcClient

@synthesize requestId;
@synthesize url;
@synthesize delegate;

- (NSMutableData*)dataForConnection:(CustomURLConnection*)connection {
   NSMutableData *data = [receivedData objectForKey:[connection.tag objectForKey:@"id"]];
    return data;
}

- (void)connection:(CustomURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSMutableData *dataForConnection = [self dataForConnection:connection];
    [dataForConnection setLength:0];
}

- (void)connection:(CustomURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableData *dataForConnection = [self dataForConnection:connection];
    [dataForConnection appendData:data];
}

- (void)connection:(CustomURLConnection *)connection didFailWithError:(NSError *)error {    
//    NSMutableData *dataForConnection = [self dataForConnection:(CustomURLConnection*)connection];
	NSDictionary *tag = [[[NSDictionary alloc] initWithDictionary:connection.tag] autorelease];
	NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Unable to parse server response", @"message", nil];
	[self jsonRpcClient:self 
   didFailWithErrorCode:[NSNumber numberWithInt:0] 
                message:message
                    tag:tag];
    //NSMutableData *dataForConnection = [self dataForConnection:connection];
    [receivedData removeObjectForKey:[connection.tag objectForKey:@"id"]];
    [connection release];
}

- (void)connectionDidFinishLoading:(CustomURLConnection *)connection {
    NSMutableData *dataForConnection = [self dataForConnection:(CustomURLConnection*)connection];
    //[connection release];
    	
//    NSDate *start = [  NSDate date];
    // do stuff...
	NSError *error = nil;
    NSArray *results = [dataForConnection objectFromJSONDataWithParseOptions:JKSerializeOptionNone error:&error];
//    NSTimeInterval timeInterval = [start timeIntervalSinceNow];
// 	NSLog(@"json time %f",timeInterval);
    [receivedData removeObjectForKey:[connection.tag objectForKey:@"id"]];
	NSDictionary *tag = [NSDictionary dictionaryWithDictionary:connection.tag];
    
    [connection release];
	// Handle parse error
	if(error) {
		[self jsonRpcClient:self 
       didFailWithErrorCode:[NSNumber numberWithInt:[error code]] 
                    message:[NSDictionary dictionaryWithObjectsAndKeys:
                             @"Unable to parse server response", @"message", nil]
                        tag:tag];
		return;
	}
    if ([results isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *response in results)
        {
            [self jsonRpcClient:self 
               didReceiveResult:response tag:tag];
        }
    }
     else
     {
         [self jsonRpcClient:self 
            didReceiveResult:results tag:tag];
     }
}



- (id)init {
	self = [super init];
	protocol = @"2.0";
	requestId = @"0";
    receivedData = [[NSMutableDictionary alloc] init];
	return self;
}

- (id)initWithUrl:(NSURL *)newUrl delegate:(id)newDelegate {
	self = [self init];
	self.url = newUrl;
	self.delegate = newDelegate;
	
	return self;
}

- (void)requestWithUrl:(NSURL*)Rqurl data:(NSData *)requestData tag:(NSDictionary*)tag {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:Rqurl];
	[request setValue:[[NSNumber numberWithInt:[requestData length]] stringValue] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody: requestData];
	
    CustomURLConnection *connection = [[CustomURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES tag:tag];  
    if (connection) {
        [receivedData setObject:[NSMutableData data] forKey:[connection.tag objectForKey:@"id"]];
    }else {
        NSLog(@"Connection Failed!");
    }
}

- (void)requestWithArray:(NSArray *)methods 
					 info:(NSDictionary *)info 
                   target:(NSObject*)object 
                 selector:(SEL)sel
{
	NSMutableArray* jsonrequest = [NSMutableArray array];
	for (NSDictionary* method in methods)
	{
		[jsonrequest addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							   protocol, @"jsonrpc",
							   [method objectForKey:@"cmd"], @"method",
							   [method objectForKey:@"params"], @"params",
							   self.requestId, @"id",
							   nil]];
	}
	
	NSString *string = [jsonrequest yajl_JSONString];
//    NSLog(@"sending %@", string);
	NSData *serializedData = [string dataUsingEncoding:NSUTF8StringEncoding];

	
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
    NSDictionary* tag = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%f",time], @"id",
                         info?info:[[[NSDictionary alloc] init] autorelease], @"info",
						 object, @"object",
						 [NSValue valueWithPointer:sel], @"selector",
						 nil];
	[self requestWithUrl:self.url data:serializedData tag:tag];
}

- (void)requestWithMethod:(NSString *)method 
                   params:(NSObject *)params 
                   info:(NSDictionary *)info 
                   target:(NSObject*)object 
                 selector:(SEL)sel
{
    NSDictionary *jsonRpc = [NSDictionary dictionaryWithObjectsAndKeys:
						protocol, @"jsonrpc",
						method, @"method",
						params, @"params",
						self.requestId, @"id",
						nil];

	NSString *string = [jsonRpc yajl_JSONString];
//    NSLog(@"sending %@", string);
//    NSLog(@"infos %@", info);
	NSData *serializedData = [string dataUsingEncoding:NSUTF8StringEncoding];

    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	
    NSDictionary* tag = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%f",time], @"id",
                         info?info:[[[NSDictionary alloc] init] autorelease], @"info",
                         method, @"cmd",
						object, @"object",
						[NSValue valueWithPointer:sel], @"selector",
						nil];
	[self requestWithUrl:self.url data:serializedData tag:tag];
}
- (void)requestWithMethod:(NSString *)method params:(NSObject *)params {
    [self requestWithMethod:method params:params info:nil target:nil selector:nil];
}

- (void)requestWithMethod:(NSString *)method {
	[self requestWithMethod:method params:[NSArray array]];
}




# pragma mark delegate

- (void)jsonRpcClientDidStartLoading:(JsonRpcClient *)client {
	if([[self delegate] respondsToSelector:@selector(jsonRpcClientDidStartLoading:)]) {
		[[self delegate] jsonRpcClientDidStartLoading:client];
	}		
}

- (void)jsonRpcClient:(JsonRpcClient *)client didReceiveResult:(id)result  tag:(NSDictionary*)tag {
	if([[self delegate] respondsToSelector:@selector(jsonRpcClient:didReceiveResult:tag:)]) {
		[[self delegate] jsonRpcClient:client didReceiveResult:result tag:tag];
	}	
}

- (void)jsonRpcClient:(JsonRpcClient *)client didFailWithErrorCode:(NSNumber *)code message:(NSDictionary *)message  tag:(NSDictionary*)tag {
	if([[self delegate] respondsToSelector:@selector(jsonRpcClient:didFailWithErrorCode:message:tag:)]) {
		[[self delegate] jsonRpcClient:client didFailWithErrorCode:code message: message tag:tag];
		NSLog(@"error %@",message);
	}	
}

- (void)dealloc {
	[requestId release];
    [receivedData release];
	[url release];
	[super dealloc];
}

@end

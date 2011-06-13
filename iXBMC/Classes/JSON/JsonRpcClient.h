//
//  JsonRpcClient.h
//
//  Created by Marcel Stegmann on 28.07.09.
//

#import <Foundation/Foundation.h>

@interface CustomURLConnection : NSURLConnection {
    NSDictionary *tag;
    NSObject* target;
    SEL selector;
}

@property (nonatomic, retain) NSDictionary *tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSDictionary*)tag;

@end

@interface JsonRpcClient : NSObject {
	NSString *protocol;
	NSString *requestId;
    NSMutableDictionary *receivedData;	
	NSURL *url;
		
	id delegate;
}

@property (nonatomic, copy) NSString *requestId;

@property (nonatomic, copy) NSURL *url;

@property (nonatomic, retain) id delegate;

- (id)initWithUrl:(NSURL *)newUrl delegate:(id)newDelegate;

- (void)requestWithMethod:(NSString *)method;
- (void)requestWithMethod:(NSString *)method params:(NSObject *)params;
- (void)requestWithMethod:(NSString *)method 
                   params:(NSObject *)params 
                   info:(NSDictionary *)info 
                   target:(NSObject*)object 
                 selector:(SEL)sel;

- (void)requestWithUrl:(NSURL *)requestUrl data:(NSData *)requestData tag:(NSDictionary*)tag;


// NSURLConnection handling
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

// Delegates
- (void)jsonRpcClientDidStartLoading:(JsonRpcClient *)client;
- (void)jsonRpcClient:(JsonRpcClient *)client didReceiveResult:(id)result tag:(NSDictionary*)tag;
- (void)jsonRpcClient:(JsonRpcClient *)client didFailWithErrorCode:(NSNumber *)code message:(NSDictionary *)message tag:(NSDictionary*)tag;

@end

//
//  XBMCCommunicator.h
//  TheElements
//
//  Created by Martin Guillon on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JsonRpcClient;

@interface XBMCJSONCommunicator : NSObject {
    
    JsonRpcClient* json;
    
    NSString* _fulladdress;
}

@property (nonatomic, retain) JsonRpcClient* json;
@property (nonatomic,retain) NSString* fulladdress;

+ (XBMCJSONCommunicator *) sharedInstance;

- (void) setAddress:(NSString*)address port:(NSString*)port login:(NSString*)log password:(NSString*)pwd;
- (void)jsonRpcClient:(JsonRpcClient *)client didReceiveResult:(id)result tag:(NSDictionary *)tag;
- (void)jsonRpcClient:(JsonRpcClient *)client didFailWithErrorCode:(NSNumber *)code message:(NSDictionary *)message tag:(NSDictionary *)tag;
-(void)addJSONRequest:(NSDictionary*)rq;
-(void)addJSONRequest:(NSDictionary*)rq target:(NSObject*)object selector:(SEL)sel;

@end

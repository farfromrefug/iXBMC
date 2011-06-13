//
//  XBMCTCP.h
//  iXBMC
//
//  Created by Martin Guillon on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

extern NSString * const kNotification;
extern NSString * const kNotificationMessage;

@protocol XBMCTCPDelegate
@optional

- (void)XBMCTCPConnected;
- (void)XBMCTCPDisconnected;
- (void)XBMCTCPReceivedData:(NSDictionary*)data;

@end

@interface XBMCTCP : NSObject<AsyncSocketDelegate> {
    AsyncSocket *_socket;
    BOOL _isRunning;
    NSNotificationCenter* _notificationCenter;
	id _delegate;
    NSDictionary * _requestInfos;
}

@property (nonatomic, retain) id delegate;
@property (readwrite, assign) BOOL isRunning;

+ (XBMCTCP *) sharedInstance;
- (void)connectToHost:(NSString *)hostName onPort:(int)port;
+ (void)sendMessage:(NSString *)message;
+ (void)sendData:(NSData *)data;
- (void)disconnect;
- (void)connect;

@end

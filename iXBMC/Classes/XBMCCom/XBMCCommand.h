//
//  XBMCCommand.h
//  iXBMC
//
//  Created by Martin Guillon on 5/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XBMCCommand : NSObject {
    NSDictionary *_commandList;
    
}
+ (XBMCCommand *) sharedInstance;
+(void)send:(NSString*)cmd;
-(void)internalSend:(NSString*)cmd;

+ (void)play:(NSString *) url;
+ (void)setVideoPlaylistAndPlay:(NSArray *) items;
+ (void)enqueue:(id)item;

@end

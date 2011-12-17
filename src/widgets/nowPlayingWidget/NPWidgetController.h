//
//  XBMCGestureViewController.h
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectedViewController.h"

@class FadingImageView;

@interface NPWidgetController : TTViewController<NINetworkImageViewDelegate>
{
//    NSString* _imdb;
    NSString* _type;
//    NSString* _id;
     
//    UIImageView *_backgroundView;
    TTView *_infosView;
    NINetworkImageView* _cover;
//    FadingImageView* _fanart;
    UIImageView* _gestureView;
    TTStyledTextLabel* _infoLabel;
}
//@property (nonatomic, retain) NSString* imdb;
@property (nonatomic, retain) NSString* type;
//@property (nonatomic, retain) NSString* itemId;

-(void)updatePlayingInfo: (NSNotification *) notification;
-(void)cleanPlayingInfo;
-(void)downloadCover:(NSString*)url;

- (void)applicationDidBecomeActive: (NSNotification *) notification; 
- (void)applicationWillResignActive: (NSNotification *) notification; 

@end

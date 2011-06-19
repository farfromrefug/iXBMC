//
//  RemoteViewController.h
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectedViewController.h"

@class XBMCTouchView;
@class FadingImageView;
@class CustomTitleView;
@interface RemoteViewController : ConnectedViewController <UIActionSheetDelegate> 
{
    UIActivityIndicatorView* imageLoadingIndicator;
    NSString* _imdb;
    NSString* _type;
    NSString* _id;
    
 
    TTView* _toolBar;
//    UIImageView *_backgroundView;
    TTView *_infosView;
    TTView *_buttonsView;
    CustomTitleView* _titleBackground;
    FadingImageView* _cover;
    FadingImageView* _fanart;
    TTStyledTextLabel* _infoLabel;

}
@property (nonatomic, retain) NSString* imdb;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* itemId;

//- (void)playingStarted: (NSNotification *) notification;
//- (void)playingStopped: (NSNotification *) notification;

-(void)updatePlayingInfo: (NSDictionary *) notification;
-(void)cleanPlayingInfo;
-(void)downloadCover:(NSString*)url;

- (void) addButtons;

- (void)applicationDidBecomeActive: (NSNotification *) notification; 
- (void)applicationWillResignActive: (NSNotification *) notification; 

@end

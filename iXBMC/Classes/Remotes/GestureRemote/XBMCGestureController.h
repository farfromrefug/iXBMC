//
//  XBMCGestureViewController.h
//  iHaveNoName
//
//  Created by Martin Guillon on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectedViewController.h"

@class XBMCTouchView;
@class BCTab;
@class FadingImageView;
@class CustomTitleView;

@interface XBMCGestureController : ConnectedViewController
{
    NSString* _imdb;
    NSString* _type;
    NSString* _id;
    
    BCTab* _tabButton;
 
    TTView* _toolBar;
//    UIImageView *_backgroundView;
    TTView *_infosView;
    FadingImageView* _cover;
    FadingImageView* _fanart;
    UIImageView* _gestureView;
    TTStyledTextLabel* _infoLabel;
    TTStyledTextLabel* _plotLabel;
    
    CustomTitleView* _titleBackground;
}
@property (nonatomic, retain) BCTab* tabButton;
@property (nonatomic, retain) NSString* imdb;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* itemId;

//
//- (void)handleTap:(UITapGestureRecognizer *)recognizer;
//- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer; 
//- (void)handleSwipe:(UISwipeGestureRecognizer *)recognizer;

-(void)updatePlayingInfo: (NSNotification *) notification;
-(void)cleanPlayingInfo;
-(void)downloadCover:(NSString*)url;

- (void)applicationDidBecomeActive: (NSNotification *) notification; 
- (void)applicationWillResignActive: (NSNotification *) notification; 

@end

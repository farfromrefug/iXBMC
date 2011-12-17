//
//  DetailView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FadingImageView;
@interface DetailView : TTView {
    
//    UIImageView *_backgroundView;
    UIScrollView* _scrollView;
    FadingImageView* _cover;
    FadingImageView* _fanart;
    UIImageView *_newFlag;
    TTStyledTextLabel* _infoLabel;
	
	UIView* _plotView;
    TTStyledTextLabel* _plotLabel;
    UIScrollView* _plotScroll;
    TTStyledTextLabel* _plotTitleLabel;
    
	UIView* _castView;
    UIScrollView* _castScroll;
    TTStyledTextLabel* _castTitleLabel;
    TTStyledTextLabel* _castLabel;
    
    
    bool _layoutDone;
}
@property (nonatomic, retain)   FadingImageView* cover;
@property (nonatomic, retain)   FadingImageView* fanart;
@property (nonatomic, retain)   UIImageView* newFlag;
//@property (nonatomic, retain)   TTStyledTextLabel* infoLabel;
//@property (nonatomic, retain)   TTStyledTextLabel* plotLabel;
//@property (nonatomic, retain)   TTStyledTextLabel* plotTitleLabel;
//@property (nonatomic, retain)   UIScrollView* plotScroll;
//@property (nonatomic, retain)   TTStyledTextLabel* castTitleLabel;
//@property (nonatomic, retain)   TTStyledTextLabel* castLabel;
//@property (nonatomic, retain)   UIScrollView* castScroll;
//@property (nonatomic, retain)   UIScrollView* scrollView;
//@property (nonatomic, retain)   UIImageView *backgroundView;

- (void) setInfo:(NSString*) info;
- (void) setPlot:(NSString*) plot;
- (void) setCast:(NSString*) cast;

@end

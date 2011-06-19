//
// Copyright 2009-2011 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "StyleSheet.h"
#import "TTHLinearGradientBorderStyle.h"
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation StyleSheet

- (CGFloat) toolbarAnimationDuration
{
	return 0.2;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

- (UIFont *) tabBarTextFont
{
	return [UIFont systemFontOfSize:12];
}

- (UIColor *) tabBarTextColor
{
	return [UIColor whiteColor];
}

- (UIColor*) tabBarTextShadowColor
{
	return [UIColor clearColor];
	
}
- (CGSize) tabBarTextShadowOffset
{
	return CGSizeMake(0.0, 0.0);
}
- (UILineBreakMode) tabBarTextLineBreakMode
{
	return UILineBreakModeTailTruncation;
}

- (UIEdgeInsets) tabBarTextEdgeInsets
{
	return UIEdgeInsetsMake(0.0, 0.0, -30.0, 0.0);
}

- (UIControlContentHorizontalAlignment) tabBarTextHAlignment
{
	return UIControlContentHorizontalAlignmentCenter;
}

- (UIControlContentVerticalAlignment) tabBarTextVAlignment
{
	return UIControlContentVerticalAlignmentBottom;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) highQualityImages {
    return NO;
}

- (CGFloat) highQualityFactor
{
//	return [UIScr een mainScreen].scale;
	return 2.0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat) headerViewHeight {
  return 22;
}

- (CGFloat) movieCellHeight {
    return 80;
}

- (CGFloat) movieCellMinHeight {
    return 60;
}

- (CGFloat) movieCellMaxHeight {
    return 100;
}

- (CGFloat) movieDetailsViewCoverHeight {
    return 200;
}

- (BOOL) movieCellRatingStars {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat) tvshowCellHeight {
    return 60;
}

- (CGFloat) tvshowCellMinHeight {
    return 60;
}

- (CGFloat) tvshowCellMaxHeight {
    return 60;
}

- (CGFloat) tvshowViewCoverHeight {
    return 200;
}

- (BOOL) tvshowCellRatingStars {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat) seasonCellHeight {
    return 60;
}

- (CGFloat) seasonCellMinHeight {
    return 60;
}

- (CGFloat) seasonCellMaxHeight {
    return 100;
}

- (CGFloat) seasonViewCoverHeight {
    return 200;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (CGFloat) episodeCellHeight {
    return 60;
}

- (CGFloat) episodeCellMinHeight {
    return 60;
}

- (CGFloat) episodeCellMaxHeight {
    return 100;
}

- (CGFloat) episodeViewCoverHeight {
    return 200;
}

- (BOOL) episodeCellRatingStars {
    return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)navigationBarTintColor {
    return RGBCOLOR(0, 0, 0);
}

- (UIColor*)themeColor {
    return RGBCOLOR(92,157,194);
}

- (TTStyle*)whiteText {
    TTTextStyle* style = [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                              color:[UIColor whiteColor]
                                      textAlignment: UITextAlignmentLeft next:nil];
    style.lineBreakMode = UILineBreakModeWordWrap;
    return style;
}

- (TTStyle*)plotText {
    TTTextStyle* style = (TTTextStyle*)TTSTYLEVAR(whiteText);
    style.lineBreakMode = UILineBreakModeTailTruncation;
    style.numberOfLines = 4;
    return style;
}

- (TTStyle*)bigWhiteText {
    TTTextStyle* style = [TTTextStyle styleWithFont:[UIFont systemFontOfSize:14] 
                                              color:[UIColor whiteColor]
                                      textAlignment: UITextAlignmentLeft next:nil];
    style.lineBreakMode = UILineBreakModeWordWrap;
    return style;
}

- (TTStyle*)grayText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                color:[UIColor grayColor]
                        textAlignment: UITextAlignmentLeft next:nil];
}

- (TTStyle*)buttonText {
    return [TTTextStyle styleWithFont:[UIFont systemFontOfSize:12] 
                                color:[UIColor grayColor]
                        textAlignment: UITextAlignmentLeft next:nil];
}

- (TTStyle*)actorListBox {
    return
    [TTSolidFillStyle styleWithColor:[UIColor blueColor] next:
     [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(5,0,5,0) next:
      [TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 next:nil]]];
}

- (NSString*) emptyDBName {
    return @"empty";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tabTintColor {
    return RGBCOLOR(150, 150, 150);
}

- (TTStyle*)tableToolbar {
    TTImageStyle* style = [TTImageStyle styleWithImageURL:@"bundle://tableToolbar.png" next:nil];
    style.contentMode = UIViewContentModeScaleToFill;
    return style;
}

- (TTStyle*)switchButton:(UIControlState)state {
    TTImageStyle* style;
    if (state == UIControlStateSelected) {
        style = [TTImageStyle styleWithImageURL:@"bundle://switchButtonOn.png" next:nil];
    }
    else {
        style = [TTImageStyle styleWithImageURL:@"bundle://switchButtonOff.png" next:nil];
    }
    style.contentMode = UIViewContentModeScaleToFill;
    return style;
}

- (TTStyle*)embossedButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
//         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(161,161,161,0.2) blur:1 offset:CGSizeMake(0, 1) next:
           [TTSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) next:
            [TTHLinearGradientBorderStyle styleWithColor1:RGBACOLOR(145, 145, 145, 0.5) color2:RGBACOLOR(0,0,0, 0) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
              [TTTextStyle styleWithFont:nil color:[UIColor grayColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.1]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:10] next:
//         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(161,161,161,0.2) blur:1 offset:CGSizeMake(0, 1) next:
           [TTSolidFillStyle styleWithColor:RGBACOLOR(0, 0, 0, 0.5) next:
            [TTHLinearGradientBorderStyle styleWithColor1:RGBACOLOR(45, 45, 45, 0.5) color2:TTSTYLEVAR(themeColor) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(themeColor)
                             shadowColor:[UIColor colorWithWhite:160 alpha:0.1]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]];
    } else {
        return nil;
    }
}

- (TTStyle*)navigationButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(5, 5, 5, 5) next:
         [TTShadowStyle styleWithColor:RGBACOLOR(161,161,161,0.2) blur:1 offset:CGSizeMake(0, 1) next:
          [TTLinearGradientFillStyle styleWithColor1:RGBACOLOR(63, 63, 63, 0.7) color2:RGBACOLOR(40,40,40, 0.7) next:
           [TTLinearGradientBorderStyle styleWithColor1:RGBACOLOR(0,0,0, 0) color2:RGBACOLOR(145, 145, 145, 0.5) width:1 next:
            [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
             [TTTextStyle styleWithFont:nil color:[UIColor grayColor]
                            shadowColor:[UIColor colorWithWhite:255 alpha:0.1]
                           shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:6] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(5, 5, 5, 5) next:
         [TTShadowStyle styleWithColor:RGBACOLOR(161,161,161,0.2) blur:1 offset:CGSizeMake(0, 1) next:
          [TTLinearGradientFillStyle styleWithColor1:RGBACOLOR(40,40,40, 0.7) color2:RGBACOLOR(63, 63, 63, 0.7) next:
           [TTLinearGradientBorderStyle styleWithColor1:RGBACOLOR(45, 45, 45, 0.5) color2:TTSTYLEVAR(themeColor) width:1 next:
            [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
             [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(themeColor)
                            shadowColor:[UIColor colorWithWhite:160 alpha:0.1]
                           shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCellSelectionStyle)tableSelectionStyle {
    return UITableViewCellSelectionStyleGray;
}


///TTTableviewDragAndRefresh
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableRefreshHeaderLastUpdatedFont {
	return [UIFont systemFontOfSize:12.0f];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableRefreshHeaderStatusFont {
	return [UIFont boldSystemFontOfSize:14.0f];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderBackgroundColor {
	return RGBCOLOR(25, 25, 25);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderTextColor {
	return [UIColor grayColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderTextShadowColor {
	return TTSTYLEVAR(themeColor);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)tableRefreshHeaderTextShadowOffset {
	return CGSizeMake(0.0f, 1.0f);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)tableRefreshHeaderArrowImage {
	return TTIMAGE(@"bundle://Three20.bundle/images/blackArrow.png");
}


@end

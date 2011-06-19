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

// Style
#import "Three20Style/TTStyleSheet.h"

@interface StyleSheet : TTDefaultStyleSheet

@property (nonatomic, readonly) CGFloat toolbarAnimationDuration;

@property (nonatomic, readonly) UIFont *tabBarTextFont;
@property (nonatomic, readonly) UIColor	*tabBarTextColor;
@property (nonatomic, readonly) UIColor	*tabBarTextShadowColor;
@property (nonatomic, readonly) CGSize	tabBarTextShadowOffset;
@property (nonatomic, readonly) UILineBreakMode	tabBarTextLineBreakMode;
@property (nonatomic, readonly) UIEdgeInsets tabBarTextEdgeInsets;
@property (nonatomic, readonly) UIControlContentHorizontalAlignment tabBarTextHAlignment;
@property (nonatomic, readonly) UIControlContentVerticalAlignment tabBarTextVAlignment;


@property (nonatomic, readonly) BOOL highQualityImages;
@property (nonatomic, readonly) CGFloat highQualityFactor;

@property (nonatomic, readonly) CGFloat headerViewHeight;
@property (nonatomic, readonly) CGFloat movieCellHeight;
@property (nonatomic, readonly) CGFloat movieCellMinHeight;
@property (nonatomic, readonly) CGFloat movieCellMaxHeight;
@property (nonatomic, readonly) BOOL movieCellRatingStars;

@property (nonatomic, readonly) CGFloat tvshowCellHeight;
@property (nonatomic, readonly) CGFloat tvshowCellMinHeight;
@property (nonatomic, readonly) CGFloat tvshowCellMaxHeight;
@property (nonatomic, readonly) BOOL tvshowCellRatingStars;

@property (nonatomic, readonly) CGFloat seasonCellHeight;
@property (nonatomic, readonly) CGFloat seasonCellMinHeight;
@property (nonatomic, readonly) CGFloat seasonCellMaxHeight;

@property (nonatomic, readonly) CGFloat episodeCellHeight;
@property (nonatomic, readonly) CGFloat episodeCellMinHeight;
@property (nonatomic, readonly) CGFloat episodeCellMaxHeight;
@property (nonatomic, readonly) BOOL episodeCellRatingStars;

@property (nonatomic, readonly) CGFloat movieDetailsViewCoverHeight;
@property (nonatomic, readonly) UIColor*  navigationBarTintColor;
@property (nonatomic, readonly) TTStyle* whiteText;
@property (nonatomic, readonly) TTStyle* plotText;
@property (nonatomic, readonly) TTStyle* bigWhiteText;
@property (nonatomic, readonly) UIColor*  tabTintColor;
@property (nonatomic, readonly) UIColor*  themeColor;
@property (nonatomic, readonly) TTStyle* tableToolbar;
@property (nonatomic, readonly) NSString*  emptyDBName;
@property (nonatomic, readonly) UITableViewCellSelectionStyle tableSelectionStyle;

@end

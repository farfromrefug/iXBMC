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

@property (nonatomic, readonly) CGFloat tableViewCellMenuHeight;
@property (nonatomic, readonly) CGFloat tableViewCellSearchHeight;

@property (nonatomic, readonly) TTStyle *connectionBanner;
@property (nonatomic, readonly) UIColor	*connectionBarTextColor;
@property (nonatomic, readonly) UIFont	*connectionBarTextFont;

@property (nonatomic, readonly) UIColor	*navBarBackColor;
@property (nonatomic, readonly) UIColor	*navBarBorderColor;
@property (nonatomic, readonly) UIFont *navBarTextFont;
@property (nonatomic, readonly) UIFont *navBarSubtitleTextFont;
@property (nonatomic, readonly) UIColor	*navBarTextColor;
@property (nonatomic, readonly) UIColor	*navBarSubtitleTextColor;

@property (nonatomic, readonly) UIColor	*tabBarBackColor;
@property (nonatomic, readonly) UIColor	*tabBarBorderColor;
@property (nonatomic, readonly) UIColor	*tabBarHighlightedColor;
@property (nonatomic, readonly) UIFont *tabBarTextFont;
@property (nonatomic, readonly) UIColor	*tabBarTextColor;
@property (nonatomic, readonly) UIColor	*tabBarTextHighlightedColor;
@property (nonatomic, readonly) UIColor	*tabBarTextShadowColor;
@property (nonatomic, readonly) CGSize	tabBarTextShadowOffset;
@property (nonatomic, readonly) UILineBreakMode	tabBarTextLineBreakMode;
@property (nonatomic, readonly) UIEdgeInsets tabBarTextEdgeInsets;
@property (nonatomic, readonly) UITextAlignment tabBarTextAlignment;
@property (nonatomic, readonly) UIControlContentVerticalAlignment tabBarTextVAlignment;


@property (nonatomic, readonly) BOOL highQualityImages;
@property (nonatomic, readonly) CGFloat highQualityFactor;

@property (nonatomic, readonly) CGFloat cellHeight;

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

@property (nonatomic, readonly) UIColor* recentEpisodesBackColor;
@property (nonatomic, readonly) UIColor* recentEpisodesFirstBorderColor;
@property (nonatomic, readonly) UIColor* recentEpisodesSecondBorderColor;
@property (nonatomic, readonly) UIColor* recentEpisodeTextFirstColor;
@property (nonatomic, readonly) UIColor* recentEpisodeTextSecondColor;
@property (nonatomic, readonly) UIFont* recentEpisodeTextFirstFont;
@property (nonatomic, readonly) UIFont* recentEpisodeTextSecondFont;


@property (nonatomic, readonly) UIColor* tableViewBackColor;
@property (nonatomic, readonly) UIColor* tableViewHeaderMainColor;
@property (nonatomic, readonly) UIColor* tableViewHeaderSecondColor;
@property (nonatomic, readonly) UIColor* tableViewHeaderBorderColor;
@property (nonatomic, readonly) UIColor* tableViewHeaderTextColor;
@property (nonatomic, readonly) UIFont* tableViewHeaderTextFont;

@property (nonatomic, readonly) UIColor* tableViewCellMainColor;
@property (nonatomic, readonly) UIColor* tableViewCellSecondColor;
@property (nonatomic, readonly) UIColor* tableViewCellFirstBorderColor;
@property (nonatomic, readonly) UIColor* tableViewCellSecondBorderColor;

@property (nonatomic, readonly) UIColor* tableViewCellHighlightedMainColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedSecondColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedFirstBorderColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedSecondBorderColor;

@property (nonatomic, readonly) UIColor* tableViewCellTextFirstColor;
@property (nonatomic, readonly) UIColor* tableViewCellTextSecondColor;
@property (nonatomic, readonly) UIColor* tableViewCellTextThirdColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedTextFirstColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedTextSecondColor;
@property (nonatomic, readonly) UIColor* tableViewCellHighlightedTextThirdColor;
@property (nonatomic, readonly) UIFont* tableViewCellTextFirstFont;
@property (nonatomic, readonly) UIFont* tableViewCellTextSecondFont;
@property (nonatomic, readonly) UIFont* tableViewCellTextThirdFont;

@property (nonatomic, readonly) UIColor* detailsViewBackColor;

@property (nonatomic, readonly) TTStyle* bigWhiteText;
@property (nonatomic, readonly) UIColor*  tabTintColor;
@property (nonatomic, readonly) UIColor*  themeColor;
@property (nonatomic, readonly) TTStyle* tableToolbar;
@property (nonatomic, readonly) NSString*  emptyDBName;
@property (nonatomic, readonly) UITableViewCellSelectionStyle tableSelectionStyle;

@end

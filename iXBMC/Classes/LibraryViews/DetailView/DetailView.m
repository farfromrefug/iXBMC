//
//  DetailView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailView.h"
#import "FadingImageView.h"

@implementation DetailView
@synthesize cover = _cover;
@synthesize fanart = _fanart;
@synthesize newFlag = _newFlag;
//@synthesize infoLabel = _infoLabel;
//@synthesize plotLabel = _plotLabel;
//@synthesize plotScroll = _plotScroll;
//@synthesize plotTitleLabel = _plotTitleLabel;
//@synthesize castScroll = _castScroll;
//@synthesize castTitleLabel = _castTitleLabel;
//@synthesize castLabel = _castLabel;
//@synthesize scrollView = _scrollView;
//@synthesize backgroundView = _backgroundView;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if (self = [super init]) {
        _layoutDone = false;

        //        self.frame = self.bounds;
        //[self setClipsToBounds:YES];
        //self.autoresizesSubviews = YES;
        self.backgroundColor = TTSTYLEVAR(detailsViewBackColor);
        
        _scrollView = [[[UIScrollView alloc] init] autorelease];
        _scrollView.delaysContentTouches = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        _fanart = [[[FadingImageView alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _fanart.contentMode = UIViewContentModeScaleAspectFill;
        _fanart.backgroundColor = [UIColor clearColor];
        _fanart.clipsToBounds = YES;
        _fanart.alpha = 0.1;
        [self insertSubview:_fanart belowSubview:_scrollView];
                
        _cover = [[[FadingImageView alloc] init] autorelease];
        
        _cover.contentMode = UIViewContentModeScaleToFill;
        _cover.clipsToBounds = YES;
        _cover.userInteractionEnabled= YES;
        _cover.backgroundColor = [UIColor clearColor];
        _cover.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:4] next:
                  [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,1.0) blur:10 offset:CGSizeMake(0, 0) next:
                   [TTContentStyle styleWithNext:nil]]];

        _cover.defaultImage = TTIMAGE(@"bundle://thumbnailNoneBig.png");
        
        _newFlag = [[[UIImageView alloc] init] autorelease];
        _newFlag.backgroundColor = [UIColor clearColor];
        _newFlag.image = TTIMAGE(@"bundle://UnWatchedBig.png");
        _newFlag.hidden = TRUE;
        _newFlag.userInteractionEnabled = FALSE;
//        _newFlag.style = _cover.style;
        
        _infoLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _infoLabel.font = [UIFont systemFontOfSize:12];
        _infoLabel.backgroundColor = [UIColor clearColor];
        
        _plotView = [[[UIView alloc] init] autorelease];
		_plotView.backgroundColor = [UIColor clearColor];
        _plotScroll = [[[UIScrollView alloc] init] autorelease];
        _plotScroll.autoresizesSubviews = YES;
//        _plotScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _plotScroll.backgroundColor = [UIColor clearColor];
        _plotTitleLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _plotTitleLabel.contentInset = UIEdgeInsetsMake(5, 5, 0, 5);
        _plotTitleLabel.backgroundColor = [UIColor clearColor];
		_plotTitleLabel.text = [TTStyledText textFromXHTML:@"<span class=\"grayText\">Plot:</span>"];
  
        _plotLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _plotLabel.contentInset = UIEdgeInsetsMake(0, 5, 5, 5);
        _plotLabel.font = [UIFont systemFontOfSize:12];
        _plotLabel.backgroundColor = [UIColor clearColor];
        
        
        _castView = [[[UIView alloc] init] autorelease];
		_castView.backgroundColor = [UIColor clearColor];
        _castScroll = [[[UIScrollView alloc] init] autorelease];
        _castScroll.autoresizesSubviews = YES;
        _castScroll.backgroundColor = [UIColor clearColor];
        _castTitleLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _castTitleLabel.contentInset = UIEdgeInsetsMake(5, 5, 0, 5);
        _castTitleLabel.backgroundColor = [UIColor clearColor];
        
        _castLabel = [[[TTStyledTextLabel alloc] initWithFrame:TTNavigationFrame()] autorelease];
        _castLabel.contentInset = UIEdgeInsetsMake(0, 5, 5, 5);
        _castLabel.font = [UIFont systemFontOfSize:12];
        _castLabel.backgroundColor = [UIColor clearColor];
		_castTitleLabel.text = [TTStyledText textFromXHTML:@"<span class=\"grayText\">Cast:</span>"];
      
        
        [_scrollView addSubview:_infoLabel]; 
		
		[_plotView addSubview:_plotScroll];    
        [_plotView addSubview:_plotTitleLabel];    
        [_plotScroll addSubview:_plotLabel]; 
        [_scrollView addSubview:_plotView];    

        [_castView addSubview:_castTitleLabel];    
        [_castView addSubview:_castScroll];    
        [_castScroll addSubview:_castLabel];
		[_scrollView addSubview:_castView];    

        [self addSubview:_cover];
        [_scrollView addSubview:_newFlag];
        
        
        
        ///
        
        
    }
    
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
//    TT_RELEASE_SAFELY(_cover);
//    TT_RELEASE_SAFELY(_fanart);
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView

-(void) setFrame:(CGRect) frame
{
    [super setFrame:frame];
    _layoutDone = false;
//    [self setNeedsLayout];
//    [self layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    if(_layoutDone) return;
    _layoutDone = true;
   
//    self.frame = TTNavigationFrame();
//    _backgroundView.frame = self.frame;
    _scrollView.frame = self.frame;
    _fanart.frame = self.frame;
    
    CGFloat coverHeight = TTSTYLEVAR(movieDetailsViewCoverHeight)*2/3;
   
    _cover.frame = CGRectMake(5, self.height + 15 - coverHeight, coverHeight*2/3, coverHeight);
    int newFlagWidth = _cover.width*1/2;
    _newFlag.frame = CGRectMake(_cover.right - newFlagWidth - 8, _cover.top + 8
                                , newFlagWidth, newFlagWidth);
    
    _infoLabel.frame = CGRectMake(0, 5, self.width , self.height);
    _infoLabel.contentInset = UIEdgeInsetsMake(5, 5 + _cover.right, 5, 5);
    [_infoLabel layoutSubviews];
    [_infoLabel sizeToFit];
    [_infoLabel setHeight:MAX(_infoLabel.height, _cover.bottom + 5)];
    
    _plotTitleLabel.frame = CGRectMake(0, 0, self.width, self.height);
    [_plotTitleLabel layoutSubviews];
    [_plotTitleLabel sizeToFit];
//    _plotTitleLabel.top = _infoLabel.bottom + 10;
    [_plotScroll setFrame:CGRectMake(0, _plotTitleLabel.bottom, self.width - 20, 100)];
    [_plotLabel setFrame:CGRectMake(0, 0, _plotScroll.width, _plotScroll.height)];
    [_plotLabel layoutSubviews];
    [_plotLabel sizeToFit];
    [_plotScroll setContentSize:_plotLabel.size];
  	_plotView.frame = CGRectMake(_plotScroll.left, _infoLabel.bottom + 10
								 , _plotScroll.width
								 , _plotScroll.bottom - _plotTitleLabel.top);
  
    _castTitleLabel.frame = CGRectMake(0, 5, self.width, self.height);
    [_castTitleLabel layoutSubviews];
    [_castTitleLabel sizeToFit];
//    _castTitleLabel.top = _plotScroll.bottom + 10;
    [_castScroll setFrame:CGRectMake(0, _castTitleLabel.bottom, self.width - 20, 200)];
    [_castLabel setFrame:CGRectMake(0, 0, _castScroll.width, _castScroll.height)];
    [_castLabel layoutSubviews];
    [_castLabel sizeToFit];
    [_castScroll setContentSize:_castLabel.size];
   	_castView.frame = CGRectMake(_castScroll.left, _plotView.bottom + 10
								 , _castScroll.width
								 , _castScroll.bottom - _castTitleLabel.top);
   
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in _scrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [_scrollView setContentSize:(CGSizeMake(_scrollView.width, _castView.bottom))];
    //_scrollView.contentOffset = CGPointMake(0, 0);
}

- (void) setInfo:(NSString*) info
{
	if (![info isEqualToString:@""])
	{
		_infoLabel.text = [TTStyledText textFromXHTML:info lineBreaks:YES URLs:YES];
	}
	else
	{
		_infoLabel.hidden = TRUE;
	}
}

- (void) setPlot:(NSString*) plot
{
	if (![plot isEqualToString:@""])
	{
		_plotLabel.text = [TTStyledText textFromXHTML:plot lineBreaks:YES URLs:YES];
	}
	else
	{
		_plotView.hidden = TRUE;
	}
}

- (void) setCast:(NSString*) cast
{
	if (![cast isEqualToString:@""])
	{
		_castLabel.text = [TTStyledText textFromXHTML:cast lineBreaks:YES URLs:YES];
	}
	else
	{
		_castView.hidden = TRUE;
	}
}

@end

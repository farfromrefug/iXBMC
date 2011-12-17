//
//  CustomTitleView.m
//  iXBMC
//
//  Created by Martin Guillon on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTitleView.h"


@implementation CustomTitleView
@synthesize title;
@synthesize subtitle;

- (id)init {
    if (self = [super init]) 
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = TRUE;
        
        _titleLabel = [[[UILabel alloc] init] autorelease];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLabel.font = TTSTYLEVAR(navBarTextFont);
        _titleLabel.textColor = TTSTYLEVAR(navBarTextColor);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;  
        _titleLabel.contentMode = UIViewContentModeCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.userInteractionEnabled = FALSE;
        
        _subTitleLabel = [[[UILabel alloc] init] autorelease];
        _subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _subTitleLabel.font = TTSTYLEVAR(navBarSubtitleTextFont);
        _subTitleLabel.textColor = TTSTYLEVAR(navBarSubtitleTextColor);
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = UITextAlignmentCenter;
        _subTitleLabel.adjustsFontSizeToFitWidth = NO;
        _subTitleLabel.lineBreakMode = UILineBreakModeTailTruncation;  
        _subTitleLabel.contentMode = UIViewContentModeBottom;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.userInteractionEnabled = FALSE;
        
        [self addSubview:_titleLabel]; 
        [self addSubview:_subTitleLabel]; 
        
        self.frame = CGRectMake(0, 0, TTScreenBounds().size.width, 40);
        _titleLabel.frame = CGRectMake(0, 0, self.width, self.height/2);
        _subTitleLabel.frame = CGRectMake(0, self.height/2
                                          , self.width, self.height/2);
    }
    return self;
}

-(NSString *) title
{
    return _titleLabel.text;
}

-(void) setTitle:(NSString *)value
{
    _titleLabel.text = [value uppercaseString];
}

-(NSString *) subtitle
{
    return _subTitleLabel.text;
}

-(void) setSubtitle:(NSString *)value
{
    _subTitleLabel.text = [value uppercaseString];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect superframe = self.superview.frame;
    double decale = MAX(self.left, superframe.size.width - self.right);
    _titleLabel.frame = CGRectMake(decale - self.left, 0
                                   , superframe.size.width - 2*decale
                                   , self.height/2);
    _subTitleLabel.frame = CGRectMake(_titleLabel.left, self.height/2
                                      , _titleLabel.width, self.height/2);
//    NSLog(@"set frame %@", NSStringFromCGRect(frame));
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    NSLog(@"titleView frame %@", NSStringFromCGRect(self.frame));
}
@end

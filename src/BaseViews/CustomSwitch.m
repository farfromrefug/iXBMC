//
//  CustomSwitch.m
//  iXBMC
//
//  Created by Martin Guillon on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomSwitch.h"


@implementation CustomSwitch

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 55, 28)]) {
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CustomSwitch*)switchWithTitle:(NSString*)title {
    CustomSwitch* button = [[[self alloc] init] autorelease];
    [button setTitle:title forState:UIControlStateNormal];
    [button setStylesWithSelector:@"switchButton:"];
    return button;
}

- (void) setFrame:(CGRect)frame 
{
    [super setFrame:CGRectMake(frame.origin.x + frame.size.width - self.width
                               , frame.origin.y + frame.size.height/2 - self.height/2, self.width, self.height)];
}
@end

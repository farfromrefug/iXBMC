//
//  MyImageView.m
//  iXBMC
//
//  Created by Martin Guillon on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyImageView.h"


@implementation MyImageView

-(void) setImage:(UIImage*)image
{
    _image = [image retain];
    [image release];
}

@end

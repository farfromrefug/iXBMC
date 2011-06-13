//
//  MyTabBarController.m
//  iXBMC
//
//  Created by Martin Guillon on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTabBarController.h"
#import "TabBarController.h"

@implementation MyTabBarController
@synthesize surrogateParent;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.surrogateParent.headerVisible)
    {
        self.surrogateParent.headerVisible = FALSE;
        [self.surrogateParent showHeader];
    }
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
//    if (self.surrogateParent.headerVisible)
//    {
//        [self.surrogateParent hideHeader];
//    }
}

@end

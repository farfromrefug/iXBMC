//
//  MyTabBarController.h
//  iXBMC
//
//  Created by Martin Guillon on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCTabBarController.h"
@class HeaderTabBarController;
@interface MyTabBarController : BCTabBarController {
    HeaderTabBarController* surrogateParent;
}
@property (nonatomic, assign) HeaderTabBarController *surrogateParent;
- (UIViewController*)rootControllerForController:(UIViewController*)controller;
- (void)setTabURLs:(NSArray*)URLs;

@end

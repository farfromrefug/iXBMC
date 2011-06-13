//
//  MyTabBarController.h
//  iXBMC
//
//  Created by Martin Guillon on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TabBarController;
@interface MyTabBarController : UITabBarController {
    TabBarController* surrogateParent;
}
@property (nonatomic, assign) TabBarController *surrogateParent;

@end

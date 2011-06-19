//
//  MyTabBarController.m
//  iXBMC
//
//  Created by Martin Guillon on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyTabBarController.h"
#import "HeaderTabBarController.h"

@implementation MyTabBarController
@synthesize surrogateParent;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)rootControllerForController:(UIViewController*)controller {
	if ([controller canContainControllers]) {
		return controller;
		
	} else {
		TTNavigationController* navController = [[[TTNavigationController alloc] init] autorelease];
		[navController pushViewController:controller animated:NO];
		return navController;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController (TTCategory)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canContainControllers {
	return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)topSubcontroller {
	return self.selectedViewController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addSubcontroller:(UIViewController*)controller animated:(BOOL)animated
			  transition:(UIViewAnimationTransition)transition {
	self.selectedViewController = controller;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)bringControllerToFront:(UIViewController*)controller animated:(BOOL)animated {
	self.selectedViewController = controller;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)keyForSubcontroller:(UIViewController*)controller {
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)subcontrollerForKey:(NSString*)key {
	return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)persistNavigationPath:(NSMutableArray*)path {
	UIViewController* controller = self.selectedViewController;
	[[TTNavigator navigator] persistController:controller path:path];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTabURLs:(NSArray*)URLs {
	NSMutableArray* controllers = [NSMutableArray array];
	for (NSString* URL in URLs) {
		UIViewController* controller = [[TTNavigator navigator] viewControllerForURL:URL];
		if (controller) {
			UIViewController* tabController = [self rootControllerForController:controller];
			[controllers addObject:tabController];
		}
	}
	self.viewControllers = controllers;
}

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

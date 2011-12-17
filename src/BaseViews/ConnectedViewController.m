//
//  MyClass.m
//  iXBMC
//
//  Created by Martin Guillon on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectedViewController.h"
#import "XBMCStateListener.h"
#import "NotConnectedController.h"


@implementation ConnectedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _notConnected = nil;
    }
    return self ;
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center
     addObserver:self
     selector:@selector(disconnectedFromXBMC:)
     name:@"DisconnectedFromXBMC"
     object:nil ];
    
    [center
     addObserver:self
     selector:@selector(connectedToXBMC:)
     name:@"ConnectedToXBMC"
     object:nil ];
    
    if (![[XBMCStateListener sharedInstance] connected])
    {
        [self disconnectedFromXBMC:nil];
    }
}

- (void)disconnectedFromXBMC: (NSNotification *) notification
{
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    if (_notConnected == nil)
    {
        _notConnected = [[NotConnectedController alloc] init];
    }
    _notConnected.view.frame = self.view.frame;
	[self.view addSubview:_notConnected.view];
}

- (void)connectedToXBMC: (NSNotification *) notification
{
    [_notConnected.view removeFromSuperview];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    TT_RELEASE_SAFELY(_notConnected);
}


@end

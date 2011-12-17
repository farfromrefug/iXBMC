//
//  MyClass.h
//  iXBMC
//
//  Created by Martin Guillon on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NotConnectedController;
@interface ConnectedViewController : TTViewController {
    NotConnectedController* _notConnected;    
}

- (void)disconnectedFromXBMC: (NSNotification *) notification;
- (void)connectedToXBMC: (NSNotification *) notification;

@end

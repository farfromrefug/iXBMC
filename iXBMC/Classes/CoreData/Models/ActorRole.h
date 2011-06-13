//
//  ActorRole.h
//  iXBMC
//
//  Created by Martin Guillon on 5/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Movie;

@interface ActorRole : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString* role;
@property (nonatomic, retain) Movie * RoleToMovie;
@property (nonatomic, retain) Actor * RoleToActor;

@end

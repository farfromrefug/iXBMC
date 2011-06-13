//
//  ActorRole.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Episode, Movie, TVShow;

@interface ActorRole : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * actorName;
@property (nonatomic, retain) Actor * RoleToActor;
@property (nonatomic, retain) NSSet* RoleToTVShow;
@property (nonatomic, retain) NSSet* RoleToMovie;
@property (nonatomic, retain) NSSet* RoleToEpisode;

@end

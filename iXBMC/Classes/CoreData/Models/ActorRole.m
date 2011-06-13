//
//  ActorRole.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ActorRole.h"
#import "Actor.h"
#import "Episode.h"
#import "Movie.h"
#import "TVShow.h"


@implementation ActorRole
@dynamic role;
@dynamic RoleToActor;
@dynamic RoleToTVShow;
@dynamic RoleToMovie;
@dynamic RoleToEpisode;


- (void)addRoleToTVShowObject:(TVShow *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToTVShow"] addObject:value];
    [self didChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRoleToTVShowObject:(TVShow *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToTVShow"] removeObject:value];
    [self didChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRoleToTVShow:(NSSet *)value {    
    [self willChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToTVShow"] unionSet:value];
    [self didChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRoleToTVShow:(NSSet *)value {
    [self willChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToTVShow"] minusSet:value];
    [self didChangeValueForKey:@"RoleToTVShow" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRoleToMovieObject:(Movie *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToMovie"] addObject:value];
    [self didChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRoleToMovieObject:(Movie *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToMovie"] removeObject:value];
    [self didChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRoleToMovie:(NSSet *)value {    
    [self willChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToMovie"] unionSet:value];
    [self didChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRoleToMovie:(NSSet *)value {
    [self willChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToMovie"] minusSet:value];
    [self didChangeValueForKey:@"RoleToMovie" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRoleToEpisodeObject:(Episode *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToEpisode"] addObject:value];
    [self didChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRoleToEpisodeObject:(Episode *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"RoleToEpisode"] removeObject:value];
    [self didChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRoleToEpisode:(NSSet *)value {    
    [self willChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToEpisode"] unionSet:value];
    [self didChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRoleToEpisode:(NSSet *)value {
    [self willChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"RoleToEpisode"] minusSet:value];
    [self didChangeValueForKey:@"RoleToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end

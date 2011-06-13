//
//  Season.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Season.h"
#import "Episode.h"


@implementation Season
@dynamic fanart;
@dynamic showtitle;
@dynamic playcount;
@dynamic thumbnail;
@dynamic seasonid;
@dynamic tvshowid;
@dynamic SeasonToTVShow;
@dynamic SeasonToEpisode;


- (void)addSeasonToEpisodeObject:(Episode *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"SeasonToEpisode"] addObject:value];
    [self didChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeSeasonToEpisodeObject:(Episode *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"SeasonToEpisode"] removeObject:value];
    [self didChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addSeasonToEpisode:(NSSet *)value {    
    [self willChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"SeasonToEpisode"] unionSet:value];
    [self didChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSeasonToEpisode:(NSSet *)value {
    [self willChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"SeasonToEpisode"] minusSet:value];
    [self didChangeValueForKey:@"SeasonToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end

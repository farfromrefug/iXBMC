//
//  TVShow.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TVShow.h"
#import "ActorRole.h"
#import "Episode.h"
#import "Genre.h"
#import "Season.h"


@implementation TVShow
@dynamic fanart;
@dynamic firstLetter;
@dynamic genre;
@dynamic imdbid;
@dynamic label;
@dynamic tvshowid;
@dynamic playcount;
@dynamic plot;
@dynamic rating;
@dynamic sortLabel;
@dynamic studio;
@dynamic tagline;
@dynamic thumbnail;
@dynamic nbepisodes;
@dynamic premiered;
@dynamic TVShowToGenre;
@dynamic TVShowToRole;
@dynamic TVShowToSeason;
@dynamic TVShowToEpisode;

- (void)addTVShowToGenreObject:(Genre *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToGenre"] addObject:value];
    [self didChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTVShowToGenreObject:(Genre *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToGenre"] removeObject:value];
    [self didChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTVShowToGenre:(NSSet *)value {    
    [self willChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToGenre"] unionSet:value];
    [self didChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTVShowToGenre:(NSSet *)value {
    [self willChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToGenre"] minusSet:value];
    [self didChangeValueForKey:@"TVShowToGenre" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTVShowToRoleObject:(ActorRole *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToRole"] addObject:value];
    [self didChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTVShowToRoleObject:(ActorRole *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToRole"] removeObject:value];
    [self didChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTVShowToRole:(NSSet *)value {    
    [self willChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToRole"] unionSet:value];
    [self didChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTVShowToRole:(NSSet *)value {
    [self willChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToRole"] minusSet:value];
    [self didChangeValueForKey:@"TVShowToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTVShowToSeasonObject:(Season *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToSeason"] addObject:value];
    [self didChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTVShowToSeasonObject:(Season *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToSeason"] removeObject:value];
    [self didChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTVShowToSeason:(NSSet *)value {    
    [self willChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToSeason"] unionSet:value];
    [self didChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTVShowToSeason:(NSSet *)value {
    [self willChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToSeason"] minusSet:value];
    [self didChangeValueForKey:@"TVShowToSeason" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void)addTVShowToEpisodeObject:(Episode *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToEpisode"] addObject:value];
    [self didChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTVShowToEpisodeObject:(Episode *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"TVShowToEpisode"] removeObject:value];
    [self didChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTVShowToEpisode:(NSSet *)value {    
    [self willChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToEpisode"] unionSet:value];
    [self didChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTVShowToEpisode:(NSSet *)value {
    [self willChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"TVShowToEpisode"] minusSet:value];
    [self didChangeValueForKey:@"TVShowToEpisode" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


+ (NSString*)defaultSort
{
    return @"firstLetter asc sortLabel asc";
}

+ (NSArray*)sorts
{
    return [NSArray arrayWithObjects:[self defaultSort], @"premiered des sortLabel asc", nil];
}
+ (NSArray*)sortNames
{
    return [NSArray arrayWithObjects:@"Title", @"Premier", nil];
}

@end

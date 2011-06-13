//
//  Movie.m
//  iXBMC
//
//  Created by Martin Guillon on 5/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"
#import "ActorRole.h"


@implementation Movie
@dynamic thumbnail;
@dynamic runtime;
@dynamic playcount;
@dynamic tagline;
@dynamic file;
@dynamic trailer;
@dynamic dateAddedLocal;
@dynamic plot;
@dynamic year;
@dynamic imdbid;
@dynamic plotoutline;
@dynamic label;
@dynamic sortLabel;
@dynamic firstLetter;
@dynamic studio;
@dynamic director;
@dynamic writer;
@dynamic genre;
@dynamic fanart;
@dynamic dateAdded;
@dynamic rating;
@dynamic movieid;
@dynamic MovieToGenre;
@dynamic MovieToRole;


- (void)addMovieToRoleObject:(ActorRole *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToRole"] addObject:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeMovieToRoleObject:(ActorRole *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"MovieToRole"] removeObject:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addMovieToRole:(NSSet *)value {    
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToRole"] unionSet:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeMovieToRole:(NSSet *)value {
    [self willChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"MovieToRole"] minusSet:value];
    [self didChangeValueForKey:@"MovieToRole" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

+ (NSString*)defaultSort
{
    return @"firstLetter asc sortLabel asc";
}

+ (NSArray*)sorts
{
    return [NSArray arrayWithObjects:[self defaultSort], @"year des sortLabel asc", @"director asc sortLabel asc", nil];
}
+ (NSArray*)sortNames
{
    return [NSArray arrayWithObjects:@"Title", @"Year", @"Director", nil];
}

@end

//
//  ActorRole.h
//  iXBMC
//
//  Created by Martin Guillon on 6/14/11.
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
@property (nonatomic, retain) Actor * actor;
@property (nonatomic, retain) NSSet* episodes;
@property (nonatomic, retain) NSSet* tvshows;
@property (nonatomic, retain) NSSet* movies;

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)value;
- (void)removeEpisodes:(NSSet *)value;
- (void)addTvshowsObject:(TVShow *)value;
- (void)removeTvshowsObject:(TVShow *)value;
- (void)addTvshows:(NSSet *)value;
- (void)removeTvshows:(NSSet *)value;
- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)value;
- (void)removeMovies:(NSSet *)value;

@end

//
//  TVShow.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ActorRole, Episode, Genre, Season;

@interface TVShow : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * fanart;
@property (nonatomic, retain) NSString * firstLetter;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * imdbid;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * tvshowid;
@property (nonatomic, retain) NSNumber * playcount;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * sortLabel;
@property (nonatomic, retain) NSString * studio;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSNumber * nbepisodes;
@property (nonatomic, retain) NSString * premiered;
@property (nonatomic, retain) NSSet* TVShowToGenre;
@property (nonatomic, retain) NSSet* TVShowToRole;
@property (nonatomic, retain) NSSet* TVShowToSeason;
@property (nonatomic, retain) NSSet * TVShowToEpisode;

- (void)addTVShowToGenreObject:(Genre *)value;
- (void)removeTVShowToGenreObject:(Genre *)value;
- (void)addTVShowToGenre:(NSSet *)value;
- (void)removeTVShowToGenre:(NSSet *)value;

- (void)addTVShowToRoleObject:(ActorRole *)value;
- (void)removeTVShowToRoleObject:(ActorRole *)value;
- (void)addTVShowToRole:(NSSet *)value;
- (void)removeTVShowToRole:(NSSet *)value;

- (void)addTVShowToSeasonObject:(Season *)value;
- (void)removeTVShowToSeasonObject:(Season *)value;
- (void)addTVShowToSeason:(NSSet *)value;
- (void)removeTVShowToSeason:(NSSet *)value;

- (void)addTVShowToEpisodeObject:(Episode *)value;
- (void)removeTVShowToEpisodeObject:(Episode *)value;
- (void)addTVShowToEpisode:(NSSet *)value;
- (void)removeTVShowToEpisode:(NSSet *)value;
@end

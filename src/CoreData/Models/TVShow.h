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
@property (nonatomic, retain) NSString * tvdbid;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * tvshowid;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * sortLabel;
@property (nonatomic, retain) NSString * studio;
@property (nonatomic, retain) NSString * tagline;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * premiered;
@property (nonatomic, retain) NSSet* genres;
@property (nonatomic, retain) NSSet* roles;
@property (nonatomic, retain) NSSet* seasons;
@property (nonatomic, retain) NSSet * episodes;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)value;
- (void)removeGenres:(NSSet *)value;

- (void)addRolesObject:(ActorRole *)value;
- (void)removeRolesObject:(ActorRole *)value;
- (void)addRoles:(NSSet *)value;
- (void)removeRoles:(NSSet *)value;

- (void)addSeasonsObject:(Season *)value;
- (void)removeSeasonsObject:(Season *)value;
- (void)addSeasons:(NSSet *)value;
- (void)removeSeasons:(NSSet *)value;

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)value;
- (void)removeEpisodes:(NSSet *)value;

+ (NSString*)defaultSort;

@end

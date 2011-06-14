//
//  Genre.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

@interface Genre : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* movies;
@property (nonatomic, retain) NSSet* tvshows;

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet *)value;
- (void)removeMovies:(NSSet *)value;
- (void)addTvshowsObject:(NSManagedObject *)value;
- (void)removeTvshowsObject:(NSManagedObject *)value;
- (void)addTvshows:(NSSet *)value;
- (void)removeTvshows:(NSSet *)value;
@end

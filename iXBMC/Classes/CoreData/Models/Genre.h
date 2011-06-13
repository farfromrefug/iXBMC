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
@property (nonatomic, retain) NSSet* GenreToMovie;
@property (nonatomic, retain) NSSet* GenreToTVShow;

- (void)addGenreToMovieObject:(Movie *)value;
- (void)removeGenreToMovieObject:(Movie *)value;
- (void)addGenreToMovie:(NSSet *)value;
- (void)removeGenreToMovie:(NSSet *)value;
- (void)addGenreToTVShowObject:(NSManagedObject *)value;
- (void)removeGenreToTVShowObject:(NSManagedObject *)value;
- (void)addGenreToTVShow:(NSSet *)value;
- (void)removeGenreToTVShow:(NSSet *)value;
@end

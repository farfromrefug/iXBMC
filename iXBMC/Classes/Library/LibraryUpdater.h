//
//  LibraryUpdater.h
//  iHaveNoName
//
//  Created by Martin Guillon on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSArray (movieKeyedDictionaryExtension)
- (NSDictionary *)movieKeyedDictionary;
@end

@interface LibraryUpdater : NSObject {
    
    NSOperationQueue *_moviesQueue;
    NSArray* _recentlyAddedMovies; 
    NSTimer * _updatingTimer;
    
    BOOL _updating;
}

+ (LibraryUpdater *) sharedInstance;
+ (BOOL) updating;

@property (nonatomic, retain, readonly) NSArray* recentlyAddedMovies;
@property (nonatomic, readonly) BOOL updating;

- (void)start;
- (void)stop;

- (void) updateLibrary;
- (void) updateLibrary:(NSInteger) number;
- (void) updateMovies:(NSInteger) number;
- (void) updateTVShows:(NSInteger) number;
- (void) updateRecentlyAdded;
- (void) updateRecentlyAdded:(NSInteger) number;
@end

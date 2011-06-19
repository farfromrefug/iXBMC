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
    
//    NSOperationQueue *_moviesQueue;
	dispatch_queue_t _queue;
    NSArray* _recentlyAddedMovies; 
    NSArray* _recentlyAddedEpisodes; 
    NSTimer * _updatingTimer;
	
	NSCharacterSet *_lettersCharSet;
    
    BOOL _updating;
	BOOL _valid;
	
	int _nbrunningUpdates;
}

+ (LibraryUpdater *) sharedInstance;
+ (BOOL) updating;

@property (nonatomic, retain, readonly) NSArray* recentlyAddedMovies;
@property (nonatomic, retain, readonly) NSArray* recentlyAddedEpisodes;
@property (nonatomic, readonly) BOOL updating;

- (void)start;
- (void)stop;

- (void) updateLibrary;
- (void) updateLibrary:(NSInteger) number;
- (void) updateMovies:(NSInteger) number hidden:(BOOL) hid;
- (void) updateAllTVShows:(NSInteger) number hidden:(BOOL) hid;

- (void) updateRecentlyAddedMovies:(BOOL) hid;
- (void) updateRecentlyAddedMovies:(NSInteger) number hidden:(BOOL) hid;

- (void) updateRecentlyAddedEpisodes:(BOOL) hid;
- (void) updateRecentlyAddedEpisodes:(NSInteger) number hidden:(BOOL) hid;
@end

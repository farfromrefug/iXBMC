//
//  Season.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode, TVShow;

@interface Season : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * fanart;
@property (nonatomic, retain) NSString * showtitle;
@property (nonatomic, retain) NSNumber * playcount;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSNumber * season;
@property (nonatomic, retain) NSNumber * tvshowid;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * nbepisodes;

@property (nonatomic, retain) TVShow * tvshow;
@property (nonatomic, retain) NSSet* episodes;

- (void)addEpisodesObject:(Episode *)value;
- (void)removeEpisodesObject:(Episode *)value;
- (void)addEpisodes:(NSSet *)value;
- (void)removeEpisodes:(NSSet *)value;

@end

//
//  Episode.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TVShow, Season;
@interface Episode : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * fanart;
@property (nonatomic, retain) NSString * file;
@property (nonatomic, retain) NSString * imdbid;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * episode;
@property (nonatomic, retain) NSNumber * episodeid;
@property (nonatomic, retain) NSNumber * playcount;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSString * showtitle;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSNumber * seasonid;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSString * firstaired;
@property (nonatomic, retain) NSString * writer;
@property (nonatomic, retain) NSNumber * tvshowid;
@property (nonatomic, retain) Season * season;
@property (nonatomic, retain) TVShow * tvshow;

+ (NSString*)defaultSort;

@end

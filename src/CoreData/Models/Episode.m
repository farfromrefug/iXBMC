//
//  Episode.m
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Episode.h"


@implementation Episode
@dynamic director;
@dynamic fanart;
@dynamic file;
@dynamic imdbid;
@dynamic label;
@dynamic episode;
@dynamic episodeid;
@dynamic playcount;
@dynamic plot;
@dynamic showtitle;
@dynamic rating;
@dynamic runtime;
@dynamic seasonid;
@dynamic thumbnail;
@dynamic firstaired;
@dynamic writer;
@dynamic tvshowid;
@dynamic season;
@dynamic tvshow;

+ (NSString*)defaultSort
{
    return @"season.season asc episode asc";
}

+ (NSArray*)sorts
{
    return [NSArray arrayWithObjects:[self defaultSort], nil];
}
+ (NSArray*)sortNames
{
    return [NSArray arrayWithObjects:@"Episode", nil];
}


@end

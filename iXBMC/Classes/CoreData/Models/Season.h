//
//  Season.h
//  iXBMC
//
//  Created by Martin Guillon on 6/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Episode;

@interface Season : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * fanart;
@property (nonatomic, retain) NSString * showtitle;
@property (nonatomic, retain) NSNumber * playcount;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSNumber * seasonid;
@property (nonatomic, retain) NSNumber * tvshowid;
@property (nonatomic, retain) NSManagedObject * SeasonToTVShow;
@property (nonatomic, retain) NSSet* SeasonToEpisode;

@end

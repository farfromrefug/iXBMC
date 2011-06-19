//
//  EpisodesCellView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EpisodeTableItem;
@interface EpisodeCellView : TTView {
    UIImage* _posterShadow;
    UIImage* _posterShadowSelected;
    UIImage* _newFlag;
    UIImage* _stars;
	UIImage* _line;
	EpisodeTableItem *_item;
	
	BOOL highlighted;
	BOOL editing;
}
@property (nonatomic, retain) EpisodeTableItem *item;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

- (void)loadImage;

@end

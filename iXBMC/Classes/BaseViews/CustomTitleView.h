//
//  CustomTitleView.h
//  iXBMC
//
//  Created by Martin Guillon on 5/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomTitleView : UIButton {
    UILabel* _titleLabel;
    UILabel* _subTitleLabel;   
}
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;

@end

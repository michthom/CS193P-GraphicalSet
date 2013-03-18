//
//  GSet_SetCardView.h
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSet_SetCard.h"
#import "GSet_CardView.h"

@interface GSet_SetCardView : GSet_CardView

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *colour;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) int               count;

@end

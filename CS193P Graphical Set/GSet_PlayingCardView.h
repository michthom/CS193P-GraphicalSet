//
//  GSet_PlayingCardView.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_CardView.h"

@interface GSet_PlayingCardView : GSet_CardView

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) int rank;

+ (NSString *)formattedRank:(int)rank;
+ (NSString *)formattedSuit:(NSString *)suit;

@end

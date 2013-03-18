//
//  GSet_PlayingCard.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_Card.h"

@interface GSet_PlayingCard : GSet_Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) int rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;

+ (NSUInteger)maxRank;

@end

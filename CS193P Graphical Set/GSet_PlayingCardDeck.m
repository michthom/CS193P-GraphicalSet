//
//  GSet_PlayingCardDeck.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_PlayingCardDeck.h"

@implementation GSet_PlayingCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [GSet_PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank < [GSet_PlayingCard maxRank]; rank++) {
                GSet_PlayingCard *card = [[GSet_PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card atTop:YES];
            }
        }
    }
    return self;
}

@end

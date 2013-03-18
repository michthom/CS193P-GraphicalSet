//
//  GSet_Deck.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_Deck.h"

@interface GSet_Deck()

@property (nonatomic, strong) NSMutableArray *cardsInDeck; // of Card

@end
@implementation GSet_Deck

- (NSMutableArray *)cardsInDeck
{
    if (!_cardsInDeck) {
        _cardsInDeck = [[NSMutableArray alloc] init];
    }
    return _cardsInDeck;
}

- (void)addCard:(GSet_Card *)card
          atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cardsInDeck insertObject:card atIndex:0];
    } else {
        [self.cardsInDeck addObject:card];
    }
}

- (GSet_Card *)drawRandomCard
{
    GSet_Card *randomCard = nil;
    
    if ([self.cardsInDeck count]) {
        NSUInteger index = arc4random() % [self.cardsInDeck count];
        randomCard = self.cardsInDeck[index];
        [self.cardsInDeck removeObjectAtIndex:index];
    }
    return randomCard;
}

- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] init];
    for (GSet_Card *card in self.cardsInDeck) {
        result = [[result stringByAppendingString:[card description]] mutableCopy];
    }
    result = [[result stringByAppendingFormat:@"Cards in deck: %d",[self.cardsInDeck count]] mutableCopy];
    return result;
}

@end

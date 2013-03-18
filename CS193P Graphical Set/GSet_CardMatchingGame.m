//
//  GSet_CardMatchingGame.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_CardMatchingGame.h"

@interface GSet_CardMatchingGame()

@end

@implementation GSet_CardMatchingGame

- (NSMutableArray *)cardsInPlay
{
    if (! _cardsInPlay) {
        _cardsInPlay = [[NSMutableArray alloc] init];
    }
    return _cardsInPlay;
}

- (NSMutableArray *)faceUpCards
{
    if (!_faceUpCards) {
        _faceUpCards = [[NSMutableArray alloc] init];
    }
    return _faceUpCards;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    GSet_Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        
        if (card.isFaceUp) {
            self.state = CardMatchingGameStateCardTurnedFaceDown;
            
            // Flip card down
            [self.faceUpCards removeObject:card];
            card.faceUp = !card.isFaceUp;

            self.latestScore = 0;

            self.narrative = [NSString stringWithFormat:@"%d cards face up.", [self.faceUpCards count]];
                        
        } else {
            
            NSArray *otherCards = [self.faceUpCards copy];
            
            if ([self.faceUpCards count] < self.numberOfCardsToMatch) {
                
                // Flip this card up
                self.state = CardMatchingGameStateCardTurnedFaceUp;

                self.narrative = [NSString stringWithFormat:@"Flipped up %@", [card description]];
                
                [self.faceUpCards addObject:card];
                
                self.narrative = [NSString stringWithFormat:@"%d cards face up.", [self.faceUpCards count]];
                card.faceUp = !card.isFaceUp;
                
                self.latestScore = -self.flipCostValue;
                self.score += self.latestScore;
                                
                if ([self.faceUpCards count] == self.numberOfCardsToMatch) {
                    // Have we got a match?
                                        
                    int matchScore = [card match:otherCards];
                    
                    if (matchScore) {
                        
                        self.state = CardMatchingGameStateCardsMatchedAndWereDisabled;
                        
                        self.latestScore = matchScore * self.matchBonusValue;
                        self.score += self.latestScore;

                        self.narrative = [NSString stringWithFormat:@"%d cards matched for %d points!", self.numberOfCardsToMatch, matchScore * self.matchBonusValue];
                        
                        for (GSet_Card *oneCard in self.faceUpCards) {
                            oneCard.unplayable = YES;
                        }
                        
                    } else {
                        
                        self.state = CardMatchingGameStateCardsDoNotMatch;
                        
                        self.latestScore = -self.misMatchPenaltyValue;
                        self.score += self.latestScore;
                        
                        self.narrative = [NSString stringWithFormat:@"%d cards don't match! %d point penalty.", self.numberOfCardsToMatch, self.misMatchPenaltyValue];
                    }
                }

            } else {
                self.state = CardMatchingGameStateNoChangeSinceLastTime;
                self.latestScore = 0;

                self.narrative = [NSString stringWithFormat:@"%d cards are face up already!", self.numberOfCardsToMatch];
            }            
        }
    } else {
        self.state = CardMatchingGameStateNoChangeSinceLastTime;
        self.latestScore = 0;
    }
}

// Designated initialiser!
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(GSet_Deck *)deck
{
    self = [super init];
    if (self) {
        self.state = CardMatchingGameStateInitialising;
        
        for (int i = 0; i < cardCount; i++) {
                GSet_Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                [self.cardsInPlay addObject:card];
            }
        }
    }
    return self;
}

- (GSet_Card *)cardAtIndex:(NSUInteger)index
{
    return self.cardsInPlay[index];
}

@end

//
//  GSet_CardMatchingGame.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSet_Deck.h"

@interface GSet_CardMatchingGame : NSObject

typedef NS_ENUM(NSInteger, CardMatchingGameState) {
    CardMatchingGameStateInitialising,
    CardMatchingGameStateCardTurnedFaceUp,
    CardMatchingGameStateCardTurnedFaceDown,
    CardMatchingGameStateCardsDoNotMatch,
    CardMatchingGameStateCardsMatchedAndWereDisabled,
    CardMatchingGameStateNoChangeSinceLastTime
};

@property (nonatomic) NSUInteger flipCostValue;
@property (nonatomic) NSUInteger misMatchPenaltyValue;
@property (nonatomic) NSUInteger matchBonusValue;
@property (nonatomic) NSUInteger numberOfCardsToMatch;

@property (nonatomic) NSUInteger score;

@property (nonatomic) NSInteger latestScore;

@property (nonatomic) CardMatchingGameState state;

@property (strong, nonatomic) NSMutableArray *cardsInPlay; // of Card
@property (strong, nonatomic) NSMutableArray *faceUpCards; // of Card

@property (nonatomic, strong) NSString *narrative;

- (void)flipCardAtIndex:(NSUInteger)index; // abstract

// Designated initialiser!
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(GSet_Deck *)deck;

- (GSet_Card *)cardAtIndex:(NSUInteger)index;

@end

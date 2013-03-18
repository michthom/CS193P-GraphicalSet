//
//  GSet_PlayingCard_ViewController.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_PlayingCard_ViewController.h"
#import "GSet_PlayingCard.h"
#import "GSet_PlayingCardDeck.h"
#import "GSet_CollectionView_PlayingCardCell.h"
#import "GSet_CollectionView_TextCell.h"

@implementation GSet_PlayingCard_ViewController

- (GSet_Deck *)createDeck
{
    return [[GSet_PlayingCardDeck alloc] init];
}

- (void)setupGame:(GSet_CardMatchingGame *)game
{
    game.flipCostValue = 1;
    game.misMatchPenaltyValue = 2;
    game.matchBonusValue = 4;
    game.numberOfCardsToMatch = 2;
}

- (NSUInteger)startingCardCount
{
    return 22;
}

- (void)updateCell:(UICollectionViewCell *)cell
           forCard:(GSet_Card *)card
{
    if ([cell isKindOfClass:[GSet_CollectionView_PlayingCardCell class]]) {
        
        if ([card isKindOfClass:[GSet_PlayingCard class]]) {
            
            GSet_PlayingCard *playingCard = (GSet_PlayingCard *)card;
            GSet_PlayingCardView *playingCardView = ((GSet_CollectionView_PlayingCardCell *)cell).playingCardView;
            
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.enabled = (! playingCard.isUnplayable);
                        
            [playingCardView setNeedsDisplay];
        } 
    }
}

- (void)updateCell:(UICollectionViewCell *)cell
           withText:(NSString *)text
{
    if ([cell isKindOfClass:[GSet_CollectionView_TextCell class]]) {
        UILabel *label = ((GSet_CollectionView_TextCell *)cell).statusTextLabel;
        label.text = self.statusText;
        [label setNeedsDisplay];
    }
}

- (void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

    if ([self.statusCards count] > 0) {
        [self.statusCards removeAllObjects];
    }
    for (GSet_PlayingCard *oneCard in self.game.faceUpCards) {
        [self.statusCards addObject:oneCard];
        
        [self updateCell:[self.statusCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.statusCards count]-1
                                                                                               inSection:0]]
                 forCard:oneCard];
    }
    
    switch (self.game.state) {
            
        case CardMatchingGameStateCardTurnedFaceDown:

            self.statusText = @"Card flipped down.";
            break;
            
        case CardMatchingGameStateCardTurnedFaceUp:
            
            self.statusText = @"Card flipped up.";
            break;
            
        case CardMatchingGameStateCardsDoNotMatch:

            self.statusText = [NSString stringWithFormat:@"Cards don't match. %d point penalty.", self.game.latestScore];
            break;
            
        case CardMatchingGameStateCardsMatchedAndWereDisabled:

            for (GSet_PlayingCard *oneCard in self.game.faceUpCards) {
                oneCard.faceUp = YES;
                oneCard.unplayable = YES;
            }
            
            [self.game.faceUpCards removeAllObjects];
            
            self.statusText = [NSString stringWithFormat:@"Cards matched. %d point bonus!", self.game.latestScore];
            break;
            
        case CardMatchingGameStateNoChangeSinceLastTime:

            self.statusText = @"";
            break;
            
        case CardMatchingGameStateInitialising:

            self.statusText = @"Good luck!";
            break;
            
        default:
            self.statusText = @"Error!";
            break;
    }
        
    [self.cardCollectionView reloadData];
    [self.statusCollectionView reloadData];
}

@end

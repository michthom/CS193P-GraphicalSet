//
//  GSet_SetCardViewController.m
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_SetCard_ViewController.h"
#import "GSet_SetCard.h"
#import "GSet_SetCardDeck.h"
#import "GSet_CollectionView_SetCardCell.h"
#import "GSet_CollectionView_TextCell.h"

@implementation GSet_SetCard_ViewController

- (GSet_Deck *)createDeck
{
    return [[GSet_SetCardDeck alloc] init];
}

- (void)setupGame:(GSet_CardMatchingGame *)game
{
    game.flipCostValue = 1;
    game.misMatchPenaltyValue = 2;
    game.matchBonusValue = 12;
    game.numberOfCardsToMatch = 3;
}

- (NSUInteger)startingCardCount
{
    return 12;
}

- (void)updateCell:(UICollectionViewCell *)cell
           forCard:(GSet_Card *)card
{
    if ([cell isKindOfClass:[GSet_CollectionView_SetCardCell class]]) {
        
        if ([card isKindOfClass:[GSet_SetCard class]]) {
            
            GSet_SetCard *setCard = (GSet_SetCard *)card;
            GSet_SetCardView *setCardView = ((GSet_CollectionView_SetCardCell *)cell).setCardView;
            
            setCardView.shape = setCard.shape;
            setCardView.colour = setCard.colour;
            setCardView.shading = setCard.shading;
            setCardView.count = setCard.count;
            
            setCardView.faceUp = setCard.isFaceUp;
            setCardView.enabled = (! setCard.isUnplayable);
            
            [setCardView setNeedsDisplay];
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

    for (GSet_SetCard *oneCard in self.game.faceUpCards) {
        
        [self.statusCards addObject:oneCard];
        
        [self updateCell:[self.statusCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.statusCards count]-1
                                                                                               inSection:0]]
                 forCard:oneCard];
    }

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    
    for (int i=0; i < [self.game.cardsInPlay count]; i++) {
        if ([[self.game cardAtIndex:i] isUnplayable]) {
            [indexSet addIndex:i];
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
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
            
            for (GSet_SetCard *oneCard in self.game.faceUpCards) {
                oneCard.faceUp = YES;
                oneCard.unplayable = YES;
            }
            
            // FIXME: Need to remove the matched cards from cardsInPlay
            if ([indexSet count] > 0) {
                [self.game.cardsInPlay removeObjectsAtIndexes:indexSet];
            }
            
            if ([indexPaths count] > 0) {
                [self.cardCollectionView performBatchUpdates:^{
                    [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths];
                } completion:nil];
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

- (NSAttributedString *)attributedContentsOfSetCard:(GSet_SetCard *)card
{
    NSString *newText = [card contents];
    
    NSRange range = [newText rangeOfString:newText];
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:newText];
    
    if ((range.location != NSNotFound)) {
        // Need to create the AtributedString here...
        
        CGFloat alpha;
        UIColor *strokeColour;
        UIColor *fillColour;
        
        
        // NSStrokeWidthAttributeName : @(-2.0)
        // NSStrokeColorAttributeName :
        
        if ([card.shading isEqualToString:@"solid"]) {
            alpha = 1.0;
        } else if ([card.shading isEqualToString:@"striped"]) {
            alpha = 0.3;
        } else if ([card.shading isEqualToString:@"hollow"]) {
            alpha = 0.0;
        } else {
            // Something went wrong
            alpha = 0.1;
        }
        
        if ([card.colour isEqualToString:@"red"]) {
            strokeColour = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0];
            fillColour = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:alpha];
            
        } else if ([card.colour isEqualToString:@"green"]) {
            strokeColour = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:1.0];
            fillColour = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:alpha];
            
        } else if ([card.colour isEqualToString:@"purple"]) {
            strokeColour = [UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:1.0];
            fillColour = [UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:alpha];
            
        } else {
            // Something went wrong
            strokeColour = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0];
            fillColour = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alpha];
        }
        
        NSDictionary *attributes = @{ NSStrokeColorAttributeName : strokeColour,
                                      NSStrokeWidthAttributeName : @-10.0f,
                                      NSForegroundColorAttributeName : fillColour,
                                      };
        
        [result addAttributes:attributes range:range];
    }
    return result;
}

@end

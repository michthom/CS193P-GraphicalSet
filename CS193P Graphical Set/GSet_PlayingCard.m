//
//  GSet_PlayingCard.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_PlayingCard.h"

@implementation GSet_PlayingCard

@synthesize suit = _suit; // Because we implemented BOTH setter and getter

- (NSString *)contents
{
    NSArray *rankStrings = [GSet_PlayingCard rankStrings];
    NSMutableString *result = [NSString stringWithFormat:@"%@", rankStrings[self.rank]];
    return [result stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[GSet_PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(int)rank
{
    if (rank < [GSet_PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 1) {
        // Match one other card only
        GSet_PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    } else if ([otherCards count] == 2) {
        // Match two other cards only
        GSet_PlayingCard *otherOne = otherCards[0];
        GSet_PlayingCard *otherTwo = otherCards[1];
        
        //Three ranks match
        if ( ( otherOne.rank == self.rank ) &
            ( otherTwo.rank == self.rank ) )
        {
            score = 10;
            return score;
        }
        
        //Three suits match
        if ( ( [otherOne.suit isEqualToString:self.suit] ) &
            ( [otherTwo.suit isEqualToString:self.suit] ) )
        {
            score = 5;
            return score;
        }
        
        //Two ranks match & two suits match
        if (
            (
             ( [otherOne.suit isEqualToString:self.suit]     ) |
             ( [otherTwo.suit isEqualToString:self.suit]     ) |
             ( [otherOne.suit isEqualToString:otherTwo.suit] )
             )
            & // AND
            (
             ( otherOne.rank == self.rank     ) |
             ( otherTwo.rank == self.rank     ) |
             ( otherOne.rank == otherTwo.rank )
             )
            )
        {
            score = 2;
            return score;
        }
    }
    return score;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[GSet_PlayingCard class]]) {
        GSet_PlayingCard *card = (GSet_PlayingCard *)object;
        if (([self.suit isEqualToString:card.suit]) && (self.rank == card.rank)) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)description
{
    return [self contents];
}

+ (NSArray *)validSuits
{
    return @[ @"C", @"D", @"H", @"S" ];
}

+ (NSArray *)rankStrings
{
    return @[ @"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K" ];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count];
}

@end

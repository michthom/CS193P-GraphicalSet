//
//  GSet_SetCard.m
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_SetCard.h"

@implementation GSet_SetCard

@synthesize shape = _shape; // Because we implemented BOTH setter and getter

- (void)setShape:(NSString *)shape
{
    if ([[GSet_SetCard validShapes] containsObject:shape]) {
        _shape = shape;
    }
}

- (NSString *)shape
{
    return _shape ? _shape : @"?";
}

- (NSString *)colour
{
    return _colour ? _colour : @"?";
}

- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Silence Xcode warnings about variables being used uninitialised
    BOOL shapesAllMatch = NO, coloursAllMatch = NO, shadingsAllMatch = NO, numbersAllMatch = NO;
    BOOL shapesAllDiffer  = NO, coloursAllDiffer = NO, shadingsAllDiffer = NO, numbersAllDiffer = NO;
    
    //    @property (strong, nonatomic) NSString *shape;
    //    @property (strong, nonatomic) NSString *colour;
    //    @property (strong, nonatomic) NSString *shading;
    //    @property (nonatomic) int               count;
    
    //    A set satisfies ALL of:
    //    They all have the same number, or they have three different numbers.
    //    They all have the same symbol, or they have three different symbols.
    //    They all have the same shading, or they have three different shadings.
    //    They all have the same color, or they have three different colors.
    //    The rules of Set are summarized by:
    //    If you can sort a group of three cards into "Two of ____ and one of _____," then it is not a set.
    
    //    For example, these three cards form a set:
    //    One red striped diamond
    //    Two red solid diamonds
    //    Three red open diamonds
    //    Given any two cards from the deck, there will be one and only one other card that forms a set with them.
    
    //    10% of possible sets differ in one feature, 30% in two features, 40% in three features, and 20% in all four features.
    
    if ([otherCards count] == 2) {
        GSet_SetCard *a, *b, *c;
        
        a = self;
        b = otherCards[0];
        c = otherCards[1];
        
        // Shape checks
        if ([a.shape isEqualToString:b.shape]) {
            if ([a.shape isEqualToString:c.shape]) {
                shapesAllMatch = YES;
            }
        } else {
            if ( ([a.shape isEqualToString:c.shape]) || ([b.shape isEqualToString:c.shape]) ){
                shapesAllMatch = NO;
                shapesAllDiffer = NO;
            } else {
                shapesAllDiffer = YES;
            }
        }
        
        // Colour checks
        if ([a.colour isEqualToString:b.colour]) {
            if ([a.colour isEqualToString:c.colour]) {
                coloursAllMatch = YES;
            }
        } else {
            if ( ([a.colour isEqualToString:c.colour]) || ([b.colour isEqualToString:c.colour]) ){
                coloursAllMatch = NO;
                coloursAllDiffer = NO;
            } else {
                coloursAllDiffer = YES;
            }
        }
        
        // Shading checks
        if ([a.shading isEqualToString:b.shading]) {
            if ([a.shading isEqualToString:c.shading]) {
                shadingsAllMatch = YES;
            }
        } else {
            if ( ([a.shading isEqualToString:c.shading]) || ([b.shading isEqualToString:c.shading]) ){
                shadingsAllMatch = NO;
                shadingsAllDiffer = NO;
            } else {
                shadingsAllDiffer = YES;
            }
        }
        
        // Number checks
        if (a.count == b.count) {
            if (a.count == c.count) {
                numbersAllMatch = YES;
            }
        } else {
            if ( (a.count == c.count) || (b.count == c.count) ){
                numbersAllMatch = NO;
                numbersAllDiffer = NO;
            } else {
                numbersAllDiffer = YES;
            }
        }
        
    } else {
        // Whoops
        NSLog(@"Something very wrong here... matching cards <> 3");
    }
    
    //    NSLog(@"Attribute checks: Shapes (%@) Colours (%@) Shadings (%@) Numbers (%@)",(shapesAllMatch ? @"X" : @" "), (coloursAllMatch ? @"X" : @" "), (shadingsAllMatch ? @"X" : @" "), (numbersAllMatch ? @"X" : @" "));
    
    if ((   shapesAllMatch ||   shapesAllDiffer ) &&
        (  coloursAllMatch ||  coloursAllDiffer ) &&
        ( shadingsAllMatch || shadingsAllDiffer ) &&
        (  numbersAllMatch ||  numbersAllDiffer ) ) {
        
        // We have a Set
        
        if (( ( shapesAllDiffer ) &&   coloursAllMatch    &&   shadingsAllMatch    &&   numbersAllMatch    ) ||
            (   shapesAllMatch    && ( coloursAllDiffer ) &&   shadingsAllMatch    &&   numbersAllMatch    ) ||
            (   shapesAllMatch    &&   coloursAllMatch    && ( shadingsAllDiffer ) &&   numbersAllMatch    ) ||
            (   shapesAllMatch    &&   coloursAllMatch    &&   shadingsAllMatch    && ( numbersAllDiffer ) ) ) {
            
            // Score 12 - 10% of possible sets differ in one feature,
            score = 12;
        }
        
        if ( shapesAllDiffer && coloursAllDiffer && shadingsAllDiffer && numbersAllDiffer ) {
            // Score  6 - 20% of possible sets differ in all four features.
            score = 6;
        }
        
        if (
            (   shapesAllMatch    &&   coloursAllMatch    && ( shadingsAllDiffer ) && ( numbersAllDiffer ) ) ||
            (   shapesAllMatch    && ( coloursAllDiffer ) &&   shadingsAllMatch    && ( numbersAllDiffer ) ) ||
            (   shapesAllMatch    && ( coloursAllDiffer ) && ( shadingsAllDiffer ) &&   numbersAllMatch    ) ||
            ( ( shapesAllDiffer ) &&   coloursAllMatch    &&   shadingsAllMatch    && ( numbersAllDiffer ) ) ||
            ( ( shapesAllDiffer ) &&   coloursAllMatch    && ( shadingsAllDiffer ) &&   numbersAllMatch    ) ||
            ( ( shapesAllDiffer ) && ( coloursAllDiffer ) &&   shadingsAllMatch    &&   numbersAllMatch    ) ) {
            
            // Score  4 - 30% of possible sets differ in two features,
            score = 4;
        }
        
        if ((   shapesAllMatch    && ( coloursAllDiffer ) && ( shadingsAllDiffer ) && ( numbersAllDiffer ) ) ||
            ( ( shapesAllDiffer ) &&   coloursAllMatch    && ( shadingsAllDiffer ) && ( numbersAllDiffer ) ) ||
            ( ( shapesAllDiffer ) && ( coloursAllDiffer ) &&   shadingsAllMatch    && ( numbersAllDiffer ) ) ||
            ( ( shapesAllDiffer ) && ( coloursAllDiffer ) && ( shadingsAllDiffer ) &&   numbersAllMatch  ) ) {
            
            // Score  3 - 40% of possible sets differ in three features.
            score = 3;
        }
        
    } else {
        score = 0;
    }
    
    return score;
}

- (NSString *)contents
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:self.shape];
    
    for (int repeat = 1; repeat < self.count; repeat++) {
        [result appendString:self.shape];
    }
    
    return result;
}


- (NSString *)description
{
    NSMutableString *result = [[NSMutableString alloc] initWithString:@"("];
    
    [result appendFormat:@"%@)", [self contents]];
    
    return result;
}

+ (NSArray *)validShapes
{
    return @[ @"diamond", @"squiggle", @"oval" ];
}

+ (NSArray *)validColours
{
    return @[ @"red", @"green", @"purple" ];
}

+ (NSArray *)validShadings
{
    return @[ @"solid", @"striped", @"hollow" ];
}

+ (NSUInteger)maxCount
{
    return 3;
}

@end

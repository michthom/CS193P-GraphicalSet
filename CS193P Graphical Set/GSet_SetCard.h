//
//  GSet_SetCard.h
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSet_Card.h"

@interface GSet_SetCard : GSet_Card

@property (strong, nonatomic) NSString *contents;

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *colour;
@property (strong, nonatomic) NSString *shading;
@property (nonatomic) int               count;

- (int)match:(NSArray *)otherCards;

+ (NSArray *)validShapes;
+ (NSArray *)validColours;
+ (NSArray *)validShadings;
+ (NSUInteger)maxCount;

@end

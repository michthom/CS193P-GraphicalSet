//
//  GSet_SetCardDeck.m
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_SetCardDeck.h"
#import "GSet_SetCard.h"

@implementation GSet_SetCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        
        for (NSString *shape in [GSet_SetCard validShapes]) {
            for (NSString *colour in [GSet_SetCard validColours]) {
                for (NSString *shading in [GSet_SetCard validShadings]) {
                    for (NSUInteger count = 1; count <= [GSet_SetCard maxCount]; count++) {
                        GSet_SetCard *card = [[GSet_SetCard alloc] init];
                        
                        card.shape = shape;
                        card.colour = colour;
                        card.shading = shading;
                        card.count = count;
                        
                        [self addCard:card atTop:YES];
                        
                    }
                }
            }
        }
    }
    return self;
}

@end

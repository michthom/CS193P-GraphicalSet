//
//  GSet_Card.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_Card.h"

@implementation GSet_Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (GSet_Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

@end

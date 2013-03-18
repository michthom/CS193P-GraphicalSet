//
//  GSet_Deck.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSet_Card.h"

@interface GSet_Deck : NSObject

- (void)addCard:(GSet_Card *)card atTop:(BOOL)atTop;
- (GSet_Card *)drawRandomCard;

@end

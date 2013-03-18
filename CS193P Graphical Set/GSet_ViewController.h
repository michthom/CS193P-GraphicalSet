//
//  GSet_ViewController.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSet_Deck.h"
#import "GSet_CardMatchingGame.h"

@interface GSet_ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *statusCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (strong, nonatomic) GSet_CardMatchingGame *game;
@property (strong, nonatomic) GSet_Deck *deck;

@property (nonatomic, strong) NSMutableArray *statusCards;
@property (nonatomic, strong) NSString *statusText;

// Abstract property / methods
@property (nonatomic) NSUInteger startingCardCount;
- (GSet_Deck *)createDeck;
- (void)setupGame:(GSet_CardMatchingGame *)game;
- (void)updateCell:(UICollectionViewCell *)cell
           forCard:(GSet_Card *)card;
- (void)updateCell:(UICollectionViewCell *)cell
          withText:(NSString *)text;
- (void)updateUI;
@end
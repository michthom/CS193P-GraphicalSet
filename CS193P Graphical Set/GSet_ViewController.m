//
//  GSet_ViewController.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_ViewController.h"

@interface GSet_ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation GSet_ViewController

- (NSMutableArray *)statusCards
{
    if (!_statusCards) {
        _statusCards = [[NSMutableArray alloc] init];
    }
    return _statusCards;
}

- (GSet_Deck *)createDeck
{
    // Abstract method
    return nil;
}

- (void)updateCell:(UICollectionViewCell *)cell
           forCard:(GSet_Card *)card
{
    // Abstract method
}

- (void)updateCell:(UICollectionViewCell *)cell
          withText:(NSString *)text
{
    // Abstract method
}

- (void)setupGame:(GSet_CardMatchingGame *)game
{
    // Abstract method
}

- (void)updateUI
{
    // Abstract method
}

- (GSet_CardMatchingGame *)game
{
    if (!_game) {
        self.deck = [self createDeck];
        _game = [[GSet_CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:self.deck];
        [self setupGame:_game];
    }
    return _game;
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.cardCollectionView];
    
    // We only want touches for cards that are visible in the cardCollectionView
    if ([self.cardCollectionView pointInside:tapLocation withEvent:nil]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
        
        if (indexPath) {
            [self.game flipCardAtIndex:indexPath.item];
        }
        [self updateUI];
    }
}

// Protocol methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize result = CGSizeZero;
    if ([collectionView isEqual:self.statusCollectionView]) {
        if (indexPath.item == [self.statusCollectionView numberOfItemsInSection:0] - 1) {
            result = CGSizeMake(150, 50);
        } else {
            result = CGSizeMake(34, 50);
        }
    }
    if ([collectionView isEqual:self.cardCollectionView]) {
        result = CGSizeMake(64, 96);
    }
    return result;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.cardCollectionView]) {
        return [self.game.cardsInPlay count];
    }
    if ([collectionView isEqual:self.statusCollectionView]) {
        return [self.statusCards count] + 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if ([collectionView isEqual:self.cardCollectionView]) {
        cell = [self.cardCollectionView dequeueReusableCellWithReuseIdentifier:@"CardCell" forIndexPath:indexPath];
        
        GSet_Card *card = [self.game cardAtIndex:indexPath.item];
        
        [self updateCell:cell forCard:card];
    }
    
    if ([collectionView isEqual:self.statusCollectionView]) {
        if ( indexPath.item == [self.statusCollectionView numberOfItemsInSection:0] - 1){
            cell = [self.statusCollectionView dequeueReusableCellWithReuseIdentifier:@"StatusTextCell" forIndexPath:indexPath];
            
            [self updateCell:cell withText:self.statusText];
        } else {
            // List of cards
            cell = [self.statusCollectionView dequeueReusableCellWithReuseIdentifier:@"StatusCardCell" forIndexPath:indexPath];
            
            GSet_Card *card = [self.statusCards objectAtIndex:indexPath.item];
            
            [self updateCell:cell forCard:card];
        }
    }
    return cell;
}

- (IBAction)dealPressed:(UIButton *)sender
{
    self.game = nil;
    [self.cardCollectionView reloadData];
    
    self.statusCards = nil;
    self.statusText = nil;
    
    [self.statusCollectionView reloadData];
    
    [self.moreButton setAlpha:1.0f];
    [self.moreButton setEnabled:YES];
    [self updateUI];
}

- (IBAction)morePressed:(UIButton *)sender
{
    for (int moreCards = self.game.numberOfCardsToMatch; moreCards > 0; moreCards--) {
        GSet_Card *newCard = [self.deck drawRandomCard];
        if (newCard) {
            [self.game.cardsInPlay addObject:newCard];
            [self.cardCollectionView reloadData];
            
            [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.game.cardsInPlay count] - 1
                                                                                 inSection:0]
                                            atScrollPosition:UICollectionViewScrollPositionBottom
                                                    animated:YES];
        } else {
            [self.moreButton setAlpha:0.3f];
            [self.moreButton setEnabled:NO];
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

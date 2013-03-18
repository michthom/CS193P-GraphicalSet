//
//  GSet_CollectionView_PlayingCardCell.h
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSet_PlayingCardView.h"

@interface GSet_CollectionView_PlayingCardCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet GSet_PlayingCardView *playingCardView;

@end

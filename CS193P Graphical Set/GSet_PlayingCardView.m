//
//  GSet_PlayingCardView.m
//  Graphical Set
//
//  Created by Michael Thomson on 26/02/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_PlayingCardView.h"
#import "GSet_PlayingCard.h"

@implementation GSet_PlayingCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialisation code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0f];
     
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);

    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
        
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@.jpg", self.suit, [GSet_PlayingCardView formattedRank:self.rank]]];
        
        if (faceImage) {
            CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * 0.20, self.bounds.size.height * 0.20);
            [faceImage drawInRect:imageRect];
        } else {
            [self drawPips];
        }
        [self drawCorners];
        
    } else {
        UIImage *backImage = [UIImage imageNamed:@"cardback.png"];
        
        if (backImage) {
            [backImage drawInRect:self.bounds];
        }
    }
    
    if (self.enabled) {
        self.alpha = 1.0f;
    } else {
        self.alpha = 0.3f;
    }
}

#pragma mark - Draw Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) ||
        (self.rank == 3) ||
        (self.rank == 5) ||
        (self.rank == 9)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) ||
        (self.rank == 7) ||
        (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) ||
        (self.rank == 3) ||
        (self.rank == 7) ||
        (self.rank == 8) ||
        (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) ||
        (self.rank == 5) ||
        (self.rank == 6) ||
        (self.rank == 7) ||
        (self.rank == 8) ||
        (self.rank == 9) ||
        (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) ||
        (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
#define PIP_FONT_SCALE_FACTOR 0.17
    if (upsideDown) [self pushContextAndRotate];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont systemFontOfSize:self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:[GSet_PlayingCardView formattedSuit:self.suit] attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    UIFont *cornerfont = [UIFont systemFontOfSize:self.bounds.size.width * 0.15f];
    
    NSArray *rankStrings = [GSet_PlayingCard rankStrings];
    NSMutableString *rankString = [NSString stringWithFormat:@"%@", rankStrings[self.rank]];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", rankString, [GSet_PlayingCardView formattedSuit:self.suit]] attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerfont }];

    CGRect textBounds;
    
    textBounds.origin = CGPointMake(2.0f, 2.0f);
    textBounds.size = [cornerText size];
    
    [cornerText drawInRect:textBounds];
    [self pushContextAndRotate];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

- (void)pushContextAndRotate
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

+ (NSString *)formattedRank:(int)rank
{
    NSString *result = [[NSString alloc] init];
    
    switch (rank) {
        case 1:
            result = [result stringByAppendingString:@"A"];
            break;
        case 2 ... 10:
            result = [result stringByAppendingFormat:@"%d", rank];
            break;
        case 11:
            result = [result stringByAppendingString:@"J"];
            break;
        case 12:
            result = [result stringByAppendingString:@"Q"];
            break;
        case 13:
            result = [result stringByAppendingString:@"K"];
            break;
        default:
            result = [result stringByAppendingString:@"?"];
            break;
    }
    return result;
}

+ (NSString *)formattedSuit:(NSString *)suit;
{
    NSString *result = [[NSString alloc] init];

    if ([suit isEqualToString:@"C"]) {
        result = [result stringByAppendingString:@"♣"];
    } else if ([suit isEqualToString:@"D"]) {
        result = [result stringByAppendingString:@"♦"];
    } else if ([suit isEqualToString:@"H"]) {
        result = [result stringByAppendingString:@"♥"];
    } else if ([suit isEqualToString:@"S"]) {
        result = [result stringByAppendingString:@"♠"];
    } else {
        result = [result stringByAppendingString:@"?"];
    }
    
    return result;
}

@end

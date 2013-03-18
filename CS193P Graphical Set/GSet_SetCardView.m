//
//  GSet_SetCardView.m
//  Graphical Set
//
//  Created by Michael Thomson on 06/03/2013.
//  Copyright (c) 2013 Michael Thomson. All rights reserved.
//

#import "GSet_SetCardView.h"

@implementation GSet_SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:10.0f];
    
    [roundedRect addClip];
    
    if (self.faceUp) {
        
#define FACEUP_RED   212
#define FACEUP_GREEN 246
#define FACEUP_BLUE  249
#define FACEUP_ALPHA   1

        [[UIColor colorWithRed:  FACEUP_RED/255.0f
                         green:FACEUP_GREEN/255.0f
                          blue: FACEUP_BLUE/255.0f
                         alpha:FACEUP_ALPHA/  1.0f] setFill];
    } else {
        
        [[UIColor whiteColor] setFill];
        
    }
    
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    CGFloat centreY = self.bounds.size.height / 2.0f;

    CGFloat symbolX = self.bounds.size.width / 2.0f;
    CGFloat symbolY = self.bounds.size.height / 6.0f;
    
    CGFloat spacingY = self.bounds.size.height / 20.0f;
    
    CGFloat offsetX = (self.bounds.size.width - symbolX ) / 2.0f;
    CGFloat offsetY = 0.0f;
    
    offsetY = - (self.count) * (symbolY / 2.0f);
    
    if (self.count > 1) {
        offsetY = offsetY - (self.count - 1) * spacingY / 2.0f;
    }
    
    CGRect symbolRect = CGRectMake(0.0f, 0.0f, symbolX, symbolY);

    // Create path(s) in symbolRect
    UIBezierPath *clippingPath = [self createClippingPathInRect:symbolRect
                                                       forShape:self.shape];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int index=0; index < self.count; index++) {

        // Push the graphics context
        CGContextSaveGState(context);

        // Need to offset Y by centreY+offsetY+(index * symbolY)
        CGFloat newY = centreY+offsetY+(index * symbolY);
        if (index > 0) {
            newY = newY + index * spacingY;
        }
        
        CGContextTranslateCTM(context, offsetX, newY);

        UIColor *shapeStrokeColour = [[UIColor alloc] init];
        UIColor *shapeFillColour   = [[UIColor alloc] init];
        
        if ([self.colour isEqualToString:@"red"]) {
            shapeStrokeColour = [UIColor redColor];
        } else if ([self.colour isEqualToString:@"green"]) {
            shapeStrokeColour = [UIColor greenColor];
        } else if ([self.colour isEqualToString:@"purple"]) {
            shapeStrokeColour = [UIColor purpleColor];
        } else {
            // Sign of trouble
            shapeStrokeColour = [UIColor blackColor];
        }

        [shapeStrokeColour setStroke];

        if ([self.shading isEqualToString:@"hollow"]) {
            shapeFillColour = [UIColor whiteColor];
            [shapeFillColour setFill];
            
            [clippingPath setLineWidth:3.0f];
            [clippingPath fill];
            [clippingPath stroke];

        } else if ([self.shading isEqualToString:@"striped"]) {
            shapeFillColour = [UIColor whiteColor];
            [shapeFillColour setFill];
            [clippingPath addClip];
            
            [clippingPath fill];
            
            UIBezierPath *shading = [[UIBezierPath alloc] init];
            
            CGFloat shadingX = symbolRect.origin.x;

            while (shadingX < symbolRect.size.width) {
                [shading moveToPoint:CGPointMake(shadingX, 0.0f)];
                [shading addLineToPoint:CGPointMake(shadingX, symbolRect.size.height)];
                shadingX = shadingX + (int)(symbolRect.size.width / 10.0f);
            }
            [shading stroke];
            
            [clippingPath setLineWidth:3.0f];
            [clippingPath stroke];
            
        } else if ([self.shading isEqualToString:@"solid"]) {
            shapeFillColour = shapeStrokeColour;
            [shapeFillColour setFill];
            
            [clippingPath setLineWidth:3.0f];
            [clippingPath fill];
            [clippingPath stroke];
            
        } else {
            // Sign of trouble
            shapeFillColour = [UIColor blackColor];
        }

        // Pop the graphics context
        CGContextRestoreGState(context);
    }
}

- (UIBezierPath *)createClippingPathInRect:(CGRect)rect
                                  forShape:(NSString *)shape
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    if ([self.shape isEqualToString:@"diamond"]) {
        [path moveToPoint:    CGPointMake(                   0.0f, height          /   2.0f)];
        [path addLineToPoint: CGPointMake(width            / 2.0f,                     0.0f)];
        [path addLineToPoint: CGPointMake(width                  , height          /   2.0f)];
        [path addLineToPoint: CGPointMake(width            / 2.0f, height                  )];
        [path closePath];
    } else if ([self.shape isEqualToString:@"squiggle"]) {
        [path moveToPoint:    CGPointMake(width *  42.5f / 100.0f, height *  15.0f / 100.0f)];
        [path addCurveToPoint:CGPointMake(width *  97.5f / 100.0f, height *  15.0f / 100.0f)
                controlPoint1:CGPointMake(width *  77.5f / 100.0f, height *  50.0f / 100.0f)
                controlPoint2:CGPointMake(width *  87.5f / 100.0f, height * -30.0f / 100.0f)];
        [path addCurveToPoint:CGPointMake(width *  47.5f / 100.0f, height *  80.0f / 100.0f)
                controlPoint1:CGPointMake(width * 107.5f / 100.0f, height *  60.0f / 100.0f)
                controlPoint2:CGPointMake(width *  80.0f / 100.0f, height * 110.0f / 100.0f)];
        [path addCurveToPoint:CGPointMake(width *   2.5f / 100.0f, height *  85.0f / 100.0f)
                controlPoint1:CGPointMake(width *  22.5f / 100.0f, height *  60.0f / 100.0f)
                controlPoint2:CGPointMake(width *  10.0f / 100.0f, height * 125.0f / 100.0f)];
        [path addCurveToPoint:CGPointMake(width *  42.5f / 100.0f, height *  15.0f / 100.0f)
                controlPoint1:CGPointMake(width *  -7.5f / 100.0f, height *  45.0f / 100.0f)
                controlPoint2:CGPointMake(width *  10.0f / 100.0f, height * -20.0f / 100.0f)];
        [path closePath];
        
    } else if ([self.shape isEqualToString:@"oval"]) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect
                                          cornerRadius:height / 2.0f];
    }    
    return path;
}

@end

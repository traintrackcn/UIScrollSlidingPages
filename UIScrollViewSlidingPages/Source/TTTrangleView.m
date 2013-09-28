//
//  TTSlidingArrowView.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-8-27.
//  Copyright (c) 2013年 Thomas Thorpe. All rights reserved.
//

#import "TTTrangleView.h"

@implementation TTTrangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"layoutSubviews");
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"draw rect w %f h %f", rect.size.width, rect.size.height);
    
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize s = rect.size;
    CGFloat padding = 8.0;
    CGFloat lineW = 3.0;
    CGFloat y = s.height;
    
    
    UIColor *c = [UIColor colorWithWhite:153.0/255.0 alpha:1.0];
    CGFloat middleX = s.width/2.0;
    CGFloat halfTrangleW = [self trangleW]/2;
    CGFloat titleStartX = (s.width - self.titleW)/2.0;
    CGFloat titleEndX = titleStartX + self.titleW;
    CGFloat trangleStartX = middleX-halfTrangleW;
    CGFloat trangleEndX = middleX+halfTrangleW;
    
    CGPoint p1 = CGPointMake(padding, y);
    CGPoint p2 = CGPointMake(titleStartX, y);
    CGPoint p4 = CGPointMake(titleEndX, y);
    CGPoint p5 = CGPointMake(s.width-padding, y);
    
    // H line
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, [c CGColor]);
    CGContextSetLineWidth(ctx, lineW);
    
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    
    CGContextMoveToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    // highlight H line

    c = [UIColor colorWithRed:218.0/255.0 green:67.0/255.0 blue:38.0/255.0 alpha:1.0];
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, [c CGColor]);
    CGContextSetLineWidth(ctx, lineW);
    
    CGContextMoveToPoint(ctx, titleStartX, y);
    CGContextAddLineToPoint(ctx, trangleStartX, y);
    
    CGContextMoveToPoint(ctx, trangleEndX, y);
    CGContextAddLineToPoint(ctx, titleEndX, y);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    
    // Trangle
    CGPoint pA = CGPointMake(trangleStartX, y);
    CGPoint pB = CGPointMake(middleX, 0+1);
    CGPoint pC = CGPointMake(trangleEndX, y);
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, [c CGColor]);
    CGContextSetLineWidth(ctx, lineW-1);
    CGContextSetFillColorWithColor(ctx, [self trangleColor].CGColor);
    CGContextMoveToPoint(ctx, pA.x, pA.y);
    CGContextAddLineToPoint(ctx, pB.x, pB.y);
    CGContextAddLineToPoint(ctx, pC.x, pC.y);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
}





@end

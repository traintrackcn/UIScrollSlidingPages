//
//  TTSlidingArrowView.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-8-27.
//  Copyright (c) 2013年 Thomas Thorpe. All rights reserved.
//

#import "TTArrowView.h"

@implementation TTArrowView

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
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize s = rect.size;
    
    UIColor *c = [UIColor colorWithWhite:216.0/255.0 alpha:1.0];
    CGFloat middleX = s.width/2.0;
    CGFloat halfTrangleW = [self trangleW]/2;
    
    CGPoint p1 = CGPointMake(0, 0);
    CGPoint p2 = CGPointMake(middleX-halfTrangleW, 0);
    CGPoint p3 = CGPointMake(middleX, s.height);
    CGPoint p4 = CGPointMake(middleX+halfTrangleW, 0);
    CGPoint p5 = CGPointMake(s.width, 0);
    
    // H line
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, [c CGColor]);
    CGContextSetLineWidth(ctx, 1.0);
//    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextMoveToPoint(ctx, p1.x, p1.y);
    CGContextAddLineToPoint(ctx, p2.x, p2.y);
//    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextMoveToPoint(ctx, p4.x, p4.y);
    CGContextAddLineToPoint(ctx, p5.x, p5.y);
    CGContextStrokePath(ctx);
//    CGContextFillPath(ctx);
    CGContextRestoreGState(ctx);
    
    
    // Trangle
    
    CGContextSaveGState(ctx);
    CGContextSetStrokeColorWithColor(ctx, [c CGColor]);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetFillColorWithColor(ctx, [self trangleColor].CGColor);
    CGContextMoveToPoint(ctx, p2.x, p2.y);
    CGContextAddLineToPoint(ctx, p3.x, p3.y);
    CGContextAddLineToPoint(ctx, p4.x, p4.y);
//    CGContextAddLineToPoint(ctx, p2.x, p2.y);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
}





@end

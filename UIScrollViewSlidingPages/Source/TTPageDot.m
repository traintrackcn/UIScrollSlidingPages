//
//  TTPageDot.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-9-4.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

#import "TTPageDot.h"
#import <QuartzCore/QuartzCore.h>
#import "TTAnimation.h"


@interface TTPageDot(){
//    CGFloat bgAlpha;
}

@end

@implementation TTPageDot

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFont:[UIFont boldSystemFontOfSize:10.0]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        
    }
}

//- (void)setBackgroundAlpha:(CGFloat)alpha{
//    NSLog(@"alpha->%f",alpha);
//    bgAlpha = alpha;
//    [self setNeedsDisplay];
//}

- (void)setSelected:(BOOL)selected{
    if (_selected == selected) return;
    _selected = selected;
    
    
    if ([self selected]) {
        [self setTextColor:[UIColor whiteColor]];
    }else{
        [self setTextColor:[UIColor blackColor]];
    }
    
    [self setNeedsDisplay];

}


- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if (self.selected) {
        CGFloat padding = 1.0;
        rect.origin = CGPointMake(rect.origin.x+padding, rect.origin.y+padding);
        rect.size = CGSizeMake(rect.size.width- padding*2, rect.size.height-padding*2);
        [self drawEclipse:ctx rect:rect fillColor:[UIColor colorWithRed:1.0 green:0 blue:0 alpha:1]];
    }
    
    
    
    [super drawRect:rect];
}


- (void)drawEclipse:(CGContextRef)c rect:(CGRect)rect fillColor:(UIColor *)fillColor{
    CGContextSaveGState(c);
    CGContextSetFillColorWithColor(c, [fillColor CGColor]);
    CGContextFillEllipseInRect(c, rect);
    CGContextRestoreGState(c);
}


@end

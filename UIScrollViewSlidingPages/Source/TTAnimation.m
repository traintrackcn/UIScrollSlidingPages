//
//  TTAnimation.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-9-4.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

#import "TTAnimation.h"

@implementation TTAnimation


//- (void)setRadius:(CGFloat)radius{
//    _radius = radius;
//    NSLog(@"radius -> %f", radius);
//}


- (void)drawInContext:(CGContextRef)ctx{
     NSLog(@"radius -> %f", [self radius]);
}


//- (BOOL)needsDisplayFo

+ (BOOL)needsDisplayForKey:(NSString *)key{
    if ([key isEqualToString:@"radius"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}



@end

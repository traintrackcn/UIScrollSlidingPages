//
//  TTPageControl.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-9-4.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

#import "TTPageControl.h"
#import "TTPageDot.h"

@interface TTPageControl(){
    NSMutableArray *dots;
    int touchedIndex;
    int displayedIndex;
}

@end

@implementation TTPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setMultipleTouchEnabled:NO];
    }
    return self;
}



- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview) {
        [self assmble];
    }
}


#pragma mark - assemblors

- (void)assmble{
    dots = [NSMutableArray arrayWithCapacity:[self countOfTitles]];
    for ( int i=0; i<[self countOfTitles]; i++) {
        TTPageDot *dotV = [self assembleDotForIndex:i];
        [self addSubview:dotV];
        [dots addObject:dotV];
    }
}

- (TTPageDot *)assembleDotForIndex:(NSInteger)index{
    CGRect frame;
    frame.size = CGSizeMake(self.dotW, self.dotH);
    frame.origin = CGPointMake([self dotXForIndex:index], [self dotY]);
    TTPageDot *dot = [[TTPageDot alloc] initWithFrame:frame];
    [dot setText:[self titleForIndex:index]];
    return dot;
}

#pragma mark - touch 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint pt = [touch locationInView:self];
    touchedIndex = [self indexForTargetX:pt.x];
    NSLog(@"touchBegan -> %f %f index->%d", pt.x ,pt.y, touchedIndex);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (touchedIndex == -1) return;
    [self dispatchIndexChanged];
}

#pragma mark - dispatcher

- (void)dispatchIndexChanged{
    if (displayedIndex == touchedIndex) return;
    [self setCurrentIndex:touchedIndex];
    if ([_delegate respondsToSelector:@selector(pageControlDidChangeIndex:)]) {
        [_delegate pageControlDidChangeIndex:touchedIndex];
    }
}

#pragma mark - properties

- (void)setCurrentIndex:(NSInteger)currentIndex{
    for (int i=0; i<[self countOfTitles]; i++) {
        TTPageDot *dotV = [dots objectAtIndex:i];
        if (currentIndex == i) {
            [dotV setSelected:YES];
            continue;
        }
        
        [dotV setSelected:NO];
    }
    displayedIndex = currentIndex;
}

- (NSString *)titleForIndex:(NSInteger)index{
    NSArray *arr = self.titles;
    if(arr) return  [arr objectAtIndex:index];
    return [NSString stringWithFormat:@"%d",index];
}

- (CGFloat)dotXForIndex:(NSInteger)index{
    return (self.dotXStart + self.dotW*index);
}

- (CGFloat)dotXStart{
    return ( self.w - self.dotW*self.countOfTitles )/2.0;
}

- (CGFloat)dotXEnd{
    return self.dotXStart+self.dotW*self.countOfTitles;
}


-(int)indexForTargetX:(CGFloat)targetX{
    //sum through all the views until you get to a position that matches the offset then that's what page youre on (each view can be a different width)
    
    
    if (targetX<[self dotXStart]) return -1;
    if (targetX>[self dotXEnd]) return -1;
    
    int idx = 0;
    CGFloat positionX = [self dotXStart];
    while (positionX <= targetX){
        positionX += [self dotW];
        if (positionX <= targetX){
            idx++;
        }
    }
    
    return idx;
}


- (CGFloat)dotW{
    return self.h;
}

- (CGFloat)dotH{
    return  self.h;
}

- (CGFloat)dotY{
    return (self.h - self.dotH)/2.0;
}

- (CGFloat)w{
    return [self frame].size.width;
}

- (CGFloat)h{
    return [self frame].size.height;
}

- (int)countOfTitles{
    return [self.titles count];
}


@end

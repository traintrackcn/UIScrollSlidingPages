//
//  TTPageControl.h
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-9-4.
//  Copyright (c) 2013年 Thomas Thorpe. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TTPageControlDelegate <NSObject>

- (void)pageControlDidChangeIndex:(int)index;

@end


@interface TTPageControl : UIView



@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id<TTPageControlDelegate> delegate;

@end

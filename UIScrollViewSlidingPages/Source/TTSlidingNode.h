//
//  TTSlidingNode.h
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-8-19.
//  Copyright (c) 2013年 Thomas Thorpe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSlidingNode : NSObject


@property (nonatomic, assign) int titleX;
@property (nonatomic, assign) int pageX;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIView *pageView;
@property (nonatomic, weak) TTSlidingNode *previousNode;
@property (nonatomic, weak) TTSlidingNode *nextNode;




@end

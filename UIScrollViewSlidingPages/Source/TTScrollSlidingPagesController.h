//
//  TTSlidingPagesController.h
//  UIScrollViewSlidingPages
//
//  Created by Thomas Thorpe on 27/03/2013.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

/*
 Copyright (c) 2012 Tom Thorpe. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import <UIKit/UIKit.h>
#import "TTSlidingPagesDataSource.h"
#import "TTPageControl.h"
@class TTScrollViewWrapper;

@interface TTScrollSlidingPagesController : UIViewController<UIScrollViewDelegate, TTPageControlDelegate>


@property (nonatomic, assign) int displayedPageIndex; // Default is 0.
@property (nonatomic, strong) id<TTSlidingPagesDataSource> dataSource;

//styles
@property (nonatomic, assign) BOOL loop;    //loop title & page
@property (nonatomic, assign) BOOL pageControlMode;
@property (nonatomic, assign) BOOL titleAsImageMode;

@property (nonatomic) bool zoomOutAnimationDisabled;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *titleFontSelected;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleColorSelected;
@property (nonatomic, assign) CGFloat titleScrollerHeight;
@property (nonatomic, assign) CGFloat titleScrollerItemWidth;
@property (nonatomic, strong) UIColor *titleBackgroundColor;
@property (nonatomic, strong) UIColor *titleBackgroundColorSelected;
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, strong) NSArray *titles;



@end

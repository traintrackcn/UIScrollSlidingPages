//
//  TTSlidingPagesController.m
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

#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import <QuartzCore/QuartzCore.h>
#import "TTScrollViewWrapper.h"
#import "TTSlidingNode.h"
#import "TTTrangleView.h"

@interface TTScrollSlidingPagesController (){
    int indexBefore;
    NSMutableArray *nodes;
    bool viewDidLoadHasBeenCalled;
    TTScrollViewWrapper *titleContainerWrapper;
    UIScrollView *titleContainer;
    UIScrollView *pageContainer;
    TTPageControl *pageControl;
    CGFloat pageControlHeight;
    
    TTTrangleView *trangleView;
}

@end

@implementation TTScrollSlidingPagesController

/**
 Initalises the control and sets all the default values for the user-settable properties.
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewDidLoadHasBeenCalled = NO;
        //set defaults
        self.titleScrollerHeight = 50;
        self.titleScrollerItemWidth = 50*2;
        self.zoomOutAnimationDisabled = NO;
        self.titleFont = [UIFont fontWithName:@"Verdana" size:14.0];
        self.titleFontSelected = [UIFont fontWithName:@"Verdana-Bold" size:14.0];
        self.loop = NO;
       
        self.titleColor = [UIColor colorWithWhite:170.0/255.0 alpha:1.0];
        self.titleColorSelected = [UIColor colorWithRed:219.0/255.0 green:64.0/255.0 blue:34.0/255.0 alpha:1.0];
        
        self.titleBackgroundColor = [UIColor whiteColor];
        self.titleBackgroundColorSelected = [UIColor whiteColor];
        
//        self.titleScrollerBackgroundColor = [UIColor colorWithWhite:238.0/255.0 alpha:1.0];
        
        self.arrowWidth = 16.0;
        self.arrowHeight = 5.0;
        
        pageControlHeight = 20.0;
    }
    return self;
}

/**
 Initialse the top and bottom scrollers (but don't populate them with pages yet)
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSLog(@"numOfPages -> %d",[self numOfPages]);
    [self assemble];
}

-(void)didRotate{
}


-(void)viewDidLayoutSubviews{
    NSLog(@"========== viewDidLayoutSubviews ==========");
    //this will get called when the screen rotates, at which point we need to fix the frames of all the subviews to be the new correct x position horizontally. The autolayout mask will automatically change the width for us.

//    [self updateTitleConainerWrapperShadowPath];
    [self updateTitlesAndPagesPosition];
    [self updateScrollContentSize];
    [self updateTrangleView];
    [self jumpToDisplayedIndexTarget];
}



#pragma mark - assemblers

- (void)assemble{
    viewDidLoadHasBeenCalled = YES;
    int nextYPosition = 0;
    
    if (self.pageControlMode) {
        [self assemblePageControlWithYPosition:nextYPosition];
        nextYPosition += pageControlHeight;
        [self assembleBottomScrollViewWithYPosition:nextYPosition];
    }else{
        [self assembleTopScrollViewWithYPosition:nextYPosition];
        [self assembleTopScrollViewWrapperWithYPosition:nextYPosition];
        nextYPosition += self.titleHeight;
        [self assembleBottomScrollViewWithYPosition:nextYPosition];
        [self assembleArrowViewWithYPosition:nextYPosition];
    }
    
}

- (void)assembleArrowViewWithYPosition:(CGFloat)yPosition{
    if (trangleView != nil) return;
    CGRect frame = CGRectMake(0, yPosition - [self arrowHeight], self.view.frame.size.width, [self arrowHeight]);
    trangleView = [[TTTrangleView alloc] initWithFrame:frame];
//    NSLog(@"trangle width -> %f", self.view.frame.size.width);
    [trangleView setTrangleW:[self arrowWidth]];
    [trangleView setTrangleH:[self arrowHeight]];
    [trangleView setTitleW:[self titleWidth]];
    [trangleView setTrangleColor:[self titleBackgroundColorSelected]];
    [[self view] addSubview:trangleView];
}

- (void)assemblePageControlWithYPosition:(CGFloat)yPosition{
    //create and add the UIPageControl
    pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width, pageControlHeight)];
    pageControl.backgroundColor = [UIColor whiteColor];
    pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [pageControl setDelegate:self];
//    [pageControl addTarget:self action:@selector(didTapPageControl:) forControlEvents:UIControlEventValueChanged];
    pageControl.titles = [self titles];
    pageControl.currentIndex = [self displayedIndexTarget];
    [self.view addSubview:pageControl];
}



- (void)assembleTopScrollViewWithYPosition:(CGFloat)yPosition{
    titleContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.titleWidth, self.titleHeight)];
    titleContainer.center = CGPointMake(self.view.center.x, titleContainer.center.y); //center it horizontally
    titleContainer.pagingEnabled = YES;
    titleContainer.clipsToBounds = NO;
    titleContainer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleContainer.showsVerticalScrollIndicator = NO;
    titleContainer.showsHorizontalScrollIndicator = NO;
    titleContainer.directionalLockEnabled = YES;
    titleContainer.backgroundColor = [UIColor clearColor];
    titleContainer.pagingEnabled = YES;
    titleContainer.delegate = self; //move the bottom scroller proportionally as you drag the top.
    [titleContainer setBackgroundColor:[self titleBackgroundColorSelected]];
    
}

- (void)assembleBottomScrollViewWithYPosition:(CGFloat)yPosition{
    pageContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width, self.view.frame.size.height-yPosition)];
    pageContainer.pagingEnabled = YES;
    pageContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    pageContainer.showsVerticalScrollIndicator = NO;
    pageContainer.showsHorizontalScrollIndicator = NO;
    pageContainer.directionalLockEnabled = YES;
    pageContainer.delegate = self; //move the top scroller proportionally as you drag the bottom.
    pageContainer.alwaysBounceVertical = NO;
    [pageContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:pageContainer];
}

- (void)assembleTopScrollViewWrapperWithYPosition:(CGFloat)yPosition{
    //make the view to put the scroll view inside which will allow the background colour, and allow dragging from anywhere in this wrapper to be passed to the scrollview.
    titleContainerWrapper = [[TTScrollViewWrapper alloc] initWithFrame:CGRectMake(0, yPosition, self.view.frame.size.width, self.titleHeight) andUIScrollView:titleContainer];
    titleContainerWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleContainerWrapper.backgroundColor = [self titleBackgroundColor];
    //pass touch events from the wrapper onto the scrollview (so you can drag from the entire width, as the scrollview itself only lives in the very centre, but with clipToBounds turned off)
    
    //single tap to switch to different item
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTitleContainer:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [titleContainerWrapper addGestureRecognizer: singleTap];
    
    [titleContainerWrapper addSubview:titleContainer];//put the top scroll view in the wrapper.
    [self.view addSubview:titleContainerWrapper]; //put the wrapper in this view.
    
    //decorate shadow
//    CALayer *l = titleContainerWrapper.layer;
//    l.masksToBounds = NO;
//    l.shadowOffset = CGSizeMake(0, 4);
//    l.shadowRadius = 4;
//    l.shadowOpacity = 0.3;
    
    //Add shadow path (better performance)
//    [self updateTitleConainerWrapperShadowPath];
    
    [self.view bringSubviewToFront:titleContainerWrapper];//bring view to sit on top so you can see the shadow!
}




- (void)removeAllSubviews{
    //remove any existing items from the subviews
    [titleContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [pageContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //remove any existing items from the view hierarchy
    for (UIViewController* subViewController in self.childViewControllers){
        [subViewController willMoveToParentViewController:nil];
        [subViewController removeFromParentViewController];
    }
}





- (UIView *)assembleTitleViewForIndex:(int)index{
    NSString *titleText = [self titleForIndex:index];
    TTSlidingPageTitle *title =  [[TTSlidingPageTitle alloc] initWithHeaderText:titleText];
    if (title == nil) return [[UIView alloc] init];
    if (![title isKindOfClass:[TTSlidingPageTitle class]]) return [[UIView alloc] init];
    UIView *titleView;
    if (self.titleAsImageMode) {
        titleView = [self assembleTitleViewAsImageForTitle:title];
    }else{
        titleView = [self assembleTitleViewAsLabelForTitle:title];
    }
    [titleContainer addSubview:titleView];
    return titleView;
}

- (UIView *)assembleTitleViewAsLabelForTitle:(TTSlidingPageTitle *)title{
    UILabel *label = [[UILabel alloc] init];
    label.text = title.headerText;
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = self.titleFont;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = self.titleColor;
    
    return label;
}

- (UIView *)assembleTitleViewAsImageForTitle:(TTSlidingPageTitle *)title{
    UIImageView *imgV = [[UIImageView alloc] init];
    UIImage *img = [UIImage imageNamed:title.headerText];
    [imgV setContentMode:UIViewContentModeScaleAspectFit];
    [imgV setImage:img];
    
//    CALayer *l = [imgV layer];
//    [l setBorderWidth:1.0];
//    [l setBorderColor:[UIColor blackColor].CGColor];
//    [l setCornerRadius:5.0];
    
    return imgV;
}

- (UIView *)assemblePageViewForIndex:(int)index{
    //bottom scroller add-----
    //set the default width of the page
    TTSlidingPage *page = [self.dataSource pageForSlidingPagesViewController:self atIndex:index];//get the page
    if (page == nil || ![page isKindOfClass:[TTSlidingPage class]]){
        [NSException raise:@"TTScrollSlidingPagesController Wrong Page Content Type" format:@"TTScrollSlidingPagesController: Page contents should be instances of TTSlidingPage, one was returned that was either nil, or wasn't a TTSlidingPage. Make sure your pageForSlidingPagesViewController method in the datasource always returns a TTSlidingPage instance for each page requested."];
    }
    UIView *pageV = page.contentView;
    [pageContainer addSubview:pageV];
    
    //view contoller
    if (page.contentViewController != nil){
        [self addChildViewController:page.contentViewController];
        [page.contentViewController didMoveToParentViewController:self];
    }
    
    return pageV;
}


- (TTSlidingNode *)assembleNodeForIndex:(int)index titleView:(UIView *)titleView pageView:(UIView *)pageView{
    TTSlidingNode *node = [[TTSlidingNode alloc] init];
    [node setTitleView:titleView];
    [node setPageView:pageView];
    [node setPageIndex:index];
    return node;
}



-(void)assembleTitlesAndPages{
    if (self.dataSource == nil) return;
    
    NSLog(@"========== assembleTitlesAndPages ==========");
    
    [self removeAllSubviews];
    
    //loop through each page and add it to the scroller
    nodes = [NSMutableArray arrayWithCapacity:[self numOfPages]];
    for (int i=0; i<[self numOfPages]; i++){
        UIView *titleView = [self assembleTitleViewForIndex:i];
        UIView *pageView = [self assemblePageViewForIndex:i ];
        TTSlidingNode *node = [self assembleNodeForIndex:i titleView:titleView pageView:pageView];
        [nodes addObject:node];
    }
    
    [self connectNodes];
}

#pragma mark - 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**
 Gets the x position of the requested page in the bottom scroller. For example, if you ask for page 5, and page 5 starts at the contentOffset 520px in the bottom scroller, this will return 520.
 
 @param page The page number requested.
 @return Returns the x position of the requested page in the bottom scroller
 */
-(int)pagePositionXForIndex:(int)index{
    return [self pageWidth]*index;
}

- (int)titlePositionXForIndex:(int)index{
    return [self titleWidth]*index;
}


/**
 Gets the page based on an X position in the topScrollView. For example, if you pass in 100 and each topScrollView width is 50, then this would return page 2.
 
 @param page The X position in the topScrollView
 @return Returns the page. For example, if you pass in 100 and each topScrollView width is 50, then this would return page 2.
 */
-(int)titleViewIndexForPositionX:(int)positionX{
    return (positionX) / [self titleWidth];
}


#pragma mark - tap actions

/**
 Handler for the gesture recogniser on the top scrollview wrapper. When the topscrollview wrapper is tapped, this works out the tap position and scrolls the view to that page.
 */
- (void)tappedTitleContainer:(id)sender {
    //get the point that was tapped within the context of the topScrollView (not the wrapper)
    CGPoint point = [sender locationInView:titleContainer];

    //find out what page in the topscroller would be at that x location
    int index = [self titleViewIndexForPositionX:point.x];
//    NSLog(@"tappedTitleContainer index -> %d", index);
    //if not already on the page and the page is within the bounds of the pages we have, scroll to the page!
    if (index < [self numOfPages]){
        [self scrollToIndex:index];
    }
    
}





#pragma mark - dispatcher

- (void)dispatchPageChanged{
    
    if (indexBefore == [self displayedIndexCurrent]) return;
    
    int offset = abs(indexBefore-[self displayedIndexCurrent]);
//    NSLog(@"offset -> %d   indexBefore -> %d displayedIndexCurrent -> %d", offset, indexBefore, [self displayedIndexCurrent]);
    if (indexBefore>[self displayedIndexCurrent]) {
        [self didScrollToPreviousPage:offset];
        [self didScrollToIndex:[self displayedIndexCurrent]];
    }else{
        [self didScrollToNextPage:offset];
        [self didScrollToIndex:[self displayedIndexCurrent]];
    }
    
    if ([self loop]) {
        [self updateTitlesAndPagesPosition];
        [self jumpToDisplayedIndexTarget];
    }
    
    
    
    if ([_dataSource respondsToSelector:@selector(pageChanagedForSlidingPagesViewController:)]) {
        [_dataSource pageChanagedForSlidingPagesViewController:self];
    }
    
    
    
}

#pragma mark - scroll actions

/**
 Scrolls the bottom scorller (content scroller) to a particular page number.
 
 @param page The page number to scroll to.
 @param animated Whether the scroll should be animated to move along to the page (YES) or just directly scroll to the page (NO)
 */
-(void)scrollToIndex:(int)index{
    NSLog(@"========== scrollToIndex -> %d ==========", index);
    [pageContainer setContentOffset: CGPointMake([self pagePositionXForIndex:index],0) animated:YES];
}

- (void)jumpToDisplayedIndexTarget{
    [self jumpToIndex:[self displayedIndexTarget]];
}

- (void)jumpToIndex:(int)index{
    NSLog(@"========== jumpToIndex -> %d ==========", index);
    [self willJumpToIndex:index];
    [pageContainer setContentOffset: CGPointMake([self pagePositionXForIndex:index],0) animated:NO];
    [titleContainer setContentOffset: CGPointMake([self titlePositionXForIndex:index], 0) animated:NO];
    [self didJumpToIndex:index];
    
}

- (void)didScrollToPreviousPage:(int)offset{
    //    NSLog(@"previousPage");
    int pageIndex = [[self previousNodeWithOffset:offset] pageIndex];
    [self setDisplayedPageIndex:pageIndex];
    //    NSLog(@"current displayedPageIndex -> %d", [self displayedPageIndex]);
}

- (void)didScrollToNextPage:(int)offset{
    //    NSLog(@"nextPage");
    int pageIndex = [[self nextNodeWithOffset:offset] pageIndex];
    [self setDisplayedPageIndex:pageIndex];
    //    NSLog(@"current displayedPageIndex -> %d", [self displayedPageIndex]);
}

//- (void)willScrollToIndex:(int)index{
//    NSLog(@"willScrollToIndex -> %d", index);
//    indexBefore = [self displayedIndexCurrent];
//}

- (void)didScrollToIndex:(int)index{
    NSLog(@"didScrollToIndex -> %d indexBefore->%d", index, indexBefore);
    indexBefore = [self displayedIndexCurrent];
    
    [self updateTitles];
    [self updatePageControl];
}

- (void)willJumpToIndex:(int)index{
    NSLog(@"willJumpToIndex -> %d indexBefore->%d", index, indexBefore);
    indexBefore = [self displayedIndexCurrent];
}

- (void)didJumpToIndex:(int)index{
    NSLog(@"didJumpToIndex -> %d indexBefore->%d", index, indexBefore);
    indexBefore = [self displayedIndexCurrent];
    
    [self updateTitles];
    [self updatePageControl];
}


#pragma mark UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int currentIndex = [self displayedIndexCurrent];

    if (scrollView == titleContainer){
        //translate the top scroll to the bottom scroll
        
        //get the page number of the scroll item (e.g third header = 3rd page).
        int pageNumber =  [self titleViewIndexForPositionX:titleContainer.contentOffset.x];
        
        //get the width of the bottom scroller item at that page
        int bottomPageWidth = [self pageWidth];
        
        //work out the start of that page number in the bottom scroller (e.g if the 3rd bottom scroller page starts at 520px, then it's 520)
        int bottomPageStart = [self pagePositionXForIndex:pageNumber];
        
        //work out the percent through the header you have scrolled in the top scroller
        int startOfTopPage = pageNumber * self.titleScrollerItemWidth;
        float percentOfTop = (titleContainer.contentOffset.x - startOfTopPage) / self.titleScrollerItemWidth;
        
        //translate that to the percent through the bottom scroller page to scroll, by doing the (percent through the top header * the bottom width) + the bottomPageStart.
        int bottomScrollOffset = (percentOfTop * bottomPageWidth) + bottomPageStart;
        [self updateContentOffset:CGPointMake(bottomScrollOffset, 0) forScrollView:pageContainer];
    }
    else if (scrollView == pageContainer){
        //translate the bottom scroll to the top scroll. The bottom scroll items can in theory be different widths so it's a bit more complicated.
        
        //get the x position of the page in the top scroller
        int topXPosition = self.titleScrollerItemWidth * currentIndex;
        
        //work out the percentage past this page the view currently is, by getting the xPosition of the next page and seeing how close it is
        float currentPageStartXPosition = [self pagePositionXForIndex:currentIndex]; //subtract the current page's start x position from both the current offset and next page's start position, to mean that we're on a base level. So for example if we're on page 1 so that the currentPageStartXPosition is 320, and the current offset is 330, the next page xPosition is 640, then 330-320 - 10, and 640-320 - 320. So we're 10 pixels into 320, so roughly 3%.
        float nextPagesXPosition = [self pagePositionXForIndex:currentIndex+1];
        float percentageTowardsNextPage = (scrollView.contentOffset.x-currentPageStartXPosition) / (nextPagesXPosition-currentPageStartXPosition);
        //multiply the percentage towards the next page that you are, by the width of each topScroller item, and add it to the topXPosition
        float addToTopXPosition = percentageTowardsNextPage * self.titleScrollerItemWidth;
        topXPosition = topXPosition + roundf(addToTopXPosition);
        [self updateContentOffset:CGPointMake(topXPosition, 0) forScrollView:titleContainer];
        
    }
//    [self dispatchPageChanged];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self dispatchPageChanged];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self dispatchPageChanged];
}


#pragma mark - node actions

- (void)connectNodes{
    int lastIndex = [nodes count] - 1;
    for (int i=0; i<[nodes count]; i++) {
        int preIndex = i-1;
        int nextIndex = i+1;
        if (preIndex<0) preIndex = lastIndex;
        if (nextIndex>lastIndex)  nextIndex = 0;
        TTSlidingNode *preNode = [nodes objectAtIndex:preIndex];
        TTSlidingNode *nextNode = [nodes objectAtIndex:nextIndex];
        TTSlidingNode *node = [nodes objectAtIndex:i];
        [node setPreviousNode:preNode];
        [node setNextNode:nextNode];
    }
}


#pragma mark - update actions

//- (void)updateTitleConainerWrapperShadowPath{
//    CGPathRef shadowPath = [UIBezierPath bezierPathWithRect:titleContainerWrapper.bounds].CGPath;
//    [titleContainerWrapper.layer setShadowPath:shadowPath];
//    //rasterize (also due to the better performance)
//    titleContainerWrapper.layer.shouldRasterize = YES;
//    titleContainerWrapper.layer.rasterizationScale = [UIScreen mainScreen].scale;
//}

- (void)updateTrangleView{
    CGRect frame = trangleView.frame;
    frame.size = CGSizeMake(self.view.frame.size.width, frame.size.height);
    [trangleView setFrame:frame];
    [trangleView setNeedsDisplay];
}

- (void)updateContentOffset:(CGPoint)contentOffset forScrollView:(UIScrollView *)scrollView{
    scrollView.delegate = nil;
    scrollView.contentOffset = contentOffset;
    scrollView.delegate = self;
}

- (void)updateTitlesAndPagesPosition{
    NSLog(@"========== updateTitlesAndPagesPosition =========");
    //        view.transform = CGAffineTransformIdentity;
    
    TTSlidingNode *node = [nodes objectAtIndex:[self pageIndexAtFirstIndex]];
    //    NSLog(@"pageIndexAtFirstIndex -> %d",[self pageIndexAtFirstIndex]);
    for (int i=0; i<[self numOfPages]; i++) {
        UIView *titleV = [node titleView];
        UIView *pageV = [node pageView];
        CGPoint titleOrigin = CGPointMake([self titleWidth]*i, 0);
        CGRect titleFrame;
        CGPoint pageOrigin = CGPointMake([self pageWidth]*i, 0);
        CGRect pageFrame;
        
        titleFrame.origin = titleOrigin;
        titleFrame.size = [self titleSize];
        titleV.frame = titleFrame;
        
        pageFrame.origin = pageOrigin;
        pageFrame.size = [self pageSize];
        pageV.frame = pageFrame;
        
        //        NSLog(@"displayIndex:%d pageIndex:%d titleX:%f   pageX:%f",i,[node pageIndex], titleOrigin.x, pageOrigin.x);
        
        node = [node nextNode];
    }
    
    
    //    NSLog(@"TitleContainer")
    
    //    NSLog(@"============================");
}

- (void)updateScrollContentSize{
    //    CGFloat topScrollViewContentW = self.numOfPages * self.titleWidth;
    //    CGFloat topScrollViewContentH = titleC.frame.size.height;
    titleContainer.contentSize = [self contentSizeOfTitleContainer];
    
    //    CGFloat bottomScrollViewContentW = self.numOfPages * self.pageWidth;
    //    CGFloat bottomScrollViewContentH = pageContainer.frame.size.height;
    pageContainer.contentSize = [self contentSizeOfPageContainer];
}


- (void)updateTitles{
    if (self.titleAsImageMode) {
        [self updateTitlesAlpha];
    }else{
        [self updateTitlesTextStyle];
    }
}

- (void)updateTitlesAlpha{
    int pageIndex = [self displayedPageIndex];
    for (int i=0; i<[nodes count]; i++) {
        TTSlidingNode *node = [nodes objectAtIndex:i];
        UIImageView *displayedTitleView = (UIImageView *)[node titleView];
        CGFloat alpha = 0.3;
        
        if (pageIndex == i) alpha = 1.0;
        
        [displayedTitleView setAlpha:alpha];
    }
}

- (void)updateTitlesTextStyle{
    int pageIndex = [self displayedPageIndex];
    for (int i=0; i<[nodes count]; i++) {
        TTSlidingNode *node = [nodes objectAtIndex:i];
        UILabel *displayedTitleLabel = (UILabel *)[node titleView];
        UIColor *c = [self titleColor];
        UIFont *f = [self titleFont];
        
        if (pageIndex == i) {
            c = [self titleColorSelected];
            f = [self titleFontSelected];
        }
        
        [displayedTitleLabel setTextColor:c];
        [displayedTitleLabel setFont:f];
    }
}

- (void)updatePageControl{
    [pageControl setCurrentIndex:[self displayedIndexCurrent]];
}


#pragma mark - properties

-(void)setDataSource:(id<TTSlidingPagesDataSource>)dataSource{
    _dataSource = dataSource;
    if (self.view != nil){
        [self assembleTitlesAndPages];
    }
}

- (NSString *)titleForIndex:(NSInteger)index{
    NSArray *arr = self.titles;
//    NSLog(@"arr -> %@", arr);
    if(arr) return [arr objectAtIndex:index];
    return  [NSString stringWithFormat:@"%d",index];
}

- (CGFloat)contentOffsetXOfPageContainer{
    return [pageContainer contentOffset].x;
}

- (CGFloat)contentOffsetXOfTitleContainer{
    return [titleContainer contentOffset].x;
}

- (CGSize)contentSizeOfPageContainer{
    CGFloat w = self.numOfPages * self.pageWidth;
    CGFloat h = pageContainer.frame.size.height;
    return CGSizeMake(w, h);
}

- (CGSize)contentSizeOfTitleContainer{
    CGFloat w = self.numOfPages * self.titleWidth;
    CGFloat h = titleContainer.frame.size.height;
    return CGSizeMake(w, h);
}

- (CGSize)pageSize{
    return CGSizeMake([self pageWidth], [self pageHeight]);
}

- (CGFloat)pageWidth{
    return  pageContainer.frame.size.width;
}

- (CGFloat)pageHeight{
    return pageContainer.frame.size.height;
}

- (CGSize)titleSize{
    return CGSizeMake([self titleWidth], [self titleHeight]);
}

- (CGFloat)titleWidth{
    return [self titleScrollerItemWidth];
}

- (CGFloat)titleHeight{
    return [self titleScrollerHeight] - [self arrowHeight];
}

- (int)numOfPages{
//    NSLog(@"titles -> %@", self.titles);
     return [self.titles count];
}

- (int)offsetBeforeDisplayedPageIndex{
    if ([self loop]) return [self numOfPages]/2;
    return 0;
}

- (int)displayedIndexTarget{
    if ([self loop])  return  [self numOfPages]/2;
    return [self displayedPageIndex];
}

/**
 Gets number of the page currently displayed in the bottom scroller (zero based - so starting at 0 for the first page).
 
 @return Returns the number of the page currently displayed in the bottom scroller (zero based - so starting at 0 for the first page).
 */
-(int)displayedIndexCurrent{
    //sum through all the views until you get to a position that matches the offset then that's what page youre on (each view can be a different width)
    int idx = 0;
    int positionX = 0;
    while (positionX <= pageContainer.contentOffset.x && positionX < pageContainer.contentSize.width){
        positionX += [self pageWidth];
        if (positionX <= pageContainer.contentOffset.x){
            idx++;
        }
    }
    
    return idx;
}

- (int)pageIndexAtFirstIndex{
    TTSlidingNode *node = [self previousNodeWithOffset:[self offsetBeforeDisplayedPageIndex]];
    return [node pageIndex];
}

- (TTSlidingNode *)previousNodeWithOffset:(int)offset{
    TTSlidingNode *node = [nodes objectAtIndex:[self displayedPageIndex]];
    while (offset) {
        node = [node previousNode];
        offset --;
    }
    return  node;
}

- (TTSlidingNode *)nextNodeWithOffset:(int)offset{
    TTSlidingNode *node = [nodes objectAtIndex:[self displayedPageIndex]];
    while (offset) {
        node = [node nextNode];
        offset --;
    }
    return  node;
}


#pragma mark - TTPageControlDelegate

- (void)pageControlDidChangeIndex:(int)index{
    int targetIdx = index;
    NSLog(@"========== pageControlDidChangeIndex targetIdx -> %d ==========", targetIdx);
    if ([self displayedIndexCurrent] != targetIdx){
        [self scrollToIndex:targetIdx];
    }
}

@end

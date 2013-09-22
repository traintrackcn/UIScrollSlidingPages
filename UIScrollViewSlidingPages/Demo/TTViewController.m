//
//  TTViewController.m
//  UIScrollViewSlidingPages
//
//  Created by Thomas Thorpe on 27/03/2013.
//  Copyright (c) 2013 Thomas Thorpe. All rights reserved.
//

#import "TTViewController.h"
#import "TTScrollSlidingPagesController.h"
#import "TabOneViewController.h"
#import "TabTwoViewController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"
#import "TTBlankViewController.h"

@interface TTViewController ()
    @property (strong, nonatomic) TTScrollSlidingPagesController *slider;
@end

@implementation TTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initial setup of the TTScrollSlidingPagesController. 
    self.slider = [[TTScrollSlidingPagesController alloc] init];
    self.slider.titles = [NSArray arrayWithObjects:@"AD",@"AE",@"AF",@"AG",@"US",@"CN",@"TW",@"FR",@"ES",@"HK",@"JP", nil];

    
    //set properties to customiser the slider. Make sure you set these BEFORE you access any other properties on the slider, such as the view or the datasource. Best to do it immediately after calling the init method.
    //slider.titleScrollerHidden = YES;
    self.slider.titleScrollerHeight = 48.0;
    self.slider.titleScrollerItemWidth = 64.0;
    self.slider.titleAsImageMode = YES;
    //slider.titleScrollerBackgroundColour = [UIColor darkGrayColor];
    //slider.disableTitleScrollerShadow = YES;
    //slider.disableUIPageControl = YES;
    //slider.initialPageNumber = 1;
    //slider.pagingEnabled = NO;
    //slider.zoomOutAnimationDisabled = YES;
    self.slider.loop = NO;
    self.slider.pageControlMode = NO;
    //set the datasource.
    self.slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    self.slider.view.frame = self.view.frame;
    [self.view addSubview:self.slider.view];
    [self addChildViewController:self.slider];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TTSlidingPagesDataSource methods

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    TTBlankViewController *vc = [[TTBlankViewController alloc] initWithNibName:@"TTBlankViewController" bundle:nil];
//    NSLog(@"[vc textLabel]  -> %@", [vc textLabel] );
    [vc setIndex:index];
    
    
    return [[TTSlidingPage alloc] initWithContentViewController:vc];
}

//-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
//    TTSlidingPageTitle *title;
//
//    //all other pages just use a simple text header
//    switch (index) {
//        default:
//            title = [[TTSlidingPageTitle alloc] initWithHeaderText:[NSString stringWithFormat:@"P %d", index]];
//            break;
//    }
// 
//    return title;
//}

////The below method in the datasource might get removed from the control some time in the future as it doesn't work that well with the headers if the width is small.
//-(int)widthForPageOnSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index
//{
//    if (index ==3){
//        return 130;
//    } else {
//        return self.view.frame.size.width;
//    }
//}

- (void)pageChanagedForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    NSLog(@"pageIndex -> %d", [source displayedPageIndex]);
}

@end

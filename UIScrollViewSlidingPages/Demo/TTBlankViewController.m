//
//  TTBlankViewController.m
//  UIScrollSlidingPages
//
//  Created by traintrackcn on 13-8-20.
//  Copyright (c) 2013年 Thomas Thorpe. All rights reserved.
//

#import "TTBlankViewController.h"

@interface TTBlankViewController ()

@end

@implementation TTBlankViewController

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
    // Do any additional setup after loading the view from its nib.
    [[self textLabel] setText:[NSString stringWithFormat:@"Page %d" , _index]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 8/4/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+Sample.h"
#import "FUIVerticalTabBarButton.h"

@interface ViewController ()
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title = @"Actividades";
        UIImage *finishedSelectedImage = [UIImage imageNamed:@"tabBarIcon_settings" andColored:[UIColor whiteColor]];
        UIImage *finishedUnselectedImage = [UIImage imageNamed:@"tabBarIcon_settings" andColored:[UIColor slateLightGray]];

        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:nil tag:1];
        [self.tabBarItem setFinishedSelectedImage:finishedSelectedImage withFinishedUnselectedImage:finishedUnselectedImage];
        
        NSInteger randomCount = random() % (30);
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", randomCount]];
        
        self.view.backgroundColor = [UIColor randomColor];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSInteger count = [FUIVerticalTabBarButton badgeCountForValue:self.tabBarItem.badgeValue];
    count--;
    [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",count]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Auto-Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) return YES;
    else return NO;
}

@end

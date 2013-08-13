//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 8/4/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "FUIVerticalTabBarButton.h"
#import "UIColor+FlatUI.h"

@interface ViewController ()
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title = [@"Settings" uppercaseString];
        UIImage *selectedImage = [UIImage imageNamed:@"tabBarIcon_settings_selected" andColored:[UIColor colorFromHexCode:@"1f2733"]];
        UIImage *unselectedImage = [UIImage imageNamed:@"tabBarIcon_settings_unselected" andColored:[UIColor colorFromHexCode:@"c8d1de"]];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:nil tag:1];
        [self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
        
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

//
//  AppDelegate.m
//  Sample
//
//  Created by Ignacio on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "UIColor+Sample.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.verticalTabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - Getter Methods

- (FUIVerticalTabBarController *)verticalTabBarController
{
    if (!_verticalTabBarController)
    {
        _verticalTabBarController = [[FUIVerticalTabBarController alloc] init];
        _verticalTabBarController.tabBarWidth = 240.0;
        _verticalTabBarController.tabBarHeaderHeight = 80.0;
        _verticalTabBarController.tabBarButtonHeight = 60.0;
        _verticalTabBarController.maximumWidth = 240.0;
        _verticalTabBarController.minimumWidth = 58.0;
        _verticalTabBarController.shouldStartAnimated = YES;
        _verticalTabBarController.shouldStartExpanded = YES;
        _verticalTabBarController.shouldContractWhenSelecting = NO;
        _verticalTabBarController.delegate = self;
        
        _verticalTabBarController.tabBar.backgroundColor = [UIColor slateDarkGray];
        _verticalTabBarController.tabBar.selectedTabColor = [UIColor brandColor];
        _verticalTabBarController.tabBar.unselectedTabColor = [UIColor slateGray];
        _verticalTabBarController.tabBar.textColor = [UIColor slateLightGray];
        _verticalTabBarController.tabBar.scrollMode = FUIVerticalTabBarScrollToFit;
        
        NSMutableArray *viewControllers = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            ViewController *vc = [[ViewController alloc] init];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:_verticalTabBarController action:@selector(switchMenu)];
            [vc.navigationItem setLeftBarButtonItem:menuItem];
            
            UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(test:)];
            [vc.navigationItem setRightBarButtonItem:testItem];
            
            [viewControllers addObject:nc];
        }
        [_verticalTabBarController setViewControllers:viewControllers];
        
        _verticalTabBarController.selectedIndex = 0;
    }
    return _verticalTabBarController;
}

- (IBAction)test:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - FUIVerticalTabBarControllerDelegate Methods

- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
//    NSLog(@"%s",__FUNCTION__);
}

- (BOOL)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (BOOL)verticalTabBarControllerShouldAllowPanning:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

@end

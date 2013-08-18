//
//  AppDelegate.m
//  Sample
//
//  Created by Ignacio on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "UIColor+FlatUI.h"

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
        _verticalTabBarController.tabBarHeaderHeight = 80.0;
        _verticalTabBarController.tabBarButtonHeight = 60.0;
        _verticalTabBarController.maximumWidth = 240.0;
        _verticalTabBarController.minimumWidth = 58.0;
        _verticalTabBarController.startAnimated = YES;
        _verticalTabBarController.startExpanded = NO;
        _verticalTabBarController.delegate = self;
        
        _verticalTabBarController.tabBar.scrollMode = FUIVerticalTabBarScrollAlways;
        _verticalTabBarController.tabBar.backgroundColor = [UIColor colorFromHexCode:@"1f2733"];
        _verticalTabBarController.tabBar.selectedTabColor = [UIColor colorFromHexCode:@"c8602c"];
        _verticalTabBarController.tabBar.unselectedTabColor = [UIColor colorFromHexCode:@"28313f"];
        _verticalTabBarController.tabBar.textColor = [UIColor colorFromHexCode:@"c8d1de"];
        _verticalTabBarController.tabBar.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
        _verticalTabBarController.tabBar.badgeTextColor = [UIColor whiteColor];
        _verticalTabBarController.tabBar.badgeTextFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];

        NSMutableArray *viewControllers = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            ViewController *vc = [[ViewController alloc] init];
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:_verticalTabBarController action:@selector(switchMenu:)];
            [vc.navigationItem setLeftBarButtonItem:menuItem];
            
            [viewControllers addObject:nc];
        }
        [_verticalTabBarController setViewControllers:viewControllers];
        
        _verticalTabBarController.selectedIndex = 0;
    }
    return _verticalTabBarController;
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

- (BOOL)verticalTabBarControllerContractWhenSelecting:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

- (BOOL)verticalTabBarControllerCanMoveHorizontally:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

- (BOOL)verticalTabBarControllerContractAfterTap:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

@end

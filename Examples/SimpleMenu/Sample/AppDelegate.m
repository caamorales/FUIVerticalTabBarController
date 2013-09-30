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
        _verticalTabBarController.tabBarButtonHeight = 60.0;
        _verticalTabBarController.maximumWidth = [UIScreen mainScreen].bounds.size.width-54.0;
        _verticalTabBarController.startAnimated = YES;
        _verticalTabBarController.startExpanded = NO;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].statusBarFrame.size.width, 64.0)];
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 20.0, _verticalTabBarController.maximumWidth, 44.0)];
        searchBar.barStyle = UISearchBarStyleMinimal;
        searchBar.barTintColor = [UIColor clearColor];
        searchBar.placeholder = @"Search";
        [headerView addSubview:searchBar];
        _verticalTabBarController.headerView = headerView;
        
        _verticalTabBarController.tabBar.scrollMode = FUIVerticalTabBarScrollAlways;
        _verticalTabBarController.tabBar.backgroundColor = [UIColor colorFromHexCode:@"1f2733"];
        _verticalTabBarController.tabBar.selectedTabColor = [UIColor colorFromHexCode:@"c8602c"];
        _verticalTabBarController.tabBar.unselectedTabColor = [UIColor colorFromHexCode:@"28313f"];
        _verticalTabBarController.tabBar.textFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
        _verticalTabBarController.tabBar.textColor = [UIColor colorFromHexCode:@"c8d1de"];
        _verticalTabBarController.tabBar.highlightedTextColor = _verticalTabBarController.tabBar.unselectedTabColor;
        _verticalTabBarController.tabBar.badgeTextColor = [UIColor whiteColor];
        _verticalTabBarController.tabBar.badgeTextFont = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
        
        [self setupControllers];
    }
    return _verticalTabBarController;
}

- (void)setupControllers
{
    NSMutableArray *navigationcontrollers = [NSMutableArray new];
    for (int i = 0; i < 5; i++)
    {
        ViewController *vc = [[ViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"Section %d", i+1];
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [navigationcontrollers addObject:nc];
        
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:_verticalTabBarController action:@selector(switchMenu:)];
        [vc.navigationItem setLeftBarButtonItem:menuItem];
    }
    
    [_verticalTabBarController setViewControllers:navigationcontrollers];
    _verticalTabBarController.selectedIndex = 0;
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

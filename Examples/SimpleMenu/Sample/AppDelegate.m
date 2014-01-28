//
//  AppDelegate.m
//  Sample
//
//  Created by Ignacio on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) UISearchBar *searchBar;
@end

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
        _verticalTabBarController.delegate = self;
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIApplication sharedApplication].statusBarFrame.size.width, 64.0)];
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 20.0, _verticalTabBarController.maximumWidth, 44.0)];
        _searchBar.barStyle = UISearchBarStyleMinimal;
        if ([_searchBar respondsToSelector:@selector(setBarTintColor:)]) {
            _searchBar.barTintColor = [UIColor clearColor];
        }
        _searchBar.placeholder = @"Search";
        [headerView addSubview:_searchBar];
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
        
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[self menuIcon] style:UIBarButtonItemStylePlain target:_verticalTabBarController action:@selector(switchMenu:)];
        [vc.navigationItem setLeftBarButtonItem:menuItem];
    }
    
    [_verticalTabBarController setViewControllers:navigationcontrollers];
    _verticalTabBarController.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (UIImage *)menuIcon
{
    static UIImage *_menuIcon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(24.0, 24.0), NO, 0);
        
        //// Color Declarations
        UIColor *fillColor = self.window.tintColor;
        
        //// Rectangles Drawing
        for (int i = 0; i < 3; i++) {
            CGFloat yPos = 5 + 6*i;
            
            UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, yPos, 24.0, 2.0)];
            [fillColor setFill];
            [rectanglePath fill];
        }
        
        //Create a UIImage using the current context.
        _menuIcon = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return _menuIcon;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint location = [[[event allTouches] anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    if(location.y > 0 && location.y < 20) {
        [_verticalTabBarController shouldScrollToTop];
    }
}

#pragma mark - FUIVerticalTabBarControllerDelegate Methods

- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController willDeselectViewController:(UIViewController *)viewController;
{
    
}

- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
    }
}

- (BOOL)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (BOOL)verticalTabBarControllerContractWhenSelecting:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

- (BOOL)verticalTabBarControllerCanPanHorizontally:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

- (BOOL)verticalTabBarControllerContractAfterTap:(FUIVerticalTabBarController *)tabBarController
{
    return YES;
}

@end

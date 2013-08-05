//
//  FUIVerticalTabBarController.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//  Licence: MIT-Licence
//

#import "FUIVerticalTabBarController.h"
#import "FUIVerticalTabBarButton.h"
#import <QuartzCore/QuartzCore.h>

#define kTabBarItemSizeHeight 60.0
#define kTabBarSizeWidth 240.0
#define kTabBarHeaderSizeHeight 80.0

@interface FUIVerticalTabBarController ()
@end

@implementation FUIVerticalTabBarController

- (id)init
{
    if (self = [super init])
    {
        _tabBarWidth = kTabBarSizeWidth;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.view.autoresizesSubviews = YES;
        
        [self.view addSubview:self.tabBar];
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
    
    self.view.backgroundColor = _tabBar.backgroundColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - Getter methods

- (FUIVerticalTabBar *)tabBar
{
    if (!_tabBar)
    {
        _tabBar = [[FUIVerticalTabBar alloc] initWithFrame:CGRectMake(0, 0, _tabBarWidth-1, self.view.bounds.size.height)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        _tabBar.delegate = self;
        //_tabBar.canCancelContentTouches = YES;
        
        UIImageView *headerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tabBarWidth, kTabBarHeaderSizeHeight)];
        headerImgView.backgroundColor = [UIColor clearColor];
//        headerImgView.image = [UIImage imageNamed:IMG_Feeds_TabBar_Header];
        _tabBar.tableHeaderView = headerImgView;
    }
    return _tabBar;
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex < [self.viewControllers count]) {
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    }
    return nil;
}

- (CGRect)expandedRect
{
    return CGRectMake(_maximumWidth, 0, self.view.bounds.size.width-_minimumWidth, self.view.bounds.size.height);
}

- (CGRect)contractedRect
{
    return CGRectMake(_minimumWidth, 0, self.view.bounds.size.width-_minimumWidth, self.view.bounds.size.height);
}


#pragma mark - Setter methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    
    //// Creates the tab bar items
    if (self.tabBar)
    {
        NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[_viewControllers count]];
        
        for (UIViewController *vc in _viewControllers) {
            [tabBarItems addObject:vc.tabBarItem];
            
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nc = (UINavigationController *)vc;
                
                CGRect bounds = CGRectMake(0, 0, 1024.0, 44.0);
                UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                                 byRoundingCorners:UIRectCornerTopLeft
                                                                       cornerRadii:CGSizeMake(6.0, 6.0)];
                
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                shapeLayer.frame = nc.navigationBar.layer.bounds;
                shapeLayer.path = bezierPath.CGPath;
                nc.navigationBar.layer.mask = shapeLayer;
                nc.navigationBar.layer.masksToBounds = YES;
                nc.navigationBar.layer.shouldRasterize = YES;
                nc.navigationBar.layer.rasterizationScale = [UIScreen mainScreen].scale;
            }
        }

        _tabBar.items = tabBarItems;
    }
    
    // Sets the value for the first time as -1 for the viewController to load itself properly
    _selectedIndex = -1;
    self.selectedIndex = _selectedIndex;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [self setViewControllers:viewControllers];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    self.selectedIndex = [self.viewControllers indexOfObject:selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex && selectedIndex < [self.viewControllers count])
    {
        //// Add the new view controller to hierarchy
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
        [self addChildViewController:selectedViewController];
        
        //// Set the expanded and contracted CGRect
        CGRect rect = CGRectZero;
        if (_shouldStartExpanded) rect = [self expandedRect];
        else rect = _expanded ? [self expandedRect] : [self contractedRect];
        
        if (_shouldStartAnimated) {
            _shouldStartAnimated = NO;
            selectedViewController.view.frame = _shouldStartExpanded ? [self contractedRect] : [self expandedRect];
            
            [UIView animateWithDuration:_shouldStartAnimated ? 0.3 : 0.0
                             animations:^{selectedViewController.view.frame = rect;}];
        }
        else {
            selectedViewController.view.frame = rect;
        }

        selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:selectedViewController.view];
        
        if (_shouldContractWhenSelecting) {
            [self contractMenu];
        }
        
        //// Remove the previously selected view controller (if any)
        if (_selectedIndex < INT_MAX) {
            UIViewController *previousViewController = [self.viewControllers objectAtIndex:_selectedIndex];
            [previousViewController.view removeFromSuperview];
            [previousViewController removeFromParentViewController];
        }
        
        //// Set the new selected index
        _selectedIndex = selectedIndex;
        
        //// Update the tabBar's item
        if (selectedIndex < [self.tabBar.items count]) {
            self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:selectedIndex];
        }

        //// Inform the delegate of the new selection
        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:didSelectViewController:)]) {
            [_delegate verticalTabBarController:self didSelectViewController:selectedViewController];
        }
    }
    else if (selectedIndex == _selectedIndex && _selectedIndex < INT_MAX)
    {
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
        
        if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)selectedViewController;
            if ([nc.viewControllers indexOfObject:nc.topViewController] != 0) {
                [nc popToRootViewControllerAnimated:YES];
            }
        }
        
        [self contractMenu];
    }
    
    
    if (_shouldStartExpanded) {
        _shouldStartExpanded = NO;
        _expanded = YES;
    }
}


#pragma mark FUIVerticalTabBarController methods

- (void)switchMenu
{
    if (_expanded) [self contractMenu];
    else [self expandMenu];
}

- (void)expandMenu
{
    if (!_expanded)
    {
        NSLog(@"%s",__FUNCTION__);
        
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:_selectedIndex];
        _tabBar.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.3
                         animations:^{selectedViewController.view.frame = [self expandedRect];}
                         completion:^(BOOL finished){_expanded = YES;
                             _tabBar.userInteractionEnabled = YES;}];
    }
}

- (void)contractMenu
{
    if (_expanded)
    {
        NSLog(@"%s",__FUNCTION__);
        
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:_selectedIndex];
        _tabBar.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.3
                         animations:^{selectedViewController.view.frame = [self contractedRect];}
                         completion:^(BOOL finished){_expanded = NO;
                             _tabBar.userInteractionEnabled = YES;}];
    }
}

- (void)willRotateTabBar
{
    [self.tabBar reloadData];
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:_selectedIndex];
}

- (void)didRotateTabBar
{
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:_selectedIndex];
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = (FUIVerticalTabBarButton *)[tableView cellForRowAtIndexPath:indexPath];
    if (button.isUnread) [button setUnread:NO];
    
    [self setSelectedIndex:indexPath.row];
}
 
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:shouldSelectViewController:)]) {
        UIViewController *newController = [self.viewControllers objectAtIndex:indexPath.row];
        BOOL shouldSelect = [_delegate verticalTabBarController:self shouldSelectViewController:newController];
        if (shouldSelect) return indexPath;
    }
    return tableView.indexPathForSelectedRow;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.indexPathForSelectedRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTabBarItemSizeHeight;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__FUNCTION__);
    
    [super touchesBegan:touches withEvent:event];
    [self setSelectedIndex:self.tabBar.indexPathForSelectedRow.row];
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
    return YES;
}

@end

//
//  FUIVerticalTabBarController.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FUIVerticalTabBarController.h"
#import "FUIVerticalTabBarButton.h"

#define IOS_OLDER_THAN_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 7.0 )
#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )

static CGPoint panningHorizontalPosition;

@interface FUIVerticalTabBarController () <UIGestureRecognizerDelegate> {
    BOOL _didSelect;
}
@end

@implementation FUIVerticalTabBarController

- (id)init
{
    if (self = [super init])
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            _startAnimated = NO;
            _startExpanded = NO;
        }
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
        
    if (![_tabBar superview]) {
        [self.view insertSubview:self.tabBar atIndex:0];
        
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.view.autoresizesSubviews = YES;
        self.view.backgroundColor = _tabBar.backgroundColor;
    }
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
        _tabBar = [[FUIVerticalTabBar alloc] initWithFrame:CGRectMake(0, 0, _maximumWidth, self.view.bounds.size.height)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
        _tabBar.delegate = self;
        _tabBar.canCancelContentTouches = YES;
        
        _tabBar.tableHeaderView = _headerView;
        
        if (_bottomView) {
            CGRect _tabBarRect = _tabBar.frame;
            _tabBarRect.size.height -= _bottomView.frame.size.height;
            _tabBar.frame = _tabBarRect;
            
            CGRect bottomViewRect = _bottomView.frame;
            bottomViewRect.origin.y = _tabBarRect.size.height;
            _bottomView.frame = bottomViewRect;
            
            [self.view insertSubview:_bottomView aboveSubview:_tabBar];
        }
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
    NSLog(@"%s",__FUNCTION__);
    
    _viewControllers = viewControllers;
    
    //// Creates the tab bar items
    if (self.tabBar)
    {
        NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:[_viewControllers count]];
        
        for (UIViewController *vc in _viewControllers) {
            [tabBarItems addObject:vc.tabBarItem];
            [vc.tabBarItem addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
            vc.view.clipsToBounds = YES;
            
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nc = (UINavigationController *)vc;
                nc.navigationBar.clipsToBounds = YES;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                tapGesture.delegate = self;
                [nc.view addGestureRecognizer:tapGesture];

                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanning:)];
                panGesture.maximumNumberOfTouches = 1;
                panGesture.minimumNumberOfTouches = 1;
                panGesture.delegate = self;
                [nc.view addGestureRecognizer:panGesture];
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
        if (_startExpanded) rect = [self expandedRect];
        else rect = _expanded ? [self expandedRect] : [self contractedRect];
        
        if (_startAnimated) {
            _startAnimated = NO;
            selectedViewController.view.frame = _startExpanded ? [self contractedRect] : [self expandedRect];
            
            [UIView animateWithDuration:_startAnimated ? 0.3 : 0.0
                             animations:^{selectedViewController.view.frame = rect;}];
        }
        else {
            selectedViewController.view.frame = rect;
        }

        selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:selectedViewController.view];
        
        if ([self.delegate verticalTabBarControllerContractWhenSelecting:self] && !_didSelect) {
            _didSelect = YES;
            [self performSelector:@selector(contractMenu) withObject:nil afterDelay:0.2];
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
    else if (selectedIndex == _selectedIndex && _selectedIndex < self.viewControllers.count)
    {
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:selectedIndex];
        
        if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nc = (UINavigationController *)selectedViewController;
            if ([nc.viewControllers indexOfObject:nc.topViewController] != 0) {
                [nc popToRootViewControllerAnimated:YES];
            }
        }
        
        [self contractMenu];
        
        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:didSelectViewController:)]) {
            [_delegate verticalTabBarController:self didSelectViewController:selectedViewController];
        }
    }
    
    if (_startExpanded) {
        _startExpanded = NO;
        _expanded = YES;
    }
}

- (void)setTabBarHeaderHeight:(CGFloat)height
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _tabBarHeaderHeight = 44.0;
    else _tabBarHeaderHeight = height;
    
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        _tabBarHeaderHeight+=[UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

- (void)setMinimumWidth:(CGFloat)width
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _minimumWidth = 0;
    else _minimumWidth = width;
}

- (void)setMaximumWidth:(CGFloat)width
{
    _maximumWidth = width;
}

- (void)setStartAnimated:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _startAnimated = NO;
    else _startAnimated = animated;
}

- (void)setStartExpanded:(BOOL)expanded
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _startExpanded = NO;
    else _startExpanded = expanded;
}

- (void)setUserInteractionEnabled:(BOOL)enabled ForView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        subview.userInteractionEnabled = enabled;
    }
}


#pragma mark - FUIVerticalTabBarController methods

- (void)switchMenu:(id)sender
{
    if (_expanded) [self contractMenu];
    else [self expandMenu];
}

- (void)expandMenu
{
    [self expandMenuWithDuration:0.3];
}

- (void)expandMenuWithDuration:(CGFloat)duration
{
    if (_selectedIndex < self.viewControllers.count)
    {
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:_selectedIndex];
        [self setUserInteractionEnabled:NO ForView:selectedViewController.view];
        _tabBar.userInteractionEnabled = NO;
        
        CGRect bottomViewRect = _bottomView.frame;
        bottomViewRect.size.width = _maximumWidth;
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{selectedViewController.view.frame = [self expandedRect];
                             if (_bottomView && _adjustBottomViewWhenPanning) _bottomView.frame = bottomViewRect;
                         }
                         completion:^(BOOL finished){_expanded = YES;
                             _tabBar.userInteractionEnabled = YES;
                         }];
    }
}

- (void)contractMenu
{
    if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerWillContract:)]) {
        [_delegate verticalTabBarControllerWillContract:self];
    }
    
    [self contractMenuWithDuration:0.3];
}

- (void)contractMenuWithDuration:(CGFloat)duration
{
    if (_selectedIndex < self.viewControllers.count)
    {
        UIViewController *selectedViewController = [self.viewControllers objectAtIndex:_selectedIndex];
        _tabBar.userInteractionEnabled = NO;
        
        CGRect bottomViewRect = _bottomView.frame;
        bottomViewRect.size.width = _minimumWidth;
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{selectedViewController.view.frame = [self contractedRect];
                             if (_bottomView && _adjustBottomViewWhenPanning) _bottomView.frame = bottomViewRect;
                         }
                         completion:^(BOOL finished){_expanded = NO;
                             [self setUserInteractionEnabled:YES ForView:selectedViewController.view];
                             _tabBar.userInteractionEnabled = YES;
                             _didSelect = NO;
                         }];
    }
}

- (void)handlePanning:(UIPanGestureRecognizer *)panGesture
{
    if (![self.delegate verticalTabBarControllerCanMoveHorizontally:self]) {
        return;
    }
    
    [self.view bringSubviewToFront:[panGesture view]];
    CGPoint newPoint = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        panningHorizontalPosition = panGesture.view.frame.origin;
    }
    
    newPoint = CGPointMake(panningHorizontalPosition.x + newPoint.x, 0);
    if (newPoint.x < _minimumWidth) newPoint.x = _minimumWidth;
    else if (newPoint.x > _maximumWidth) newPoint.x = _maximumWidth;
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (newPoint.x >= _minimumWidth && newPoint.x <= _maximumWidth)
        {
            CGRect frame = panGesture.view.frame;
            frame.origin = newPoint;
            [panGesture.view setFrame:frame];
            
            if (_bottomView) [self adjustBottomViewToWidth:newPoint.x];
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGFloat menuWidth = _maximumWidth - _minimumWidth;
        CGFloat threshold = 0.2;
        CGFloat velocityX = (threshold * [panGesture velocityInView:self.view].x);
        
        if (abs(velocityX) < 100) {
            if (newPoint.x > roundf(menuWidth/2)) [self expandMenu];
            else [self contractMenu];
        }
        else {
            CGFloat duration = (ABS(velocityX) * (threshold/1000)) + threshold;
            if (velocityX > 0) [self expandMenuWithDuration:duration];
            else [self contractMenuWithDuration:duration];
        }
    }
}

- (void)adjustBottomViewToWidth:(CGFloat)width
{
    if (_adjustBottomViewWhenPanning) {
        if (width > _maximumWidth) width = _maximumWidth;
        else if (width < _minimumWidth) width = _minimumWidth;
        
        CGRect bottomViewRect = _bottomView.frame;
        bottomViewRect.size.width = width;
        
        [UIView animateWithDuration:0.01 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                         animations:^{_bottomView.frame = bottomViewRect;} completion:NULL];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture
{
    if (_expanded) {
        
        if ([self.delegate verticalTabBarControllerContractAfterTap:self] && [tapGesture.view isEqual:self.selectedViewController.view]) {
            [self contractMenu];
        }
    }
}

- (void)willRotateTabBar
{
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:_selectedIndex];
}

- (void)didRotateTabBar
{
    self.tabBar.selectedItem = [self.tabBar.items objectAtIndex:_selectedIndex];
}

- (void)reset
{
    for (UIViewController *controller in self.childViewControllers) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    [self setViewControllers:nil];
    [self.tabBar setItems:nil];
    
    if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerDidReset:)]) {
        [_delegate verticalTabBarControllerDidReset:self];
    }
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_didSelect)
    {
        FUIVerticalTabBarButton *button = (FUIVerticalTabBarButton *)[tableView cellForRowAtIndexPath:indexPath];
        if (button.isUnread) [button setUnread:NO];
        
        [self setSelectedIndex:indexPath.row];
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tabBarButtonHeight;
}


#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && !_expanded) return NO;
    else return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [panGestureRecognizer translationInView:self.view];
        
        if (translation.x < 0 && !_expanded) {
            return NO;
        }

        return (fabs(translation.y) == 0);
    }
    else if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && _expanded) {
        return YES;
    }
    else return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return _expanded;
}


#pragma mark - NSKeyValueObserving (KVO) Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[UITabBarItem class]]) {
        
        NSInteger buttonIndex = [_tabBar.items indexOfObject:object];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
        [_tabBar updateContentAtIndexPath:indexPath];
    }
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

@end

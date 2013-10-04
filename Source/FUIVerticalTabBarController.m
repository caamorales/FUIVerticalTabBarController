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

static CGPoint panningHorizontalPosition;
static NSMutableArray *_tabBarItemToObserve;

@interface FUIVerticalTabBarController () <UIGestureRecognizerDelegate> {
    UIStatusBarStyle _originalStatusBarStyle;
}
@property (nonatomic, strong) UIView *statusBarBackground;
@property (nonatomic) BOOL didSelect;
@end

@implementation FUIVerticalTabBarController

- (id)init
{
    if (self = [super init])
    {
        _selectedIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1
    [self.view addSubview:self.statusBarBackground];
#endif
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
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        _tabBar.delegate = self;
        _tabBar.canCancelContentTouches = YES;
        
        _tabBar.tableHeaderView = _headerView;
        
        if (_footerView) {
            CGRect _tabBarRect = _tabBar.frame;
            _tabBarRect.size.height -= _footerView.frame.size.height;
            _tabBar.frame = _tabBarRect;
            
            CGRect footerViewRect = _footerView.frame;
            footerViewRect.origin.y = _tabBarRect.size.height;
            _footerView.frame = footerViewRect;
            
            [self.view insertSubview:_footerView aboveSubview:_tabBar];
        }
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [_tabBar addGestureRecognizer:panGesture];
    }
    return _tabBar;
}

- (UIView *)statusBarBackground
{
    if (!_statusBarBackground)
    {
        _statusBarBackground = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        
        if (!_statusBarColor) _statusBarColor = [UIColor blackColor];
        _statusBarBackground.backgroundColor = _statusBarColor;
        
        _statusBarBackground.alpha = _startExpanded ? 1.0 : 0.0;
        _originalStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    }
    return _statusBarBackground;
}

- (UIViewController *)viewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self validIndexPath:indexPath]) {
        return nil;
    }
    
    NSArray *controllers = [self.viewControllers objectAtIndex:indexPath.section];
    return [controllers objectAtIndex:indexPath.row];
}

- (UIViewController *)selectedViewController
{
    return [self viewControllerAtIndexPath:self.selectedIndexPath];
}

- (CGRect)rectToExpand
{
    return CGRectMake(_maximumWidth, 0, self.view.bounds.size.width-_minimumWidth, self.view.bounds.size.height);
}

- (CGRect)rectToContract
{
    return CGRectMake(_minimumWidth, 0, self.view.bounds.size.width-_minimumWidth, self.view.bounds.size.height);
}

- (BOOL)validIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil && indexPath.section < INT_MAX && indexPath.row < INT_MAX) {
        if (indexPath.section < self.viewControllers.count) {
            NSArray *controllers = [self.viewControllers objectAtIndex:indexPath.section];
            if (indexPath.row < controllers.count) {
                return YES;
            }
            else return NO;
        }
        else return NO;
    }
    else return NO;
}

- (BOOL)sameIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath && _selectedIndexPath.section == indexPath.section && _selectedIndexPath.row == indexPath.row) ? YES : NO;
}

- (NSArray *)tabBarItemKeyPathsToObserve
{
    if (!_tabBarItemToObserve) {
        _tabBarItemToObserve = [NSMutableArray arrayWithObject:@"badgeValue"];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_6_1
        [_tabBarItemToObserve addObjectsFromArray:@[@"finishedUnselectedImage", @"finishedSelectedImage"]];
#else
        [_tabBarItemToObserve addObjectsFromArray:@[@"image", @"selectedImage"]];
#endif
    }
    return _tabBarItemToObserve;
}


#pragma mark - Setter methods

- (void)setViewControllers:(NSArray *)viewControllers
{
    // Checks if the instance is already initialized.
    if (_viewControllers) {
        return;
    }
    
    if (![[viewControllers lastObject] isKindOfClass:[NSArray class]]) {
        _viewControllers =  @[viewControllers];
    }
    else _viewControllers = viewControllers;
    
    //// Creates the tab bar items
    if (self.tabBar) {
        NSMutableArray *tabBarItems = [NSMutableArray arrayWithCapacity:_viewControllers.count];
        
        for (NSArray *controllers in _viewControllers) {
            
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:[controllers count]];

            for (UIViewController *vc in controllers) {
                
                UITabBarItem *tabBarItem = vc.tabBarItem;
                [items addObject:tabBarItem];
                
                for (NSString *keyPath in self.tabBarItemKeyPathsToObserve) {
                    [tabBarItem addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
                    [UITabBarItem automaticallyNotifiesObserversForKey:keyPath];
                }
                
                UIViewController *controller = nil;
                if ([vc isKindOfClass:[UINavigationController class]]) controller = (UINavigationController *)vc;
                else controller = vc;
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
                tapGesture.delegate = self;
                [controller.view addGestureRecognizer:tapGesture];
                
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
                panGesture.maximumNumberOfTouches = 1;
                panGesture.minimumNumberOfTouches = 1;
                panGesture.delegate = self;
                [controller.view addGestureRecognizer:panGesture];
                
                if (_sideShadow) [self renderShadowForControllerView:controller.view];
            }
            
            [tabBarItems addObject:items];
        }

        _tabBar.items = tabBarItems;
    }
    
    self.selectedIndexPath = _selectedIndexPath;
}

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    [self setViewControllers:viewControllers];
}

- (void)setSelectedIndexPath:(NSIndexPath *)indexPath
{
    // Checks if the index path is valid.
    if (![self validIndexPath:indexPath]) {
        return;
    }
    
    if ([self sameIndexPath:indexPath]) {
        UIViewController *selectedViewController = [self viewControllerAtIndexPath:indexPath];
        
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
    else if (indexPath.section < [self.viewControllers count])
    {
        // Adds the new view controller to hierarchy
        UIViewController *selectedViewController = [self viewControllerAtIndexPath:indexPath];
        [self addChildViewController:selectedViewController];
        
        // Sets the expanded or contracted rectangle
        CGRect rect = CGRectZero;
        if (_startExpanded) rect = [self rectToExpand];
        else rect = _expanded ? [self rectToExpand] : [self rectToContract];
        
        if (_startAnimated) {
            _startAnimated = NO;
            selectedViewController.view.frame = _startExpanded ? [self rectToContract] : [self rectToExpand];
            
            [UIView animateWithDuration:_startAnimated ? 0.3 : 0.0
                             animations:^{selectedViewController.view.frame = rect;}];
        }
        else {
            selectedViewController.view.frame = rect;
        }

        selectedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if (_statusBarBackground) [self.view insertSubview:selectedViewController.view belowSubview:_statusBarBackground];
        else [self.view addSubview:selectedViewController.view];
        

        if ([self.delegate verticalTabBarControllerContractWhenSelecting:self] && !_didSelect) {
            _didSelect = YES;
            [self performSelector:@selector(contractMenu) withObject:nil afterDelay:0.2];
        }
        
        // Removes the previously selected view controller (if any)
        UIViewController *previousViewController = [self viewControllerAtIndexPath:_selectedIndexPath];
        
        // Informs the delegate of the upcoming selection
        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:willDeselectViewController:)]) {
            [_delegate verticalTabBarController:self willDeselectViewController:previousViewController];
        }
        
        [previousViewController.view removeFromSuperview];
        [previousViewController removeFromParentViewController];
        
        // Sets the new selected index
        _selectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        [self.tabBar selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];

        // Updates the tabBar's item
        if (indexPath.row < [self.tabBar.items count]) {
            self.tabBar.selectedItem = [self.tabBar tabBarItemAtIndexPath:indexPath];
        }

        // Informs the delegate of the new selection
        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:didSelectViewController:)]) {
            [_delegate verticalTabBarController:self didSelectViewController:selectedViewController];
        }
    }
    
    // Disables the 'start expanded' attribute.
    if (_startExpanded) {
        _startExpanded = NO;
        _expanded = YES;
    }
}

//- (void)setExpanded:(BOOL)expanded
//{
////    if (_expanded == expanded) {
////        return;
////    }
//    
//    _expanded = expanded;
//    
//    if (_expanded) {
//        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerDidExpand:)]) {
//            [_delegate verticalTabBarControllerDidExpand:self];
//        }
//    }
//    else {
//        if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerDidContract:)]) {
//            [_delegate verticalTabBarControllerDidContract:self];
//        }
//    }
//}

- (void)setMinimumWidth:(CGFloat)width
{
    if (_minimumWidth == width) {
        return;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _minimumWidth = 0;
    else _minimumWidth = width;
}

- (void)setMaximumWidth:(CGFloat)width
{
    if (_maximumWidth == width) {
        return;
    }
    
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

- (void)setAllUserInteractionEnabled:(BOOL)enabled
{
    for (UIView *subview in self.selectedViewController.view.subviews) {
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
    if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerWillExpand:)]) {
        [_delegate verticalTabBarControllerWillExpand:self];
    }
    
    [self expandMenuWithDuration:0.3];
}

- (void)expandMenuWithDuration:(CGFloat)duration
{
    if (![self validIndexPath:_selectedIndexPath]) {
        return;
    }
    
    _expanded = YES;
    UIViewController *selectedViewController = [self viewControllerAtIndexPath:_selectedIndexPath];
    [self setAllUserInteractionEnabled:NO];
    
    CGRect footerRect = _footerView.frame;
    footerRect.size.width = _maximumWidth;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         selectedViewController.view.frame = [self rectToExpand];
                         
                         if (_statusBarBackground) [self updateStatusBar];
                         if (_footerView && _adjustFooterViewWhenPanning) _footerView.frame = footerRect;
                     }
                     completion:^(BOOL finished){
                         
                         if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerDidExpand:)] &&
                             selectedViewController.view.frame.origin.x == _maximumWidth) {
                             [_delegate verticalTabBarControllerDidExpand:self];
                         }
                     }];
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
    if (![self validIndexPath:_selectedIndexPath]) {
        return;
    }
    
    _expanded = NO;
    UIViewController *selectedViewController = [self viewControllerAtIndexPath:_selectedIndexPath];
    
    CGRect footerRect = _footerView.frame;
    footerRect.size.width = _minimumWidth;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         selectedViewController.view.frame = [self rectToContract];
                         
                         if (_footerView && _adjustFooterViewWhenPanning) _footerView.frame = footerRect;
                         if (_statusBarBackground) [self updateStatusBar];
                     }
                     completion:^(BOOL finished){
                         
                         [self setAllUserInteractionEnabled:YES];
                         _didSelect = NO;
                         
                         if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerDidContract:)] &&
                             selectedViewController.view.frame.origin.x == _minimumWidth) {
                             [_delegate verticalTabBarControllerDidContract:self];
                         }
                     }];
}

- (void)handlePan:(UIPanGestureRecognizer *)panGesture
{
    if (![self.delegate verticalTabBarControllerCanMoveHorizontally:self] ||
        (![self.delegate verticalTabBarControllerShouldMoveHorizontallyEverywhere:self] && [panGesture.view isEqual:_tabBar])) {
        return;
    }
    
    UIView *targetView = ([panGesture.view isEqual:_tabBar]) ? self.selectedViewController.view : panGesture.view;
    CGPoint newPoint = [panGesture translationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        panningHorizontalPosition = targetView.frame.origin;
    }
    
    newPoint = CGPointMake(panningHorizontalPosition.x + newPoint.x, 0);
    if (newPoint.x < _minimumWidth) newPoint.x = _minimumWidth;
    else if (newPoint.x > _maximumWidth) newPoint.x = _maximumWidth;
    
    
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint velocity = [panGesture velocityInView:targetView];
        
        if (velocity.x > 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerWillExpand:)]) {
                [_delegate verticalTabBarControllerWillExpand:self];
            }
        }
        else {
            if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarControllerWillContract:)]) {
                [_delegate verticalTabBarControllerWillContract:self];
            }
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        if (newPoint.x >= _minimumWidth && newPoint.x <= _maximumWidth) {
            CGRect frame = targetView.frame;
            frame.origin = newPoint;
            [targetView setFrame:frame];
            
            if (_footerView && _adjustFooterViewWhenPanning) [self adjustFooterViewWidth:newPoint.x];
            if (_statusBarBackground) [self adjustStatusBarAlpha:newPoint.x];
        }
        
        if ([self.delegate verticalTabBarControllerShouldMoveHorizontallyEverywhere:self] && _tabBar.scrollEnabled) {
            _tabBar.scrollEnabled = NO;
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        if (newPoint.x == _minimumWidth) _expanded = NO;
        else if (newPoint.x == _maximumWidth) _expanded = YES;
        else {
            CGFloat menuWidth = roundf(_maximumWidth - _minimumWidth);
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
        
        if (_tabBar.scrollMode != FUIVerticalTabBarScrollNever) {
            _tabBar.scrollEnabled = YES;
        }
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

- (void)adjustFooterViewWidth:(CGFloat)xPos
{
    CGRect footerRect = _footerView.frame;
    footerRect.size.width = xPos;
        
    [UIView animateWithDuration:0.01 delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionLayoutSubviews
                     animations:^{_footerView.frame = footerRect;} completion:NULL];
}

- (void)adjustStatusBarAlpha:(CGFloat)xPos
{
    if (xPos > _minimumWidth) {
        CGFloat menuWidth = roundf(_maximumWidth - _minimumWidth);
        CGFloat alpha = (_minimumWidth-xPos)/menuWidth;
        
        if (alpha < 0) alpha *= -1;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1
        UIStatusBarStyle style = (alpha >= 0.5) ? UIStatusBarStyleLightContent : _originalStatusBarStyle;
        if ([UIApplication sharedApplication].statusBarStyle != style) {
            [self updateStatusBarStyle:style];
        }
        
        [UIView animateWithDuration:0.01 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{_statusBarBackground.alpha = alpha;} completion:NULL];
#endif
    }
}

- (void)updateStatusBar
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1
    _statusBarBackground.alpha = _expanded ? 1.0 : 0.0;
    
    UIStatusBarStyle style = _expanded ?  UIStatusBarStyleLightContent : _originalStatusBarStyle;
    [self updateStatusBarStyle:style];
#endif
}

- (void)updateStatusBarStyle:(UIStatusBarStyle)style
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_6_1
    if ([UIApplication sharedApplication].statusBarStyle != style) {
        [[UIApplication sharedApplication] setStatusBarStyle:style animated:YES];
        [self setNeedsStatusBarAppearanceUpdate];
    }
#endif
}

- (void)updateViewDisplay
{
    [_tabBar reloadData];
    [self.tabBar selectRowAtIndexPath:_selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
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
    if (!_didSelect) {
        FUIVerticalTabBarButton *button = (FUIVerticalTabBarButton *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (button.isUnread) [button setUnread:NO];
        [self setSelectedIndexPath:indexPath];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}
 
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(verticalTabBarController:shouldSelectViewController:)]) {
        
        UIViewController *newController = [self viewControllerAtIndexPath:indexPath];
        
        BOOL shouldSelect = [_delegate verticalTabBarController:self shouldSelectViewController:newController];
        if (shouldSelect) return indexPath;
    }
    return _selectedIndexPath;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tabBarButtonHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section > 0) return (_separatorHeight > 0) ? _separatorHeight : 20.0;
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0) {
        CGFloat height = [tableView.delegate tableView:tableView heightForHeaderInSection:section];
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tabBar.frame.size.width, height)];
        header.backgroundColor = [UIColor clearColor];
        return header;
    }
    else return nil;
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
        [self updateViewDisplay];
    }
}


#pragma mark - Utility Methods

- (void)renderShadowForControllerView:(UIView *)view
{
    UIColor *color = [_sideShadow.shadowColor colorWithAlphaComponent:1.0];
    CGFloat opacity = CGColorGetAlpha([_sideShadow.shadowColor CGColor]);
    
    view.layer.shadowColor = [color CGColor];
    view.layer.shadowOffset = _sideShadow.shadowOffset;
    view.layer.shadowRadius = _sideShadow.shadowBlurRadius*2;
    view.layer.shadowOpacity = opacity;
    view.layer.masksToBounds = NO;
    
    CGPathRef path = [[UIBezierPath bezierPathWithRect:view.frame] CGPath];
    view.layer.shadowPath = path;
    
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
}


#pragma mark - View Auto-Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.tabBar.selectedItem = [self.tabBar tabBarItemAtIndexPath:_selectedIndexPath];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
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

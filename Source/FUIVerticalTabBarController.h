//
//  FUIVerticalTabBarController.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//  Licence: MIT-Licence
//

#import "FlatUIKit.h"
//#import "DZCategories.h"
#import "FUIVerticalTabBar.h"

@protocol FUIVerticalTabBarControllerDelegate;

/**
 * @brief A flat vertical tab bar controller based on tableviews and tableviewcells.
 * Inspired in Błażej Biesiada's FSVerticalTabBar project.
 * https://github.com/futuresimple/FSVerticalTabBarController
*/
@interface FUIVerticalTabBarController : UIViewController <UITableViewDelegate>

/** The object that receives the VerticalTabBarController callbacks. */
@property (nonatomic, readwrite, weak) id <FUIVerticalTabBarControllerDelegate> delegate;
/** The tableview simulating a TabBar behaviour. */
@property (nonatomic, readwrite, strong) FUIVerticalTabBar *tabBar;
/** The array containing all the setted viewcontrollers. */
@property (nonatomic, readwrite, copy) NSArray *viewControllers;
/** The selected and showed viewcontroller */
@property (nonatomic, readwrite, assign) UIViewController *selectedViewController;
/** The index of the selected viewcontroller */
@property (nonatomic, readwrite, assign) NSUInteger selectedIndex;
/** The TabBar width. */
@property (nonatomic, readwrite, assign) CGFloat tabBarWidth;
/**  */
@property (nonatomic, readwrite, assign) CGFloat maximumWidth;
/**  */
@property (nonatomic, readwrite, assign) CGFloat minimumWidth;
/**  */
@property (nonatomic, getter = isExpanded) BOOL expanded;
/**  */
@property (nonatomic, strong) UIImage *headerImage;
/**  */
@property (nonatomic) BOOL shouldStartAnimated;
/**  */
@property (nonatomic) BOOL shouldStartExpanded;
/**  */
@property (nonatomic) BOOL shouldContractWhenSelecting;
/**  */
@property (nonatomic) BOOL paneDraggingEnabled;
/**  */
@property (nonatomic) BOOL paneTappingEnabled;
/**  */
@property (nonatomic, strong) UIToolbar *toolbar;


/**
 * Replaces the view controllers currently managed by the navigation controller with the specified items.
 *
 * @param The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack.
 * @param animated If YES, animate the insertion of the top view controller. If NO, replace the view controllers without any animations.
*/
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 * Tells the tabBar that the device will rotate so it can update it's UI elements.
*/
- (void)willRotateTabBar;

- (void)switchMenu;

@end

@protocol FUIVerticalTabBarControllerDelegate <NSObject>
@optional

/**
 * Tells the delegate when the user did select a TabBar item.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @param viewController The selected viewcontroller.
*/
- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

/**
 * Tells the delegate when the user should select a TabBar item.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @param viewController The viewcontroller that should be selected.
 * @returns YES if the TabBar should be selected or not.
*/
- (BOOL)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

- (BOOL)verticalTabBarControllerShouldAllowPanning:(FUIVerticalTabBarController *)tabBarController;


@end

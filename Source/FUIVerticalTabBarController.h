//
//  FUIVerticalTabBarController.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FlatUIKit.h"
#import <QuartzCore/QuartzCore.h>
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
/** The selected and showed viewcontroller. */
@property (nonatomic, readwrite, assign) UIViewController *selectedViewController;
/** The index of the selected viewcontroller. */
@property (nonatomic, readwrite, strong) NSIndexPath *selectedIndexPath;
/** The tab bar button height. */
@property (nonatomic, readwrite, assign) CGFloat tabBarButtonHeight;
/** The TabBar maximum width. */
@property (nonatomic, readwrite, assign) CGFloat maximumWidth;
/** The TabBar minimum width. */
@property (nonatomic, readwrite, assign) CGFloat minimumWidth;
/** The TabBar's separators height. */
@property (nonatomic, readwrite, assign) CGFloat separatorHeight;
/** YES if the menu is expanded. */
@property (nonatomic, getter = isExpanded) BOOL expanded;
/** YES if the menu should start expanded. Default NO. */
@property (nonatomic) BOOL startExpanded;
/** YES if the menu should start expanding animated. Default NO. */
@property (nonatomic) BOOL startAnimated;
/** An additional header view for the section tabs. You might use this for placing a logo, a custom view or even a search bar. */
@property (nonatomic, strong) UIView *headerView;
/** An additional footer view for the section tabs. Use this as a toolbar. */
@property (nonatomic, strong) UIView *footerView;
/** Optionaly, you can set this property to YES if you want that the footer view resize while panning. */
@property (nonatomic) BOOL adjustFooterViewWhenPanning;
/** */
@property (nonatomic, strong) UIColor *statusBarColor;
/** */
@property (nonatomic, getter = isShowingSideShadow) BOOL showSideShadow;


/**
 * Replaces the view controllers currently managed by the navigation controller with the specified items.
 *
 * @param The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack.
 * @param animated If YES, animate the insertion of the top view controller. If NO, replace the view controllers without any animations.
*/
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 * Opens and closes the vertical menu.
 */
- (void)switchMenu:(id)sender;

/**
 * Removes all the content of the tar bar controller, including subviews and child view controllers in it.
 */
- (void)reset;

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

/**  */
- (BOOL)verticalTabBarControllerCanMoveHorizontally:(FUIVerticalTabBarController *)tabBarController;

/**  */
- (BOOL)verticalTabBarControllerContractAfterTap:(FUIVerticalTabBarController *)tabBarController;

/**  */
- (BOOL)verticalTabBarControllerContractWhenSelecting:(FUIVerticalTabBarController *)tabBarController;

/**  */
- (void)verticalTabBarControllerWillContract:(FUIVerticalTabBarController *)tabBarController;

/**  */
- (void)verticalTabBarControllerWillExpand:(FUIVerticalTabBarController *)tabBarController;

/**  */
- (void)verticalTabBarControllerDidReset:(FUIVerticalTabBarController *)tabBarController;

@end

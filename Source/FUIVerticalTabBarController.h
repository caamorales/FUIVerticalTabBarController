//
//  FUIVerticalTabBarController.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <FlatUIKit/FlatUIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FUIVerticalTabBar.h"

@protocol FUIVerticalTabBarControllerDelegate;

/**
 * A flat vertical tab bar controller based on tableviews and tableviewcells.
 * iPhone & iPad support. Compatible with iOS6 & iOS7.
 *
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
/** YES if the controller is expanded. */
@property (nonatomic, getter = isExpanded) BOOL expanded;
/** YES if the controller should start expanded. Default NO. On iPhone, this property does noting. */
@property (nonatomic) BOOL startExpanded;
/** YES if the controller should start expanding animated. Default NO. On iPhone, this property does noting. */
@property (nonatomic) BOOL startAnimated;
/** An additional header view for the section tabs. You might use this for placing a logo, a custom view or even a search bar. */
@property (nonatomic, strong) UIView *headerView;
/** An additional footer view for the section tabs. Use this as a toolbar. */
@property (nonatomic, strong) UIView *footerView;
/** Optionaly, you can set this property to YES if you want that the footer view resize while panning. */
@property (nonatomic) BOOL adjustFooterViewWhenPanning;
/** A status bar background color applied only for iOS7 and over. */
@property (nonatomic, strong) UIColor *statusBarColor;
/** An optional side shadow object. */
@property (nonatomic, strong) NSShadow *sideShadow;

/**
 * Replaces the view controllers currently managed by the navigation controller with the specified items.
 * IMPORTANT: This is not yet implemented.
 *
 * @param The view controllers to place in the stack. The front-to-back order of the controllers in this array represents the new bottom-to-top order of the controllers in the navigation stack.
 * @param animated If YES, animate the insertion of the top view controller. If NO, replace the view controllers without any animations.
*/
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 * Expands and collapses the controller.
 * Automatically chooses an opposed state everytime.
 *
 * @param sender The selector's owner object (probably in instance of UIBarButtonItem).
 */
- (void)switchMenu:(id)sender;

/**
 * Removes all the content of the tar bar controller, including subviews and child view controllers in it.
 */
- (void)reset;

@end

@protocol FUIVerticalTabBarControllerDelegate <NSObject>
@required

- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController willDeselectViewController:(UIViewController *)viewController;

/**
 * Tells the delegate when the user did select a TabBar item.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @param viewController The selected viewcontroller.
*/
- (void)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

/**
 * Asks the delegate if the user should select a particular TabBar item.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @param viewController The viewcontroller that should be selected.
 * @returns YES if the TabBar should be selected or not.
*/
- (BOOL)verticalTabBarController:(FUIVerticalTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 * Asks the delegate if the user might pan horizontally to expand/contract the controller.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @returns YES if the panning gesture should be enabled.
 */
- (BOOL)verticalTabBarControllerCanPanHorizontally:(FUIVerticalTabBarController *)tabBarController;

/**
 * Asks the delegate if any tap on the visible view controller should trigger the controller to contract.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @returns YES if the controller should contract.
 */
- (BOOL)verticalTabBarControllerContractAfterTap:(FUIVerticalTabBarController *)tabBarController;

/**
 * Asks the delegate if after selecting a tab the meny should contract.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 * @returns YES if the controller should contract.
 */
- (BOOL)verticalTabBarControllerContractWhenSelecting:(FUIVerticalTabBarController *)tabBarController;


@optional

/**
 * Tells the delegate that the controller will contract.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 */
- (void)verticalTabBarControllerWillContract:(FUIVerticalTabBarController *)tabBarController;

/**
 * Tells the delegate that the controller did contract.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 */
- (void)verticalTabBarControllerDidContract:(FUIVerticalTabBarController *)tabBarController;

/**
 * Tells the delegate that the controller will expand.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 */
- (void)verticalTabBarControllerWillExpand:(FUIVerticalTabBarController *)tabBarController;

/**
 * Tells the delegate that the controller did contract.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 */
- (void)verticalTabBarControllerDidExpand:(FUIVerticalTabBarController *)tabBarController;

/**
 * Tells the delegate that the controller did reset all its content.
 *
 * @param tabBarController The current FUIVerticalTabBarController.
 */
- (void)verticalTabBarControllerDidReset:(FUIVerticalTabBarController *)tabBarController;

@end

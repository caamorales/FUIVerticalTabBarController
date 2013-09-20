//
//  FUIVerticalTabBar.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FlatUIKit.h"

#define FUIVerticalTabBarIdentifier NSStringFromClass([FUIVerticalTabBarButton class])

typedef enum {FUIVerticalTabBarScrollAlways, FUIVerticalTabBarScrollToFit, FUIVerticalTabBarScrollNever} FUIVerticalTabBarScrollMode;

/**
 * @brief A tableview simulating a TabBar behaviour, in charge of the data source of the component. 
*/
@interface FUIVerticalTabBar : UITableView <UITableViewDataSource>

/** The TabBar items of each viewcontroller. */
@property (nonatomic, copy) NSArray *items;
/** The selected TabBar item. */
@property (nonatomic, weak) UITabBarItem *selectedItem;
/** The selection indicator image */
@property (nonatomic, strong) UIImage *selectionIndicatorImage;
/** The scrolling mode of the TabBar table. */
@property (nonatomic, assign) FUIVerticalTabBarScrollMode scrollMode;
/** The tab background's color for the selected state. */
@property (nonatomic, strong) UIColor *selectedTabColor;
/** The tab background's color for the unselected state. */
@property (nonatomic, strong) UIColor *unselectedTabColor;
/** The tab text's color for the normal state. */
@property (nonatomic, strong) UIColor *textColor;
/** The tab text's color for the highlighted state. */
@property (nonatomic, strong) UIColor *highlightedTextColor;
/** The tab text's font. */
@property (nonatomic, strong) UIFont *textFont;
/** The tab badge's text color for normal state. */
@property (nonatomic, strong) UIColor *badgeTextColor;
/** The tab badge's text font. */
@property (nonatomic, strong) UIFont *badgeTextFont;


/** 
 * Updates the content of a particular button from an index.
 * 
 * @param indexPath The index path of the button.
 */
- (void)updateContentAtIndexPath:(NSIndexPath *)indexPath;

@end

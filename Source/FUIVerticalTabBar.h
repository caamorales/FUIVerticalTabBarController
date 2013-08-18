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
@property (nonatomic, readwrite, copy) NSArray *items;
/** The selected TabBar item. */
@property (nonatomic, weak) UITabBarItem *selectedItem;
/** The selection indicator image */
@property (nonatomic, strong) UIImage *selectionIndicatorImage;
/** The scrolling mode of the TabBar table. */
@property (nonatomic, assign) FUIVerticalTabBarScrollMode scrollMode;
/**  */
@property (nonatomic, strong) UIColor *unselectedTabColor;
/**  */
@property (nonatomic, strong) UIColor *selectedTabColor;
/**  */
@property (nonatomic, strong) UIColor *textColor;
/**  */
@property (nonatomic, strong) UIColor *highlightedTextColor;
/**  */
@property (nonatomic, strong) UIFont *textFont;
/**  */
@property (nonatomic, strong) UIColor *badgeTextColor;
/**  */
@property (nonatomic, strong) UIFont *badgeTextFont;


/**  */
- (void)updateContentAtIndexPath:(NSIndexPath *)indexPath;

@end

//
//  FUIVerticalTabBarButton.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FlatUIKit.h"

/**
 * @brief A custom tableview cell used for simulating an UITabBarItem behaviour.
*/
@interface FUIVerticalTabBarButton : UITableViewCell

/**  */
@property (nonatomic, strong) UIColor *foregroundColor;
/**  */
@property (nonatomic, strong) NSString *badgeValue;
/**  */
@property (nonatomic, weak) UIColor *badgeTextColor;
/**  */
@property (nonatomic, weak) UIFont *badgeTextFont;
/**  */
@property (nonatomic, weak) UIColor *badgeColor;
/**  */
@property (nonatomic, weak) UIColor *badgeHighlightedColor;
/**  */
@property (nonatomic, getter = isUnread) BOOL unread;
/**  */
@property (nonatomic, assign) CGFloat height;

/**  */
+ (NSInteger)badgeCountForValue:(NSString *)value;

@end

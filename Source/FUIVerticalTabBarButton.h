//
//  FUIVerticalTabBarButton.h
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FlatUIKit.h"

#define IOS_OLDER_THAN_7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 )

/**
 * @brief A custom tableview cell used for simulating an UITabBarItem behaviour.
*/
@interface FUIVerticalTabBarButton : UITableViewCell

/** The  */
@property (nonatomic, strong) UIColor *foregroundColor;
/** The badge's count value string. */
@property (nonatomic, strong) NSString *badgeValue;
/** The badge's text color for normal state. */
@property (nonatomic, weak) UIColor *badgeTextColor;
/** The badge's text font. */
@property (nonatomic, weak) UIFont *badgeTextFont;
/** The badge's background color. */
@property (nonatomic, weak) UIColor *badgeColor;
/** YES if the button is indicating unread content, by showing a left-edged & colored indicator view. */
@property (nonatomic, getter = isUnread) BOOL unread;
/** The height of the button. */
@property (nonatomic, assign) CGFloat height;

/**  
 * Transforms the badge count value from string to number.
 *
 * @param value The badge count string.
 * @return The badge count integer number.
 */
+ (NSInteger)badgeCountForValue:(NSString *)value;

@end

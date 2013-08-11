//
//  AppDelegate.h
//  Sample
//
//  Created by Ignacio on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIVerticalTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FUIVerticalTabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FUIVerticalTabBarController *verticalTabBarController;

@end

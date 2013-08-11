//
//  UIColor+Sample.m
//  Sample
//
//  Created by Ignacio on 8/5/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//

#import "UIColor+Sample.h"
#import "UIColor+FlatUI.h"

@implementation UIColor (Sample)

// Sample UI Colors

+ (UIColor *)slateDarkGray
{
    static UIColor *_slateDarkGray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateDarkGray = [UIColor colorFromHexCode:@"242b35"];
    });
    return _slateDarkGray;
}

+ (UIColor *)slateGray
{
    static UIColor *_slateGray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateGray = [UIColor colorFromHexCode:@"313842"];
    });
    return _slateGray;
}

+ (UIColor *)slateMediumGray
{
    static UIColor *_slateMediumGray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateMediumGray = [UIColor colorFromHexCode:@"484e52"];
    });
    return _slateMediumGray;
}

+ (UIColor *)slateLightGray
{
    static UIColor *_slateLightGray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateLightGray = [UIColor colorFromHexCode:@"9fa6b0"];
    });
    return _slateLightGray;
}

+ (UIColor *)slateVeryLightGray
{
    static UIColor *_slateVeryLightGray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateVeryLightGray = [UIColor colorFromHexCode:@"ebf2f7"];
    });
    return _slateVeryLightGray;
}

+ (UIColor *)slateWhite
{
    static UIColor *_slateWhite = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _slateWhite = [UIColor colorFromHexCode:@"f5f9fc"];
    });
    return _slateWhite;
}


// Brand UI Colors

+ (UIColor *)brandColor
{
    static UIColor *_brandColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _brandColor = [UIColor colorFromHexCode:@"1466b3"];
    });
    return _brandColor;
}

+ (UIColor *)brandDarkColor
{
    static UIColor *_brandDarkColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _brandDarkColor = [UIColor colorFromHexCode:@"013461"];
    });
    return _brandDarkColor;
}

+ (UIColor *)brandLightColor
{
    static UIColor *_brandLightColor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _brandLightColor = [UIColor colorFromHexCode:@"139bde"];
    });
    return _brandLightColor;
}

@end

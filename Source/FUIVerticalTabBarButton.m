//
//  FUIVerticalTabBarButton.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FUIVerticalTabBarButton.h"
#import <QuartzCore/QuartzCore.h>

#define kVerticalTabBarButtonHeight 26.0
#define kVerticalTabBarButtonMargin 9.0

@interface FUIVerticalTabBarButton () 
@property (nonatomic, strong) UIView *readingIndicatorView;
@property (nonatomic, strong) UILabel *badgeLabel;
@end

@implementation FUIVerticalTabBarButton

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundView = [UIView new];
        self.selectedBackgroundView = [UIView new];
        
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;

        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Getter Methods

- (UILabel *)badgeLabel
{
    if (!_badgeLabel)
    {
        _badgeLabel = [UILabel new];
        
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = _badgeTextColor;
        _badgeLabel.highlightedTextColor = self.textLabel.highlightedTextColor;
        
        CGFloat radius = kVerticalTabBarButtonHeight/2;
        _badgeLabel.layer.cornerRadius = radius;
        _badgeLabel.layer.borderColor = _badgeTextColor.CGColor;
        _badgeLabel.layer.borderWidth = 1.0;
        _badgeLabel.layer.shouldRasterize = YES;
        _badgeLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return _badgeLabel;
}

- (UIView *)readingIndicatorView
{
    if (!_readingIndicatorView)
    {
        _readingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4.0, _height)];
        _readingIndicatorView.backgroundColor = self.selectedBackgroundView.backgroundColor;
        _readingIndicatorView.userInteractionEnabled = NO;
    }
    return _readingIndicatorView;
}

+ (NSInteger)badgeCountForValue:(NSString *)value
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber *badgeCount = [f numberFromString:value];
    
    return [badgeCount integerValue];
}


#pragma mark - Setter Methods

- (void)setBadgeValue:(NSString *)value
{
    _badgeValue = value;
    
    if (_badgeValue) {
        UIView *accessory = ([FUIVerticalTabBarButton badgeCountForValue:value] > 0) ? self.badgeLabel : nil;
        _badgeLabel.text = _badgeValue;
        [self setAccessoryView:accessory];
    }
    else {
        [self setBadgeLabel:nil];
        [self setUnread:NO];
        [self setAccessoryView:nil];
    }
    
    [self layoutSubviews];
}

- (void)setUnread:(BOOL)unread
{
    if (_unread != unread) {
        
        _unread = unread;
        
        if (_unread && !_readingIndicatorView) {
            [self.contentView addSubview:self.readingIndicatorView];
        }
        else if (!_unread) {
            [_readingIndicatorView removeFromSuperview];
            [self setReadingIndicatorView:nil];
        }
    }
}

- (void)setHeight:(CGFloat)height
{
    _height = height-1;
}


#pragma mark - UITableViewCell Methods

- (void)setSelected:(BOOL)selected animate:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_badgeTextFont && _badgeValue) {
        
        self.badgeLabel.font = _badgeTextFont;
        CGSize badgeSize = CGSizeZero;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_6_1
        CGSize size = [_badgeValue sizeWithFont:_badgeLabel.font constrainedToSize:CGSizeMake(100.0, kVerticalTabBarButtonHeight)];
        badgeSize = CGSizeMake(roundf(size.width), roundf(size.height));
#else
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:_badgeTextFont forKey:NSFontAttributeName];
        CGRect boundingRect = [_badgeValue boundingRectWithSize:CGSizeMake(100.0, kVerticalTabBarButtonHeight) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:stringAttributes context:nil];
        badgeSize = CGSizeMake(roundf(boundingRect.size.width), roundf(boundingRect.size.height));
#endif
        
        CGRect frame = _badgeLabel.frame;
                
        badgeSize.width += kVerticalTabBarButtonMargin*2;
        frame.size = CGSizeMake(roundf(badgeSize.width), kVerticalTabBarButtonHeight);
        _badgeLabel.frame = frame;
    }
    
    _badgeLabel.layer.borderColor = (self.highlighted || self.selected) ? self.textLabel.highlightedTextColor.CGColor : _badgeTextColor.CGColor;
}

@end

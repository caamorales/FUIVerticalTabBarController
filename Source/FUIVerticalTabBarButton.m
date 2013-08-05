//
//  FUIVerticalTabBarButton.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
//  Licence: MIT-Licence
//

#import "FUIVerticalTabBarButton.h"
#import <QuartzCore/QuartzCore.h>

#define kVerticalTabBarButtonHeight 30.0
#define kVerticalTabBarButtonMargin 8.0


@interface FUIVerticalTabBarBadgeLabel : UILabel

- (void)setPersistentBackgroundColor:(UIColor *)color;

@end

@implementation FUIVerticalTabBarBadgeLabel

- (void)setPersistentBackgroundColor:(UIColor*)color {
    super.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color {
    // do nothing - background color never changes
}

@end


@interface FUIVerticalTabBarButton () 
@property (nonatomic, strong) UIView *readingIndicatorView;
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
        self.textLabel.font = [UIFont boldFlatFontOfSize:17.0];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - Getter Methods

- (FUIVerticalTabBarBadgeLabel *)badgeView
{
    FUIVerticalTabBarBadgeLabel *badgeLabel = [[FUIVerticalTabBarBadgeLabel alloc] initWithFrame:CGRectZero];
    badgeLabel.font = [UIFont boldFlatFontOfSize:15.0];
    badgeLabel.textColor = self.textLabel.textColor;
    badgeLabel.highlightedTextColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    [badgeLabel setPersistentBackgroundColor:self.backgroundColor];
    badgeLabel.text = _badgeValue;
    
    badgeLabel.layer.cornerRadius = 4.0;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.layer.shouldRasterize = YES;
    badgeLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    CGSize size = [_badgeValue sizeWithFont:badgeLabel.font constrainedToSize:CGSizeMake(100.0, kVerticalTabBarButtonHeight)];
    size.width += kVerticalTabBarButtonMargin*2;
    badgeLabel.frame = CGRectMake(0, 0, size.width, kVerticalTabBarButtonHeight);
    
    return badgeLabel;
}

- (UIView *)readingIndicatorView
{
    if (!_readingIndicatorView)
    {
        _readingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4.0, _height)];
        _readingIndicatorView.backgroundColor = self.foregroundColor;
        _readingIndicatorView.userInteractionEnabled = NO;
    }
    return _readingIndicatorView;
}


#pragma mark - Setter Methods

- (void)setBadgeValue:(NSString *)value
{
    _badgeValue = value;
    [self setAccessoryView:[self badgeView]];
}

- (void)setUnread:(BOOL)unread
{
    _unread = unread;
    
    if (_unread && !_readingIndicatorView) {
        [self.contentView addSubview:self.readingIndicatorView];
    }
    else if (!_unread) {
        [_readingIndicatorView removeFromSuperview];
        [self setReadingIndicatorView:nil];
    }
}

- (void)setHeight:(CGFloat)height
{
    _height = height-1;
}


#pragma mark - UITableViewCell Methods

//- (void)setSelected:(BOOL)selected animate:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//}
//
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//}

@end

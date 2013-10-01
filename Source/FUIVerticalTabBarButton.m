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

#define kVerticalTabBarButtonHeight 30.0
#define kVerticalTabBarButtonMargin 8.0

@interface FUIVerticalTabBarButton () 
@property (nonatomic, strong) UIView *readingIndicatorView;
@property (nonatomic, strong) UIButton *badgeView;
@end

@implementation FUIVerticalTabBarButton

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundView = [UIView new];
        self.selectedBackgroundView = [UIView new];
        
        self.clipsToBounds = YES;
        self.separatorInset = UIEdgeInsetsZero;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;

        self.textLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


#pragma mark - Getter Methods

- (UIButton *)badgeView
{
    if (!_badgeView)
    {
        _badgeView = [UIButton buttonWithType:UIButtonTypeCustom];
        _badgeView.adjustsImageWhenHighlighted = YES;
        _badgeView.userInteractionEnabled = NO;
        
        _badgeView.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_badgeView setTitle:_badgeValue forState:UIControlStateNormal];
        [_badgeView setTitleColor:_badgeTextColor forState:UIControlStateNormal];
        [_badgeView setTitleColor:_badgeTextColor forState:UIControlStateHighlighted];
        
        [_badgeView setBackgroundImage:[UIImage imageWithColor:_badgeColor cornerRadius:4.0] forState:UIControlStateNormal];
        [_badgeView setBackgroundImage:[UIImage imageWithColor:self.backgroundView.backgroundColor cornerRadius:4.0] forState:UIControlStateHighlighted];
//        [_badgeView setBackgroundImage:[UIImage imageWithColor:self.backgroundView.backgroundColor cornerRadius:4.0] forState:UIControlStateSelected];
    }
    
    _badgeView.titleLabel.font = _badgeTextFont;
    CGSize badgeSize;
    
#ifdef IOS_NEWER_OR_EQUAL_TO_7
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:_badgeView.titleLabel.font forKey:NSFontAttributeName];
    CGRect boundingRect = [_badgeValue boundingRectWithSize:CGSizeMake(100.0, kVerticalTabBarButtonHeight) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:stringAttributes context:nil];
    badgeSize = boundingRect.size;
#else
    badgeSize = [_badgeValue sizeWithFont:_badgeView.titleLabel.font constrainedToSize:CGSizeMake(100.0, kVerticalTabBarButtonHeight)];
#endif
    
    badgeSize.width += kVerticalTabBarButtonMargin*2;
    _badgeView.frame = CGRectMake(0, 0, roundf(badgeSize.width), kVerticalTabBarButtonHeight);
    
    return _badgeView;
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
    if (_badgeValue != value) {
        
        _badgeValue = value;
        
        UIView *accessory = ([FUIVerticalTabBarButton badgeCountForValue:value] > 0) ? self.badgeView : nil;
        [self setAccessoryView:accessory];
    }
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
    [_badgeView setSelected:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [_badgeView setHighlighted:highlighted];
}

@end

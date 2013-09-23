//
//  FUIVerticalTabBar.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "FUIVerticalTabBar.h"
#import "FUIVerticalTabBarButton.h"

@implementation FUIVerticalTabBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain])
    {
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorColor = [UIColor clearColor];
        self.allowsMultipleSelection = NO;
        self.allowsSelection = YES;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (_scrollMode) {
        case FUIVerticalTabBarScrollAlways:
            self.scrollEnabled = YES;
            break;
            
        case FUIVerticalTabBarScrollToFit:
            self.scrollEnabled = (self.rowHeight * [self.items count]) > self.bounds.size.height;
            break;
            
        case FUIVerticalTabBarScrollNever:
            self.scrollEnabled = NO;
            break;
    }
}


#pragma mark - Getter Methods

- (FUIVerticalTabBarButton *)verticalTabBarButtonForIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = [[FUIVerticalTabBarButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FUIVerticalTabBarIdentifier];
    
    button.height = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    button.foregroundColor = _selectedTabColor;
    button.backgroundColor = self.backgroundColor;
    button.selectedBackgroundView.backgroundColor = _selectedTabColor;
    button.backgroundView.backgroundColor = _unselectedTabColor;
    button.textLabel.textColor = _textColor;
    button.textLabel.highlightedTextColor = _highlightedTextColor;
    button.textLabel.font = _textFont;
    button.badgeTextColor = _badgeTextColor;
    button.badgeTextFont = _badgeTextFont;
    button.badgeColor = _selectedTabColor;
    
    return button;
}

- (UITabBarItem *)tabBarItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionItems = [self.items objectAtIndex:indexPath.section];
    if (indexPath.row < sectionItems.count) return [sectionItems objectAtIndex:indexPath.row];
    else return nil;
}

- (UITabBarItem *)selectedItem
{
    NSIndexPath *selectedIndexPath = self.indexPathForSelectedRow;
    return [self tabBarItemAtIndexPath:selectedIndexPath];
}

- (NSInteger)countOnIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = 0;
    for (int i = 0; i < indexPath.section; i++) {
        for (int j = 0; j < indexPath.row; j++) {
            
            NSIndexPath *aIndexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([indexPath isEqual:aIndexPath]) return count;
            else count++;
        }
    }
    
    return count;
}


#pragma mark - Setter Methods

- (void)setItems:(NSArray *)items
{
    _items = [items copy];
    [self reloadData];
}

- (void)setSelectedTabColor:(UIColor *)color
{
    _selectedTabColor = color;
    [self reloadData];
}

- (void)setUnselectedTabColor:(UIColor *)color
{
    _unselectedTabColor = color;
    [self reloadData];
}

- (void)setTextColor:(UIColor *)color
{
    _textColor = color;
    [self reloadData];
}

- (void)setHighlightedTextColor:(UIColor *)color
{
    _highlightedTextColor = color;
    [self reloadData];
}

- (void)setTextFont:(UIFont *)font
{
    _textFont = font;
    [self reloadData];
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem
{
    NSUInteger selectedItemIndex = [self.items indexOfObject:selectedItem];

    if (selectedItemIndex != NSNotFound) {
        [self selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedItemIndex inSection:0]
                          animated:NO
                    scrollPosition:UITableViewScrollPositionNone];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionItems = [self.items objectAtIndex:section];
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = [tableView dequeueReusableCellWithIdentifier:FUIVerticalTabBarIdentifier];
    if (button == nil) button = [self verticalTabBarButtonForIndexPath:indexPath];

    [self configureTarBarButton:button atIndexPath:indexPath];
    
    return button;
}

- (void)configureTarBarButton:(FUIVerticalTabBarButton *)button atIndexPath:(NSIndexPath *)indexPath
{
    UITabBarItem *item = [self tabBarItemAtIndexPath:indexPath];
    
#ifdef IOS_NEWER_OR_EQUAL_TO_7
    button.imageView.highlightedImage = item.selectedImage;
    button.imageView.image = item.image;
#else
    button.imageView.highlightedImage = item.finishedSelectedImage;
    button.imageView.image = item.finishedUnselectedImage;
#endif
    
    button.textLabel.text = item.title;
    button.contentView.tag = indexPath.row;
    button.tag = indexPath.row;

    [button setUnread:([FUIVerticalTabBarButton badgeCountForValue:item.badgeValue] > 0) ? YES : NO];
    [button setBadgeValue:item.badgeValue];
}

- (void)updateContentAtIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = (FUIVerticalTabBarButton *)[self cellForRowAtIndexPath:indexPath];
    [self configureTarBarButton:button atIndexPath:indexPath];
}


//#pragma mark - Responding to Touch Events
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    UITouch *touch = [touches anyObject];
//    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
//        [self.delegate tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:touch.view.tag inSection:0]];
//    }
//}

@end

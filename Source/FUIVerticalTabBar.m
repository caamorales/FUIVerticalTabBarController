//
//  FUIVerticalTabBar.m
//  FUIVerticalTabBarController
//
//  Created by Ignacio Romero Zurbuchen on 8/3/13.
//  Copyright (c) 2013 DZN. All rights reserved.
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

- (UITabBarItem *)selectedItem
{
    NSIndexPath *selectedRowIndexPath = self.indexPathForSelectedRow;
    if (selectedRowIndexPath != nil) return [self.items objectAtIndex:selectedRowIndexPath.row];
    else return nil;
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

- (void)setScrollMode:(FUIVerticalTabBarScrollMode)mode
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) _scrollMode = FUIVerticalTabBarScrollToFit;
    else _scrollMode = mode;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:touch.view.tag inSection:0]];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = [tableView dequeueReusableCellWithIdentifier:FUIVerticalTabBarIdentifier];
    if (button == nil) button = [self verticalTabBarButtonForIndexPath:indexPath];

    [self configureTarBarButton:button atIndexPath:indexPath];
    
    return button;
}

- (FUIVerticalTabBarButton *)verticalTabBarButtonForIndexPath:(NSIndexPath *)indexPath
{
    FUIVerticalTabBarButton *button = [[FUIVerticalTabBarButton alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FUIVerticalTabBarIdentifier];
    button.selectedBackgroundView.backgroundColor = _selectedTabColor;
    button.backgroundView.backgroundColor = _unselectedTabColor;
    button.textLabel.textColor = _textColor;
    button.backgroundColor = self.backgroundColor;
    button.foregroundColor = _selectedTabColor;
    button.highlighted = NO;
    button.height = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    return button;
}

- (void)configureTarBarButton:(FUIVerticalTabBarButton *)button atIndexPath:(NSIndexPath *)indexPath
{
    UITabBarItem *item = [self.items objectAtIndex:indexPath.row];
    
    button.imageView.highlightedImage = item.finishedSelectedImage;
    button.imageView.image = item.finishedUnselectedImage;
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

@end

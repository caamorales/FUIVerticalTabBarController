//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 8/4/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "FUIVerticalTabBarButton.h"

static NSString *CellIdentifier = @"Cell";

@interface ViewController ()
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
                
        UIImage *selectedImage = [UIImage circularImageWithColor:[UIColor colorFromHexCode:@"1f2733"] size:CGSizeMake(20.0, 20.0)];
        UIImage *unselectedImage = [UIImage circularImageWithColor:[UIColor colorFromHexCode:@"c8d1de"] size:CGSizeMake(20.0, 20.0)];
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:nil tag:1];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED <= __IPHONE_6_1
        [self.tabBarItem setFinishedSelectedImage:selectedImage withFinishedUnselectedImage:unselectedImage];
#else
        self.tabBarItem.image = unselectedImage;
        self.tabBarItem.selectedImage = selectedImage;
#endif
        
        NSInteger randomCount = random()%10;
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d", randomCount]];
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row+1];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Auto-Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) return YES;
    else return NO;
}

@end

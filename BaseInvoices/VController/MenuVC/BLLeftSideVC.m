//
//  BLLeftSideVC.m
//  ResumeBuildling
//
//  Created by Mobiz on 10/7/14.
//  Copyright (c) 2014 Mobiz. All rights reserved.
//

#import "BLLeftSideVC.h"
#import "UIViewController+MMDrawerController.h"
#import "BIAppDelegate.h"

@interface BLLeftSideVC ()

@end

BIAppDelegate* appdelegate;

@implementation BLLeftSideVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!appdelegate.isLoginSucesss)
    {
        self.img_thumb.image = [UIImage imageNamed:@"no_img.jpg"];
        self.lblDisplayName.text = @"User Default";
    }
    else
    {
        self.img_thumb.image = appdelegate.currentUser.imageUser;
        self.lblDisplayName.text = appdelegate.currentUser.displayName;
    }
      
    self.myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSDictionary *invoice = [[NSDictionary alloc] initWithObjectsAndKeys:@"Invoices", @"title", @"", @"detail", @"menu_img_invoice.png", @"icon", nil];
    NSDictionary *customers = [[NSDictionary alloc] initWithObjectsAndKeys:@"Customers", @"title", @"", @"detail", @"menu_img_customer.png", @"icon", nil];
    NSDictionary *products = [[NSDictionary alloc] initWithObjectsAndKeys:@"Products", @"title", @"", @"detail", @"menu_img_product.png", @"icon", nil];
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:@"Settings", @"title", @"", @"detail", @"menu_img_settings.png", @"icon", nil];
    NSDictionary *signout = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sign Out", @"title", @"", @"detail", @"menu_img_logout.png", @"icon", nil];
    NSDictionary *bussines = [[NSDictionary alloc] initWithObjectsAndKeys:@"Business", @"title", @"", @"detail", @"business_icon.png", @"icon", nil];
    
    if (!appdelegate.isLoginSucesss) {
        signout = [[NSDictionary alloc] initWithObjectsAndKeys:@"Login", @"title", @"", @"detail", @"menu_img_logout.png", @"icon", nil];
    }
    
    //    self.img_thumb.layer.borderWidth = 1.0f;
    self.img_thumb.layer.masksToBounds = NO;
    self.img_thumb.clipsToBounds = YES;
    self.img_thumb.layer.cornerRadius = 40;
    
    arrData = [NSArray arrayWithObjects:invoice, customers, products, bussines, settings, signout, nil];
    
    
    [self.myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TABLEVIEW
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    if (arrData.count > 0) {
        NSDictionary *currData = [arrData objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [currData objectForKey:@"title"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [currData objectForKey:@"detail"]];
        cell.imageView.image = [UIImage imageNamed:[currData objectForKey:@"icon"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectCategory:indexPath.row];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

@end

//
//  BIBusinessesViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/27/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIBusinessesViewController.h"
#import "BIAppDelegate.h"
#import "BIBussiness.h"
#import "BIAddNewBussiness.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface BIBusinessesViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BIBusinessesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* bussinessForUser = [[NSMutableArray alloc] init];
    
    bussinessForUser = [defaults rm_customObjectForKey:@"bussinessesForUser"];
    
    if (bussinessForUser.count > 0)
    {
        appdelegate.businessForUser = bussinessForUser;
    }   
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddBussiness:(id)sender
{
    BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
    [pushToVC setIsEditBusiness:NO];
    [pushToVC setAddFrom:2];
    
    [self.navigationController pushViewController:pushToVC animated:YES];
}


- (IBAction)onCloseViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.businessForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BIBussiness* bussiness = [appdelegate.businessForUser objectAtIndex:indexPath.row];
    cell.textLabel.text = bussiness.bussinessName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIBussiness* bussiness = [appdelegate.businessForUser objectAtIndex:indexPath.row];
    
//    if (self.isViewCustomerEdit)
//    {
        BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
        [pushToVC setIsEditBusiness:YES];
        [pushToVC setBussinessEdit:bussiness];
        [pushToVC setIndexPathSelected:indexPath];
//
        [self.navigationController pushViewController:pushToVC animated:YES];
//    }
//    else
//    {
//        appdelegate.currentCustomerForAddInvoice = customer;
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

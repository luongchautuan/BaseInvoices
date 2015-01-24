//
//  BICustomerViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICustomerViewController.h"
#import "BIAddCustom.h"
#import "BIAddInvoices.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface BICustomerViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BICustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* customerForUser = [[NSMutableArray alloc] init];
    
    customerForUser = [defaults rm_customObjectForKey:@"customerForUser"];
    
    if (customerForUser.count > 0)
    {
        appdelegate.customerForUser = customerForUser;
    }
    
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddCustomer:(id)sender
{
    BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
    
    if (self.isViewCustomerEdit)
    {
        [self presentViewController:pushToVC animated:YES completion:nil];
//        [self.navigationController pushViewController:pushToVC animated:YES];
    }
    else
    {
        [self presentViewController:pushToVC animated:YES completion:nil];
    }
    
}

- (IBAction)onCloseViewController:(id)sender
{
    if (self.isViewCustomerEdit) {
//        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.customerForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BICustomer* customer = [appdelegate.customerForUser objectAtIndex:indexPath.row];
    cell.textLabel.text = customer.customerBussinessName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BICustomer* customer = [appdelegate.customerForUser objectAtIndex:indexPath.row];
    
    if (self.isViewCustomerEdit)
    {
        BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
        [pushToVC setIsEditCustomer:YES];
        [pushToVC setCustomer:customer];
        [pushToVC setIndexPathSelected:indexPath];
        
        [self presentViewController:pushToVC animated:YES completion:nil];
//        [self.navigationController pushViewController:pushToVC animated:YES];
    }
    else
    {
        appdelegate.currentCustomerForAddInvoice = customer;
        
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    
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

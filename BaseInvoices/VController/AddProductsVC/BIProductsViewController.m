//
//  BIProductsViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/21/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIProductsViewController.h"
#import "BIAddProducts.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@interface BIProductsViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BIProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* productsForUser = [[NSMutableArray alloc] init];
    productsForUser = [defaults rm_customObjectForKey:@"productsForUser"];
//
    NSLog(@"ProductForuser: %@", productsForUser);
    
    if (productsForUser.count > 0) {
        appdelegate.productsForUser = productsForUser;
    }
    
    BIBussiness* bussinessForUser = [defaults rm_customObjectForKey:@"bussinessForUser"];
    appdelegate.bussinessForUser = bussinessForUser;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddProduct:(id)sender
{
    BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
    [self presentViewController:pushToVC animated:YES completion:nil];
//    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onCloseViewController:(id)sender
{
    if (self.isViewEditProduct) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
       [self dismissViewControllerAnimated:YES completion:nil]; 
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appdelegate.productsForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    BIProduct* product = [appdelegate.productsForUser objectAtIndex:indexPath.row];
    cell.textLabel.text = product.productName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BIProduct* product = [appdelegate.productsForUser objectAtIndex:indexPath.row];
    
    if (self.isViewEditProduct)
    {
        BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
        [pushToVC setIsEditProduct:YES];
        [pushToVC setProduct:product];
        
        [self presentViewController:pushToVC animated:YES completion:nil];
//        [self.navigationController pushViewController:pushToVC animated:YES];
    }
    else
    {
        
        [appdelegate.productsFroAddInvoices addObject:product];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate checkCallback];
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

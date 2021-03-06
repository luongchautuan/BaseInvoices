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
#import "SBJson.h"
#import "UIViewController+MMDrawerController.h"

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
    if (_isFromMenu) {
        [self.btnBack setHidden:YES];
        [self.btnMenu setHidden:NO];
    }
    else
    {
        [self.btnMenu setHidden:YES];
        [self.btnBack setHidden:NO];
    }
    
    //Get All customer name from id
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchDisplayController.searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/customer" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL CUSTOMER: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                appdelegate.customerForUser = [[NSMutableArray alloc] init];
                
                for (NSDictionary* customerDic in [dataDict valueForKey:@"data"])
                {
                    BICustomer* customerObject = [[BICustomer alloc] initWithDict:customerDic];
                    [appdelegate.customerForUser addObject:customerObject];
                }
                
                [self.tableView reloadData];
                
            }
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showCat:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
    if (self.isViewCustomerEdit)
    {
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return _searchResults.count;
    }
    
    return appdelegate.customerForUser.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newFriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newFriendCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0f]];
    
    BICustomer* customer = [appdelegate.customerForUser objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        customer = [_searchResults objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = customer.customerBussinessName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BICustomer* customer = [appdelegate.customerForUser objectAtIndex:indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        customer = [_searchResults objectAtIndex:indexPath.row];
    }
    
    if (self.isViewCustomerEdit)
    {
        BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
        [pushToVC setIsEditCustomer:YES];
        [pushToVC setCustomer:customer];
        [pushToVC setIndexPathSelected:indexPath];
        
        [self presentViewController:pushToVC animated:YES completion:nil];
    }
    else
    {
        appdelegate.currentCustomerForAddInvoice = customer;
        [self.delegate didSelectedCustomer:customer];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"customerBussinessName contains[c] %@", searchText];
    _searchResults = [[[appdelegate.customerForUser copy] filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
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

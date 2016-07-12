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
#import "SBJson.h"

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
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/business" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL BUSSINESS: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                for (NSDictionary* businessDict in [dataDict valueForKey:@"data"])
                {
                    NSString* currency_id = [businessDict valueForKey:@"currency_id"];
                    NSString* country_id = [businessDict valueForKey:@"country_id"];
                    NSString* name = [businessDict valueForKey:@"name"];
                    NSString* description = [businessDict valueForKey:@"description"];
                    NSString* address = [businessDict valueForKey:@"address"];
                    NSString* address_line1 = [businessDict valueForKey:@"address_line1"];
                    NSString* address_line2 = [businessDict valueForKey:@"address_line2"];
                    NSString* city = [businessDict valueForKey:@"city"];
                    NSString* businessID = [businessDict valueForKey:@"id"];
                    NSString* postCode = [businessDict valueForKey:@"postcode"];
                    NSString* date_started = [businessDict valueForKey:@"date_started"];
                    NSString* userID = [businessDict valueForKey:@"user_id"];
                    NSString* cis_registered = [businessDict valueForKey:@"cis_registered"];
                    NSString* vat_registered = [businessDict valueForKey:@"vat_registered"];
                    NSString* vat_number = [businessDict valueForKey:@"vat_number"];
                    NSString* bank_account_name = [businessDict valueForKey:@"bank_account_name"];
                    NSString* bank_name = [businessDict valueForKey:@"bank_name"];
                    NSString* sort_code = [businessDict valueForKey:@"sort_code"];
                    NSString* bank_account_number = [businessDict valueForKey:@"bank_account_number"];
                    NSString* created = [businessDict valueForKey:@"created"];
                    NSString* modified = [businessDict valueForKey:@"modified"];                    
                    
                }
                
                [self.tableView  reloadData];
            }
            
        }
    }];
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

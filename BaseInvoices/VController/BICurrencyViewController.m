//
//  BICurrencyViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICurrencyViewController.h"
#import "BICustomCurrencyTableViewCell.h"

#import "BIAppDelegate.h"
#import "SBJson.h"

@interface BICurrencyViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BICurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
 
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getCurrencies];

}

- (void)getCurrencies
{
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/currency" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL CURRENCIES: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                appdelegate.currencies = [[NSMutableArray alloc] init];
                
                for (NSDictionary* currencyDict in [dataDict valueForKey:@"data"])
                {
                    NSString* currencyID = [currencyDict valueForKey:@"id"];
                    NSString* currencyCode = [currencyDict valueForKey:@"iso"];
                    NSString* currencyName = [currencyDict valueForKey:@"name"];
                    NSString* currencyDesc = [currencyDict valueForKey:@"description"];
                    NSString* currencySymbol = [currencyDict valueForKey:@"sign"];
                    
                    BICurrency* currency = [[BICurrency alloc] init];
                    [currency setCurrencyCode:currencyCode];
                    [currency setCurrencySymbol:currencySymbol];
                    [currency setCurrencyID:currencyID];
                    [currency setCurrencyName:currencyName];
                    [currency setCurrencyDesc:currencyDesc];
                    
                    [[BIAppDelegate shareAppdelegate].currencies addObject:currency];
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
    return appdelegate.currencies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"BICustomCurrencyTableViewCell";
    
    BICustomCurrencyTableViewCell *customCell = (BICustomCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (customCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BICustomCurrencyTableViewCell" owner:self options:nil];
        customCell = [nib objectAtIndex:0];
    }

    customCell.lblCountryCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] currencyName];
    customCell.lblSymbolCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] currencySymbol];
    customCell.lblCurrencyCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] currencyCode];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appdelegate.currency = [appdelegate.currencies objectAtIndex:indexPath.row];
    
    [self.delegate didSelectedCurrency:[[BIAppDelegate shareAppdelegate].currencies objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

//
//  BICurrencyViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/30/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICurrencyViewController.h"
#import "BICustomCurrencyTableViewCell.h"
#import "BICurrency.h"
#import "BIAppDelegate.h"

@interface BICurrencyViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BICurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CurrencyList" ofType:@"plist"];
    
    self.allCurrency = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary* currency in self.allCurrency)
    {
        NSString* countryAndCurrencyCode = [currency valueForKey:@"Country and Currency"];
        NSString* currencyCode = [currency valueForKey:@"Currency Code"];
        
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:[NSString stringWithFormat:@"%@", currencyCode]];
        NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:[currency valueForKey:@"Currency Code"]]];
        NSLog(@"Currency Symbol : %lu", (unsigned long)currencySymbol.length);
        
        BICurrency* currency = [[BICurrency alloc] init];
        
        if (currencySymbol.length > 0 && currencySymbol.length < 6)
        {
            currency.currencyCode = currencyCode;
            currency.currencySymbol = currencySymbol;
            currency.countryAndCurrency = countryAndCurrencyCode;
            
            [appdelegate.currencies addObject:currency];
        }
    }

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

    customCell.lblCountryCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] countryAndCurrency];
    customCell.lblSymbolCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] currencySymbol];
    customCell.lblCurrencyCode.text = [[appdelegate.currencies objectAtIndex:indexPath.row] currencyCode];
    
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    appdelegate.currency = [appdelegate.currencies objectAtIndex:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate checkCallback];
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

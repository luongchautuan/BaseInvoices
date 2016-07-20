//
//  CountryViewController.m
//  BaseInvoices
//
//  Created by Mac Mini on 7/8/16.
//  Copyright © 2016 mtoanmy. All rights reserved.
//

#import "CountryViewController.h"
#import "BIAppDelegate.h"

#import "CountryTableViewCell.h"

#define indexTitles @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"]

@interface CountryViewController ()

@end

@implementation CountryViewController
{
    NSMutableDictionary *codeDataDictionary;
    NSMutableArray* countryData;
}

- (void)viewWillAppear:(BOOL)animated
{
    codeDataDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString* key in indexTitles)
    {
        NSMutableArray* codeDataForKey = [[NSMutableArray alloc] init];
        
        [codeDataDictionary setObject:codeDataForKey forKey:key];
    }
    
    [self getCountryData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCountryData
{
    for (int i = 0; i < [[BIAppDelegate shareAppdelegate].countries count]; i ++)
    {
        CountryRepository* country = [[BIAppDelegate shareAppdelegate].countries objectAtIndex:i];
        
        NSString *firstLetter = [country.countryName substringToIndex:1];
        firstLetter = [firstLetter uppercaseString];
        
        for (NSString* key in indexTitles)
        {
            if ([firstLetter isEqualToString:key]) {
                NSMutableArray* codeDataForKey = [codeDataDictionary objectForKey:key];
                
                [codeDataForKey addObject:country];
                
                [codeDataDictionary setObject:codeDataForKey forKey:key];
            }
        }
    }
    
    [_tableView reloadData];
}

#pragma mark - UIButton Sender

- (IBAction)btnCancel_Clicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  indexTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [indexTitles objectAtIndex:section];
    NSArray *codeDataForKey = [codeDataDictionary objectForKey:sectionTitle];
    return [codeDataForKey count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return indexTitles;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Ratio
    return 83;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [indexTitles objectAtIndex:section];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //customize normal cell
    static NSString *TableIdentifier = @"CountryTableViewCell";
    
    CountryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CountryTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    CountryRepository* country;
    
    NSString *sectionTitle = [indexTitles objectAtIndex:indexPath.section];
    NSMutableArray *codeDataForKey = [codeDataDictionary objectForKey:sectionTitle];
    country = [codeDataForKey objectAtIndex:indexPath.row];
    
    NSLog(@"IMAGE: %@", country.countryName);
    
    cell.lblCountryCode.text = [NSString stringWithFormat:@"%@",country.countryCode];
    [cell.imgCountry setImage:[UIImage imageNamed:country.countryName]];
    
    cell.lblCountryName.text = country.countryName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [indexTitles objectAtIndex:indexPath.section];
    NSMutableArray *codeDataForKey = [codeDataDictionary objectForKey:sectionTitle];
    
    CountryRepository* country = [codeDataForKey objectAtIndex:indexPath.row];
    
    
    [self.delegate CountrySelected:country];
    
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

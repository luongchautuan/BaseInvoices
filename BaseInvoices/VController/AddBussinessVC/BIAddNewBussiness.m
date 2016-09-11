//
//  BIAddNewBussiness.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddNewBussiness.h"
#import "SBJson.h"
#import "NSDate+Utilities.h"
#import "BIBussiness.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "BIDashBoard.h"
#import "BIAddInvoices.h"
#import "ASIHTTPRequest.h"
#import "BICurrencyViewController.h"

#define ACCEPTABLE_CHARECTERS @"+0123456789."

@interface BIAddNewBussiness ()

@end

BIAppDelegate* appdelegate;
NSString* vatRegistered;

@implementation BIAddNewBussiness

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onCloseView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view];
    self.flatDatePicker.delegate = self;
    self.flatDatePicker.title = @"";
    
    [_viewContent setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 800)];
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    onCheckedButton = false;
    _isCISRegistered = false;
    
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    [self.btnCisRegistered setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnCisRegistered setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnCisRegistered setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    [self.txtTitle setText:@"Add New Bussiness"];
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    tapGeusture.delegate = self;
    [self.scrollView addGestureRecognizer:tapGeusture];
    [tapGeusture setCancelsTouchesInView:NO];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 50);
        }
    }

    if (self.isEditBusiness)
    {
        [self.txtTitle setText:@"Edit Bussiness"];
        [self loadBussinessEdit];
    }
    else
    {
        [self.txtTitle setText:@"Add New Bussiness"];
        
        //Select Unit Kingdom
        for (CountryRepository* country in [BIAppDelegate shareAppdelegate].countries)
        {
            if ([country.dialCode isEqualToString:@"77"])
            {
                _countrySelected = country;
                _txtCountry.text= _countrySelected.countryName;
                break;
            }
        }
        
        //Set Date today
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        _dateStarted = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        _txtDateStarted.text = [dateFormatter stringFromDate:[NSDate date]];
        
//        [self getCurrencies];
    }
    
    vatRegistered = @"0";
    _cisRegisteredValue = @"0";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)checkCallback
{
    self.txtCurrency.text = appdelegate.currency.currencyCode;
    self.currencySymbol = appdelegate.currency.currencySymbol;
}

- (void)loadBussinessEdit
{
    if (_bussinessEdit.bussinessAddress != nil && ![_bussinessEdit.bussinessAddress isEqual:[NSNull null]])
    {
        _txtAddress.text = _bussinessEdit.bussinessAddress;
    }
    
    if (_bussinessEdit.currency != nil && ![_bussinessEdit.currency isEqual:[NSNull null]])
    {
        _currencySelected = _bussinessEdit.currency;
        
        self.txtCurrency.text = [NSString stringWithFormat:@"%@-%@", _bussinessEdit.currency.currencyCode, _bussinessEdit.currency.currencyName];
    }
    
    if (_bussinessEdit.bussinessDescription != nil && ![_bussinessEdit.bussinessDescription isEqual:[NSNull null]])
    {
        self.txtDescription.text = _bussinessEdit.bussinessDescription;
    }
    
    if (_bussinessEdit.bussinessName != nil && ![_bussinessEdit.bussinessName isEqual:[NSNull null]])
    {
        self.txtNameBussiness.text = _bussinessEdit.bussinessName;
    }

    if (_bussinessEdit.bussinessAddress1 != nil && ![_bussinessEdit.bussinessAddress1 isEqual:[NSNull null]])
    {
        _txtAddressLine1.text = _bussinessEdit.bussinessAddress1;
    }
    
    if (_bussinessEdit.bussinessAddress2 != nil && ![_bussinessEdit.bussinessAddress2 isEqual:[NSNull null]])
    {
        _txtAddressLine2.text = _bussinessEdit.bussinessAddress2;
    }
    
    if (_bussinessEdit.bussinessPostCode != nil && ![_bussinessEdit.bussinessPostCode isEqual:[NSNull null]])
    {
        _txtPostCode.text = _bussinessEdit.bussinessPostCode;
    }
    
    if (_bussinessEdit.country != nil && ![_bussinessEdit.country isEqual:[NSNull null]])
    {
        _countrySelected = _bussinessEdit.country;
        if (_bussinessEdit.country.countryName != nil && ![_bussinessEdit.country.countryName isEqual:[NSNull null]])
        {
            _txtCountry.text = _bussinessEdit.country.countryName;
        }
    }
    
    if (_bussinessEdit.dateStarted != nil && ![_bussinessEdit.dateStarted isEqual:[NSNull null]])
    {
        _dateStarted = _bussinessEdit.dateStarted;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [dateFormatter dateFromString:_dateStarted];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        _txtDateStarted.text = [dateFormatter stringFromDate:date];
    }
    
    onCheckedButton = self.bussinessEdit.isVatRegistered;
    _isCISRegistered = self.bussinessEdit.isCISRegistered;
    
    if(onCheckedButton)
    {
        [self.btnCheckVat setSelected:onCheckedButton];
    }
 
    if (_isCISRegistered) {
        _cisRegisteredValue = @"1";
        [self.btnCisRegistered setSelected:_isCISRegistered];
    }
    else
    {
        _cisRegisteredValue = @"0";
    }
    
}

- (void)getCountries
{
    [[ServiceRequest getShareInstance] serviceRequestActionName:@"/country" accessToken:appdelegate.currentUser.token method:@"GET" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger statusCode = [httpResponse statusCode];
        
        if (statusCode == 200)
        {
            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                            encoding:NSUTF8StringEncoding];
            
            NSLog(@"RESPIONSE GET ALL COUNTRIES: %@", responeString);
            NSDictionary* dataDict = [[NSDictionary alloc] init];
            SBJsonParser *json = [SBJsonParser new];
            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
            
            if ([dataDict valueForKey:@"data"] != nil)
            {
                appdelegate.countries = [[NSMutableArray alloc] init];
                
                for (NSDictionary* countryDict in [dataDict valueForKey:@"data"])
                {
                    NSString* countryID = [countryDict valueForKey:@"id"];
                    NSString* countryCode = [countryDict valueForKey:@"code"];
                    NSString* countryName = [countryDict valueForKey:@"name"];
                    
                    CountryRepository* country = [[CountryRepository alloc] init];
                    [country setCountryCode:countryCode];
                    [country setCountryName:countryName];
                    [country setDialCode:countryID];
                    
                    [[BIAppDelegate shareAppdelegate].countries addObject:country];
                }
            }
        }
    }];

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
                
                if ([BIAppDelegate shareAppdelegate].currencies.count > 0)
                {
                    _currencySelected = [[BIAppDelegate shareAppdelegate].currencies objectAtIndex:0];
                    _txtCurrency.text = [NSString stringWithFormat:@"%@ - %@", _currencySelected.currencyCode, _currencySelected.currencyName];
                }
            }
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.btnSave])
        return NO;
    return YES;
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"Tap");
    [self.txtAddress resignFirstResponder];
    [self.txtCurrency resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    [self.txtNameBussiness resignFirstResponder];

    [self.scrollView setContentOffset:CGPointMake(0, -20)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCurrencyShow:(id)sender
{
    BICurrencyViewController *pushToVC = [[BICurrencyViewController alloc] initWithNibName:@"BICurrencyViewController" bundle:nil];
    pushToVC.delegate = self;
    
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onCheckedButton:(id)sender
{
    if(onCheckedButton)
    {
        onCheckedButton = false;
        vatRegistered = @"1";
    }
    else
    {
        onCheckedButton = true;
        vatRegistered = @"0";
    }
    
    [self.btnCheckVat setSelected:onCheckedButton];
}

- (IBAction)onCheckedCIS_Clicked:(id)sender
{
    if(_isCISRegistered)
    {
        _isCISRegistered = false;
        _cisRegisteredValue = @"0";
    }
    else
    {
        _isCISRegistered = true;
        _cisRegisteredValue = @"1";
    }
    
    [self.btnCisRegistered setSelected:_isCISRegistered];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - UIButton Sender
- (IBAction)btnSelectCountry_Clicked:(id)sender
{
    CountryViewController *pushToVC = [[CountryViewController alloc] initWithNibName:@"CountryViewController" bundle:nil];
    pushToVC.delegate = self;
    [self.navigationController pushViewController:pushToVC animated:YES];

}

- (IBAction)btnSelectCurrency_Clicked:(id)sender
{
    BICurrencyViewController *pushToVC = [[BICurrencyViewController alloc] initWithNibName:@"BICurrencyViewController" bundle:nil];
    pushToVC.delegate = self;
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)btnSelectDateStarted_Clicked:(id)sender
{
    [self.view endEditing:YES];
    
    [self.flatDatePicker show];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.flatDatePicker dismiss];
    
//    if (textField.tag == 4)
//    {
//        [self.scrollView setContentOffset:CGPointMake(0,100)];
//    }
//    if (textField.tag == 5)
//    {
//        [self.scrollView setContentOffset:CGPointMake(0,180)];
//    }
//    if (textField.tag == 6)
//    {
//        [self.scrollView setContentOffset:CGPointMake(0,200)];
//    }
//    if (textField.tag == 3)
//    {
//        [self.scrollView setContentOffset:CGPointMake(0,50)];
//    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 5)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
//    if (textField.tag == 0) {
//        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        return (newLength > 4) ? NO : YES;
//    }
    return YES;
}

- (IBAction)onSaveBusiness:(id)sender
{
    //check login and save
    if (self.txtNameBussiness.text.length > 0)
    {
        if (appdelegate.isLoginSucesss)
        {
            if (self.isEditBusiness)
            {
                NSString* dataRequest =[NSString stringWithFormat:@"name=%@&description=%@&currency_id=%d&country_id=%d&address=%@&address_line1=%@&address_line2=%@&postcode=%@&date_started=%@&cis_registered=%@&vat_registered=%@", self.txtNameBussiness.text, self.txtDescription.text == nil ? @"" : self.txtDescription.text, [_currencySelected.currencyID intValue], [_countrySelected.dialCode intValue], _txtAddress.text == nil ? @"" : _txtAddress.text, _txtAddressLine1.text == nil ? @"" : _txtAddressLine1.text, _txtAddressLine2.text == nil ? @"" : _txtAddressLine2.text == nil ? @"" : _txtAddressLine2.text, _txtPostCode.text == nil ? @"" : _txtPostCode.text,_dateStarted, _cisRegisteredValue, vatRegistered];
                
                NSLog(@"Data Request Add Business: %@", dataRequest);
                dataRequest = [dataRequest stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                
                
                if ([dataRequest containsString:@"@"]) {
                    dataRequest = [dataRequest stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
                }
                
                [[ServiceRequest getShareInstance] serviceRequestActionName:[NSString stringWithFormat:@"/business/%@?%@",self.bussinessEdit.businessID, dataRequest] accessToken:appdelegate.currentUser.token method:@"PUT" result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
                    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                    NSInteger statusCode = [httpResponse statusCode];
                    if (statusCode == 200)
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];

            }
            else
            {
                NSString* dataRequest =[NSString stringWithFormat:@"name=%@&description=%@&currency_id=%d&country_id=%d&address=%@&address_line1=%@&address_line2=%@&postcode=%@&date_started=%@&cis_registered=%@&vat_registered=%@", self.txtNameBussiness.text, self.txtDescription.text == nil ? @"" : self.txtDescription.text, [_currencySelected.currencyID intValue], [_countrySelected.dialCode intValue], _txtAddress.text == nil ? @"" : _txtAddress.text, _txtAddressLine1.text == nil ? @"" : _txtAddressLine1.text, _txtAddressLine2.text == nil ? @"" : _txtAddressLine2.text == nil ? @"" : _txtAddressLine2.text, _txtPostCode.text == nil ? @"" : _txtPostCode.text,_dateStarted, _cisRegisteredValue, vatRegistered];
                
                NSLog(@"Data Request Add Business: %@", dataRequest);
                
                dataRequest = [dataRequest stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                
                
                if ([dataRequest containsString:@"@"]) {
                    dataRequest = [dataRequest stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
                }
                
                [[ServiceRequest getShareInstance] serviceRequestActionName:[NSString stringWithFormat:@"/business?%@", dataRequest] accessToken:appdelegate.currentUser.token result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
                    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                    NSInteger statusCode = [httpResponse statusCode];
                    
                    if (statusCode == 200)
                    {
                        if (self.addFrom == 0 || self.addFrom == 2)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else if (self.addFrom == 1)
                        {
                            BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
                            [self.navigationController pushViewController:pushToVC animated:YES];
                        }

                    }
                }];

            }
        }
        else
        {
//            if (self.isEditBusiness) {
//                BIBussiness* bussiness = [appdelegate.businessForUser objectAtIndex:self.indexPathSelected.row];
//                bussiness.bussinessAddress = self.txtAddress.text;
//                bussiness.bussinessCity = self.txtCity.text;
//                bussiness.bussinessCurrency = self.txtCurrency.text;
//                bussiness.bussinessDescription = self.txtDescription.text;
//                bussiness.bussinessName = self.txtNameBussiness.text;
//                bussiness.bussinessPostCode  = self.txtPostCode.text;
//                bussiness.bussinessVat = self.txtVat.text;
//                bussiness.isVatRegistered = onCheckedButton;
//                bussiness.currencySymbol = self.currencySymbol;
//                bussiness.bankDetails = self.txtBankDetails.text;
//                bussiness.bankAccountName = self.txtBankAccountName.text;
//                bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
//                bussiness.bankName = self.txtBankName.text;
//                bussiness.bankSortCode = self.txtBankSortCode.text;
//                
//                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                
//                [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
//                [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
//                
//                [defaults setBool:YES forKey:@"bussiness"];
//                
//                [self.navigationController popViewControllerAnimated:YES];
//
//            }
//            else if (self.addFrom == 0 || self.addFrom == 2)
//            {
//                BIBussiness* bussiness = [[BIBussiness alloc] init];
//                bussiness.bussinessAddress = self.txtAddress.text;
//                bussiness.bussinessCity = self.txtCity.text;
//                bussiness.bussinessCurrency = self.txtCurrency.text;
//                bussiness.bussinessDescription = self.txtDescription.text;
//                bussiness.bussinessName = self.txtNameBussiness.text;
//                bussiness.bussinessPostCode  = self.txtPostCode.text;
//                bussiness.bussinessVat = self.txtVat.text;
//                bussiness.isVatRegistered = onCheckedButton;
//                bussiness.currencySymbol = self.currencySymbol;
//                bussiness.bankDetails = self.txtBankDetails.text;
//                bussiness.bankAccountName = self.txtBankAccountName.text;
//                bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
//                bussiness.bankName = self.txtBankName.text;
//                bussiness.bankSortCode = self.txtBankSortCode.text;
//                
//                
//                appdelegate.bussinessForUser = bussiness;
//                
//                if (appdelegate.businessForUser == nil)
//                {
//                    appdelegate.businessForUser = [[NSMutableArray alloc] init];
//                    [appdelegate.businessForUser addObject:bussiness];
//                }
//                
//                
//                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
//                [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
//                [defaults setBool:YES forKey:@"bussiness"];
//                
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else if (self.addFrom == 1)
//            {
//                BIBussiness* bussiness = [[BIBussiness alloc] init];
//                bussiness.bussinessAddress = self.txtAddress.text;
//                bussiness.bussinessCity = self.txtCity.text;
//                bussiness.bussinessCurrency = self.txtCurrency.text;
//                bussiness.bussinessDescription = self.txtDescription.text;
//                bussiness.bussinessName = self.txtNameBussiness.text;
//                bussiness.bussinessPostCode  = self.txtPostCode.text;
//                bussiness.bussinessVat = self.txtVat.text;
//                bussiness.isVatRegistered = onCheckedButton;
//                bussiness.currencySymbol = self.currencySymbol;
//                bussiness.bankDetails = self.txtBankDetails.text;
//                bussiness.bankAccountName = self.txtBankAccountName.text;
//                bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
//                bussiness.bankName = self.txtBankName.text;
//                bussiness.bankSortCode = self.txtBankSortCode.text;
//                
//                
//                appdelegate.bussinessForUser = bussiness;
//                
//                if (appdelegate.businessForUser == nil)
//                {
//                    appdelegate.businessForUser = [[NSMutableArray alloc] init];
//                    [appdelegate.businessForUser addObject:bussiness];
//                }
//                
//                NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//                [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
//                [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
//                
//                [defaults setBool:YES forKey:@"bussiness"];
//                
//                BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
//                [self.navigationController pushViewController:pushToVC animated:YES];
//            }

        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Business name cannot be empty!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
  
}

- (void)CountrySelected:(CountryRepository *)countrySelected
{
    _countrySelected = countrySelected;
    _txtCountry.text = _countrySelected.countryName;
}

- (void)didSelectedCurrency:(BICurrency *)currency
{
    _currencySelected = currency;
    _txtCurrency.text = [NSString stringWithFormat:@"%@ - %@", _currencySelected.currencyCode, _currencySelected.currencyName];
}

#pragma mark - FlatDatePicker Delegate

- (void)flatDatePicker:(FlatDatePicker*)datePicker dateDidChange:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.txtDateStarted.text = value;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    _dateStarted = [dateFormatter stringFromDate:date];
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didCancel:(UIButton*)sender {
    
}

- (void)flatDatePicker:(FlatDatePicker*)datePicker didValid:(UIButton*)sender date:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.txtDateStarted.text = value;
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    _dateStarted = [dateFormatter stringFromDate:date];
}
@end

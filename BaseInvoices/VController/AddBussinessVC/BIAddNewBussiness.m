//
//  BIAddNewBussiness.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddNewBussiness.h"
#define ACCEPTABLE_CHARECTERS @"+0123456789."
#import "BIBussiness.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "BIDashBoard.h"
#import "BIAddInvoices.h"
#import "ASIHTTPRequest.h"

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
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    onCheckedButton = false;
    
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    [self.txtTitle setText:@"Add New Bussiness"];
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusture];
    [tapGeusture setCancelsTouchesInView:NO];
    
    UITapGestureRecognizer *tapGeustureBank = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeustureBank.numberOfTapsRequired = 1;
    [self.viewPopUpMain addGestureRecognizer:tapGeustureBank];
    [tapGeustureBank setCancelsTouchesInView:NO];
    
    NSLocale *locale = [NSLocale currentLocale];
    
    
    NSString *currencyCode = [locale objectForKey:NSLocaleCurrencyCode];
    
    NSString *localCurrencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
    
    self.currencySymbol = localCurrencySymbol;
    
    NSLog(@"CUrrency Symbol: %@", localCurrencySymbol);
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 50);
        }
    }
    
    self.txtCurrency.text = currencyCode;
    
    if (self.isEditBusiness) {
        [self.txtTitle setText:@"Edit Bussiness"];
        [self loadBussinessEdit];
    }
    else
    {
        [self.txtTitle setText:@"Add New Bussiness"];
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)checkCallback
{
    self.txtCurrency.text = appdelegate.currency.currencyCode;
    self.currencySymbol = appdelegate.currency.currencySymbol;
}

- (void)loadBussinessEdit
{
    self.txtAddress.text = self.bussinessEdit.bussinessAddress;
    self.txtCity.text = self.bussinessEdit.bussinessCity;
    self.txtCurrency.text = self.bussinessEdit.bussinessCurrency;
    self.txtDescription.text = self.bussinessEdit.bussinessDescription;
    self.txtNameBussiness.text = self.bussinessEdit.bussinessName;
    self.txtPostCode.text = self.bussinessEdit.bussinessPostCode;
    self.txtVat.text = self.bussinessEdit.bussinessVat;
    onCheckedButton = self.bussinessEdit.isVatRegistered;
    self.txtBankDetails.text = self.bussinessEdit.bankDetails;
    self.txtBankSortCode.text = self.bussinessEdit.bankSortCode;
    self.txtBankAccountName.text = self.bussinessEdit.bankAccountName;
    self.txtBankAccountNumber.text = self.bussinessEdit.bankAccountNumber;
    self.txtBankName.text = self.bussinessEdit.bankName;
    
    if(onCheckedButton)
    {
        [self.btnCheckVat setSelected:onCheckedButton];
    }
 
    
}

- (IBAction)onShowBankDetails:(id)sender
{
    [self.viewPopUpBanking setHidden:NO];
    self.viewPopUpMain.frame=CGRectMake(10, -110, 300, 183);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewPopUpMain.frame=CGRectMake(10, 77, 300, 183);
    [UIView commitAnimations];

}

- (IBAction)onSaveBankDetails:(id)sender
{
//    if (self.txtBankName.text.length > 0 && self.txtBankAccountName.text.length > 0 && self.txtBankAccountNumber.text.length > 0 && self.txtBankSortCode.text.length > 0) {
        self.viewPopUpBanking.hidden = YES;
        self.txtBankDetails.text = self.txtBankName.text;
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }
    
    [self.txtBankAccountName resignFirstResponder];
    [self.txtBankAccountNumber resignFirstResponder];
    [self.txtBankName resignFirstResponder];
    [self.txtBankSortCode resignFirstResponder];
   
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"Tap");
    [self.txtCity resignFirstResponder];
    [self.txtAddress resignFirstResponder];
    [self.txtCurrency resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    [self.txtNameBussiness resignFirstResponder];
    [self.txtVat resignFirstResponder];
    [self.txtPostCode resignFirstResponder];
    [self.txtBankDetails resignFirstResponder];
    [self.txtBankAccountName resignFirstResponder];
    [self.txtBankAccountNumber resignFirstResponder];
    [self.txtBankName resignFirstResponder];
    [self.txtBankSortCode resignFirstResponder];
    
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
        vatRegistered = @"True";
    }
    else
    {
        onCheckedButton = true;
        vatRegistered = @"False";
    }
    
    [self.btnCheckVat setSelected:onCheckedButton];
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
        if (appdelegate.result.height == 480) {
            self.viewPopUpMain.frame = CGRectMake(10, 77, 300, 183);
        }
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 4)
    {
        [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
    if (textField.tag == 5)
    {
        [self.scrollView setContentOffset:CGPointMake(0,180)];
    }
    if (textField.tag == 6)
    {
        [self.scrollView setContentOffset:CGPointMake(0,200)];
    }
    if (textField.tag == 3)
    {
        [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    
    if (appdelegate.result.height == 480)
    {
        if (textField == self.txtBankAccountNumber) {
            if (appdelegate.result.height == 480) {
                self.viewPopUpMain.frame = CGRectMake(self.viewPopUpMain.frame.origin.x, self.viewPopUpMain.frame.origin.y - 50, self.viewPopUpMain.frame.size.width, self.viewPopUpMain.frame.size.height);
            }
        }
    }
  
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 5)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    if (textField.tag == 0) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    return YES;
}

- (IBAction)onSaveBusiness:(id)sender
{
    //check login and save
    NSString* cisRegistered = @"False";
    
    if (self.txtNameBussiness.text.length > 0 && self.txtVat.text.length > 0 && self.txtCurrency.text.length > 0)
    {
        if (appdelegate.isLoginSucesss)
        {
            NSString* nameBusiness = self.txtNameBussiness.text;
            NSString* descriptionsBusiness = self.txtDescription.text;
            NSString* addressBussiness = self.txtAddress.text;
            NSString* postCodeBusiness = self.txtPostCode.text;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            [dateFormatter setDateFormat:@"dd-MM-YYYY"];
            
            NSString *date_String = [dateFormatter stringFromDate:[NSDate date]];

            NSDate *date  = [dateFormatter dateFromString:date_String];
            
            NSLocale *locale = [[NSLocale alloc]
                                initWithLocaleIdentifier:@"en"];
            [dateFormatter setLocale:locale];
            
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString* dateConvert = [dateFormatter stringFromDate:date];

            if (self.isEditBusiness)
            {
                NSString* dataRequest =[NSString stringWithFormat:@"{\"id\":\"%d\",\"name\":\"%@\",\"description\":\"%@\",\"address\":\"%@\",\"postcode\":\"%@\",\"dateStarted\":\"%@\",\"cisRegistered\":%@, \"vatRegistered\":%@\"}", [appdelegate.currentUser.userID  intValue], nameBusiness, descriptionsBusiness, addressBussiness, postCodeBusiness, dateConvert, cisRegistered, vatRegistered];
                
                NSLog(@"Data Request Add Business: %@", dataRequest);
                
                
                ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/business"]];
                
                [request addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
                
                
                [request setTag:4];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                [request addRequestHeader:@"accept" value:@"application/json"];
                
                
                [request appendPostData:[dataRequest dataUsingEncoding:NSUTF8StringEncoding]];
                [request setValidatesSecureCertificate:NO];
                [request setRequestMethod:@"PUT"];
                [request startSynchronous];
                
                
                NSString  *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
                
                NSLog(@"Respone : %@", responseString);

            }
            else
            {
                NSString* dataRequest =[NSString stringWithFormat:@"{\"user\":{\"id\":\"%@\"},\"name\":\"%@\",\"description\":\"%@\",\"address\":\"%@\",\"postcode\":\"%@\",\"dateStarted\":\"%@\",\"cisRegistered\":%@, \"vatRegistered\":%@\"}", appdelegate.currentUser.userID, nameBusiness, descriptionsBusiness, addressBussiness, postCodeBusiness, dateConvert, cisRegistered, vatRegistered];
                
                NSLog(@"Data Request Add Business: %@", dataRequest);
                
                
                ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/business"]];
                
                [request addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"]andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
                
                
                [request setTag:4];
                [request addRequestHeader:@"Content-Type" value:@"application/json"];
                [request addRequestHeader:@"accept" value:@"application/json"];
                
                
                [request appendPostData:[dataRequest dataUsingEncoding:NSUTF8StringEncoding]];
                [request setValidatesSecureCertificate:NO];
                [request setRequestMethod:@"POST"];
                [request startSynchronous];
                
                
                NSString  *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];

            }
        }
        
        if (self.isEditBusiness)
        {
            BIBussiness* bussiness = [appdelegate.businessForUser objectAtIndex:self.indexPathSelected.row];
            bussiness.bussinessAddress = self.txtAddress.text;
            bussiness.bussinessCity = self.txtCity.text;
            bussiness.bussinessCurrency = self.txtCurrency.text;
            bussiness.bussinessDescription = self.txtDescription.text;
            bussiness.bussinessName = self.txtNameBussiness.text;
            bussiness.bussinessPostCode  = self.txtPostCode.text;
            bussiness.bussinessVat = self.txtVat.text;
            bussiness.isVatRegistered = onCheckedButton;
            bussiness.currencySymbol = self.currencySymbol;
            bussiness.bankDetails = self.txtBankDetails.text;
            bussiness.bankAccountName = self.txtBankAccountName.text;
            bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
            bussiness.bankName = self.txtBankName.text;
            bussiness.bankSortCode = self.txtBankSortCode.text;
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
            [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
            
            [defaults setBool:YES forKey:@"bussiness"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.addFrom == 0 || self.addFrom == 2)
        {
            BIBussiness* bussiness = [[BIBussiness alloc] init];
            bussiness.bussinessAddress = self.txtAddress.text;
            bussiness.bussinessCity = self.txtCity.text;
            bussiness.bussinessCurrency = self.txtCurrency.text;
            bussiness.bussinessDescription = self.txtDescription.text;
            bussiness.bussinessName = self.txtNameBussiness.text;
            bussiness.bussinessPostCode  = self.txtPostCode.text;
            bussiness.bussinessVat = self.txtVat.text;
            bussiness.isVatRegistered = onCheckedButton;
            bussiness.currencySymbol = self.currencySymbol;
            bussiness.bankDetails = self.txtBankDetails.text;
            bussiness.bankAccountName = self.txtBankAccountName.text;
            bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
            bussiness.bankName = self.txtBankName.text;
            bussiness.bankSortCode = self.txtBankSortCode.text;

            
            appdelegate.bussinessForUser = bussiness;
            
            [appdelegate.businessForUser addObject:bussiness];
            
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
            [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
            [defaults setBool:YES forKey:@"bussiness"];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (self.addFrom == 1)
        {
            BIBussiness* bussiness = [[BIBussiness alloc] init];
            bussiness.bussinessAddress = self.txtAddress.text;
            bussiness.bussinessCity = self.txtCity.text;
            bussiness.bussinessCurrency = self.txtCurrency.text;
            bussiness.bussinessDescription = self.txtDescription.text;
            bussiness.bussinessName = self.txtNameBussiness.text;
            bussiness.bussinessPostCode  = self.txtPostCode.text;
            bussiness.bussinessVat = self.txtVat.text;
            bussiness.isVatRegistered = onCheckedButton;
            bussiness.currencySymbol = self.currencySymbol;
            bussiness.bankDetails = self.txtBankDetails.text;
            bussiness.bankAccountName = self.txtBankAccountName.text;
            bussiness.bankAccountNumber = self.txtBankAccountNumber.text;
            bussiness.bankName = self.txtBankName.text;
            bussiness.bankSortCode = self.txtBankSortCode.text;

            
            appdelegate.bussinessForUser = bussiness;
            
            [appdelegate.businessForUser addObject:bussiness];
            
            
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults rm_setCustomObject:bussiness forKey:@"bussinessForUser"];
            [defaults rm_setCustomObject:appdelegate.businessForUser forKey:@"bussinessesForUser"];
            
            [defaults setBool:YES forKey:@"bussiness"];
            
            BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController pushViewController:pushToVC animated:YES];
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
  
}
@end

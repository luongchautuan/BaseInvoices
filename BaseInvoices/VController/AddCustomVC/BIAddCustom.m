//
//  BIAddCustom.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddCustom.h"
#import "BIAddInvoices.h"
#import "BICustomer.h"
#import "BIAppDelegate.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"


#define ACCEPTABLE_CHARECTERS @"+0123456789"

@interface BIAddCustom ()

@end

BIAppDelegate* appdelegate;

@implementation BIAddCustom
{
    int countryID;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initScreen];
    // Do any additional setup after loading the view from its nib.
    
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.isEditCustomer)
    {
        [self loadCustomerDetails];
        
        [self.txtTitle setText:@"Edit Customer"];
    }
    else
    {
        [self.txtTitle setText:@"Add Customer"];
    }
}

- (void)initScreen
{
    [self.edtBussinessName setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtAddress setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtCity setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtEmail setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtKeyContact setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtPhone setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.edtPostCode setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
////    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
////    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    
//    self.edtAddress.leftView = paddingView;
//    self.edtAddress.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtBussinessName.leftView = paddingView2;
//    self.edtBussinessName.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtCity.leftView = paddingView3;
//    self.edtCity.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtEmail.leftView = paddingView4;
//    self.edtEmail.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtKeyContact.leftView = paddingView5;
//    self.edtKeyContact.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtPhone.leftView = paddingView6;
//    self.edtPhone.leftViewMode = UITextFieldViewModeAlways;
//    
//    self.edtPostCode.leftView = paddingView7;
//    self.edtPostCode.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender
{
    if (self.edtBussinessName.text.length > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Do you want to save customer?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self saveCustomerMethod];
    }
}
#pragma mark return to close soft keyboard



- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.edtAddress resignFirstResponder];
    [self.edtBussinessName resignFirstResponder];
    [self.edtCity resignFirstResponder];
    [self.edtEmail resignFirstResponder];
    [self.edtKeyContact resignFirstResponder];
    [self.edtPhone resignFirstResponder];
    [self.edtPostCode resignFirstResponder];
    [self.txtDescription resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==3)
    {
        [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    if (textField.tag==4)
    {
        [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
    if (textField.tag==5)
    {
        [self.scrollView setContentOffset:CGPointMake(0,140)];
    }
    if (textField.tag==6)
    {
        [self.scrollView setContentOffset:CGPointMake(0,180)];
    }
    if (textField.tag==7)
    {
        [self.scrollView setContentOffset:CGPointMake(0,220)];
    }
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
        [self.scrollView setContentOffset:CGPointMake(0, -20)];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 5)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }

    return YES;
}


- (IBAction)onSaveCustomer:(id)sender
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    if (self.edtBussinessName.text.length > 0 && self.edtEmail.text.length > 0)
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
        if ([emailTest evaluateWithObject:self.edtEmail.text] == NO)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [appdelegate.activityIndicatorView hide:YES];
            
            return;
        }
        else
        {
            NSLog(@"Phone: %lu", (unsigned long)self.edtPhone.text.length);
            if (self.edtPhone.text.length > 0 && self.edtPhone.text.length < 5)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"The phone number must at least 5 characters. Please insert again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [appdelegate.activityIndicatorView hide:YES];
                
                return;
            }
            else
            {
                //Save Customer into Server
                [BIAppDelegate shareAppdelegate].activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [BIAppDelegate shareAppdelegate].activityIndicatorView.mode = MBProgressHUDAnimationFade;
                
                if (self.edtBussinessName.text.length == 0)
                {
                    [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                    
                    UIAlertView* message = [[UIAlertView alloc] initWithTitle:nil message:@"Company name cannot be empty!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [message show];
                }
                else
                {
                    //Save Customer into Server
                    NSString* urlString = @"";
                    NSString* method = @"";
                    urlString = @"/customer?";
                    
                    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                    
                    [request addBasicAuthenticationHeaderWithUsername:[[NSUserDefaults standardUserDefaults]valueForKey:@"Username"] andPassword:[[NSUserDefaults standardUserDefaults]valueForKey:@"Pass"]];
                    
                    [request addRequestHeader:@"Content-Type" value:@"application/json"];
                    [request addRequestHeader:@"accept" value:@"application/json"];
                    
                    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
                    NSString* userID = [userDefault valueForKey:@"User ID"];
                    
                    NSString *dataContent =[NSString stringWithFormat:@"country_id=%@&company_name=%@&description=%@&address=%@&address_line1=%@&address_line2=%@&city=%@&postcode=%@&telephone=%@&email=%@&contact=%@",[NSString stringWithFormat:@"%d", countryID], self.edtBussinessName.text, self.txtDescription.text, self.edtAddress.text, @"", @"", self.edtCity.text, self.edtPostCode.text, self.edtPhone.text, self.edtEmail.text, self.edtKeyContact.text];
                    
                    NSLog(@"dataContent: %@", dataContent);
                    
                    if (self.customerEditting != nil) {
                        method = @"PUT";
                        
                        [request setRequestMethod:@"PUT"];
                        
                        urlString = @"/customer";
                        
                        dataContent =[NSString stringWithFormat:@"/%@?country_id=%@&company_name=%@&description=%@&address=%@&addressLine1=%@&addressLine2=%@&city=%@&postcode=%@&telephone=%@&email=%@&contact=%@", self.customerEditting.customerID , [NSString stringWithFormat:@"%d", countryID], self.edtBussinessName.text, self.txtDescription.text, self.edtAddress.text, @"", @"", self.edtCity.text, self.edtPostCode.text, self.edtPhone.text, self.edtEmail.text, self.edtKeyContact.text];
                    }
                    else
                    {
                        method = @"POST";
                        [request setRequestMethod:@"POST"];
                    }
                    
                    dataContent = [dataContent stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                    
                    
                    if ([dataContent containsString:@"@"]) {
                        dataContent = [dataContent stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
                    }
                    
                    [[ServiceRequest getShareInstance] serviceRequestActionName:[NSString stringWithFormat:@"%@%@",urlString, dataContent] accessToken:appdelegate.currentUser.token method:method result:^(NSURLResponse *response, NSData *dataResponse, NSError *connectionError) {
                        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                        NSInteger statusCode = [httpResponse statusCode];
                        
                        [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                        
                        if (statusCode == 200)
                        {
                            NSString *responeString = [[NSString alloc] initWithData:dataResponse
                                                                            encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"RESPIONSE CREATE NEW CUSTOMER / SUPPLIER: %@", responeString);
                            NSDictionary* dataDict = [[NSDictionary alloc] init];
                            SBJsonParser *json = [SBJsonParser new];
                            dataDict = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                            
                            if ([dataDict valueForKey:@"data"] != nil)
                            {
                                [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }
                        else
                        {
                            [[BIAppDelegate shareAppdelegate].activityIndicatorView setHidden:YES];
                            
                            NSString* message = @"";
                            message = @"Cannot save customer";
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            
                        }
                    }];
                    
                    
                }

            }
        }

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please fill all text fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [appdelegate.activityIndicatorView hide:YES];
    }
}

#pragma mark - Request Delegates...


- (void)requestFinished:(ASIHTTPRequest *)request
{
    [appdelegate.activityIndicatorView hide:YES];
    
    NSString* responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"ReponseString Afer Add Photo: %@", responseString);
    
    if (self.isEditCustomer)
    {
        BICustomer* customer = [appdelegate.customerForUser objectAtIndex:self.indexPathSelected.row];
        customer.customerAddress = self.edtAddress.text;
        customer.customerBussinessName = self.edtBussinessName.text;
        customer.customerCity = self.edtCity.text;
        customer.customerEmail = self.edtEmail.text;
        customer.customerKeyContact = self.edtKeyContact.text;
        customer.customerPostCode = self.edtPostCode.text;
        customer.customerTelephone = self.edtPhone.text;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults rm_setCustomObject:appdelegate.customerForUser forKey:@"customerForUser"];
    }
    else
    {
        BICustomer* customer = [[BICustomer alloc] init];
        customer.customerAddress = self.edtAddress.text;
        customer.customerBussinessName = self.edtBussinessName.text;
        customer.customerCity = self.edtCity.text;
        customer.customerEmail = self.edtEmail.text;
        customer.customerKeyContact = self.edtKeyContact.text;
        customer.customerPostCode = self.edtPostCode.text;
        customer.customerTelephone = self.edtPhone.text;
        
        [appdelegate.customerForUser addObject:customer];
        
        NSMutableArray* arrayTosave = [[NSMutableArray alloc] init];
        arrayTosave = appdelegate.customerForUser;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults rm_setCustomObject:appdelegate.customerForUser forKey:@"customerForUser"];
        
        
    }
    
    //                if (self.isEditCustomer) {
    //                    [self.navigationController popViewControllerAnimated:YES];
    //                }
    //                else
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString* responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    NSLog(@"ReponseString Afer Add Photo: %@", responseString);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Cannot save customer" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    [appdelegate.activityIndicatorView hide:YES];
}

- (void)loadCustomerDetails
{
    self.edtAddress.text = self.customer.customerAddress;
    self.edtBussinessName.text = self.customer.customerBussinessName;
    self.edtCity.text = self.customer.customerCity;
    self.edtEmail.text = self.customer.customerEmail;
    self.edtKeyContact.text = self.customer.customerKeyContact;
    self.edtPostCode.text = self.customer.customerPostCode;
    self.edtPhone.text = self.customer.customerTelephone;

}

-(void)saveCustomerMethod
{
    //Check and sugesst login first
}

#pragma mark - UIButton Sender
- (IBAction)btnSelectCountry_Clicked:(id)sender
{
    CountryViewController *pushToVC = [[CountryViewController alloc] initWithNibName:@"CountryViewController" bundle:nil];
    pushToVC.delegate = self;
    [self presentViewController:pushToVC animated:YES completion:nil];

}


#pragma mark - CountryViewController Delegate

- (void)CountrySelected:(CountryRepository *)countrySelected
{
    self.txtCountry.text = countrySelected.countryName;
    countryID = [countrySelected.dialCode intValue];
}

@end

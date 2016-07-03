//
//  BIRegister.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIRegister.h"
#import "BILogin.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIHTTPRequest.h"
#import "BIAppDelegate.h"
#import "SBJson.h"

@interface BIRegister ()

@end

BIAppDelegate* appdelegate;

@implementation BIRegister

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
    
    appdelegate = (BIAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Register");
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];

    [self initScreen];
    NSLog(@"Gia Su Change anything");
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
//    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initScreen
{
    UIColor* color = [[UIColor alloc] initWithRed:198.0/255.0 green:224.0/255.0 blue:168.0/255.0 alpha:1.0];
    
    [self.txtEmail setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPasscode setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtConfirmPasscode setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtDisplayName setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtUserType setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];

    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];

    self.txtEmail.leftView = paddingView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtPasscode.leftView = paddingView2;
    self.txtPasscode.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtDisplayName.leftView = paddingView3;
    self.txtDisplayName.leftViewMode = UITextFieldViewModeAlways;
//
    self.txtConfirmPasscode.leftView = paddingView4;
    self.txtConfirmPasscode.leftViewMode = UITextFieldViewModeAlways;

    self.txtUserType.leftView = paddingView5;
    self.txtUserType.leftViewMode = UITextFieldViewModeAlways;

    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height + 100)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    UIBarButtonItem *buttonflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
[toolbar setItems:[NSArray arrayWithObjects:buttonflexible,buttonDone, nil]];
    self.txtUserType.inputAccessoryView = toolbar;
    self.txtUserType.isOptionalDropDown = NO;
    [self.txtUserType setItemList:[NSArray arrayWithObjects:@"Select user type", @"Individual", @"Limited Company", @"Limited Liability Partnership", @"Partnership", @"Sole trader", nil]];
}

-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nullable NSString*)item
{
    _strUserType = item;
    
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
}

-(void)textField:(IQDropDownTextField *)textField didSelectDate:(NSDate *)date
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),date);
}

-(BOOL)textField:(nonnull IQDropDownTextField*)textField canSelectItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
    return YES;
}

-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(nullable NSString*)item
{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
    return IQProposedSelectionBoth;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, -20)];
}


- (IBAction)onRegister:(id)sender
{
    appdelegate.activityIndicatorView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appdelegate.activityIndicatorView.mode = MBProgressHUDAnimationFade;
    appdelegate.activityIndicatorView.labelText = @"";
    
    [self.viewActivity setHidden:NO];
    [self.activityIndicator startAnimating];
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    
    if([self.txtEmail.text length ]>0 && [self.txtDisplayName.text length]>0 && [self.txtPasscode.text length ]>0 && [self.txtConfirmPasscode.text length]>0)
    {

        NSString *pass, *conpass;
        pass = self.txtPasscode.text;
        conpass = self.txtConfirmPasscode.text;
        
        if ([pass isEqualToString:conpass])
        {
            if([self.txtPasscode.text length] > 5)
            {
                if ([emailTest evaluateWithObject:self.txtEmail.text] == NO) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    
                    [self.viewActivity setHidden:YES];
                    [self.activityIndicator stopAnimating];
                    
                    [appdelegate.activityIndicatorView hide:YES];
                    
                    return;
                }
                else
                {
                    NSInteger userTypeID = 0;
                    
                    if ([_strUserType isEqualToString:@"Individual"]) {
                        userTypeID = 5;
                    }
                    else if ([_strUserType isEqualToString:@"Limited Company"]) {
                        userTypeID = 4;
                    }
                    else if ([_strUserType isEqualToString:@"Limited Liability Partnership"]) {
                        userTypeID = 3;
                    }
                    else if ([_strUserType isEqualToString:@"Partnership"]) {
                        userTypeID = 2;
                    }
                    else if ([_strUserType isEqualToString:@"Sole trader"]) {
                        userTypeID = 1;
                    }
                    
                    
                    NSString* paramsURL = [NSString stringWithFormat:@"/register?name=%@&email=%@&password=%@&confirm_password=%@&user_type_id=%ld", self.txtDisplayName.text, self.txtEmail.text, self.txtPasscode.text, self.txtConfirmPasscode.text, (long)userTypeID];
                    
                    paramsURL = [paramsURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                    
                    
                    if ([paramsURL containsString:@"@"]) {
                        paramsURL = [paramsURL stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
                    }
                    
                    [[ServiceRequest getShareInstance] serviceRequestActionName:paramsURL result:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                        NSInteger statusCode = [httpResponse statusCode];
                        
                        if (statusCode == 200)
                        {
                            NSString *responeString = [[NSString alloc] initWithData:data
                                                                            encoding:NSUTF8StringEncoding];
                            
                            NSLog(@"RESPIONSE: %@", responeString);
                            NSDictionary* data = [[NSDictionary alloc] init];
                            SBJsonParser *json = [SBJsonParser new];
                            data = [json objectWithString:[NSString stringWithFormat:@"%@", responeString]];
                            
                            if ([data valueForKey:@"data"] != nil)
                            {
                                [appdelegate.activityIndicatorView hide:YES];
                                [self.viewActivity setHidden:YES];
                                [self.activityIndicator stopAnimating];
                                
                                BILogin *objectiveVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
                                [self.navigationController pushViewController:objectiveVC animated:YES];

                            }
                        }
                        else if (statusCode == 400)
                        {
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"The email has been existed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                            [appdelegate.activityIndicatorView hide:YES];
                            [self.viewActivity setHidden:YES];
                            [self.activityIndicator stopAnimating];
                        }
                    }];
                    
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password restriction " message:@"The password must be at least 6 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [appdelegate.activityIndicatorView hide:YES];
                [self.viewActivity setHidden:YES];
                [self.activityIndicator stopAnimating];
            }

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password mismatched" message:@"Password and Confirm password are not same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [appdelegate.activityIndicatorView hide:YES];
            [self.viewActivity setHidden:YES];
            [self.activityIndicator stopAnimating];
        }

    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fill All" message:@"Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        [appdelegate.activityIndicatorView hide:YES];
        [self.viewActivity setHidden:YES];
        [self.activityIndicator stopAnimating];

        
//        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"https://ec2-46-137-84-201.eu-west-1.compute.amazonaws.com:8443/wTaxmapp/resources/user"]];
//        
//        
//        [request setTag:1];
//        [request addBasicAuthenticationHeaderWithUsername:self.edtUsername.text andPassword:self.edtPassword.text];
//        
//        [request addRequestHeader:@"Content-Type" value:@"application/json"];
//        [request setValidatesSecureCertificate:NO];
//        [request setDelegate:self];
//        [request startAsynchronous];
    }
    
}

- (IBAction)onBack:(id)sender {
    BILogin *objectiveVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"Tap");
    [self.txtConfirmPasscode resignFirstResponder];
    [self.txtDisplayName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPasscode resignFirstResponder];
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, -20)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize result;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        result = [[UIScreen mainScreen] bounds].size;
    }

    
    if (textField.tag == 0)
    {
        if (result.height == 480) {
            [self.scrollView setContentOffset:CGPointMake(0,150)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    if (textField.tag == 1)
    {
        if (result.height == 480) {
            [self.scrollView setContentOffset:CGPointMake(0,150)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,150)];
    }
    if (textField.tag == 2)
    {
        if (result.height == 480) {
            [self.scrollView setContentOffset:CGPointMake(0,160)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,150)];
    }

    if (textField.tag == 3)
    {
        if (result.height == 480) {
            [self.scrollView setContentOffset:CGPointMake(0,250)];
        }
        else
            [self.scrollView setContentOffset:CGPointMake(0,160)];
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


#pragma mark - Request delegates...


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString  *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    if(request.tag == 1)
    {
        if ([request responseStatusCode] == 409)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Username Already Exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if([request responseStatusCode] == 201)
        {
            [appdelegate.activityIndicatorView hide:YES];
            [self.viewActivity setHidden:YES];
            [self.activityIndicator stopAnimating];
            
            BILogin *objectiveVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
            [self.navigationController pushViewController:objectiveVC animated:YES];
        }
        
        if([request responseStatusCode] == 200)
        {

        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.viewActivity setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Registration failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}


@end

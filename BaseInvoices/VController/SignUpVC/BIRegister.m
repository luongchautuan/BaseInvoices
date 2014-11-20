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

@interface BIRegister ()

@end

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
    NSLog(@"Register");
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnSignup setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];

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
    
    //set gesture for return to close soft keyboard
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.txtEmail.leftView = paddingView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    self.txtPasscode.leftView = paddingView2;
    self.txtPasscode.leftViewMode = UITextFieldViewModeAlways;
}

- (IBAction)onRegister:(id)sender
{
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
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password mismatched" message:@"password and conform password are not same" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [self.viewActivity setHidden:YES];
            [self.activityIndicator stopAnimating];
        }

    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Fill All" message:@"Fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
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
    [self.navigationController pushViewController:objectiveVC animated:YES];
}

#pragma mark return to close soft keyboard

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    [self.txtConfirmPasscode resignFirstResponder];
    [self.txtDisplayName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPasscode resignFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Text Field delegates...

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==0)
    {
        [self.scrollView setContentOffset:CGPointMake(0,50)];
    }
    
    if (textField.tag==1)
    {
        [self.scrollView setContentOffset:CGPointMake(0,100)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    return YES;
}


#pragma mark - Request delegates...


- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(request.tag == 1)
    {
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

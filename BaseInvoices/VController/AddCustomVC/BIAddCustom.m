//
//  BIAddCustom.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddCustom.h"
#import "BIAddInvoices.h"

@interface BIAddCustom ()

@end

@implementation BIAddCustom

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
    [self.txtTitle setText:@"Add Customer"];
    [self initScreen];
    // Do any additional setup after loading the view from its nib.
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
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
//    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, screenHeight)];
    
    self.edtAddress.leftView = paddingView;
    self.edtAddress.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtBussinessName.leftView = paddingView2;
    self.edtBussinessName.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtCity.leftView = paddingView3;
    self.edtCity.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtEmail.leftView = paddingView4;
    self.edtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtKeyContact.leftView = paddingView5;
    self.edtKeyContact.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtPhone.leftView = paddingView6;
    self.edtPhone.leftViewMode = UITextFieldViewModeAlways;
    
    self.edtPostCode.leftView = paddingView7;
    self.edtPostCode.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
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
    [self.scrollView setContentOffset:CGPointMake(0,0)];
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
    
    if(textField== self.edtPhone)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    if(textField == self.edtKeyContact)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    
    
    return YES;
}
@end

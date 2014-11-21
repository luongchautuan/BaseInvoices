//
//  BIAddNewBussiness.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddNewBussiness.h"
#define ACCEPTABLE_CHARECTERS @"+0123456789."

@interface BIAddNewBussiness ()

@end

@implementation BIAddNewBussiness

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
    onCheckedButton = false;
    
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_uncheck_radiobutton.png"] forState:UIControlStateNormal];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateSelected];
    [self.btnCheckVat setBackgroundImage:[UIImage imageNamed:@"bg_checked_radiobutton.png"] forState:UIControlStateHighlighted];
    
    [self.txtTitle setText:@"Add New Bussiness"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCheckedButton:(id)sender {
    if(onCheckedButton)
    {
        onCheckedButton = false;
    }
    else
    {
        onCheckedButton = true;
    }
    
    [self.btnCheckVat setSelected:onCheckedButton];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField.tag == 4 || textField.tag == 5)
    {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        return [string isEqualToString:filtered];
    }
    
    if (textField.tag == 21) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    return YES;
}

- (IBAction)onSaveBusiness:(id)sender
{
    //check login and save
}
@end

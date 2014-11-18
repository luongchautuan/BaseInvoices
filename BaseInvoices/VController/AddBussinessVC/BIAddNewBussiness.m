//
//  BIAddNewBussiness.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddNewBussiness.h"

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
@end

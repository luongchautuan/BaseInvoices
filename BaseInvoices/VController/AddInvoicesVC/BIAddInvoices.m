//
//  BIAddInvoices.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//
#import "BIAddCustom.h"
#import "BIAddInvoices.h"
#import "BIAddProducts.h"
#import "UIViewController+MMDrawerController.h"
#import "BIDashBoard.h"

@interface BIAddInvoices ()

@end

@implementation BIAddInvoices

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
    [self.txtTitle setText:@"Add Invoices"];
    [self.btnSaveSend setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnSaveSend setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnSaveSend setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];
    
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnSave setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAddCustom:(id)sender {
    
    BIAddCustom *pushToVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}
- (IBAction)onAddProduct:(id)sender {
    
    BIAddProducts *pushToVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onOpenMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)onBack:(id)sender {
    BIDashBoard *objectiveVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
    [self.navigationController pushViewController:objectiveVC animated:YES];
}
@end

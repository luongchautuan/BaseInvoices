//
//  BIDashBoard.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIDashBoard.h"
#import "UIViewController+MMDrawerController.h"
#import "BIAddInvoices.h"
#import "BIAddNewBussiness.h"

@interface BIDashBoard ()

@end

@implementation BIDashBoard

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
    // Do any additional setup after loading the view from its nib.
    [self.txtTitle setText:@"Dash Board"];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tapGeusture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGeusture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowPopUp:(id)sender
{
    self.viewAddMore.hidden = NO;
    self.viewAddMore.frame=CGRectMake(24,-130, 288, 130);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewAddMore.frame=CGRectMake(24 ,65, 288, 130);
    [UIView commitAnimations];

    
}

- (IBAction)onAddInvoice:(id)sender
{
    self.viewAddMore.hidden = YES;
    
    BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onAddBusiness:(id)sender
{
    self.viewAddMore.hidden = YES;
    
    BIAddNewBussiness *pushToVC = [[BIAddNewBussiness alloc] initWithNibName:@"BIAddNewBussiness" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)showCat:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)tapHandler:(UIGestureRecognizer *)ges
{
    NSLog(@"TAP");
    self.viewAddMore.hidden = YES;
}

//Get invoices info from server
-(void)getAllInvoice
{
    
}

@end

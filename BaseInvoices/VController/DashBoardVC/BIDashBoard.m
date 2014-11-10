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
    
//    UITapGestureRecognizer *tapGeusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
//    tapGeusture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:tapGeusture];
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

- (IBAction)onAddInvoice:(id)sender {
    BIAddInvoices *pushToVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)showCat:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

//Get invoices info from server
-(void)getAllInvoice
{
    
}

@end

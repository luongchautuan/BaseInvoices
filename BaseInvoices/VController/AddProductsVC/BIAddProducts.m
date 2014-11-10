//
//  BIAddProducts.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAddProducts.h"
#import "BIAddInvoices.h"

@interface BIAddProducts ()

@end

@implementation BIAddProducts

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
    [self.txtTitle setText:@"Add Products"];
    // Do any additional setup after loading the view from its nib.
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
@end

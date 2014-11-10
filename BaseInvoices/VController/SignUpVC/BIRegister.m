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

- (IBAction)onBack:(id)sender {
    BILogin *objectiveVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
    [self.navigationController pushViewController:objectiveVC animated:YES];
}
@end

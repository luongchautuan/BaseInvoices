//
//  BILogin.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BILogin.h"
#import "BIRegister.h"
#import "BIDashBoard.h"
#import "UIViewController+MMDrawerController.h"
#import "BIAddInvoices.h"
#import "BIAddProducts.h"
#import "BIAddCustom.h";

@interface BILogin ()

@end

@implementation BILogin

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
    
    [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnLogin setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];
    
    [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"bg_hover.png"] forState:UIControlStateNormal];
    [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateSelected];
    [self.btnRegister setBackgroundImage:[UIImage imageNamed:@"bg_state.png"] forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self closeMenu];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    BIDashBoard *pushToVC = [[BIDashBoard alloc] initWithNibName:@"BIDashBoard" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (IBAction)onRegister:(id)sender {
    BIRegister *pushToVC = [[BIRegister alloc] initWithNibName:@"BIRegister" bundle:nil];
    [self.navigationController pushViewController:pushToVC animated:YES];
}

- (void)closeMenu
{
}

- (void)selectCategory:(int)ID {
    switch (ID) {
        case 0: {
            BIAddInvoices *objectiveVC = [[BIAddInvoices alloc] initWithNibName:@"BIAddInvoices" bundle:nil];
            [self.navigationController pushViewController:objectiveVC animated:YES];
        }
            break;
        case 1: {
            BIAddCustom *experienceVC = [[BIAddCustom alloc] initWithNibName:@"BIAddCustom" bundle:nil];
            [self.navigationController pushViewController:experienceVC animated:YES];
        }
            break;
        case 2: {
            BIAddProducts *educationVC = [[BIAddProducts alloc] initWithNibName:@"BIAddProducts" bundle:nil];
            [self.navigationController pushViewController:educationVC animated:YES];
        }
            break;
        case 3: {
//            BLSkillVC *skillVC = [[BLSkillVC alloc] initWithNibName:@"BLSkillVC" bundle:nil];
//            [self.navigationController pushViewController:skillVC animated:YES];
        }
            break;
        case 4: {
//            BLReferencesVC *referenceVC = [[BLReferencesVC alloc] initWithNibName:@"BLReferencesVC" bundle:nil];
//            [self.navigationController pushViewController:referenceVC animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
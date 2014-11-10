//
//  BILogin.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLLeftSideVC.h"

@interface BILogin : UIViewController<BLLeftSideDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UITextField *edtUsername;
@property (weak, nonatomic) IBOutlet UITextField *edtPassword;

- (IBAction)onLogin:(id)sender;
- (IBAction)onRegister:(id)sender;

- (void)closeMenu;
@end

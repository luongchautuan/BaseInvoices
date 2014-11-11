//
//  BIMainLoginViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/11/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIMainLoginViewController : UIViewController<UITextFieldDelegate>

- (IBAction)txtEmail:(id)sender;
- (IBAction)txtPassword:(id)sender;

@property (nonatomic)NSString *responseString;

@end

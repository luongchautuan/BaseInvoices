//
//  BIProfileViewController.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIProfileViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtDisplayName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewPopUpMain;

@end

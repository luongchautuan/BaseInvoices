//
//  BIProfileViewController.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIProfileViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MobileCoreServices/MobileCoreServices.h"
#import "BIAppDelegate.h"

@interface BIProfileViewController ()

@end

BIAppDelegate* appdelegate;

@implementation BIProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    appdelegate = (BIAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (!appdelegate.isLoginSucesss)
    {
        self.lblDisplayName.text = @"User Default";
        self.lblEmail.text =  @"support@baseinvoices.com";
        //        self.btnEditDisplayName.enabled = NO;
        //        self.btnEditImage.enabled = NO;
    }
    else
    {
        
        NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((appdelegate.currentUser.imageUser), 0.5)];
        
        int imageSize = imageData.length;
        
        NSLog(@"Image Size: %d", imageSize);
        
        if (appdelegate.currentUser.displayName.length > 0)
        {
            self.lblDisplayName.text = appdelegate.currentUser.displayName;
        }
        else
        {
            self.lblDisplayName.text =  @"Insert Name";
        }
        
        if (imageSize > 0) {
            self.imageProfile.image = appdelegate.currentUser.imageUser;
        }
        else
        {
            
        }
        
        self.lblEmail.text = appdelegate.currentUser.userName;
        
    }
    
    //    self.imageProfile.image = appdelegate.currentUser.imageUser;
    
    //    self.imageProfile.layer.borderWidth = 1.0f;
    self.imageProfile.layer.masksToBounds = NO;
    self.imageProfile.clipsToBounds = YES;
    self.imageProfile.layer.cornerRadius = 75;

}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEditImageProfile:(id)sender
{
    UIActionSheet *action_sheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Library", nil];
    
    [action_sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)onEditDisplayName:(id)sender
{
    //Set infor into pop up
    self.txtDisplayName.text = appdelegate.currentUser.displayName;
    self.txtEmail.text =  appdelegate.currentUser.userName;
    
    [self.viewPopUp setHidden:NO];
    self.viewPopUpMain.frame=CGRectMake(8, -170, 300, 119);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.5];
    self.viewPopUpMain.frame=CGRectMake(8, 170, 300, 119);
    [UIView commitAnimations];

}

- (IBAction)onSaveProfile:(id)sender
{
    appdelegate.currentUser.displayName = self.lblDisplayName.text;
    appdelegate.currentUser.imageUser = self.imageProfile.image;
    appdelegate.currentUser.userName = self.lblEmail.text;
    
    NSLog(@"appdelegate.currentUser.displayName : %@", self.lblDisplayName.text);
    
    appdelegate.isLoginSucesss = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)onMenuSetting:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - Action scheet...

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init ];
            
            ipc=[[UIImagePickerController alloc] init ];
            
            ipc.delegate = self;
            
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            ipc.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            
            [self presentModalViewController:ipc animated:YES];
            
            //            [self.parentViewController presentViewController:ipc animated:YES completion:nil];
            
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Camera capture is not supported in this device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
    }
    
    else if(buttonIndex == 1)
        
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            
        {
            
            UIImagePickerController *ipc=[[UIImagePickerController alloc] init ];
            
            ipc=[[UIImagePickerController alloc] init ];
            
            ipc.delegate=self;
            
            ipc.mediaTypes = [NSArray arrayWithObjects: (NSString *) kUTTypeImage, nil];
            
            
            
            ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentModalViewController:ipc animated:YES];
            //            [self presentViewController:ipc animated:YES completion:nil];
            //            [self presentModalViewController:ipc animated:YES];
            
        }
    }
    
    
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet removeFromSuperview];
}


-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Image");
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageProfile.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClosePopUp:(id)sender
{
    [self.viewPopUp setHidden:YES];
}

- (IBAction)onSaveChangeDisplayName:(id)sender
{
    self.lblDisplayName.text = self.txtDisplayName.text;
    self.lblEmail.text = self.txtEmail.text;
    
    [self.viewPopUp setHidden:YES];
}

- (IBAction)onSendEmailContactSupport:(id)sender
{
    
    if([MFMailComposeViewController canSendMail])
    {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        
        NSString *subject;
        
        subject = @"Invoice by Baseinvoices on iOS";
        
        [mailer setSubject:subject];
        [mailer setTitle:@"Invite"];
        
        NSString* emailToRecipents = @"support@baseinvoices.com";

        NSArray *toRecipents = [NSArray arrayWithObject:emailToRecipents];
        [mailer setMessageBody:@"" isHTML:NO];
        [mailer setToRecipients:toRecipents];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Failure"
                              message:@"Your device doesn't support the composer sheet"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            /*	NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");*/
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deleted" message:@"Your mail has been Deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        case MFMailComposeResultSaved:
            //  NSLog(@"Mail saved: you saved the email message in the Drafts folder");
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Saved" message:@"Your Conversation has been saved to Draft" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
            
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Send successfully." delegate:self cancelButtonTitle:@"Thank you!" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        case MFMailComposeResultFailed:
            
        {
            NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Failed" message:@"Your valuable FeedBack has been Failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            
        }
            break;
        default:
            NSLog(@"Mail not sent");
            break;
    }
    
    NSLog(@"Disconnect EMAIL");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

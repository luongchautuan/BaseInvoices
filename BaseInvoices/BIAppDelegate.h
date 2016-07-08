//
//  BIAppDelegate.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "BIUser.h"
#import "BIProduct.h"
#import "BICustomer.h"
#import "BIBussiness.h"
#import "BICurrency.h"
#import "GAITracker.h"
#import "MBProgressHUD.h"

@interface BIAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) id<GAITracker> tracker;

@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic)MBProgressHUD* activityIndicatorView;

@property (nonatomic, retain) BIUser* currentUser;
@property (nonatomic, retain) BICustomer* currentCustomerForAddInvoice;
@property (nonatomic, retain) BIBussiness* bussinessForUser;

@property (nonatomic, retain)NSMutableArray* productsFroAddInvoices;

@property (nonatomic, retain)NSMutableArray* invoicesForUser;
@property (nonatomic)NSMutableArray* productsForUser;
@property (nonatomic, retain)NSMutableArray* customerForUser;
@property (nonatomic, retain)NSMutableArray* businessForUser;
@property (nonatomic)NSMutableArray* currencies;

@property (nonatomic)NSString* country;
@property (nonatomic)NSString* companyName;

@property (nonatomic)BOOL isLoginSucesss;
@property (nonatomic)BOOL isLaunchAppFirstTime;

@property (nonatomic, retain)BICurrency* currency;

@property (nonatomic) CGSize result;

@property (nonatomic) NSMutableArray* countries;
@property (strong, nonatomic) NSArray *dataRows;

+ (BIAppDelegate*)shareAppdelegate;

@end

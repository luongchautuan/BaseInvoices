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

@interface BIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) MMDrawerController * drawerController;
@property (nonatomic, retain) BIUser* currentUser;

@property (nonatomic)NSMutableArray* productsFroAddInvoices;

@property (nonatomic)NSMutableArray* invoicesForUser;
@property (nonatomic)NSMutableArray* productsForUser;
@property (nonatomic)NSMutableArray* customerForUser;

@end

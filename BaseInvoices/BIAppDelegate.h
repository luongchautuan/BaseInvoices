//
//  BIAppDelegate.h
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"

@interface BIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) MMDrawerController * drawerController;

@end

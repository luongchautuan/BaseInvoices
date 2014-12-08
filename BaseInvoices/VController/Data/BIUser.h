//
//  BIUser.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BIUser : NSObject

@property (nonatomic)NSString* userName;
@property (nonatomic)NSString* password;
@property (nonatomic)NSString* displayName;
@property (nonatomic)NSString* email;
@property (nonatomic)UIImage* imageUser;

@end

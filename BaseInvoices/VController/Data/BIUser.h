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

@property (nonatomic, strong)NSString* userName;
@property (nonatomic, strong)NSString* password;
@property (nonatomic, strong)NSString* displayName;
@property (nonatomic, strong)NSString* email;
@property (nonatomic)UIImage* imageUser;
@property (nonatomic, strong)NSString* userID;
@property (nonatomic) BOOL isLoginSuccessFully;

@property (nonatomic, strong) NSString* token;

@end

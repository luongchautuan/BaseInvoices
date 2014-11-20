//
//  BIBussiness.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIBussiness : NSObject

@property (nonatomic)NSString* bussinessName;
@property (nonatomic)NSString* bussinessDescription;
@property (nonatomic)NSString* bussinessAddress;
@property (nonatomic)NSString* bussinessCity;
@property (nonatomic)NSString* bussinessPostCode;
@property (nonatomic)NSString* bussinessVat;
@property (nonatomic)BOOL isVatRegistered;
@property (nonatomic)NSString* bussinessCurrency;

@end
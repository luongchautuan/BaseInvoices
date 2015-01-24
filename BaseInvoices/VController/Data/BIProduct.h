//
//  BIProduct.h
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/20/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIProduct : NSObject

@property (nonatomic)NSString* productName;
@property (nonatomic)NSString* productDescription;
@property (nonatomic)NSString* productUnitPrice;
@property (nonatomic)NSString* productTaxRate;
@property (nonatomic)float numberOfUnit;

@end

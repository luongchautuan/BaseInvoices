//
//  Common.h
//  chumbarscratcherscard
//
//  Created by Luong Chau Tuan on 2/8/16.
//  Copyright © 2016 Mantis Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define urlHost @"http://chumba.demo.mantissolution.com/api/v1/auth/"

#define urlHost @"http://www.basetax.co.uk/v2"

@interface Common : NSObject

FOUNDATION_EXTERN NSInteger ADMIN;
FOUNDATION_EXTERN NSInteger NORMAL_USER;
FOUNDATION_EXPORT NSInteger RETAILER;
FOUNDATION_EXPORT NSString* RETAILER_NONE;
FOUNDATION_EXPORT NSString* NORMAIL_ALL;
FOUNDATION_EXPORT NSString* const NAME ;
FOUNDATION_EXPORT NSString* const CODE ;

@end

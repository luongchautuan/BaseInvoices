//
//  MyUITextField.m
//  ComplyFlow
//
//  Created by Alex on 17/03/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

#import "MyUITextField.h"

@implementation MyUITextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

@end

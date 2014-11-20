//
//  COPGlobalVariables.m
//  ClockOutPremium
//
//  Created by ThomasTran on 10/9/14.
//
//

#import "COPGlobalVariables.h"

@implementation COPGlobalVariables

+ (COPGlobalVariables *)sharedInstance {
    static dispatch_once_t onceToken;
    static COPGlobalVariables *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[COPGlobalVariables alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end

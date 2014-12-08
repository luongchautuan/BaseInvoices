//
//  BICustomProductTableViewCell.m
//  BaseInvoices
//
//  Created by Hung Kiet Ngo on 11/22/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BICustomProductTableViewCell.h"

@implementation BICustomProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [[self.quantity layer] setCornerRadius:4.0f];
    
    [[self.quantity layer] setMasksToBounds:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

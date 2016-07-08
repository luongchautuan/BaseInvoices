//
//  CountryTableViewCell.h
//  chumbarscratcherscard
//
//  Created by Luong Chau Tuan on 2/8/16.
//  Copyright © 2016 Mantis Solution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCountryName;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryCode;
@property (weak, nonatomic) IBOutlet UIImageView *imgCountry;
@end

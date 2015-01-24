//
//  BLLeftSideVC.h
//  ResumeBuildling
//
//  Created by Mobiz on 10/7/14.
//  Copyright (c) 2014 Mobiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLLeftSideDelegate <NSObject>

@optional
- (void)selectCategory:(int)ID;

@end

@interface BLLeftSideVC : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSArray *arrData;
}

@property (assign) id<BLLeftSideDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIImageView *img_thumb;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayName;

@end

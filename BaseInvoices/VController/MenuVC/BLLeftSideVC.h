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

@end

//
//  COPDBManager.h
//  ClockOutPremium
//
//  Created by ThomasTran on 10/8/14.
//
//

#import <Foundation/Foundation.h>

@interface COPDBManager : NSObject
{
    NSString *databasePath;
}

+(COPDBManager*)getSharedInstance;
-(void)createDB;

//#pragma mark modules getdata fromlocal
//-(void)getDataFromLocal;
//-(void)initDbFromFirstLogin;
//
//#pragma mark modules insert data
//-(BOOL)insertUser:(COPUser *)dataUser;
//-(BOOL)insertShift:(COPShifts *)dataShift withIdUser:(NSString *)idUser;
//-(BOOL)insertTheme:(COPThemes *)dataTheme;
//
//#pragma mark modules delete data
//-(void)deleteAllUser;
//-(void)deleteAllShift;
//-(void)deleteAllTheme;
//-(void)deleteUserAt:(NSString*)idUser ;
//
//#pragma mark modules update data
//-(void)updateUserWithId:(NSString*)idUser andData:(COPUser*)dataUser;
//
//#pragma mark modules get data
//-(NSArray* )getAllUser;
//-(NSArray* )getAllShiftAtUserId:(NSString*)idUser;
//-(COPThemes *)getDataTheme;
@end

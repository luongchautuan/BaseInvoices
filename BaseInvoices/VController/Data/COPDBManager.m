//
//  COPDBManager.m
//  ClockOutPremium
//
//  Created by ThomasTran on 10/8/14.
//
//

#import "COPDBManager.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "COPGlobalVariables.h"

static COPDBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation COPDBManager

+(COPDBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

//-(void)createDB{
//    NSString *docsDir;
//    NSArray *dirPaths;
//    // Get the documents directory
//    dirPaths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    docsDir = dirPaths[0];
//    // Build the path to the database file
//    databasePath = [[NSString alloc] initWithString:
//                    [docsDir stringByAppendingPathComponent: @"clock_out_pro.db"]];
//    
//    NSLog(@"path db: %@",databasePath);
////    BOOL isSuccess = YES;
//    NSFileManager *filemgr = [NSFileManager defaultManager];
//    if ([filemgr fileExistsAtPath: databasePath ] == NO)
//    {
//        NSLog(@"[filemgr fileExistsAtPath: databasePath ] == NO");
//        const char *dbpath = [databasePath UTF8String];
//        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//        {
//            char *errMsg;
//            const char *sql_stmt =
//            "CREATE TABLE IF NOT EXISTS USER (IDUSER INTEGER PRIMARY KEY AUTOINCREMENT, USERNAME TEXT, COMPANY TEXT, PHONE TEXT, ZIP TEXT, STREET TEXT, STATE TEXT, CITY TEXT, FAX TEXT, EMAIL TEXT, THUMB TEXT)";
//            
//            NSLog(@"TABLE USER prepare created.");
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
//                == SQLITE_OK)
//            {
//                NSLog(@"TABLE USER created.");
//                
//            }
//            
//            sql_stmt = "CREATE TABLE IF NOT EXISTS SHIFTS (IDSHIFT INTEGER PRIMARY KEY AUTOINCREMENT, TIMEEND TEXT, TIMESTART TEXT, IDUSER TEXT, TIMEWORKED TEXT, EARNEDTODAY TEXT, PAYRATE TEXT, TIMEBREAK TEXT, NOTE TEXT, OVERTIME TEXT, OVERTIMERATE TEXT)";
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
//            {
//                NSLog(@"TABLE USER & SHIFTS created.");
//            }
//            
//            sql_stmt = "CREATE TABLE IF NOT EXISTS SETTINGS (IDTHEME INTEGER PRIMARY KEY AUTOINCREMENT, TXT1 TEXT, COLOR1 TEXT, TXT2 TEXT, COLOR2 TEXT, TXT3 TEXT, COLOR3 TEXT)";
//            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
//            {
//                NSLog(@"TABLE USER & SETTINGS created.");
//            }
//            
////            [self initDbFromFirstLogin];
//            
//            sqlite3_close(database);
//        }
//        else {
////            isSuccess = NO;
//            NSLog(@"Failed to open/create database");
//        }
//    }else{
////        [self getDataFromLocal];
//    }
//}

//-(void)initDbFromFirstLogin
//{
//    NSLog(@"initDbFromFirstLogin");
//    
////    COPUser *objUser = [[COPUser alloc] initWithFirstName:@"" andCompany:@"" andPhone:@"" andZip:@"" andStreet:@"" andState:@"" andCity:@"" andFax:@"" andEmail:@"" andIdUser:@""];
//    
//    COPUser *objUser = [[COPUser alloc] initWithFirstName:@"" andCompany:@"" andPhone:@"" andZip:@"" andStreet:@"" andState:@"" andCity:@"" andFax:@"" andEmail:@"" andIdUser:@"" andThumb:@""];
//
//    [self insertUser:objUser];
//    
//    COPThemes *objTheme = [[COPThemes alloc]initWithIdTheme:@"0" andTxt1:@"Default" andColor1:@"#6CA6CD" andTxt2:@"Default" andColor2:@"#27408B" andTxt3:@"Default" andColor3:@"#394264"];
//    [self insertTheme:objTheme];
////    [self deleteAllUser];
//}
//
//-(void)getDataFromLocal
//{
//    NSLog(@"getDataFromLocal");
//    COPGlobalVariables *global = [COPGlobalVariables sharedInstance];
//
//    global.lstUser = [self getAllUser];
////    global.currenObjTheme = [self getDataTheme];
//}
//
//#pragma mark modules insert data
//-(BOOL)insertShift:(COPShifts *)dataShift withIdUser:(NSString *)idUser
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SHIFTS(TIMEEND, TIMESTART,IDUSER,TIMEWORKED,EARNEDTODAY,PAYRATE,TIMEBREAK,NOTE,OVERTIME,OVERTIMERATE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", dataShift.timeEnd,
//                               dataShift.timeStart,dataShift.idUser,dataShift.timeWorked,dataShift.earnTotal,dataShift.payRate,dataShift.timeBreak,dataShift.note,dataShift.overTime,dataShift.overTimeRate];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"shifts inserted.");
//            return YES;
//        }
//        else {
//            NSLog(@"shifts error.");
//            return NO;
//        }
//        sqlite3_reset(statement);
//    }
//    return NO;
//
//}
//
//-(BOOL)insertUser:(COPUser *)dataUser
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO USER (USERNAME, COMPANY, PHONE, ZIP, STREET,STATE,CITY,FAX,EMAIL,THUMB) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", dataUser.username,
//                               dataUser.company,dataUser.phone,dataUser.zip,dataUser.street,dataUser.state,dataUser.city,dataUser.fax,dataUser.email,dataUser.thumb];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"Person inserted.");
//            return YES;
//        }
//        else {
//            NSLog(@"Person error.");
//            return NO;
//        }
//        sqlite3_reset(statement);
//    }
//    return NO;
//}
//
//-(BOOL)insertTheme:(COPThemes *)dataTheme
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO SETTINGS (TXT1, COLOR1, TXT2, COLOR2, TXT3,COLOR3) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", dataTheme.txt1,
//                               dataTheme.txt2,dataTheme.txt3,dataTheme.color1,dataTheme.color2,dataTheme.color3];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"theme inserted.");
//            return YES;
//        }
//        else {
//            NSLog(@"theme error.");
//            return NO;
//        }
//        sqlite3_reset(statement);
//    }
//    return NO;
//}
//
//#pragma mark modules get data
//-(NSArray*)getAllShiftAtUserId:(NSString *)idUser
//{
//    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = [NSString stringWithFormat:@"select * from SHIFTS where IDUSER=\"%@\"",idUser];
//        
//        const char *query_stmt = [querySQL UTF8String];
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            NSLog(@"in process");
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString *ID = [[NSString alloc] initWithUTF8String:
//                                (const char *) sqlite3_column_text(statement, 0)];
//                //                [resultArray addObject:ID];
//                
//                NSString *TIMEEND = [[NSString alloc] initWithUTF8String:
//                                      (const char *) sqlite3_column_text(statement, 1)];
//                //                [resultArray addObject:USERNAME];
//                NSString *TIMESTART = [[NSString alloc] initWithUTF8String:
//                                     (const char *) sqlite3_column_text(statement, 2)];
//                //                [resultArray addObject:COMPANY];
//                NSString *IDUSER = [[NSString alloc]initWithUTF8String:
//                                   (const char *) sqlite3_column_text(statement, 3)];
//                //                [resultArray addObject:PHONE];
//                
//                NSString *TIMEWORKED = [[NSString alloc]initWithUTF8String:
//                                 (const char *) sqlite3_column_text(statement, 4)];
//                //                [resultArray addObject:ZIP];
//                
//                NSString *EARNEDTODAY = [[NSString alloc]initWithUTF8String:
//                                    (const char *) sqlite3_column_text(statement, 5)];
//                //                [resultArray addObject:STREET];
//                
//                NSString *PAYRATE = [[NSString alloc]initWithUTF8String:
//                                   (const char *) sqlite3_column_text(statement, 6)];
//                //                [resultArray addObject:STATE];
//                
//                NSString *TIMEBREAK = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 7)];
//                //                [resultArray addObject:CITY];
//                
//                NSString *NOTE = [[NSString alloc]initWithUTF8String:
//                                 (const char *) sqlite3_column_text(statement, 8)];
//                //                [resultArray addObject:FAX];
//                
//                NSString *OVERTIME = [[NSString alloc]initWithUTF8String:
//                                   (const char *) sqlite3_column_text(statement, 9)];
//                //                [resultArray addObject:EMAIL];
//                
//                NSString *OVERTIMERATE = [[NSString alloc]initWithUTF8String:
//                                      (const char *) sqlite3_column_text(statement, 10)];
//                //                [resultArray addObject:EMAIL];
//                
//                NSLog(@"id: %@ timeend: %@ timestart: %@ iduser: %@ timeworked: %@ earnedtoday: %@ payrate: %@ timebreak: %@ note: %@ overttime: %@ overtimerate: %@",ID,TIMEEND,TIMESTART,IDUSER,TIMEWORKED,EARNEDTODAY,PAYRATE,TIMEBREAK,NOTE,OVERTIME,OVERTIMERATE);
//                
//                COPShifts *objShift = [[COPShifts alloc] initWithIdUser:IDUSER andIdShift:ID andTimeStart:TIMESTART andTimeEnd:TIMEEND andTimeWorked:TIMEWORKED andEarnTotal:EARNEDTODAY andPayRate:PAYRATE andTimeBreak:TIMEBREAK andNote:NOTE andOverTime:OVERTIME andOverTimeRate:OVERTIMERATE];
//                
//                [resultArray addObject:objShift];
//            }
//        }
//        else{
//            NSLog(@"Not found");
//        }
//        //        sqlite3_reset(statement);
//        //        
//        sqlite3_finalize(statement);
//        sqlite3_close(database);
//    }
//    
//    return resultArray;
//}
//
//-(NSArray*)getAllUser
//{
//    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *querySQL = @"select * from USER";
//        const char *query_stmt = [querySQL UTF8String];
//        if (sqlite3_prepare_v2(database,
//                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
//        {
//            NSLog(@"in process");
//            while (sqlite3_step(statement) == SQLITE_ROW)
//            {
//                NSString *ID = [[NSString alloc] initWithUTF8String:
//                                      (const char *) sqlite3_column_text(statement, 0)];
////                [resultArray addObject:ID];
//                
//                NSString *USERNAME = [[NSString alloc] initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 1)];
////                [resultArray addObject:USERNAME];
//                NSString *COMPANY = [[NSString alloc] initWithUTF8String:
//                                        (const char *) sqlite3_column_text(statement, 2)];
////                [resultArray addObject:COMPANY];
//                NSString *PHONE = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 3)];
////                [resultArray addObject:PHONE];
//                
//                NSString *ZIP = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 4)];
////                [resultArray addObject:ZIP];
//                
//                NSString *STREET = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 5)];
////                [resultArray addObject:STREET];
//                
//                NSString *STATE = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 6)];
////                [resultArray addObject:STATE];
//                
//                NSString *CITY = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 7)];
////                [resultArray addObject:CITY];
//                
//                NSString *FAX = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 8)];
////                [resultArray addObject:FAX];
//                
//                NSString *EMAIL = [[NSString alloc]initWithUTF8String:
//                                  (const char *) sqlite3_column_text(statement, 9)];
//                
//                NSString *THUMB = [[NSString alloc]initWithUTF8String:
//                                   (const char *) sqlite3_column_text(statement, 10)];
////                [resultArray addObject:EMAIL];
//                
////                NSLog(@"id: %@ name: %@ company: %@ phone: %@ zip: %@ street: %@ state: %@ city: %@ fax: %@ email: %@",ID,USERNAME,COMPANY,PHONE,ZIP,STREET,STATE,CITY,FAX,EMAIL);
//                
//                COPUser *objUser = [[COPUser alloc] initWithFirstName:USERNAME andCompany:COMPANY andPhone:PHONE andZip:ZIP andStreet:STREET andState:STATE andCity:CITY andFax:FAX andEmail:EMAIL andIdUser:ID andThumb:THUMB];
//                
//                [resultArray addObject:objUser];
//                
////                return resultArray;
//            }
//        }
//        else{
//            NSLog(@"Not found");
//        }
////        sqlite3_reset(statement);
////        
//        sqlite3_finalize(statement);
//        sqlite3_close(database);
//    }
//    
//    return resultArray;
//}
//
//#pragma mark modules update data
//-(void)updateUserWithId:(NSString *)idUser andData:(COPUser *)dataUser
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"update USER set USERNAME = \"%@\", COMPANY = \"%@\", PHONE = \"%@\", ZIP = \"%@\", STREET = \"%@\", STATE = \"%@\", CITY = \"%@\", FAX = \"%@\", EMAIL = \"%@\", THUMB = \"%@\" where IDUSER = \"%@\"",dataUser.username, dataUser.company, dataUser.phone, dataUser.zip, dataUser.street, dataUser.state, dataUser.city, dataUser.fax, dataUser.email, dataUser.thumb,idUser];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"update ok.");
//        }
//        else {
//            NSLog(@"update error.");
//        }
//        sqlite3_reset(statement);
//    }
//}
//
//#pragma mark modules delete data
//
//-(void)deleteAllUser
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = @"delete from USER";
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"delete ok.");
//        }
//        else {
//            NSLog(@"delete error.");
//        }
//        sqlite3_reset(statement);
//    }
//}
//
//-(void)deleteAllTheme
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = @"delete from SETTINGS";
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"delete ok.");
//        }
//        else {
//            NSLog(@"delete error.");
//        }
//        sqlite3_reset(statement);
//    }
//}
//
//-(void)deleteAllShift
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = @"delete from SHIFTS";
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"delete ok.");
//        }
//        else {
//            NSLog(@"delete error.");
//        }
//        sqlite3_reset(statement);
//    }
//}

@end
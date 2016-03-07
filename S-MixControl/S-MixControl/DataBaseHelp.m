//
//  DataBaseHelp.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/16.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//


#define FILE_NAME @"database.sqlite"
#import "DataBaseHelp.h"


#import "SignalValue.h"



@implementation DataBaseHelp
static sqlite3 *db;


//+(sqlite3 *)openDB
//{
//    //打开数据库
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
//    NSString *fileName = [doc stringByAppendingPathComponent:@"Database.sqlite"];
//    const char *cfileName = fileName.UTF8String;
//    int result = sqlite3_open(cfileName, &db);
//    if (result == SQLITE_OK) {
//        NSLog(@"数据库打开成功");
//        //创建表
//       const char *sql = "CREATE TABLE IF NOT EXISTS Data_name (id integer PRIMARY KEY AUTOINCREMENT,Temp integer NOT NULL,type integer NOT NULL,Key text NOT NULL, Text text NOT NULL);";
//        
//        char *erroMsg = NULL;
//        sqlite3_exec(db, sql, NULL, NULL, &erroMsg);
//        if (result == SQLITE_OK) {
//            NSLog(@"创表成功");
//            NSLog(@"沙盒路径:%@",NSHomeDirectory());
//            
//            
//        }else
//        {
//            NSLog(@"创建表失败");
//        }
//    }else
//    {
//        NSLog(@"打开数据库失败");
//    }
//
//    return db;
//    
//}
//
//+(void)closeDB
//{
//    sqlite3_close(db);
//    db = nil;
//    
//}




//
//+(NSArray * )SelectWithtabl    //:(NSString *)t_table Temp:(NSInteger)temp type:(NSInteger)type
//{
//     //打开数据库
//    sqlite3 *db = [DataBase openDB];
//    
//    //数据库操作指针 stmt:statement
//    sqlite3_stmt *stmt = nil;
//    
//    
//    const char *sql = "SELECT id,Temp,type ,Key,Text FROM Data_name WHERE ;";
//    
//    
//    int result = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
//    NSMutableArray *array = nil;
//    
//    if (result == SQLITE_OK) {
//        array = [NSMutableArray array];
//        while (sqlite3_step(stmt) == SQLITE_ROW) {
//            int Id = sqlite3_column_int(stmt, 0);
//            int temp = sqlite3_column_int(stmt,1);
//            int type = sqlite3_column_int(stmt, 2);
//            const unsigned char *Key = sqlite3_column_text(stmt, 3);
//            const unsigned char *text = sqlite3_column_text(stmt, 4);
//            NSLog(@"%d,%d,%s,%s",temp,type,Key,text);
//            
//         
//            NSLog(@"查询成功");
//        }
//    }
//    return array;
//    
//}
//
//
//
//
//
//
//+(BOOL)InsetWithTemp:(NSInteger)temp type:(NSInteger)type Key:(NSString *)key Text:(NSString *)text
//{
//    
//    sqlite3 *db = [DataBaseHelp openDB];
//    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (Temp,type,Key,Text) VALUES (%ld,%ld,'%@','%@');",T_table,(long)temp,(long)type,key,text];
//    sqlite3_stmt *stmt = nil;
//    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//        if (sqlite3_step(stmt) == SQLITE_DONE) {
//            sqlite3_finalize(stmt);
//            [DataBaseHelp closeDB];
//            NSLog(@"插入数据成功%ld %ld %@,%@",(long)temp,(long)type,key,text);
//            return YES;
//            
//        }
//        NSLog(@"插入数据库失败");
//        
//    }
//    sqlite3_finalize(stmt);
//    [DataBaseHelp closeDB];
//    return NO;
// 
//}
//
//
//
//
//+(BOOL)DeleteWithTemp:(NSInteger)temp //type:(NSInteger)type Key:(NSString *)key
//{
//    sqlite3 *db = [DataBaseHelp openDB];
//    sqlite3_stmt *stmt = nil;
//    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Data_name  WHERE Temp = %ld",(long)temp];
//    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//        if (sqlite3_step(stmt) == SQLITE_ROW) {
//            if (sqlite3_step(stmt) == SQLITE_DONE) {
//                sqlite3_finalize(stmt);
//                [DataBaseHelp closeDB];
//                NSLog(@"删除成功");
//                return YES;
//            }
//        }
//        
//    }sqlite3_finalize(stmt);
//    [DataBaseHelp closeDB];
//    NSLog(@"删除失败");
//    return NO;
//    
////}


+(void)CreatTable
{
    
    
    //打开数据库
    //取到沙盒
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"Name"];
    const char *CfileName = fileName.UTF8String;
    
    int result = sqlite3_open(CfileName, &db);
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_name (id integer PRIMARY KEY AUTOINCREMENT,stemp integer NOT NULL , type integer NOT NULL , key text NOT NULL , svalue text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(db, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
            NSLog(@"创表成功");
        }else
        {
            NSLog(@"创建表失败");
        }
    }else
    {
        NSLog(@"打开数据库失败");
    }
    


}

+(void)InsertIntoTemp:(int)temp Type:(int)type Key:(NSString *)key Values:(NSString *)values
{
  
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_name (stemp,type,key,svalue) VALUES (%d,%d,'%@','%@');",temp,type,key,values];
    char *erroMsg = NULL;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        printf("插入失败%s",erroMsg);
    }else
    {
        NSLog(@"插入成功");
    }

}


+(NSArray *)SelectTemp:(int)temp Type:(int)type
{
    
    NSMutableArray *mutArra = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT stemp,type,key,svalue FROM t_name WHERE stemp = %d and type = %d;",temp,type];
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
    
    if ( sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        NSLog(@"查询语句没问题");
        mutArra = [NSMutableArray array];
        
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_column_int(stmt, 1);
            int temp = sqlite3_column_int(stmt, 0);
            int type = sqlite3_column_int(stmt, 1);
            const unsigned char *key = sqlite3_column_text(stmt, 2);
            const unsigned char *svalue = sqlite3_column_text(stmt, 3);
            
            NSString *string = [NSString stringWithUTF8String:(const char *)key];
            NSString *obj = [NSString stringWithUTF8String:(const char *)svalue];
       
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:string];
            
            [[NSUserDefaults standardUserDefaults]setObject:obj forKey:string];
           
          
            printf("%d  %d %s %s\n",temp,type,key,svalue);
        }
    }else
    {
        NSLog(@"查询有问题");
    }
  
    return mutArra;
    
}

+(void)DeleteWithTemp:(int)temp type:(int)type Key:(NSString *)key
{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE stemp = %d and type = %d and key = '%@'",temp,type,key];
    
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                NSLog(@"删除成功");
            }
            NSLog(@"删除失败");
            
        }
    }
}


@end

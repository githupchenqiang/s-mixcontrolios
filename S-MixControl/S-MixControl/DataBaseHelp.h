//
//  DataBaseHelp.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/16.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <sqlite3.h>
@interface DataBaseHelp : NSObject



@property (nonatomic ,strong)NSMutableArray *sqArray;

//
//+(sqlite3 *)openDB;
//+(void)closeDB;
//
//+(NSArray *)SelectWithtable;    //:(NSString *)t_table Temp:(NSInteger)temp type:(NSInteger)type;
//
//+(BOOL)InsetWithTemp:(NSInteger)temp type:(NSInteger)type Key:(NSString *)key Text:(NSString *)text;
//
//+(BOOL)DeleteWithTemp:(NSInteger)temp; //type:(NSInteger)type Key:(NSString *)key;
//

+(void)CreatTable;

+(void)InsertIntoTemp:(int)temp Type:(int)type Key:(NSString *)key Values:(NSString *)values;


+(NSArray *)SelectTemp:(int)temp Type:(int)type;

+(void)DeleteWithTemp:(int)temp type:(int)type Key:(NSString *)key;




@end

//
//  SqliteData.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/14.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBase.h"

@interface SqliteData : NSObject
@property (nonatomic ,strong)NSMutableArray *Array;


+(void)Save:(DataBase *)Sence;


- (void)AddWithTable:(NSString *)t_table id:(NSInteger)ID type:(NSInteger)type Key:(NSString *)key Text:(NSString *)text;


- (NSArray *)SelectWithtable:(NSString *)t_table id:(NSInteger)ID type:(NSInteger)type Key:(NSString *)key Text:(NSString *)text;




@end

//
//  SignalViewController.h
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface SignalViewController : UIViewController

@property (nonatomic ,strong)NSString *ipstr;
@property (nonatomic ,strong)NSString *portstr;
@property (nonatomic ,strong)NSMutableArray *SendArray; //发送数据的数组
@property (nonatomic ,strong)NSMutableArray *mutArray; //类型的数组
@property (nonatomic ,assign)NSInteger sendInt; //中间传值变量
@property (nonatomic ,strong)NSMutableSet *MutSetArray; //中间传值数组
@property (nonatomic ,strong)NSArray *ValueArray; //发送数据的数组
@property (nonatomic ,strong)NSMutableArray *RemoveArray;
@property (nonatomic ,assign)sqlite3 *db;


-(void)SendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str;


@end

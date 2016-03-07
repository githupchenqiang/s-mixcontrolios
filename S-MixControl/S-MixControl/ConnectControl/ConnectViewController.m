//
//  ConnectViewController.m
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "ConnectViewController.h"
#import "LoginViewController.h"

//整个页面的尺寸宏
#define KscreenWidth self.view.frame.size.width
#define KscreenHeight  self.view.frame.size.height
@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0,61, KscreenWidth, KscreenHeight - 61);
    view.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1];
    [self.view addSubview:view];
    //产品类型
    UILabel *Ductlabel = [[UILabel alloc]init];
    Ductlabel.frame = CGRectMake(10, KscreenHeight/4, KscreenWidth/1.5, KscreenHeight/14);
    Ductlabel.text = @"产品名称：S-Mix系列控制管理平台";
    Ductlabel.textAlignment = NSTextAlignmentLeft;
    
    //版本号
    UILabel *version = [[UILabel alloc]init];
    version.frame = CGRectMake(10, CGRectGetMaxY(Ductlabel.frame)+10, KscreenWidth/1.5,  KscreenHeight/14);
    version.text = @"版本号：1.0.0.62";
    version.textAlignment = NSTextAlignmentLeft;
    
    //电话
    UILabel *Telephone = [[UILabel alloc]init];
    Telephone.frame = CGRectMake(10, CGRectGetMaxY(version.frame)+10,  KscreenWidth/1.5,  KscreenHeight/14);
    Telephone.textAlignment = NSTextAlignmentLeft;
    Telephone.text = @"电话：+86-01082275130";
    
    
    //邮件地址
    UILabel *Mail = [[UILabel alloc]init];
    Mail.frame = CGRectMake(10, CGRectGetMaxY(Telephone.frame)+10,  KscreenWidth/1.5, KscreenHeight/14);
    Mail.text = @"邮箱：info@kensence.com";
    Mail.textAlignment = NSTextAlignmentLeft;
    
    //主页
    UILabel *mainPage = [[UILabel alloc]init];
    mainPage.frame = CGRectMake(10, CGRectGetMaxY(Mail.frame)+10, KscreenWidth/1.5, KscreenHeight/14);
    mainPage.text = @"主页：www.kensence.com";
    mainPage.textAlignment = NSTextAlignmentLeft;
    
    
    //地址
    UILabel *Adress = [[UILabel alloc]init];
    Adress.frame = CGRectMake(10, CGRectGetMaxY(mainPage.frame)+10, KscreenWidth/1.5, KscreenHeight/14);
    Adress.text = @"地址：北京市朝阳区安定路39号长新大厦1201A室";
    Adress.textAlignment = NSTextAlignmentLeft;

    [self.view addSubview:Ductlabel];
    [self.view addSubview:version];
    [self.view addSubview:Telephone];
    [self.view addSubview:Mail];
    [self.view addSubview:mainPage];
    [self.view addSubview:Adress];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

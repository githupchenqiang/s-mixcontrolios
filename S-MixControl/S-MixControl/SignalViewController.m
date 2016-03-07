//
//  SignalViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "SignalViewController.h"
#define KScreenWith self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height
#import "ChangeViewController.h"




@interface SignalViewController ()<UIScrollViewDelegate>
@property (nonatomic ,strong)UIScrollView *Scroll;
@property (nonatomic ,strong)NSArray *SignalArray;

@end

@implementation SignalViewController

- (void)viewDidLoad {

    self.view.backgroundColor = [UIColor colorWithRed:91 green:171 blue:209 alpha:1];
    
    UILabel *InLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWith/7, 120,100, 40)];
    InLabel.text = @"输入(in)";
    InLabel.font = [UIFont systemFontOfSize:29];
    InLabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.6 blue:0.6 alpha:1];
    InLabel.layer.cornerRadius = 5;
    InLabel.layer.masksToBounds = YES;
    [self.view addSubview:InLabel];
    
    [self setUpView];
    
    
    UILabel *outLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWith/1.45, 120, 120, 40)];
    outLabel.text = @"输出(out)";
    outLabel.font = [UIFont systemFontOfSize:29];
    outLabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.6 blue:0.6 alpha:1];
    outLabel.layer.cornerRadius = 5;
    outLabel.layer.masksToBounds = YES;
    [self.view addSubview:outLabel];
    NSLog(@"%f",self.view.frame.size.width);
    
    
    _SignalArray  = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *InButton = [UIButton buttonWithType:UIButtonTypeSystem];
            InButton.frame = CGRectMake(20 + (120)*j, 170+ (90)*i,110, 70);
            [InButton setTitle:_SignalArray[3*i + j] forState:UIControlStateNormal];
            InButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            InButton.titleLabel.textColor = [UIColor blackColor];
            InButton.backgroundColor = [UIColor orangeColor];
            InButton.layer.masksToBounds = YES;
            [InButton setFont:[UIFont systemFontOfSize:27]];
            InButton.layer.cornerRadius = 10;
            [InButton addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            InButton.tag = 200 + i;
            [self.view addSubview:InButton];
        }
    }
    
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *OutButton = [UIButton buttonWithType:UIButtonTypeSystem];
            OutButton.frame = CGRectMake(600+ (120)*j, 170 + (90)*i, 110, 70);
            [OutButton setTitle:_SignalArray[3*i + j] forState:UIControlStateNormal];
            OutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            OutButton.titleLabel.textColor = [UIColor blackColor];
            OutButton.backgroundColor = [UIColor orangeColor];
            OutButton.layer.masksToBounds = YES;
            [OutButton setFont:[UIFont systemFontOfSize:27]];
            OutButton.layer.cornerRadius = 10;
            OutButton.tag = 300+i;
            [self.view addSubview:OutButton];
        }
    }
  
}


- (void)setUpView
{
    UIButton *Clear = [UIButton buttonWithType:UIButtonTypeSystem];
    Clear.frame = CGRectMake(KScreenWith/12, KScreenHeight/1.2, KScreenWith/12, 50);
    Clear.backgroundColor = [UIColor blueColor];
    [Clear setTitle:@"Clear" forState:UIControlStateNormal];
    [Clear setFont:[UIFont systemFontOfSize:26]];
    Clear.layer.cornerRadius = 5;
    Clear.layer.masksToBounds = YES;
    [self.view addSubview:Clear];
    
    
    UIButton *All = [UIButton buttonWithType:UIButtonTypeSystem];
    All.frame = CGRectMake(KScreenWith/1, KScreenHeight/1.2, KScreenWith/12, 50);
    All.backgroundColor = [UIColor blueColor];
    [All setTitle:@"Clear" forState:UIControlStateNormal];
    [All setFont:[UIFont systemFontOfSize:26]];
    All.layer.cornerRadius = 5;
    All.layer.masksToBounds = YES;
    [self.view addSubview:All];
  
}



- (void)ButtonAction:(UIButton *)button
{
    
    ChangeViewController *change = [[ChangeViewController alloc]init];
    
    [self presentViewController:change animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

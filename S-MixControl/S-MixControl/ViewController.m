//
//  ViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "ViewController.h"
#import "SignalViewController.h"
#import "ChangeViewController.h"
#import "ConseverViewController.h"
#import "ConnectViewController.h"
@interface ViewController ()
{
    SignalViewController *_Signal;
    ChangeViewController *_Change;
    ConseverViewController *_Consever;
    ConnectViewController *_Connect;
    
    
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegMent;

@end

@implementation ViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        ViewController *aView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Root"];
        self = aView;
    }
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置分段控制器名称
    [_SegMent setTitle:@"场景保存" forSegmentAtIndex:2];
    [_SegMent setTitle:@"关于我们" forSegmentAtIndex:3];
    
     // 根据内容调整视图的大小
    _SegMent.apportionsSegmentWidthsByContent = YES;
    
    // 设置点击事件
    [_SegMent addTarget:self action:@selector(ChangePage:) forControlEvents:UIControlEventValueChanged];
    
    // 初始化视图控制器；
    _Signal = [[SignalViewController alloc]init];
    _Change = [[ChangeViewController alloc]init];
    _Consever = [[ConseverViewController alloc]init];
    _Connect = [[ConnectViewController alloc]init];
    
      //将视图添加上来
    [self.view addSubview:_Signal.view];
    [self.view addSubview:_Change.view];
    [self.view addSubview:_Consever.view];
    [self.view addSubview:_Connect.view];
 
    // 延长视图的生命周期
    [self addChildViewController:_Signal];
    [self addChildViewController:_Change];
    [self addChildViewController:_Consever];
    [self addChildViewController:_Connect];
    
    // 设置默认选中
    _SegMent.selectedSegmentIndex = 0;

    //将视图添加上来
    [self.view addSubview:_SegMent];
  
}

- (void)ChangePage:(UISegmentedControl *)seg
{
        //添加视图Signal
    if (_SegMent.selectedSegmentIndex == 0) {
        [_Change.view removeFromSuperview];
        [_Consever.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Signal.view atIndex:0];
        
        // 添加视图Change
    }else if (_SegMent.selectedSegmentIndex == 1){
        [_Signal.view removeFromSuperview];
        [_Consever.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Change.view atIndex:0];
        
        //添加视图Consever
    }else if (_SegMent.selectedSegmentIndex == 2){
        [_Signal.view removeFromSuperview];
        [_Change.view removeFromSuperview];
        [_Connect.view removeFromSuperview];
        [self.view insertSubview:_Consever.view atIndex:0];
        
        //添加视图Connect
    }else if (_SegMent.selectedSegmentIndex == 3){
        [_Signal.view removeFromSuperview];
        [_Consever.view removeFromSuperview];
        [_Change.view removeFromSuperview];
        [self.view insertSubview:_Connect.view atIndex:0];
    }
  
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

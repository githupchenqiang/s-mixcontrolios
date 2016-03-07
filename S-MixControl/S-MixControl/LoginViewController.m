//
//  LoginViewController.m
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "SignalViewController.h"
#import "SignalValue.h"
#import "GCDAsyncUdpSocket.h"
#import "ConnectPort.h"
#import "SockerSever.h"
#import "ConseverViewController.h"
#import "ProConnect.h"
#define KscreenWidth self.view.frame.size.width
#define KscreenHeight  self.view.frame.size.height
#define BackKscreenWith _BackView.frame.size.width
#define BackKscreenHeight _BackView.frame.size.height



@interface LoginViewController ()<GCDAsyncUdpSocketDelegate,UITextFieldDelegate>
{
    NSUserDefaults *_userDefault;
    NSUserDefaults *_default;
    GCDAsyncUdpSocket *_udpSocket;
    NSUserDefaults *_getDefault;
    NSUserDefaults *_SDefaults;
    
}
@property (nonatomic ,strong)UITextField *text4ip;
@property (nonatomic ,strong)UITextField *text4port;
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,assign)int count;
@property (nonatomic ,assign)NSInteger dispath;
@property (nonatomic ,strong)UIButton *SButton;
@property (nonatomic ,strong)UIButton *Pbutton;
@property (nonatomic ,strong)UIView  *BackView;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _userDefault = [NSUserDefaults standardUserDefaults];
    _text4ip.text = [_userDefault objectForKey:@"IPAdress"];
    _text4port.text = [_userDefault objectForKey:@"PortValues"];
    
    _default = [NSUserDefaults standardUserDefaults];
    
      NSString *string = [_default objectForKey:@"select"];
    NSInteger inte = string.integerValue;
    
    if (inte == 2) {
        UIImage *image1 = [UIImage imageNamed:@"复选框-选中"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = (UIButton *)[self.view viewWithTag:2999];
        [button setImage:image1 forState:UIControlStateNormal];
        [SignalValue ShareValue].ProCount = 2;
        
      
    }else if (inte == 1){
        UIImage *image1 = [UIImage imageNamed:@"复选框-选中"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = (UIButton *)[self.view viewWithTag:2998];
        [button setImage:image1 forState:UIControlStateNormal];
        [SignalValue ShareValue].ProCount = 1;
        
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dispath = 0;
    
    
    UIImage *img = [UIImage imageNamed:@"bk"];
    
    UIImageView *imagevi = [[UIImageView alloc]init];
    imagevi.frame = CGRectMake(KscreenWidth/4, KscreenHeight/8, KscreenWidth/2, KscreenHeight/7);
//    imagevi.backgroundColor = [UIColor orangeColor];
    imagevi.image = img;
    [self.view addSubview:imagevi];
    
    self.view.backgroundColor = [UIColor colorWithRed:43/255.0 green:161/255.0 blue:250/255.0 alpha:1];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0,KscreenHeight, KscreenWidth, -KscreenHeight/4);
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
    
    
    UIImage *ima = [UIImage imageNamed:@"login_bg"];
    UIImageView *imgeview = [[UIImageView alloc]init];
    imgeview.frame = CGRectMake(0, CGRectGetMinY(imageView.frame) - KscreenHeight/9, KscreenWidth, KscreenHeight/9);
    imgeview.image = ima;
    [self.view addSubview:imgeview];
    
    _BackView = [[UIView alloc]init];
    _BackView.frame = CGRectMake(KscreenWidth/3.2,  KscreenHeight/3.6, KscreenWidth/2.7, KscreenHeight/2);
    _BackView.backgroundColor = [UIColor whiteColor];
    _BackView.layer.shadowColor = [UIColor grayColor].CGColor;//阴影的颜色
    _BackView.layer.shadowOpacity = 2.6f; // 阴影透明度
    _BackView.layer.shadowOffset = CGSizeMake(0.0, 3.0f); // 阴影的范围
    _BackView.layer.shadowRadius = 3.0;// 阴影扩散的范围控制
    [self.view addSubview:_BackView];
    

     //添加导航控制器
//    UINavigationController *Nav = [[UINavigationController alloc]init];
//    Nav.navigationItem.title = @"登录";
//    [_BackView addSubview:Nav.view];
//  
        //创建输入框
    _text4ip  = [[UITextField alloc]initWithFrame:CGRectMake(10, 30
                                                             , BackKscreenWith-20,52)];
    _text4ip.layer.masksToBounds = YES;
    _text4ip.delegate = self;
    _text4ip.placeholder = @"请输入ip地址";

        //设置字体对其方式
    _text4ip.textAlignment = NSTextAlignmentNatural;
    _text4ip.borderStyle = UITextBorderStyleRoundedRect;
    
    //做标记以便取得输入的值
    _text4ip.tag = 11232;
    _text4port = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_text4ip.frame)+20, BackKscreenWith - 20,52)];
    _text4port.placeholder = @"请输入端口号";
  
    _text4port.textAlignment = NSTextAlignmentNatural;
    _text4port.borderStyle = UITextBorderStyleRoundedRect;
    _text4port.tag = 11231;
    _text4port.delegate = self;
    
    [_BackView addSubview:_text4ip];
    [_BackView addSubview:_text4port];
    
    
    //Pro的选择类型按钮
    _SButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _SButton.frame = CGRectMake(0, CGRectGetMaxY(_text4port.frame)+20,BackKscreenWith/2, 52);
    [_SButton setTitle:@"S-mixPro" forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"复选框-未选中"];
    image = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SButton setImage:image forState:UIControlStateNormal];
//    [_SButton setSelected:YES];
   
    _SButton.imageEdgeInsets =UIEdgeInsetsMake(5,-5,0,0);
    _SButton.titleEdgeInsets = UIEdgeInsetsMake(5,0, 0, 0);
    
//    _SButton.backgroundColor = [UIColor orangeColor];
//    _SButton.layer.borderWidth = 1;
//    _SButton.layer.borderColor = [UIColor blackColor].CGColor;
    
    _SButton.layer.cornerRadius = 7;
    _SButton.layer.masksToBounds = YES;
    _SButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _SButton.tag = 2999;
    [_SButton addTarget:self action:@selector(ProButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_SButton];
  
    //s-Mix的类型选择按钮
    _Pbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _Pbutton.frame = CGRectMake(CGRectGetMaxX(_SButton.frame), CGRectGetMaxY(_text4port.frame)+20, BackKscreenWith/2, 52);
    _Pbutton.layer.cornerRadius =  7;
    _Pbutton.layer.masksToBounds = YES;
    [_Pbutton setTitle:@"S-mix" forState:UIControlStateNormal];
    UIImage *Pimage = [UIImage imageNamed:@"复选框-未选中"];
    Pimage = [Pimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Pbutton setImage:Pimage forState:UIControlStateNormal];
    _Pbutton.imageEdgeInsets = UIEdgeInsetsMake(5, -30, 0, 0);
    _Pbutton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
//    _Pbutton.layer.borderWidth = 1;
    _Pbutton.titleLabel.font = [UIFont systemFontOfSize:20];
    _Pbutton.tag = 2998;
//    _Pbutton.layer.borderColor = [UIColor blackColor].CGColor;
    [_Pbutton addTarget:self action:@selector(SbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_BackView addSubview:_Pbutton];
    
  
    
    //创建登陆的点击按钮
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(12,CGRectGetMaxY(_SButton.frame) + 20,BackKscreenWith - 24, 52);
    [_button setTitle:@"登录" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(SendText:) forControlEvents:UIControlEventTouchUpInside];
    _button.backgroundColor = [UIColor orangeColor];
    _button.layer.cornerRadius = 7;
    _button.layer.masksToBounds = YES;
    _button.titleLabel.font = [UIFont systemFontOfSize:23];
    [_BackView addSubview:_button];
    [self SetupUdp];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _BackView.frame = CGRectMake(_BackView.frame.origin.x, _BackView.frame.origin.y - 80, _BackView.frame.size.width, _BackView.frame.size.height);
    

}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _BackView.frame = CGRectMake(_BackView.frame.origin.x, _BackView.frame.origin.y + 80, _BackView.frame.size.width, _BackView.frame.size.height);
    

}


//选择类型转换背景图片
- (void)ProButtonAction:(UIButton *)sender
{
    
    if (sender.selected == NO) {
     
        UIImage *image1 = [UIImage imageNamed:@"复选框-未选中"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = (UIButton *)[self.view viewWithTag:2998];
        [button setImage:image1 forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"复选框-选中"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_SButton setImage:image forState:UIControlStateNormal];
       _default = [NSUserDefaults standardUserDefaults];
        [_default removeObjectForKey:@"select"];
    
        [SignalValue ShareValue].ProCount = 2;
        NSString *str = [NSString stringWithFormat:@"%d",2];
        [_default setObject:str forKey:@"select"];

        
    }else
    {
        UIImage *pimage = [UIImage imageNamed:@"复选框-未选中"];
        pimage = [pimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_SButton setImage:pimage forState:UIControlStateNormal];
        [_default removeObjectForKey:@"select"];
        [SignalValue ShareValue].ProCount = 0;
        
        
        
    }
}

- (void)SbuttonAction:(UIButton *)sender
{
   
    if ( sender.selected == NO) {
        UIImage *image1 = [UIImage imageNamed:@"复选框-未选中"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIButton *button = (UIButton *)[self.view viewWithTag:2999];
        [button setImage:image1 forState:UIControlStateNormal];
        
        
        _default = [NSUserDefaults standardUserDefaults];
        [_default removeObjectForKey:@"select"];
        
        UIImage *image = [UIImage imageNamed:@"复选框-选中"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_Pbutton setImage:image forState:UIControlStateNormal];
        _SDefaults = [NSUserDefaults standardUserDefaults];
        [_SDefaults setBool:sender.selected forKey:@"select"];
        [SignalValue ShareValue].ProCount = 1;
        NSString *strin =[NSString stringWithFormat:@"%d",1];
        [_default setObject:strin forKey:@"select"];
        
        
        
        UITextField *textField = (UITextField *)[self.view viewWithTag:11232];
        UITextField *portText = (UITextField *)[self.view viewWithTag:11231];
        [SignalValue ShareValue].SignalIpStr = textField.text;
        NSString *str = portText.text;
        unsigned short utfString = [str integerValue];
        [SignalValue ShareValue].SignalPort =utfString;

        
        
    }else
    {
        
        UIImage *image = [UIImage imageNamed:@"复选框-未选中"];
      
        [_Pbutton setImage:image forState:UIControlStateNormal];
        _SDefaults = [NSUserDefaults standardUserDefaults];
        [_SDefaults removeObjectForKey:@"select"];
        [SignalValue ShareValue].ProCount = 0;
        sender.selected = NO;
        
    }
}

  //正则判断
- (BOOL)isValidateIP:(NSString *)IP
{
    NSString *ipRegex = @"(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)";
    NSPredicate *iptext = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ipRegex];
    return [iptext evaluateWithObject:IP];

}
#pragma mark ===登陆的点击事件====
- (void)SendText:(UIButton *)button

{      [self.view endEditing:YES];
      [[SignalValue ShareValue].GetMessage removeAllObjects];
    
     //获取输入的值
    UITextField *textField = (UITextField *)[self.view viewWithTag:11232];
    UITextField *portText = (UITextField *)[self.view viewWithTag:11231];
    
        //判断端口和IP格式是否正确
    if ([self isValidateIP:textField.text]&& portText.text.length == 4) {
      
        [SignalValue ShareValue].SignalIpStr = textField.text;
        NSString *str = portText.text;
        unsigned short utfString = [str integerValue];
        [SignalValue ShareValue].SignalPort =utfString;
        //将用户输入保存到本地方便登陆
        
#pragma mark ===打印场景发送数据
        if ([SignalValue ShareValue].ProCount == 2) {
           
            unsigned char buf[256] = {0};
            unsigned char num = 0;
            NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
            NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
            
            [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
            [_udpSocket receiveOnce:nil];
       
        }else if ([SignalValue ShareValue].ProCount == 1){
          
            kice_t kic = scene_print_cmd(0x00);
            NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
            
           
            
            [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
            [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
            [_udpSocket receiveOnce:nil];
        }
        
        //将用户保存在本地
        _userDefault = [NSUserDefaults standardUserDefaults];
        [_userDefault setObject:_text4ip.text forKey:@"IPAdress"];
        [_userDefault setObject:_text4port.text forKey:@"PortValues"];
        

    }else
    {
            //提示框
       UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"输入有误" message:@"连接失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:Action];
        [alert addAction:twoAc];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

#pragma mark ===初始化socket====
- (void)SetupUdp
{
    //初始化对象，使用全局队列
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    [_udpSocket receiveOnce:nil];
}
//发送数据成功
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 544) {
        NSLog(@"标记为544的数据发送完成");
    }
}
//发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    
     NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
    
}
//接收数据完成
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
   
    const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
     const  unsigned char *resultBuff = [data bytes];
   
    if (resultBuff[0] == 0x55 && resultBuff[1] == 0x55 && resultBuff[7] == 0x04 && resultBuff[8] == 0x02) {
        unsigned short count = 0;
        memcpy(&count, &resultBuff[9], 2);
        count = EXCHANGE16BIT(count);
        [SignalValue ShareValue].Integer = count-1;
        
        unsigned char Probuf[512] = {0};
        for (unsigned int i = 0; i < count -1; i++) {
            
            Probuf[i] = resultBuff[12+i];
            NSInteger proValu = (NSInteger)Probuf[i];
            NSNumber *number = [NSNumber numberWithInteger:proValu];
            [[SignalValue ShareValue].GetMessage addObject:number];
        }
      
    }else if (cmd == 0x27)
    {
        sw_state_t *sw = (sw_state_t *)(&((kice_t *)a)->data[3]);
        _count = (unsigned int)(sw->input);
        [SignalValue ShareValue].Integer = _count;
        
        unsigned int buf[512] ={0};
        for(int i = 0; i < _count; i++)
        {
            buf[i] = (unsigned char)sw->group[_count + i];
            NSInteger value = (NSInteger)buf[i];
            NSNumber *number = [NSNumber numberWithInteger:value];
            [[SignalValue ShareValue].GetMessage addObject:number];
           
        }

    }

    _dispath++;
    if (_dispath == 1 && [SignalValue ShareValue].GetMessage!=nil) {
        //视图跳转
        ViewController *root = [ViewController new];
        [self presentViewController:root animated:YES completion:nil];
    }
//
        [sock receiveOnce:nil];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[SockerSever SharedSocket]SendBackToHost:ip port:port withMessage:str];
    });
    }


-(void)SendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str
{
    NSString *Msg = @"我在发送消息";
    NSData *data = [Msg dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:545];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
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

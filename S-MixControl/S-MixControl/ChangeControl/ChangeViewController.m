//
//  ChangeViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//
#import "ChangeViewController.h"
#import "SignalViewController.h"
#import "ConnectPort.h"
#import "SignalValue.h"
#import "GCDAsyncUdpSocket.h"
#import "ConnectPort.h"
#import "SubsenceViewController.h"
#import "ProConnect.h"
#import "DataBaseHelp.h"
#define KScreenWith self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height

#define BackScrollerHight self.BackScroller.frame.size.height
#define BackSrollerWith   self.BackScroller.frame.size.width

@interface ChangeViewController ()<GCDAsyncUdpSocketDelegate,UITextFieldDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
    SubsenceViewController *_Subsecene;
}
@property (nonatomic ,strong)UIButton *Button; //场景按钮
@property (nonatomic ,strong)NSArray*Array; //记录输出端口号的数组
@property (nonatomic ,strong)UIScrollView *Scroller; //显示输出的滚动视图
@property (nonatomic ,strong)UILabel *Outlabel; //输出label
@property (nonatomic ,strong)UIScrollView *BackScroller; //最下面的滚动视图
@property (nonatomic ,strong)UIButton *LoadButton; //场景加载按钮
@property (nonatomic ,strong)NSMutableArray *MutArray; //记录tag值
@property (nonatomic ,assign)NSInteger buttonValue; //记录当前点击的按钮
@property (nonatomic ,strong)NSMutableArray *labelArrat; //记录返回的数据
@property (nonatomic ,assign)int countValue;
@property (nonatomic ,strong)NSMutableArray *seceneArray; // 记录场景
@property (nonatomic ,assign)NSInteger Count;//定义全局变量用于block遍历数组
@property (nonatomic ,strong)NSMutableSet *GetSet; //记录返回数据的数组
@property (nonatomic ,strong)NSMutableArray *datArray;
@property (nonatomic , strong)NSString *Astring;
@property (nonatomic ,strong)NSString *Dstring;
@property (nonatomic ,strong)NSString *signalString;
@property (nonatomic ,strong)NSString *NSStringVal;
@property (nonatomic ,strong)UIScrollView *OutScroller;
@property (nonatomic ,strong)UITextField *Intextfild;

@end

@implementation ChangeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    unsigned char integertag = [SignalValue ShareValue].Integer/9;
    unsigned char tage = (char)[SignalValue ShareValue].ProCount;
    [DataBaseHelp CreatTable];
    [DataBaseHelp SelectTemp:integertag Type:tage];
    
    for (int i = 0; i < [SignalValue ShareValue].Integer ; i++) {
        UILabel *label = (UILabel *)[self.view viewWithTag:5000+i];
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        NSString *Key = [NSString stringWithFormat:@"%ld",(long)(i+300+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)];
        NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:Key];
         UIScrollView *scroller = (UIScrollView *)[self.view viewWithTag:500+i];
        [scroller setContentOffset:CGPointMake(0, 0)];
        
        if (value != nil) {
            
            label.text = value;

        }else
        {
            label.text = str;
            
        }
        
        UILabel *labeltext = [self.view viewWithTag:3000+i];
        
        labeltext.text = @"";
        
    }
    if ([SignalValue ShareValue].ProCount == 1) {
        
        kice_t kic = scene_print_cmd(0x00);
        NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
     //  [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
    }else if ([SignalValue ShareValue].ProCount == 2)
    {
        
        unsigned char buf[256] = {0};
        unsigned char num = 0;
        NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
        
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //  [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
  
    }


    UIButton *button = (UIButton *)[self.view viewWithTag:200];
    button.backgroundColor = [UIColor orangeColor];
    
    
    if ([SignalValue ShareValue].ProCount == 2) {
        [DataBaseHelp CreatTable];
        [DataBaseHelp SelectTemp:integertag Type:tage];
        
        for (int i = 0; i < 12; i++) {
            NSInteger integer = 200+i;
            NSString *string = [NSString stringWithFormat:@"%ld",(long)integer];
            UIButton *button = (UIButton *)[self.view viewWithTag:integer];
            NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:string];
            
            if (value != nil) {
                [button setTitle:value forState:UIControlStateNormal];
                
            }
            
            
        }
        
    }

    
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    UIButton *button = [self.view viewWithTag:200+_buttonValue];
    button.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        
        UILabel *label = [self.view viewWithTag:3000+i];
        
        label.text = @"";
        
    }

}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if ([SignalValue ShareValue].ProCount == 1) {
        kice_t kic = scene_print_cmd(0x00);
        NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
    }else if ([SignalValue ShareValue].ProCount == 2)
    {
        unsigned char buf[256] = {0};
        unsigned char num = 0;
        NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
        
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
   [self SetUpScroller];
    [self SetUpLabel];
    _NSStringVal = @"";
    self.Count = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _labelArrat = [NSMutableArray array];
    _seceneArray = [NSMutableArray array];
    _datArray = [NSMutableArray array];
    //将视图添加上来
    
    [self setUpButton];
    
    
    [self SetUpLoadButton];
    [self setUpsocket];
    
    _MutArray = [NSMutableArray array];
    for (int i = 0; i < 12; i++) {
        NSInteger Value = 200+i;
        NSNumber *number = [NSNumber numberWithInteger:Value];
        [_MutArray addObject:number];
    }
}

- (void)SetUpLabel
{
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        for (int j = 0; j < 1; j++) {
            UILabel *Inlabel = [[UILabel alloc]initWithFrame:CGRectMake(BackSrollerWith/100*j,BackScrollerHight/17+ BackScrollerHight/9.5*i,BackSrollerWith/7,BackScrollerHight/13)];
            Inlabel.backgroundColor = [UIColor whiteColor];
            Inlabel.layer.masksToBounds = YES;
            Inlabel.layer.cornerRadius = 5;
            Inlabel.tag = 5000+i;
            Inlabel.layer.borderColor = [UIColor blackColor].CGColor;
            Inlabel.layer.borderWidth = 0.50f;
            Inlabel.font = [UIFont systemFontOfSize:19];
            Inlabel.textAlignment = NSTextAlignmentCenter;
            _OutScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Inlabel.frame) * j +120, KScreenHeight/16 + KScreenHeight/10.6*i,KScreenWith/2,40)];
            
            _OutScroller.contentSize = CGSizeMake(BackSrollerWith*[SignalValue ShareValue].Integer/7.2, 40);
            _OutScroller.layer.borderColor = [UIColor blackColor].CGColor;
            _OutScroller.layer.borderWidth = 0.50f;
            _OutScroller.layer.masksToBounds = YES;
            _OutScroller.layer.cornerRadius = 3;
            _OutScroller.showsVerticalScrollIndicator = YES;
            _OutScroller.scrollEnabled = YES;
            _OutScroller.tag = 500+i;
            [_BackScroller addSubview:_OutScroller];
            [_BackScroller addSubview:Inlabel];
        }
    }
    int count = 0;
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(-0, 5, BackScrollerHight*[SignalValue ShareValue].Integer/5, 30);
        count++;
        label.tag = 3000+i;
        UIScrollView *scroller = [self.view viewWithTag:500+i];

        [scroller addSubview:label];
    }
 
}

- (void)SetUpScroller
{
    _BackScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(KScreenWith/100, KScreenHeight/10, KScreenWith/1.5,KScreenHeight -  KScreenHeight/10 - 5)];
    _BackScroller.contentSize = CGSizeMake(BackSrollerWith,BackScrollerHight*[SignalValue ShareValue].Integer/9);
    _BackScroller.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_BackScroller];
}

- (void)setUpButton
{
         //场景;
    for (int i = 0; i < 6; i++) {
        for (int j = 0; j < 2; j++) {
            _Button = [UIButton buttonWithType:UIButtonTypeSystem];
            _Button.frame = CGRectMake(KScreenWith/1.3 + (KScreenWith/8) * j, KScreenWith/7+(KScreenHeight/9)*i, KScreenWith/11, KScreenHeight/12);
            _Button.tag = 200+(2)*i+j;
            _Button.layer.borderColor = [UIColor blackColor].CGColor;
            _Button.layer.borderWidth = 0.5f;
            NSString * string = [NSString stringWithFormat:@"场景%d",2*i+j];
            [_Button setTitle:string forState:UIControlStateNormal];
            _Button.layer.masksToBounds = YES;
            _Button.layer.cornerRadius = 7;
            [_Button addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchDown];
            if ([SignalValue ShareValue].ProCount == 2) {
                UILongPressGestureRecognizer *LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(ChangeSencePress:)];
                
                [_Button addGestureRecognizer:LongPress];
                LongPress.minimumPressDuration = 0.5;
            }
            
            
            
            [self.view addSubview:_Button];
            
        }
    }
}

- (void)ChangeSencePress:(UILongPressGestureRecognizer *)LongPress
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入场景名称" message:@"输入" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.backgroundColor = [UIColor orangeColor];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        
    }];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIButton *button = [self.view viewWithTag:_buttonValue+200];
        button.backgroundColor = [UIColor whiteColor];
        button.selected = NO;
        
    }];
    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        _Intextfild = (UITextField *)alert.textFields.firstObject;
        
        UIButton *button = [self.view viewWithTag:_buttonValue+200];
        
        NSString *string = [NSString stringWithFormat:@"%ld",(long)_buttonValue+200];
        
        NSString *ConseverString = [NSString stringWithFormat:@"%ld",(long)_buttonValue+700];
        
        
        if (_Intextfild.text.length <= 0) {
            
            NSString *title = [NSString stringWithFormat:@"场景%ld",(long)_buttonValue];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.backgroundColor = [UIColor whiteColor];
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:title];
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:ConseverString];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:ConseverString Values:title];
            
            
        }else if (_Intextfild.text.length >= 5){
            
            NSString *str = [_Intextfild.text substringToIndex:5];
            [button setTitle:str forState:UIControlStateNormal];
            
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:str];
     
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:ConseverString];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:ConseverString Values:str];
            
            
        }else if (_Intextfild.text.length < 5 &&_Intextfild.text.length > 0)
        {
            [button setTitle:_Intextfild.text forState:UIControlStateNormal];
            
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:_Intextfild.text];
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:ConseverString];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:ConseverString Values:_Intextfild.text];
            
        }
        
        
    }];
    
    [alert addAction:Action];
    [alert addAction:twoAc];
    [self presentViewController:alert animated:YES completion:nil];
    

}



//切换场景的按钮点击事件
- (void)SendMessage:(UIButton *)Sender
{
    
    __weak typeof(self) weakSelf = self;
    [_seceneArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // weakSelf.Count++;
        NSNumber *number = obj;
        NSInteger integer = number.integerValue;
        UILabel *label = (UILabel *)[self.view viewWithTag:((integer - 1)*[SignalValue ShareValue].Integer+3000)+idx];
        label.text = @" ";
        
    }];
    weakSelf.Count = 0;
    [_seceneArray removeAllObjects];
    for (int i=0; i< _MutArray.count; i++) {
        UIButton *button = [self.view viewWithTag:[(NSString*)_MutArray[i] integerValue]];
        if (Sender.tag == button.tag) {
            button.backgroundColor = [UIColor orangeColor];
            _buttonValue = (NSInteger)(Sender.tag - 200); 
            NSLog(@"adddd%ld",(long)_buttonValue);
#pragma mark ===打印场景发送数据
            if ([SignalValue ShareValue].ProCount == 1) {
                unsigned char cmdNum = _buttonValue;
                kice_t kic = scene_print_cmd(cmdNum);
                NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
                [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:70 tag:666];
                
                [_udpSocket receiveOnce:nil];
            }else if ([SignalValue ShareValue].ProCount == 2)
            {
                unsigned char buf[256] = {0};
                unsigned char num = _buttonValue;
                NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
                NSData *data2 = [NSData dataWithBytes:(void *)&buf  length:length];
                
                [_udpSocket sendData:data2 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
                [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
                [_udpSocket receiveOnce:nil];
            }
           
        }
        else
        {
            button.backgroundColor = [UIColor whiteColor];
        }
    }
}

//场景切换
- (void)SetUpLoadButton
{
    _LoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _LoadButton.frame = CGRectMake(KScreenWith/1.45 + KScreenWith/7, KScreenWith/4.3+(KScreenHeight/9)*5, KScreenWith/11, KScreenHeight/12);
    _LoadButton.backgroundColor = [UIColor whiteColor];
    _LoadButton.layer.borderColor = [UIColor blackColor].CGColor;
    _LoadButton.layer.borderWidth = 0.5;
    [_LoadButton setTitle:@"Load" forState:UIControlStateNormal];
    [_LoadButton addTarget:self action:@selector(loadAction:) forControlEvents:UIControlEventTouchDown];
    _LoadButton.layer.cornerRadius = 7;
    _LoadButton.layer.masksToBounds = YES;
    [self.view addSubview:_LoadButton];
}

#pragma mark === 点击按钮发送数据====
- (void)loadAction:(UIButton *)send
{
    NSString *host = [SignalValue ShareValue].SignalIpStr;
    uint16_t port = [SignalValue ShareValue].SignalPort;
    if ([SignalValue ShareValue].ProCount == 1) {
        unsigned char LoadValue = _buttonValue;
        kice_t kic = scene_load_cmd(LoadValue);
        NSData *dataLoad = [NSData dataWithBytes:(void *)&kic length:kic.size];
        [_udpSocket sendData:dataLoad toHost:host port:port withTimeout:60 tag:343];
        
        //  加载场景完成后打印当前场景的链接
        kice_t kicget = scene_print_cmd(LoadValue);
        NSData *data1 = [NSData dataWithBytes:(void *)&kicget  length:kicget.size];
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
        
        kice_t kic1 = scene_print_cmd(0x00);
        NSData *data12 = [NSData dataWithBytes:(void *)&kic1  length:kic1.size];
        [_udpSocket sendData:data12 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        // [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
        
    }else if ([SignalValue ShareValue].ProCount == 2)
    {
        unsigned char load = _buttonValue;
        unsigned char buf[256] = {0};
        NSInteger length = make_pack_5555(METHOD_SET, CMD_SENCE_SWITCH_ID_LOAD, 1, &load, buf);
        NSData *data = [NSData dataWithBytes:(void *)&buf length:length];
        [_udpSocket sendData:data toHost:host port:port withTimeout:60 tag:343];
        
        unsigned char buf1[256] = {0};
        unsigned char num = 0;
        NSInteger length1 = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, _buttonValue, &num, buf);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf1  length:length1];
    
        [_udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
        
        unsigned char buf2[256] = {0};
        unsigned char num1 = 0;
        NSInteger length2 = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, _buttonValue, &num1, buf);
        NSData *data2 = [NSData dataWithBytes:(void *)&buf2  length:length2];
        
        [_udpSocket sendData:data2 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [_udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [_udpSocket receiveOnce:nil];
      
    }
    
   
 

}
#pragma mark ===创建socket=====
- (void)setUpsocket
{
    //初始化对象，使用全局队列
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalIpStr error:nil];
    
    [_udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    //接收一次消息
    [_udpSocket receiveOnce:nil];
}
#pragma mark === udpSocket执行的代理方法=======
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 666) {
        NSLog(@"发送数据完成");
    }
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
        NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag, error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        
        UILabel *label = [self.view viewWithTag:3000+i];
        
        label.text = @"";
        
    }

    [[SignalValue ShareValue].GetMessage removeAllObjects];
    [SignalValue ShareValue].GetMessage = NULL;
    [_seceneArray removeAllObjects];
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
    const  unsigned char *resultBuff = [data bytes];
    if(cmd == 0x27)
    {
        sw_state_t *sw = (sw_state_t *)(&((kice_t *)a)->data[3]);
        _countValue = (unsigned int)(sw->input);
        [SignalValue ShareValue].Integer = _countValue;
        unsigned int buf[512] ={0};
        for(int i = 0; i < _countValue; i++)
        {
            buf[i] = (unsigned char)sw->group[_countValue + i];
            NSInteger value = (NSInteger)buf[i];
            NSNumber *number = [NSNumber numberWithInteger:value];
            [[SignalValue ShareValue].secene addObject:number];
             [_seceneArray addObject:number];
            [[SignalValue ShareValue].GetMessage addObject:number];
            
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
                
                UILabel *label = [self.view viewWithTag:3000+i];
                
                label.text = @" ";
                
            }
            NSString *str = @"";
           // _Astring  = [SignalValue ShareValue].GetMessage[0];
            for (int i = 0; i <[SignalValue ShareValue].GetMessage.count; i++) {
                NSNumber *number = [SignalValue ShareValue].GetMessage[i];
                NSInteger integer = number.integerValue;
                UILabel *text = [self.view viewWithTag:3000 + integer - 1];
                NSString *string = [NSString stringWithFormat:@"%d",i +1];
                NSString *strVale = [NSString stringWithFormat:@"%ld",(long)(i+599+1+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)];
                NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                if (value == nil) {
                    NSString *stringwe = text.text;
                    str = [NSString stringWithFormat:@"%@ %@,",stringwe ,string];
                    text.text = str;
                }else
                {
                    NSString *textString = text.text;
                    NSString *stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                    str = [NSString stringWithFormat:@"%@ %@,",textString,stringValue];
                    text.text = str;
                }
            }
        });
      
        
    }else if (resultBuff[0] == 0x55 && resultBuff[1] == 0x55 && resultBuff[7] == 0x04 && resultBuff[8] == 0x02) {
        unsigned short count = 0;
        memcpy(&count, &resultBuff[9], 2);
        count = EXCHANGE16BIT(count);
        [SignalValue ShareValue].Integer = count-1;
        
        unsigned char Probuf[512] = {0};
        for (unsigned int i = 0; i < count -1; i++) {
            
            Probuf[i] = resultBuff[12+i];
            NSInteger proValu = (NSInteger)Probuf[i];
            NSNumber *number = [NSNumber numberWithInteger:proValu];
            [[SignalValue ShareValue].secene addObject:number];
            [_seceneArray addObject:number];
            [[SignalValue ShareValue].GetMessage addObject:number];
            
        }
  
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
                
                UILabel *label = [self.view viewWithTag:3000+i];
                
                label.text = @" ";
            }
            NSString *str = @"";
            // _Astring  = [SignalValue ShareValue].GetMessage[0];
            for (int i = 0; i <[SignalValue ShareValue].GetMessage.count; i++) {
                NSNumber *number = [SignalValue ShareValue].GetMessage[i];
                NSInteger integer = number.integerValue;
                UILabel *text = [self.view viewWithTag:3000 + integer - 1];
                NSString *string = [NSString stringWithFormat:@"%d",i +1];
                NSString *strVale = [NSString stringWithFormat:@"%ld",(long)(i+599+1+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)];
                NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                if (value == nil) {
                    NSString *stringwe = text.text;
                    str = [NSString stringWithFormat:@"%@ %@,",stringwe ,string];
                    text.text = str;
                }else
                {
                    NSString *textString = text.text;
                    NSString *stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:strVale];
                    str = [NSString stringWithFormat:@"%@ %@,",textString,stringValue];
                    text.text = str;
                }
                
                
            }
            
        });


    }
    [sock receiveOnce:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendBackTohost:ip port:port wiwthMessage:s];
      
    });
   
}

- (void)sendBackTohost:(NSString *)ip port:(uint16_t)port wiwthMessage:(NSString *)str
{
    NSString *Msg = @"我在发送消息";
    NSData *data = [Msg dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:344];
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

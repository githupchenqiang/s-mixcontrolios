//
//  SignalViewController.m
//  S-MixControl
//
//  Created by aa on 15/11/27.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
#import "SignalViewController.h"
#import "ChangeViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "ConnectPort.h"
#import "SockerSever.h"
#import "ProConnect.h"

#import "DataBaseHelp.h"
#import "ProSetView.h"
#import "ProInSet.h"


#define NMUBERS @"0123456789./*-+~!@#$%^&()_+-=,./;'[]{}:<>?`"
//界面的宏
#define KScreenWith self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height

 //输入按钮所在的滚动视图尺寸的宏
#define ScrollerWith self.SignalScroll.frame.size.width
#define ScrollerHeight self.SignalScroll.frame.size.height

   //输出按钮所在滚动视图的宏
#define OutScrollerWith self.OutScroller.frame.size.width
#define OutScrollerHeight self.OutScroller.frame.size.height

#define KscWith    self.view.frame.size.width
#define KscHeight  self.view.frame.size.height


@interface SignalViewController ()<UIScrollViewDelegate,GCDAsyncUdpSocketDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
    NSUserDefaults *_senceName;
    NSUserDefaults *_SenceInName;
  
}
@property (nonatomic ,strong)NSArray *SignalArray; // 端口号数组
@property (nonatomic ,strong)UIButton *OutButton; // 输出
@property (nonatomic ,strong)UIButton *InButton; // 输入
@property (nonatomic ,strong)UIButton *Clear; // 清除
@property (nonatomic ,strong)UIButton *UnDo; // 返回上一步操作
@property (nonatomic ,strong)UIButton *OKButton; // 确认按钮
@property (nonatomic ,strong)UIButton *Allbutton; // 全选按钮
@property (nonatomic ,strong)UIScrollView *SignalScroll; // 滚动视图
@property (nonatomic ,strong)UIView *aView; // 滚动的画布
@property (nonatomic ,assign)BOOL isSeleted; // 判定是否选状态
@property (nonatomic ,assign)BOOL isAllSeleted; // 判定是否全选状态
@property (nonatomic ,strong)UIScrollView *OutScroller; //输出的滚动视图
@property (nonatomic ,strong)UIPageControl *pageNumber; //显示页数
@property (nonatomic ,strong)UITextField *IPtextField; //IP输入框
@property (nonatomic ,strong)UITextField *portTextfield; //port输入框
@property (nonatomic ,strong)NSString *host; //网址
@property (nonatomic ,assign)uint16_t port; //端口
@property (nonatomic ,assign)NSInteger InValue; //输入端口的数据
@property (nonatomic ,strong)NSMutableArray *TagArray; //标记数组
@property (nonatomic ,assign)NSInteger InStr; //输入端口
@property (nonatomic ,assign)int count;
@property (nonatomic ,strong)NSMutableArray *SelectArray;
@property (nonatomic ,strong)NSMutableArray *UnArray;
@property (nonatomic ,strong)UITextField *senceText; //输入的场景名称
@property (nonatomic ,strong)NSMutableArray *collectionArray; //改数据的数组
@property (nonatomic ,strong)UITextField *Intextfild; //输入的textfield
@property (nonatomic ,strong)NSMutableArray *lisetArray;
@property (nonatomic ,strong)NSMutableArray *MainArr; //
@property (nonatomic ,strong)NSNumber *temp;//记录当前点击的输入按钮
@property (nonatomic ,strong)UIView *Aview; //右边框
@property (nonatomic ,strong)UIView *LView; //左边框
@property (nonatomic ,strong)NSMutableArray *ProArray; //Pro的数据数组；
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSArray *Array;
@property (nonatomic ,strong)NSMutableArray *proArray;
@property (nonatomic ,strong)NSNumber *TxtNumber;
@property (nonatomic ,strong)NSNumber *OutNumber;
@property (nonatomic ,assign)BOOL IsOk;

@end

@implementation SignalViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _senceName = [NSUserDefaults standardUserDefaults];
    
    unsigned char integertag = [SignalValue ShareValue].Integer/9;
    unsigned char tage = (char)[SignalValue ShareValue].ProCount;
    
    [DataBaseHelp CreatTable];
    [DataBaseHelp SelectTemp:integertag Type:tage];
     
    
        _SenceInName = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i++) {
          UIButton *inButton = [self.view viewWithTag:300+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+i];
        NSString *Instr = [NSString stringWithFormat:@"%ld",(long)(i+300+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)];
         NSString *Inname = [_SenceInName objectForKey:Instr];
        if (Inname == nil) {
            NSString *count = [NSString stringWithFormat:@"%d",i+1];
            [inButton setTitle:count forState:UIControlStateNormal];
          

        }else
        {
            [inButton setTitle:Inname forState:UIControlStateNormal];
          
            

        }
    }

   
    
    for (int i = 0 ; i < [SignalValue ShareValue].GetMessage.count; i++) {
        UIButton *button = [self.view viewWithTag:600+i+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
      
        NSString *outstr = [NSString stringWithFormat:@"%ld",(long)(i+600+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)];
        
        NSString *nameStr = [_senceName objectForKey:outstr];
       
        if (nameStr == nil) {
            NSString *CountString = [NSString stringWithFormat:@"%d",i+1];
            
            [button setTitle:CountString forState:UIControlStateNormal];
            
        }else
        {
            [button setTitle:nameStr forState:UIControlStateNormal];
 }
    }
   
}

-(NSMutableArray *)collectionArray
{
    if (_collectionArray == nil) {
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
    
}

- (void)viewDidDisappear:(BOOL)animated

{   [super viewDidDisappear:animated];
    
    
    if ([SignalValue ShareValue].ProCount == 1) {
        
        kice_t kic = scene_print_cmd(0x00);
        NSData *data1 = [NSData dataWithBytes:(void *)&kic  length:kic.size];
        [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [udpSocket receiveOnce:nil];
    }else if ([SignalValue ShareValue].ProCount == 2){
        unsigned char buf[256] = {0};
        unsigned char num = 0;
        NSInteger length = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
        
        [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [udpSocket receiveOnce:nil];
        
        unsigned char integer = [SignalValue ShareValue].Integer/9;
        unsigned char tage = (char)[SignalValue ShareValue].ProCount;
        
        [DataBaseHelp CreatTable];
        [DataBaseHelp SelectTemp:integer Type:tage];

    }
    
  
}



- (NSArray *)Array
{
    
    if (_Array == nil) {
     //   self.Array = [DataBaseHelp SelectWithtable];
        
    }
    
    return _Array;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _LView = [[UIView alloc]init];
    _LView.frame = CGRectMake(5, KScreenHeight/6, KScreenWith/2.2, KScreenHeight/1.7);
    _LView.layer.borderColor = [UIColor blackColor].CGColor;
    _LView.layer.borderWidth = 0.5;
    _LView.layer.cornerRadius = 5;
    _LView.layer.masksToBounds = YES;
    [self.view addSubview:_LView];
    
    _Aview = [[UIView alloc]init];
    _Aview.frame = CGRectMake(KScreenWith/1.9 + 10, KScreenHeight/6, KScreenWith/2.18, KScreenHeight/1.7);
    _Aview.layer.borderColor = [UIColor blackColor].CGColor;
    _Aview.layer.borderWidth = 0.5;
    _Aview.layer.cornerRadius = 5;
    _Aview.layer.masksToBounds = YES;
    [self.view addSubview:_Aview];

    // 将视图添加上来
    //[self setUpLabel];
    [self SetSignalScroll];
    [self SetOutScrollerview];
    [self SetUpViewLabel];
    [self setUpButton];
    [self setUpView];
    [self ShowUdpSocket];
     _OutScroller.center = _Aview.center;
     _SignalScroll.center = _LView.center;
    _SendArray = [NSMutableArray array];
    _mutArray = [NSMutableSet mutableCopy];
    _ValueArray = [NSMutableArray array];
    _RemoveArray = [NSMutableArray array];
    _TagArray = [NSMutableArray array];

    _SelectArray = [NSMutableArray array];
    
    _UnArray = [NSMutableArray array];
    _ProArray = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    _ProArray = [NSMutableArray arrayWithArray:[SignalValue ShareValue].GetMessage];
    _dataArray = [NSMutableArray arrayWithArray:[SignalValue ShareValue].GetMessage];
  
    int i = 0;
    for (; i < [SignalValue ShareValue].Integer; i++) {
        NSInteger number = 300+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+i;
        NSNumber *TagNumber = [NSNumber numberWithInteger:number];
        [_TagArray addObject:TagNumber];
    }

    //注册通知ProOut
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TextNameAction:) name:@"textname" object:nil];
    
    //注册通知PronIn
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PronInAction:) name:@"ProInNot" object:nil];
  
}

//通知的事件PronOut
- (void)TextNameAction:(NSNotification *)notice
{
    NSString *stri = notice.userInfo[@"Name"];
    NSInteger taginteger = _OutNumber.integerValue;
    UIButton *outButton = (UIButton *)[self.view viewWithTag:taginteger +599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
    
    [outButton setTitle:stri forState:UIControlStateNormal];
//    outButton.selected = NO;
//    outButton.backgroundColor = [UIColor whiteColor];
}

//通知的事件PronIn
- (void)PronInAction:(NSNotification *)notice
{
    NSString *string = notice.userInfo[@"ProIn"];
    NSInteger InTage = _TxtNumber.integerValue;
    UIButton *button = (UIButton *)[self.view viewWithTag:InTage+299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
   
    [button setTitle:string forState:UIControlStateNormal];
//    button.selected = NO;
//    button.backgroundColor = [UIColor whiteColor];
}


- (void)SetUpViewLabel
{
    UILabel *label  = [[UILabel alloc]init];
    label.frame = CGRectMake(KScreenWith/23, CGRectGetMinY(_LView.frame)+10 ,CGRectGetMaxX(_SignalScroll.frame)-10, 30);
    label.text = @"输入";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor colorWithRed:71/255.0 green:185/255.0 blue:251/255.0 alpha:1];
    label.layer.cornerRadius = 3;
    label.layer.masksToBounds = YES;
    [self.view addSubview:label];
    UILabel *outLabel = [[UILabel alloc]init];

    outLabel.frame = CGRectMake(KScreenWith/1.74, CGRectGetMinY(_Aview.frame)+10, CGRectGetMaxX(_OutScroller.frame)/2.6, 30);
    outLabel.text = @"输出";
    outLabel.textAlignment = NSTextAlignmentCenter;
    outLabel.backgroundColor = [UIColor colorWithRed:71/255.0 green:185/255.0 blue:251/255.0 alpha:1];
    outLabel.layer.cornerRadius = 3;
    outLabel.layer.masksToBounds = YES;
    [self.view addSubview:outLabel];
}


#pragma mark === label===
- (void)setUpLabel
{
    UILabel *InLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,KScreenHeight/10,80, 40)];
    InLabel.text = @"输入(in)";
    InLabel.font = [UIFont systemFontOfSize:21];
    InLabel.backgroundColor = [UIColor orangeColor];
    
    //切圆
    InLabel.layer.cornerRadius = 5;
    InLabel.layer.masksToBounds = YES;
    [self.view addSubview:InLabel];
    
    //输出的label
    UILabel *outLabel = [[UILabel alloc]initWithFrame:CGRectMake(5,CGRectGetMaxY(InLabel.frame)+30, 80, 40)];
    outLabel.text = @"输出(out)";
    
    //设置字体大小
    outLabel.font = [UIFont systemFontOfSize:18];
    outLabel.backgroundColor = [UIColor whiteColor];

    //切圆
    outLabel.layer.cornerRadius = 5;
    outLabel.layer.masksToBounds = YES;
    
    // 添加到视图上
    [self.view addSubview:outLabel];

}
#pragma mark ===button布局=======
- (void)setUpButton
{
// 循环布置输入按钮
    for (int i = 0; i < 3; i++) {
        for (int j = 0 ;j < [SignalValue ShareValue].Integer/3; j++) {
            _InButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _InButton.frame = CGRectMake(5+ScrollerWith/3*i,ScrollerHeight/10+ScrollerHeight/4*j,ScrollerWith/3.2,ScrollerWith/6);
            NSString *string = [NSString stringWithFormat:@"%d",3*j+i+1];
            [_InButton setTitle:string forState:UIControlStateNormal];
            _InButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _InButton.titleLabel.textColor = [UIColor blackColor];
            _InButton.layer.masksToBounds = YES;
            _InButton.layer.cornerRadius = 10;
            _InButton.layer.borderColor = [UIColor blackColor].CGColor;
            _InButton.layer.borderWidth = 0.5f;
            _InButton.titleLabel.font = [UIFont systemFontOfSize:23];
            
           
            
            _InButton.tag = 300 + (3)*j+i + 115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9;
            [_InButton addTarget:self action:@selector(action4btn:) forControlEvents:UIControlEventTouchDown];
            UILongPressGestureRecognizer *InPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(InPressAction:)];
            [_InButton addGestureRecognizer:InPress];
            [_SignalScroll addSubview:_InButton];
            
            //输出按钮
            _OutButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _OutButton.frame = CGRectMake(5+OutScrollerWith/3*i,OutScrollerHeight/10+OutScrollerHeight/4*j,OutScrollerWith/3.2,OutScrollerHeight/4.8);
            NSString *String = [NSString stringWithFormat:@"%d",3*j+i + 1];
            [_OutButton setTitle:String forState:UIControlStateNormal];
            _OutButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            _OutButton.layer.masksToBounds = YES;
            _OutButton.layer.borderColor = [UIColor blackColor].CGColor;
            _OutButton.layer.borderWidth = 0.5f;
            _OutButton.titleLabel.font = [UIFont systemFontOfSize:23];
            _OutButton.layer.cornerRadius = 10;
            _OutButton.tag = 600+(3)*j+i + 115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9;
           
            
            // 添加点击事件
            [_OutButton addTarget:self action:@selector(OutbuttonAction:) forControlEvents:UIControlEventTouchDown];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressAction:)];
            
            [_OutButton addGestureRecognizer:longPress];
            longPress.minimumPressDuration = 0.5;
            [_OutScroller addSubview:_OutButton];
        }
    }
    
}
#pragma mark ===输入的手势事件===
- (void)InPressAction:(UILongPressGestureRecognizer *)gesture
{
    
    if ([SignalValue ShareValue].ProCount == 1) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入场景名称" message:@"输入" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.backgroundColor = [UIColor orangeColor];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocorrectionTypeDefault;
        
    }];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         for (NSNumber *number in [SignalValue ShareValue].InArray) {
             
            NSInteger num = number.integerValue;
            UIButton *button = [self.view viewWithTag:299+num +115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor whiteColor];
             button.selected = NO;
         }
    }];
    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _Intextfild = (UITextField *)alert.textFields.firstObject;
        
        [[SignalValue ShareValue].InArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *num = obj;
            NSInteger integer = num.integerValue;
            UIButton *button = [self.view viewWithTag:299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+integer];
            
            NSString *string = [NSString stringWithFormat:@"%ld",(long)integer+299 +115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            
            [[SignalValue ShareValue].InArray removeAllObjects];
         
            if (_Intextfild.text.length <= 0) {
               
                NSString *title = [NSString stringWithFormat:@"%ld",(long)integer];
                [button setTitle:title forState:UIControlStateNormal];
                [[SignalValue ShareValue].InArray removeObject:num];
                button.backgroundColor = [UIColor whiteColor];
                unsigned char integer = [SignalValue ShareValue].Integer/9;
                unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
                [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:title];
                
             
            }else if (_Intextfild.text.length >= 5){
               
                NSString *str = [_Intextfild.text substringToIndex:5];
                [button setTitle:str forState:UIControlStateNormal];

                unsigned char integer = [SignalValue ShareValue].Integer/9;
               unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
                [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:str];
                [DataBaseHelp SelectTemp:integer Type:tage];
               
                [DataBaseHelp SelectTemp:integer Type:tage];

               
            }else if (_Intextfild.text.length < 5 &&_Intextfild.text.length > 0)
            {
                [button setTitle:_Intextfild.text forState:UIControlStateNormal];
                
                unsigned char integer = [SignalValue ShareValue].Integer/9;
                unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
                [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:_Intextfild.text];
                
       }
            
           
        }];
       [[SignalValue ShareValue].InArray removeAllObjects];
       
    }];
    
    [alert addAction:Action];
    [alert addAction:twoAc];
    [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([SignalValue ShareValue].ProCount == 2){
        ProInSet *set = [ProInSet new];
       set.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        set.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:set animated:YES completion:nil];
     
    }
    
}
#pragma mark ===输出的执行事件======
- (void)LongPressAction:(UILongPressGestureRecognizer *)longPress
{
    
    
    if ([SignalValue ShareValue].ProCount == 1) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入场景名称" message:@"非数字输入" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.delegate = self;
        
        // 可以在这里对textfield进行定制，例如改变背景色
        //textField.backgroundColor = [UIColor orangeColor];
    }];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (int i = 0; i < [SignalValue ShareValue].OutArray.count; i++) {
            
            NSNumber *num = [SignalValue ShareValue].OutArray[i];
            NSInteger tagnum = num.integerValue;
            UIButton *button = (UIButton *)[self.view viewWithTag:599+tagnum+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor whiteColor];
            [_RemoveArray removeObject:num];
            
            
            button.selected = NO;
        }
    }];
    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        _senceText = (UITextField *)alert.textFields.firstObject;
        [[SignalValue ShareValue].OutArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number = obj;
            NSInteger integer = number.integerValue;
            UIButton *button = [self.view viewWithTag:599+integer+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor whiteColor];
            button.selected = NO;
              NSString *Nstring = [NSString stringWithFormat:@"%ld",(long)integer+599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            [[SignalValue ShareValue].OutArray removeObject:obj];
            [_RemoveArray removeObject:obj];
            if (_senceText.text.length <= 0) {
                
                [button setTitle:[NSString stringWithFormat:@"%ld",(long)integer] forState:UIControlStateNormal];
                
                unsigned char integertag = [SignalValue ShareValue].Integer/9;
                unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
                [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:[NSString stringWithFormat:@"%ld",(long)integer]];

              
                [[SignalValue ShareValue].OutArray removeAllObjects];
                
            }else if (_senceText.text.length >= 5){
                
                NSString *str = [_senceText.text substringToIndex:5];
                [button setTitle:str forState:UIControlStateNormal];
                unsigned char integertag = [SignalValue ShareValue].Integer/9;
                unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                
                
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
                [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:str];
                [DataBaseHelp SelectTemp:integertag Type:tage];
                
                [[SignalValue ShareValue].OutArray removeAllObjects];
              
            }else
            {
  
                [button setTitle:_senceText.text forState:UIControlStateNormal];
                
                unsigned char integertag = [SignalValue ShareValue].Integer/9;
                unsigned char tage = (char)[SignalValue ShareValue].ProCount;
                [DataBaseHelp CreatTable];
                [DataBaseHelp DeleteWithTemp:integertag type:tage Key:Nstring];
                [DataBaseHelp InsertIntoTemp:integertag Type:tage Key:Nstring Values:_senceText.text];
                [[SignalValue ShareValue].OutArray removeAllObjects];
            }
       
        }];

   
 }];
   
    [alert addAction:Action];
    [alert addAction:twoAc];
    [self presentViewController:alert animated:YES completion:nil];
        
    }else if ([SignalValue ShareValue].ProCount == 2 && [SignalValue ShareValue].OutArray != nil)
    
    {
        
            ProSetView  *pro = [ProSetView new];
        pro.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        pro.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:pro animated:YES completion:nil];
        

    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *charact;
    charact = [[NSCharacterSet characterSetWithCharactersInString:NMUBERS]invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:charact]componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange) {
        UIAlertController *AlertControl = [UIAlertController alertControllerWithTitle:@"数字输入不被允许" message:@"请输入汉字或字母" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [AlertControl addAction:action];
        [AlertControl addAction:cancle];
        [self presentViewController:AlertControl animated:YES completion:nil];
        
        return NO;

    }
    return YES;

}


#pragma mark====输入的点击事件======
-(void)action4btn:(UIButton*)btn
{   [[SignalValue ShareValue].InArray removeAllObjects];
    [_RemoveArray removeAllObjects];
    [_SelectArray removeAllObjects];
    
    if ([SignalValue ShareValue].ProCount == 1) {
        
    for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i ++) {
        
        NSInteger select = (NSInteger)(btn.tag - (299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
       _temp = [NSNumber numberWithInteger:select];
        
    
        if ([SignalValue ShareValue].GetMessage[i] == _temp) {
            
            NSInteger count = i+1;
            NSNumber *countNumber = [NSNumber numberWithInteger:count];
            [_RemoveArray addObject:countNumber];
            [_SelectArray addObject:countNumber];
           
            UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor orangeColor];
            button.selected = YES;
            
        }else
        {
            NSInteger count = i+1;
//            NSNumber *countNumber = [NSNumber numberWithInteger:count];
//           [_SelectArray addObject:countNumber];
           
            UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor whiteColor];
            button.selected = NO;
          
        }
    }
    for (int i=0; i<_TagArray.count; i++) {
        UIButton *button = [self.view viewWithTag:[(NSString*)_TagArray[i] integerValue]];
        if (btn.tag == button.tag) {
            button.backgroundColor = [UIColor orangeColor];
            NSInteger vale = (NSInteger)(btn.tag - (299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *number = [NSNumber numberWithInteger:vale];
            [[SignalValue ShareValue].InArray
             addObject:number];
            
        }
        else
        {
           button.backgroundColor = [UIColor whiteColor];
         
        }
    }
    
        
    }else if ([SignalValue ShareValue].ProCount == 2){

        for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i ++) {
            
            NSInteger select = (NSInteger)(btn.tag - (299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            _temp = [NSNumber numberWithInteger:select];
            
            if ([SignalValue ShareValue].GetMessage[i] == _temp) {
                
                NSInteger count = i+1;
                NSNumber *countNumber = [NSNumber numberWithInteger:count];
                [_RemoveArray addObject:countNumber];
                
                _ProArray[count-1] = _temp;
                _dataArray[count - 1] = _temp;
          
                UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
                button.backgroundColor = [UIColor orangeColor];
                button.selected = YES;
                
            }else
            {
                NSInteger count = i+1;
                NSNumber *countNumber = [NSNumber numberWithInteger:count];
                NSInteger zero = 0;
                NSNumber *zeNumber = [NSNumber numberWithInteger:zero];
                [_RemoveArray addObject:zeNumber];
//                [_SelectArray addObject:countNumber];
                
                UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
                button.backgroundColor = [UIColor whiteColor];
                button.selected = NO;
                
            }
        }
        for (int i=0; i<_TagArray.count; i++) {
            UIButton *button = [self.view viewWithTag:[(NSString*)_TagArray[i] integerValue]];
            if (btn.tag == button.tag) {
                button.backgroundColor = [UIColor orangeColor];
                NSInteger vale = (NSInteger)(btn.tag - (299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
                NSNumber *number = [NSNumber numberWithInteger:vale];
                [[SignalValue ShareValue].InArray addObject:number];
               
            }
            
            else
            {
                button.backgroundColor = [UIColor whiteColor];
                
            }
        }
        _TxtNumber = [SignalValue ShareValue].InArray[0];
        
        
    }
   
}

#pragma mark=== 输出点击响应事件===
- (void)OutbuttonAction:(UIButton *)sender
{
    [[SignalValue ShareValue].OutArray removeAllObjects];
    if ([SignalValue ShareValue].ProCount == 1) {
     
        if (sender.selected == NO) {
            sender.selected = YES;
            self.sendInt = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)) ;
            NSNumber *numStr = [NSNumber numberWithInteger:self.sendInt];
            [_UnArray addObject:numStr];//记录后来点击的按钮
            [_RemoveArray addObject:numStr];//改了数组
         
            _MutSetArray = [NSMutableSet setWithArray:_RemoveArray];//改了数组
            NSArray *array = [_MutSetArray allObjects];
            NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
            _RemoveArray = [NSMutableArray arrayWithArray:sorted];
            [[SignalValue ShareValue].OutArray addObject:numStr];
            
            sender.backgroundColor = [UIColor orangeColor];
            
            
        }else{
            sender.backgroundColor = [UIColor whiteColor];
            sender.selected = NO;
            NSInteger intnum = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *Rrmove = [NSNumber numberWithInteger:intnum];
            [_UnArray removeObject:Rrmove];//清除去掉的按钮
            [_RemoveArray removeObject:Rrmove];
            [[SignalValue ShareValue].OutArray addObject:Rrmove];
            

          
        }

    }else if ([SignalValue ShareValue].ProCount == 2 && _temp != 0){
       
        if (sender.selected == NO) {
            sender.selected = YES;
            self.sendInt = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)) ;
            NSNumber *numStr = [NSNumber numberWithInteger:self.sendInt];
            [_UnArray addObject:numStr];//记录后来点击的按钮
            
            
            _ProArray[_sendInt - 1] = _temp;
            [_RemoveArray addObject:numStr];//改了数组
            [[SignalValue ShareValue].OutArray addObject:numStr];
            
            _MutSetArray = [NSMutableSet setWithArray:_RemoveArray];//改了数组
            NSArray *array = [_MutSetArray allObjects];
            NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
            _RemoveArray = [NSMutableArray arrayWithArray:sorted];
         
            sender.backgroundColor = [UIColor orangeColor];
            _OutNumber = [SignalValue ShareValue].OutArray[0];
            
            
        }else{
            sender.backgroundColor = [UIColor whiteColor];
            sender.selected = NO;
            NSInteger intnum = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *Rrmove = [NSNumber numberWithInteger:intnum];
            [_UnArray removeObject:Rrmove];//清除去掉的按钮
            [_RemoveArray removeObject:Rrmove];
            [[SignalValue ShareValue].OutArray addObject:Rrmove];
            _ProArray[intnum-1] = [NSNumber numberWithInteger:0];
            _OutNumber = [SignalValue ShareValue].OutArray[0];
            
          
        }

    }else
    {
        
        if (sender.selected == NO) {
            sender.selected = YES;
            self.sendInt = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9)) ;
            NSNumber *numStr = [NSNumber numberWithInteger:self.sendInt];
            [_UnArray addObject:numStr];//记录后来点击的按钮
           
            [_RemoveArray addObject:numStr];//改了数组
            [[SignalValue ShareValue].OutArray addObject:numStr];
            
            _MutSetArray = [NSMutableSet setWithArray:_RemoveArray];//改了数组
            NSArray *array = [_MutSetArray allObjects];
            NSArray *sorted = [array sortedArrayUsingSelector:@selector(compare:)];
            _RemoveArray = [NSMutableArray arrayWithArray:sorted];
           
            sender.backgroundColor = [UIColor orangeColor];
            _OutNumber = [SignalValue ShareValue].OutArray[0];
            
            
        }else{
            sender.backgroundColor = [UIColor whiteColor];
            sender.selected = NO;
            NSInteger intnum = (NSInteger)(sender.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *Rrmove = [NSNumber numberWithInteger:intnum];
            [_UnArray removeObject:Rrmove];//清除去掉的按钮
            [_RemoveArray removeObject:Rrmove];
            _ProArray[intnum-1] = [NSNumber numberWithInteger:0];
            [[SignalValue ShareValue].OutArray addObject:Rrmove];
            _OutNumber = [SignalValue ShareValue].OutArray[0];
            
        }

    }
    

    
    }

#pragma mark  ===建立点击button====
- (void)setUpView
{
    // 清除当前选中状态
   _Clear = [UIButton buttonWithType:UIButtonTypeSystem];
    _Clear.frame = CGRectMake(KScreenWith/12.9, KScreenHeight/1.2, KScreenWith/12, 50);
    [_Clear setTitle:@"Clear" forState:UIControlStateNormal];
     _Clear.titleLabel.font = [UIFont systemFontOfSize:23];
    _Clear.layer.cornerRadius = 5;
    _Clear.layer.masksToBounds = YES;
    _Clear.layer.borderColor = [UIColor blackColor].CGColor;
    _Clear.layer.borderWidth = 0.5;
    [_Clear addTarget:self action:@selector(Action4Clear:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_Clear];
    
    // 取消上一步操作
    _UnDo = [UIButton buttonWithType:UIButtonTypeSystem];
    _UnDo.frame = CGRectMake(KScreenWith/4, KScreenHeight/1.2, KScreenWith/12, 50);

    [_UnDo setTitle:@"Undo" forState:UIControlStateNormal];
    _UnDo.titleLabel.font = [UIFont systemFontOfSize:23];
    _UnDo.layer.cornerRadius = 5;
    _UnDo.layer.masksToBounds = YES;
    _UnDo.layer.borderColor = [UIColor blackColor].CGColor;
    _UnDo.layer.borderWidth = 0.5;
    [_UnDo addTarget:self action:@selector(Return:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_UnDo];
    
     // 确认按钮
    _OKButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _OKButton.frame = CGRectMake(KScreenWith/1.5, KScreenHeight/1.2, KScreenWith/12, 50);
    [_OKButton setTitle:@"OK" forState:UIControlStateNormal];
    _OKButton.titleLabel.font = [UIFont systemFontOfSize:23];
    _OKButton.layer.cornerRadius = 5;
    _OKButton.layer.masksToBounds = YES;
    _OKButton.layer.borderColor = [UIColor blackColor].CGColor;
    _OKButton.layer.borderWidth = 0.5;
    [_OKButton addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_OKButton];
    
      // 选中全部
    _Allbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _Allbutton.frame = CGRectMake(KScreenWith/1.2, KScreenHeight/1.2, KScreenWith/12, 50);
    [_Allbutton setTitle:@"All" forState:UIControlStateNormal];
    _Allbutton.titleLabel.font = [UIFont systemFontOfSize:23];
    _Allbutton.layer.cornerRadius = 5;
    _Allbutton.layer.masksToBounds = YES;
    _Allbutton.layer.borderColor = [UIColor blackColor].CGColor;
    _Allbutton.layer.borderWidth = 0.5;
    [_Allbutton addTarget:self action:@selector(AllAction:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_Allbutton];
    
}
//清除
-(void)Action4Clear:(UIButton *)Clear
{
    for (int i = 0; i < _RemoveArray.count; i++) {
        
        NSNumber *num = _RemoveArray[i];
        NSInteger integer = num.integerValue;
        UIButton *outButton = (UIButton *)[self.view viewWithTag:integer + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            outButton.backgroundColor = [UIColor whiteColor];
            outButton.selected = NO;
        
    }
    
    if ([SignalValue ShareValue].ProCount == 1) {
        
        [_RemoveArray removeAllObjects];
        
    }else if ([SignalValue ShareValue].ProCount == 2){
    
           for (int i = 0; i <_ProArray.count; i++) {
            
            if (_ProArray[i]== _temp) {
                NSInteger zeo = 0;
                NSNumber *num = [NSNumber numberWithInteger:zeo];
                _ProArray[i] =num;
                
            }else
            {
              
                
            }
        }
        
    }

}


//返回上一步操作
- (void)Return:(UIButton *)Undo
{
    [_RemoveArray removeAllObjects];
    for (int i = 0; i < [SignalValue ShareValue].GetMessage.count; i ++) {
        if ([SignalValue ShareValue].GetMessage[i] == _temp) {
            
            NSInteger count = i+1;
            NSNumber *countNumber = [NSNumber numberWithInteger:count];
//            [_RemoveArray addObject:countNumber];
//            [_SelectArray addObject:countNumber];
            [_MainArr addObject:countNumber];
            UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor orangeColor];
            button.selected = YES;
            
        }else
        {
            NSInteger count = i+1;
            NSNumber *countNumber = [NSNumber numberWithInteger:count];
//            [_SelectArray addObject:countNumber];
           
            UIButton *button = [self.view viewWithTag:count + 599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
            button.backgroundColor = [UIColor whiteColor];
            button.selected = NO;
            [_MainArr removeObject:countNumber];
            
        }
     
    }
    
    if ([SignalValue ShareValue].ProCount == 1) {
        _RemoveArray = [NSMutableArray arrayWithArray:_SelectArray];
        
    }else if ([SignalValue ShareValue].ProCount == 2)
    {
        _ProArray = [NSMutableArray arrayWithArray:_dataArray];
       
    }

}

#pragma mark ===发送指令====
- (void)SendMessage:(UIButton *)Send
{   [_SelectArray removeAllObjects];
    
    [_UnArray removeAllObjects];
    NSString *host = [SignalValue ShareValue].SignalIpStr;
    uint16_t port = [SignalValue ShareValue].SignalPort;

    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //开始发送
    //改函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
   
    unsigned char sendout[512]={0};
    unsigned int i= 0;

    unsigned char Pro[512] = {0};

    if ([SignalValue ShareValue].ProCount ==2) {
//   
//        unsigned char dobuf[512] = {0};
//        
            for (int i = 0; i < _ProArray.count ; i++) {
            
                NSNumber *num = _ProArray[i];
                Pro[i] = (unsigned char)num.integerValue;
           
                }
        
            }

    for( ; i < _RemoveArray.count; i++)
    {
        NSNumber *b = _RemoveArray[i];
        sendout[i] = (unsigned char)b.intValue;
        
    }

    int Intag = 0;
    for (int i = 0; i < [SignalValue ShareValue].InArray.count; i++) {
        NSNumber *number = [SignalValue ShareValue].InArray[i];
        Intag  = number.intValue;
    }

       if ([SignalValue ShareValue].ProCount == 1) {
        
        
        kice_t kic = signal_map_cmd(Intag, sendout, i , [SignalValue ShareValue].Integer);
        
        NSData *data1 = [NSData dataWithBytes:(void *)&kic   length:kic.size];
        [udpSocket sendData:data1 toHost:host port:port withTimeout:60 tag:200];
        
        [udpSocket bindToPort:_port error:nil];
        [udpSocket receiveOnce:nil];
        
        //[[SignalValue ShareValue].GetMessage removeAllObjects];
        
        kice_t kic1 = scene_print_cmd(0x00);
        NSData *data2 = [NSData dataWithBytes:(void *)&kic1  length:kic1.size];
        [udpSocket sendData:data2 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [udpSocket receiveOnce:nil];
        //[_RemoveArray removeAllObjects];
    }else if ([SignalValue ShareValue].ProCount == 2){
        
        unsigned char buf1[256] ={0};
        unsigned char num = 0;
    
        NSInteger length = make_pack_5555(METHOD_SET, CMD_SCREEN_SWITCH_STATUSTABLE, 18 ,Pro, buf1);
        NSData *data = [NSData dataWithBytes:(void *)&buf1 length:length];
        [udpSocket sendData:data toHost:host port:port withTimeout:60 tag:200];
        [udpSocket bindToPort:_port error:nil];
        [udpSocket receiveOnce:nil];
      
        NSInteger length1 = make_pack_5555(METHOD_GET, CMD_SENCE_SWITCH_ID_GAIN, 1, &num, buf1);
        NSData *data1 = [NSData dataWithBytes:(void *)&buf1  length:length1];
    
        [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
        [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
        [udpSocket receiveOnce:nil];
        
    }

    
}
    //选择所有的按钮
- (void)AllAction:(UIButton *)AllButton
{  [_UnArray removeAllObjects];
    [_RemoveArray removeAllObjects];
    
    for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
        _OutButton = [self. view viewWithTag:600+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+i];
        if (_OutButton.selected== NO) {
            self.isAllSeleted = NO;
            NSInteger witch = (NSInteger)(_OutButton.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *num = [NSNumber numberWithInteger:witch];
            [_SendArray addObject:num];
           
            break;
        }else if (_OutButton.selected == YES && i == 8)
            self.isAllSeleted = YES;
        
    }
    [_SendArray removeAllObjects];
    if (self.isAllSeleted == NO ) {
        for (int i = 0; i < [SignalValue ShareValue].Integer; i++) {
            _OutButton = [self. view viewWithTag:600+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+i];
            _OutButton.backgroundColor = [UIColor orangeColor];
            NSInteger outbut = (NSInteger)(_OutButton.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *number = [NSNumber numberWithInteger:outbut];
            [_SendArray addObject:number];
        
            _MutSetArray = [NSMutableSet setWithArray:_SendArray];
            
            _ValueArray = [_MutSetArray allObjects];
            
            NSArray *array = [_ValueArray sortedArrayUsingSelector:@selector(compare:)];
            _RemoveArray = [NSMutableArray arrayWithArray:array];
            _UnArray = [NSMutableArray arrayWithArray:array];
            
            [_MainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_UnArray removeObject:obj];
                
            }];
            if (_temp != nil) {
                _ProArray[outbut -1] = _temp;
            }
            
            NSMutableSet *Set = [NSMutableSet setWithArray:_UnArray];
            NSArray *Allarray = [Set allObjects];
            NSArray *sortArray = [Allarray sortedArrayUsingSelector:@selector(compare:)];
            _UnArray = [NSMutableArray arrayWithArray:sortArray];
            
         
            
            _OutButton.selected= YES;
        }
        
        
        self.isAllSeleted = YES;
    }else{
        [_UnArray removeAllObjects];
        for (int i = 0; i < [SignalValue ShareValue].Integer ; i++) {
            _OutButton = [self.view viewWithTag:600+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+i];
            _OutButton.backgroundColor = [UIColor whiteColor];
            NSInteger intOut = (NSInteger)(_OutButton.tag - (599+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9));
            NSNumber *numb = [NSNumber numberWithInteger:intOut];
            [_MainArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_UnArray removeObject:obj];
            }];
            [_RemoveArray removeObject:numb];
            [_MutSetArray removeAllObjects];
            [_SendArray removeAllObjects];
            _OutButton.selected = NO;
            [_UnArray addObject:numb];
            
            _ProArray[intOut - 1] = [NSNumber numberWithInteger:0];
            
        }
        // [_UnArray removeAllObjects];
        self.isAllSeleted = NO;
       
    }

}

#pragma mark ===输入的滚动视图=====
-(void)SetSignalScroll
{
    _SignalScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10,KScreenHeight/4,KScreenWith/2.6,KScreenHeight/2.3)];
    _SignalScroll.contentSize = CGSizeMake(ScrollerWith,ScrollerHeight*[SignalValue ShareValue].Integer/9);
    _SignalScroll.pagingEnabled = NO;
    _SignalScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_SignalScroll];
//    _SignalScroll.layer.borderColor = [UIColor blackColor].CGColor;
//    _SignalScroll.layer.borderWidth = 0.5;
//    
    _pageNumber = [[UIPageControl alloc]init];

}

#pragma mark ===输出的滚动视图=====
- (void)SetOutScrollerview

{//1.67
    _OutScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(KScreenWith/1.67, KScreenHeight/4, KScreenWith/2.6, KScreenHeight/2.3)];
    _OutScroller.contentSize = CGSizeMake(ScrollerWith, OutScrollerHeight*[SignalValue ShareValue].Integer/9);
    _OutScroller.delegate = self;
    
    _OutScroller.pagingEnabled = NO;
    _OutScroller.showsVerticalScrollIndicator = NO;
//    _OutScroller.layer.borderColor = [UIColor blackColor].CGColor;
//    _OutScroller.layer.borderWidth = 0.5;
    [self.view addSubview:_OutScroller];
}

#pragma mark ===scroller的代理方法====

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _OutButton.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _OutButton.userInteractionEnabled = YES;
}




#pragma mark ===创建socket=====
- (void)ShowUdpSocket
{
       //初始化对象，使用全局队列
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [udpSocket bindToPort:(uint16_t)[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];

}
#pragma mark === udpSocket执行的代理方法=======
//发送成功34
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    if (tag == 200) {
        NSLog(@"标记为200的数据发送完成了");
    }
}
    //发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
   NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
  
}
 //接收成功;
-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    [[SignalValue ShareValue].GetMessage removeAllObjects];
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    const unsigned char *a= [data bytes];
    kice_t *kic = (kice_t *)a;
    unsigned char cmd = kic->data[0];
    const  unsigned char *resultBuff = [data bytes];
    if(cmd == 0x27)
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
    }else if (resultBuff[0] == 0x55 && resultBuff[1] == 0x55 && resultBuff[7] == 0x04 && resultBuff[8] == 0x02){
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
}
    [sock receiveOnce:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self SendBackToHost:ip port:port withMessage:str];
    });
    
}

-(void)SendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str
{
    NSString *Msg = @"我在发送消息";
    NSData *data = [Msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:ip port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:201];
}

//懒加载
- (NSMutableArray *)SendArray
{
    if (_SendArray == nil) {
        _SendArray = [NSMutableArray array];
    }
    return _SendArray;
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

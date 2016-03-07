//
//  ProInSet.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/20.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "ProInSet.h"
#import "DataBaseHelp.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "SignalViewController.h"
#import "ProConnect.h"
#import "ProInTableViewController.h"


#define KscWith    self.view.frame.size.width
#define KscHeight  self.view.frame.size.height
@interface ProInSet ()<UITextFieldDelegate,GCDAsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
    
}

@property (nonatomic ,strong)UIButton *ratioButton;
@property (nonatomic ,strong)UIButton *Spacebutton;
@property (nonatomic ,strong)UIButton *LightAdd;
@property (nonatomic ,strong)UIButton *LightCut;
@property (nonatomic ,strong)UIButton *contrastadd;
@property (nonatomic ,strong)UIButton *contrastCut;
@property (nonatomic ,strong)UIButton *chromaCut;
@property (nonatomic ,strong)UIButton *chromaAdd;
@property (nonatomic ,strong)UIButton *Saturation;
@property (nonatomic ,strong)UIButton *SaturationCut;
@property (nonatomic ,strong)UIButton *ZoomAdd;
@property (nonatomic ,strong)UIButton *ZoomCut;
@property (nonatomic ,strong)UIButton *ErectImage;
@property (nonatomic ,strong)UIButton *InvertedImage;
@property (nonatomic ,strong)UIButton *Reset;
@property (nonatomic ,strong)UIButton *Naming;
@property (nonatomic ,strong)UITextField *Nametext;
@property (nonatomic ,strong)UIButton *Cancle;
@property (nonatomic ,strong)NSString *Namestring;
@property (nonatomic ,strong)NSArray *InGroups;
@property (nonatomic ,strong)UITableView *table;
@property (nonatomic ,strong)NSString *Intext;
@property (nonatomic ,assign)BOOL isYes;
@property (nonatomic ,strong)UIView *InAview;




@property (nonatomic ,strong)ProInTableViewController *ProInTable;


@end

@implementation ProInSet



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    _InGroups = @[@"720x480i60",@" 720x576i50",@" 720x480p60",@" 720x576p50",@" 1280x720p60",@" 1280x720p59",@" 1280x720p30",@" 1280x720p25",@" 1280x720p24",@" 1920x1080i60",@" 1920x1080i59",@" 1920x1080i50",@" 1920x1080p60",@" 1920x1080p59",@" 1920x1080p50",@" 1920x1080p30",@" 1920x1080p25",@" 1920x1080p24",@" 640x480p60",@" 640x480p75",@" 800x600p60",@" 800x600p75",@" 1024x768p60",@" 1024x768p75",@" 1280x1024p60",@" 1280x1024p75",@" 1360x768p60",@" 1366x768p60",@" 1400x1050p60",@" 1600x1200p60",@" 1440x900p60",@" 1440x900p75",@" 1680x150p60",@" 1680x1050pRB",@" 1920x1080pRB",@" 1920x1200pRB",@" 1280x800p60"];
    

    self.preferredContentSize = CGSizeMake(KscWith/2.5, KscHeight/1.5);
    _InAview = [[UIView alloc]init];
    _InAview.frame = CGRectMake(0, 0, KscWith, KscHeight);
    [self.view addSubview:_InAview];
  
    self.view.backgroundColor = [UIColor colorWithRed:191/255.0 green:219/255.0 blue:255/255.0 alpha:1];
    
    
    UIView *HeaderView = [[UIView alloc]init];
    HeaderView.frame = CGRectMake(0, 0, KscWith, 50);
    HeaderView.backgroundColor = [UIColor colorWithRed:71/255.0 green:185/255.0 blue:251/255.0 alpha:1];
    [_InAview addSubview:HeaderView];
    
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, KscHeight/12, KscWith/17, KscHeight/19);
    label.text = @"分辨率";
    [_InAview addSubview:label];
 
    UILabel *Inlabel = [[UILabel alloc]init];
    Inlabel.frame = CGRectMake(5, 5, KscWith/8, 30);
//    Inlabel.backgroundColor = [UIColor orangeColor];
    Inlabel.text = [NSString stringWithFormat:@"%@ %@",@"InPut : ",[SignalValue ShareValue].InArray[0]];
    [_InAview addSubview:Inlabel];
    
    
    UILabel *space = [[UILabel alloc]init];
    space.frame = CGRectMake(10,CGRectGetMaxY(label.frame) +20, KscWith/15, KscHeight/19);
    space.text = @"色彩空间";
    
    [_InAview addSubview:space];
    
    _ratioButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _ratioButton.frame = CGRectMake(KscWith/9, KscHeight/12, KscWith/4, 40);
    _ratioButton.layer.borderColor = [UIColor blackColor].CGColor;
    _ratioButton.layer.borderWidth = 0.5f;
    [_ratioButton addTarget:self action:@selector(ratioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_ratioButton];
    
    _Spacebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _Spacebutton.frame = CGRectMake(KscWith/9, CGRectGetMinY(space.frame), KscWith/4, 40);
    _Spacebutton.layer.borderColor = [UIColor blackColor].CGColor;
    _Spacebutton.layer.borderWidth = 0.5f;
    [_Spacebutton addTarget:self action:@selector(SpacebuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Spacebutton];
    
    UILabel *light = [[UILabel alloc]init];
    light.frame = CGRectMake(10,CGRectGetMaxY(space.frame) +15, KscWith/15, KscHeight/19);
    light.text = @"亮度";
    
    [_InAview addSubview:light];
    
    UILabel *dui = [[UILabel alloc]init];
    dui.frame = CGRectMake(10,CGRectGetMaxY(light.frame) +15, KscWith/15, KscHeight/19);
    dui.text = @"对比度";
    [_InAview addSubview:dui];
    
    UILabel *baohe = [[UILabel alloc]init];
    baohe.frame = CGRectMake(10,CGRectGetMaxY(dui.frame) +15, KscWith/15, KscHeight/19);
    baohe.text = @"饱和度";
    
    [_InAview addSubview:baohe];
    
    UILabel *color = [[UILabel alloc]init];
    color.frame = CGRectMake(10,CGRectGetMaxY(baohe.frame) +15, KscWith/15, KscHeight/19);
    color.text = @"色度";
    
    [_InAview addSubview:color];

    
    
    
    
    _Nametext = [UITextField new];
    _Nametext.frame = CGRectMake(KscWith/15, CGRectGetMaxY(color.frame)+30, KscWith/5, 50);
    _Nametext.layer.borderColor = [UIColor blackColor].CGColor;
    _Nametext.layer.borderWidth = 0.5f;
    _Nametext.tag = 133333;
    _Nametext.delegate = self;
    [_InAview addSubview:_Nametext];
    
    _Naming = [UIButton buttonWithType:UIButtonTypeSystem];
    _Naming.frame = CGRectMake(CGRectGetMaxX(_Nametext.frame)+10, CGRectGetMaxY(color.frame)+35, KscWith/15, KscHeight/19);
    UIImage *image1 = [UIImage imageNamed:@"命名"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Naming setImage:image1 forState:UIControlStateNormal];
    [_Naming addTarget:self action:@selector(NamingAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Naming];
    
    _LightAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *imagelight = [UIImage imageNamed:@"+"];
    imagelight = [imagelight imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightAdd setImage:imagelight forState:UIControlStateNormal];
    [_LightAdd addTarget:self action:@selector(LightAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_LightAdd];
    
    _LightCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _LightCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(space.frame)+15, KscWith/15, KscHeight/19);
    UIImage *LightCut = [UIImage imageNamed:@"-"];
    LightCut = [LightCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_LightCut setImage:LightCut forState:UIControlStateNormal];
    [_LightCut addTarget:self action:@selector(LightCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_LightCut];
    
    _contrastadd = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastadd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastadd = [UIImage imageNamed:@"+"];
    contrastadd = [contrastadd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastadd setImage:contrastadd forState:UIControlStateNormal];
    [_contrastadd addTarget:self action:@selector(contrastaddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_contrastadd];
    
    
    _contrastCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _contrastCut.frame = CGRectMake(CGRectGetMaxX(_LightAdd.frame)+10, CGRectGetMaxY(light.frame)+15, KscWith/15, KscHeight/19);
    UIImage *contrastCut = [UIImage imageNamed:@"-"];
    contrastCut = [contrastCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_contrastCut setImage:contrastCut forState:UIControlStateNormal];
    [_contrastCut addTarget:self action:@selector(contrastCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_contrastCut];
    
    
    _Saturation = [UIButton buttonWithType:UIButtonTypeSystem];
    _Saturation.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *Saturation = [UIImage imageNamed:@"+"];
    Saturation = [Saturation imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Saturation setImage:Saturation forState:UIControlStateNormal];
    [_Saturation addTarget:self action:@selector(SaturationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Saturation];
    
    
    
    _SaturationCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _SaturationCut.frame = CGRectMake(CGRectGetMaxX(_Saturation.frame)+10, CGRectGetMaxY(dui.frame)+15, KscWith/15, KscHeight/19);
    UIImage *SaturationCut = [UIImage imageNamed:@"-"];
    SaturationCut = [SaturationCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_SaturationCut setImage:SaturationCut forState:UIControlStateNormal];
    [_SaturationCut addTarget:self action:@selector(SaturationCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_SaturationCut];
    
    
    _chromaAdd = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaAdd.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaAdd = [UIImage imageNamed:@"+"];
    chromaAdd = [chromaAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaAdd setImage:chromaAdd forState:UIControlStateNormal];
    [_chromaAdd addTarget:self action:@selector(chromaAddAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_chromaAdd];
    
    
    _chromaCut = [UIButton buttonWithType:UIButtonTypeSystem];
    _chromaCut.frame = CGRectMake(CGRectGetMaxX(_chromaAdd.frame) + 10, CGRectGetMaxY(baohe.frame)+15, KscWith/15, KscHeight/19);
    UIImage *chromaCut = [UIImage imageNamed:@"-"];
    chromaCut = [chromaCut imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_chromaCut setImage:chromaCut forState:UIControlStateNormal];
    [_chromaCut addTarget:self action:@selector(chromaCutAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_chromaCut];
    


    
    _Reset = [UIButton buttonWithType:UIButtonTypeSystem];
    _Reset.frame = CGRectMake(CGRectGetMaxX(_chromaCut.frame)+30, CGRectGetMaxY(dui.frame)+10, KscWith/12, KscHeight/17);
    UIImage *Reset = [UIImage imageNamed:@"复位"];
    Reset = [Reset imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_Reset setImage:Reset forState:UIControlStateNormal];
    [_Reset addTarget:self action:@selector(ResetAction:) forControlEvents:UIControlEventTouchUpInside];
    [_InAview addSubview:_Reset];
    
    _Cancle = [UIButton buttonWithType:UIButtonTypeSystem];
    _Cancle.frame = CGRectMake(CGRectGetMaxX(_Spacebutton.frame)-5, 5, 40, 40);
    [_Cancle setTitle:@"×" forState:UIControlStateNormal];
    _Cancle.tintColor = [UIColor whiteColor];
    _Cancle.layer.borderColor = [UIColor whiteColor].CGColor;
    _Cancle.layer.borderWidth = 0.8f;
    _Cancle.layer.cornerRadius = 20;
    _Cancle.layer.masksToBounds = YES;
    
    [_Cancle addTarget:self action:@selector(CancleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_InAview addSubview:_Cancle];

    _table = [[UITableView alloc]initWithFrame:CGRectMake(KscWith/9, CGRectGetMaxY(_ratioButton.frame), _ratioButton.frame.size.width, KscHeight/1.9) style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"InCell"];
    _table.hidden = YES;
    
    [_InAview addSubview:_table];
    
   //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadAction:) name:@"load" object:nil];
    
    
    
}

- (void)reloadAction:(NSNotification *)notice
{
    _ProInTable.view.hidden = YES;
    _Spacebutton.selected = NO;

    NSString *string = notice.userInfo[@"string"];
    [_Spacebutton setTitle:string forState:UIControlStateNormal];
    _Spacebutton.titleLabel.font = [UIFont systemFontOfSize:21];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _InGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InCell"];
    cell.textLabel.text = _InGroups[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    NSNumber *number = _InGroups[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",number];
   
    [_ratioButton setTitle:string forState:UIControlStateNormal];
    _ratioButton.titleLabel.font = [UIFont systemFontOfSize:23];
    _ratioButton.tintColor  = [UIColor blackColor];
    _table.hidden = YES;
    _ratioButton.selected = NO;
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
  
    NSNumber *Anumber= [SignalValue ShareValue].InArray[0];
    NSInteger integer = Anumber.integerValue;
    int a = (int)integer;
   
    NSInteger inte = indexPath.row;
    unsigned char bull = (unsigned char)inte;
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_RESOLUTION_OUTPUT, 1,&bull , buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
 
}





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

- (void)CancleAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//分辨率
- (void)ratioButtonAction:(UIButton *)button
{
     _ProInTable.view.hidden = YES;
    if (button.selected == NO) {
        _table.hidden = NO;
       
        button.selected = YES;
    }else
    {
        _table.hidden = YES;
        button.selected = NO;
    }
    
    
    
}


//色彩空间
- (void)SpacebuttonAction:(UIButton *)button
{
    _table.hidden = YES;
    _ratioButton.selected = NO;
    if (button.selected == NO) {
        self.ProInTable = [ProInTableViewController new];
        _ProInTable.view.frame = CGRectMake(CGRectGetMinX(_Spacebutton.frame), CGRectGetMaxY(_Spacebutton.frame), _Spacebutton.frame.size.width, KscHeight/2.8);
        [self.view addSubview:_ProInTable.view];
        [self addChildViewController:_ProInTable];
        button.selected = YES;
        
    }else
    {
        _ProInTable.view.hidden = YES;
        button.selected = NO;
        
    }
    
}


//命名
- (void)NamingAction:(UIButton *)button
{
    _Namestring = @"";
    UITextField *text = (UITextField *)[self.view viewWithTag:133333];
    NSString *Instring = text.text;
   
    [[SignalValue ShareValue].InArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *num = obj;
        NSInteger integer = num.integerValue;
        UIButton *button = [self.view viewWithTag:299+115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9+integer];
        
        NSString *string = [NSString stringWithFormat:@"%ld",(long)integer+299 +115*[SignalValue ShareValue].ProCount + 115*[SignalValue ShareValue].Integer/9];
        
        [[SignalValue ShareValue].InArray removeAllObjects];
        
        if (Instring.length <= 0) {
            
            NSString *title = [NSString stringWithFormat:@"%ld",(long)integer];
            [button setTitle:title forState:UIControlStateNormal];
            [[SignalValue ShareValue].InArray removeObject:num];
            button.backgroundColor = [UIColor whiteColor];
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            _Namestring = title;
            
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:title];
   
            
        }else if (Instring.length >= 5){
            
            NSString *str = [Instring substringToIndex:5];
            button.titleLabel.text = str;
            
            _Namestring = str;
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:str];
            [DataBaseHelp SelectTemp:integer Type:tage];
            [DataBaseHelp SelectTemp:integer Type:tage];
   
            
        }else if (Instring.length < 5 &&Instring.length > 0)
        {
            [button setTitle:Instring forState:UIControlStateNormal];
            
            _Namestring = Instring;
            unsigned char integer = [SignalValue ShareValue].Integer/9;
            unsigned char tage = (char)[SignalValue ShareValue].ProCount;
            [DataBaseHelp CreatTable];
            [DataBaseHelp DeleteWithTemp:integer type:tage Key:string];
            [DataBaseHelp InsertIntoTemp:integer Type:tage Key:string Values:Instring];
            
        }
    }];
    [[SignalValue ShareValue].InArray removeAllObjects];
    
    //创建通知
    NSDictionary *dict = @{@"ProIn":_Namestring};
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ProInNot" object:nil userInfo:dict];

    [self dismissViewControllerAnimated:YES completion:nil];
    [[SignalViewController new]reloadInputViews];
    
}
    

//亮度加
- (void)LightAddAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;

    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_BRIGHTNESS_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
    
    
}

//亮度减
- (void)LightCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
 
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_BRIGHTNESS_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度减
- (void)contrastCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;

    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//对比度加
- (void)contrastaddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
  
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_CONTRAST_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//饱和度加
- (void)SaturationAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//饱和度减
- (void)SaturationCutAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_SATURATION_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//色度加
- (void)chromaAddAction:(UIButton *)button
{
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 1;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
    
    unsigned char cardid =(unsigned char)a;
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
   // [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
}

//色度减
- (void)chromaCutAction:(UIButton *)button
{
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
    int a = (int)integer;
 
    unsigned char cardid =(unsigned char)a;

    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,V_HUE_UP_DOWN, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
  //  [udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
}

//复位
- (void)ResetAction:(UIButton *)button
{
    
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    unsigned char num = 0x01;
    NSNumber *number = [SignalValue ShareValue].InArray[0];
    NSInteger integer = number.integerValue;
     int a = (int)integer;
   
    unsigned char cardid =(unsigned char)a;

    
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_INPUT,cardid,C_SYSTEM_RESET, 1, &num, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
    //[udpSocket bindToPort:[SignalValue ShareValue].SignalPort error:nil];
    [udpSocket receiveOnce:nil];
    
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
    if (tag == 544) {
        NSLog(@"标记为200的数据发送完成了");
    }
}
//发送失败
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"标记为tag %ld的发送失败 失败原因 %@",tag,error);
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    _InAview.frame = CGRectMake(_InAview.frame.origin.x, _InAview.frame.origin.y - 158, _InAview.frame.size.width, _InAview.frame.size.height);
    
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _InAview.frame = CGRectMake(_InAview.frame.origin.x, _InAview.frame.origin.y+158, _InAview.frame.size.width, _InAview.frame.size.height);
   
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

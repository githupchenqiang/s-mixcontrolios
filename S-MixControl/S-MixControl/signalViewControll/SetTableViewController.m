//
//  SetTableViewController.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/20.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "SetTableViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
#import "ProConnect.h"


@interface SetTableViewController ()<UITableViewDataSource,UITableViewDelegate,GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
}
@property (nonatomic ,strong)NSArray *array;

@end

@implementation SetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Table"];
    
    _array = @[@"RGB ",@"YUV444",@"YUV422",@"YUV422(16bit)"];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   
    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table" forIndexPath:indexPath];
    cell.textLabel.text = _array[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *number = _array[indexPath.row];
    NSString *string = [NSString stringWithFormat:@"%@",number];
//
//    UIButton *button = (UIButton*)[self.view viewWithTag:355555];
//    button.titleLabel.text = string;
//    
    //创建通知
    NSDictionary *dict = @{@"Out":string};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"OutName" object:nil userInfo:dict];
    
    //初始化udpsocket
    udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    unsigned char buf[256] = {0};
    
    NSNumber *Anumber= [SignalValue ShareValue].OutArray[0];
   
    NSInteger integer = Anumber.integerValue;
    int a = (int)integer;
    NSInteger inte = indexPath.row;
    unsigned char bull = (unsigned char)inte;

    unsigned char cardid =(unsigned char)a;
   
    NSInteger length = make_boardcard_pack_5555(METHOD_SET, CARD_OUTPUT,cardid,V_COLOR_SPACE_OUTPUT, 1,&bull, buf);
    NSData *data1 = [NSData dataWithBytes:(void *)&buf  length:length];
  
    [udpSocket sendData:data1 toHost:[SignalValue ShareValue].SignalIpStr port:[SignalValue ShareValue].SignalPort withTimeout:60 tag:544];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

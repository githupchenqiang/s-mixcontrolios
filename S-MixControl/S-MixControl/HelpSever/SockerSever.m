//
//  SockerSever.m
//  S-MixControl
//
//  Created by aa on 15/12/3.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "SockerSever.h"
#import "GCDAsyncUdpSocket.h"
#import "SignalValue.h"
@interface SockerSever ()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *_udpSocket;
    
}
@end


@implementation SockerSever

+(SockerSever *)SharedSocket
{
    static SockerSever *socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        socket = [SockerSever new];
    });
    
    return socket;
}

//创建socket
- (void)RequestSocketWithPort:(uint16_t)port
{
    _udpSocket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_udpSocket bindToPort:port error:nil];
    [_udpSocket receiveOnce:nil];
    

}

//发送数据
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    
    NSString *ip = [GCDAsyncUdpSocket hostFromAddress:address];
    uint16_t port = [GCDAsyncUdpSocket portFromAddress:address];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    [sock receiveOnce:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self SendBackToHost:ip port:port withMessage:str];
    });

}

- (void)SendBackToHost:(NSString *)ip port:(uint16_t)port withMessage:(NSString *)str
{
    NSString *Msg = @"我在发送消息";
    NSData *data = [Msg dataUsingEncoding:NSUTF8StringEncoding];
    [_udpSocket sendData:data toHost:ip port:port withTimeout:60 tag:201];
    
}



@end

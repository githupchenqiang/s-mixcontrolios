//
//  SockerSever.h
//  S-MixControl
//
//  Created by aa on 15/12/3.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SockerSever : NSObject
+ (SockerSever *)SharedSocket;

- (void)RequestSocketWithPort:(uint16_t)port;


- (void)SendBackToHost:(NSString *)host port:(uint16_t)port withMessage:(NSString *)str;



@end

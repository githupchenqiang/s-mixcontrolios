//
//  ConnectPort.m
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import "ConnectPort.h"

@implementation ConnectPort

//打印
kice_t scene_print_cmd(unsigned char num)
{
    kice_t kic;
    kice_command_t kic_c;
    //
    kic.sync = 0x90EB;
    kic.size = 0x0B;
    kic.id = 0x80;
    
    kic_c.command = 0x07;
    kic_c.arg_size = 0x01;
    kic_c.arg[0] = num;
    
    memset(&(kic.data),0,ICE_MAX_DATA_SIZE + 2);
    memcpy(&(kic.data), &kic_c , 3);
    
    return kic;
}

//切换
kice_t signal_map_cmd(unsigned char in, unsigned char *out, unsigned char out_size, unsigned char in_type)
{
    kice_t kic;
    kice_command_t kic_c;
    unsigned char buf[512] = {0};
    memcpy(&buf, out, out_size);
    kic.sync = 0x90EB;
    kic.size = 11 + out_size;
    kic.id = 0x80;
    
    kic_c.command = 0x0c;
    kic_c.arg_size = out_size + 1;
    kic_c.arg[0] = in - 1;
    
    unsigned int i = 0;
    for( ; i < out_size; i++)
    {
        buf[i] +=  in_type -1;
    }
    memcpy(&kic_c.arg[1], buf , out_size);
    
    memset(&(kic.data),0,ICE_MAX_DATA_SIZE + 2);
    memcpy(&(kic.data), &kic_c , 3+out_size);
    return kic;
  
}


//保存场景0-11
kice_t scene_save_cmd(unsigned char savesid)
{

    kice_t kic;
    kice_command_t kic_c;
    //
    kic.sync = 0x90EB;
    kic.size = 10 + 2;
    kic.id = 0x80;
    
    kic_c.command = 0x09;
    kic_c.arg_size = 0x02;
    kic_c.arg[0] = savesid;
    kic_c.arg[1] = 0x0;
    memset(&(kic.data),0,ICE_MAX_DATA_SIZE + 2);
    memcpy(&(kic.data), &kic_c , 2+2);
    
    return kic;
}

//载入场景
kice_t scene_load_cmd(unsigned char loadsid)
{
    kice_t kic;
    kice_command_t kic_c;
    //
    kic.sync = 0x90EB;
    kic.size = 10 + 2;
    kic.id = 0x80;
    
    kic_c.command = 0x08;
    kic_c.arg_size = 0x02;
    kic_c.arg[0] = 0x0;
    kic_c.arg[1] = loadsid;
    memset(&(kic.data),0,ICE_MAX_DATA_SIZE + 2);
    memcpy(&(kic.data), &kic_c , 2+2);
    
    return kic;
}

kice_t global_config_print_cmd()
{
    kice_t kic;
    kice_command_t kic_c;
    kic.sync = 0x90EB;
    kic.size = 0x0B; 
    kic.id = 0x80;
    
    kic_c.command = 0x05;
    kic_c.arg_size = 0x0;
    memset(&(kic.data), 0, ICE_MAX_DATA_SIZE + 2);
    memcpy(&(kic.data), &kic_c, 2);
    
    return kic;
}



@end

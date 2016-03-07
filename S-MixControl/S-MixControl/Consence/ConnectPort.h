//
//  ConnectPort.h
//  S-MixControl
//
//  Created by aa on 15/12/1.
//  Copyright © 2015年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#ifndef __S_MIX_PROTOCOL_H
#define __S_MIX_PROTOCOL_H

#define ICE_MAX_DATA_SIZE 514
#define GSM_MAX_TOTAL 300
enum
{
    GSM_CMD_CONFIG_PRINT = 0x05,	//print config
    GSM_CMD_CONFIG_SAVE = 0x06,		// save config
    
    GSM_CMD_SCENE_PRINT = 0x07,		// print scene
    GSM_CMD_SCENE_LOAD = 0x08,		//load scene
    GSM_CMD_SCENE_SAVE = 0x09,		// save scene
    
    GSM_CMD_PORT_INIT = 0x0A,		//port init
    GSM_CMD_PORT_SWITCH = 0x0B,		//port switch
    GSM_CMD_PORT_MAP = 0x0C,		// port map
    GSM_CMD_PORT_CONFIG = 0x0D,		// port config
    
    GSM_CMD_ACK_SUCCESS = 0x10,		//response success
    GSM_CMD_ACK_DATA = 0x20,		//response success & return data
    GSM_CMD_ACK_INVALID = 0x30,		//response invalid
    GSM_CMD_ACK_ERROR = 0x40		//response parameter error

};


typedef struct kice{
    unsigned short sync;
    unsigned short size;
    unsigned short id;
    unsigned char data[ICE_MAX_DATA_SIZE + 2];
  
}kice_t;

typedef struct kice_command
{
    
    unsigned char command;
    unsigned char arg_size;
    unsigned char arg[ICE_MAX_DATA_SIZE -2];
  
}kice_command_t;


typedef struct sw_state
{
    unsigned int flag;	//0xEB9055AA
    unsigned char total; //total port
    unsigned char input; //input port
    unsigned char output; //output port
    unsigned char group[GSM_MAX_TOTAL];
    
}sw_state_t;


typedef struct global_config
{
    unsigned int flag;	//0xEB9055AA
    unsigned char hardware_version[2];
    unsigned char firmware_version[2];
    unsigned char sn[4];
    
    unsigned char gateway[4];
    unsigned char subnet[4];
    unsigned char src_mac[6];
    unsigned char src_ip[4];
    unsigned short udp_port;
    unsigned short tcp_port;
    
    unsigned char total;
    unsigned char input;
    unsigned char output;
    unsigned char rsv0;
    
}global_config_t;


#ifdef __cplusplus
extern "C"
{
#endif
    //scene
    /*
     *num: print num scene　[0~11], 0 is current scene.
     */
    kice_t scene_print_cmd(unsigned char num);
    
    /*
     *savesid: current scene id	[0~11]
     */
    kice_t scene_save_cmd(unsigned char savesid);
    
    /*
     *loadsid: will be load scene id	[0~11]
     */
    kice_t scene_load_cmd(unsigned char loadsid);
    
    //signal map
    /*
     *in : input [0~in_type]
     *out: output(NULL,1,2,3,4,5...)
     *out_size: output numbers
     *in_type: s-mix type, such as 9x9 in_type=9; 18x18 in_type=18
     *describle: when *out= NULL , out_size=0. the in's signal will not be output all port
     */
    kice_t signal_map_cmd(unsigned char in, unsigned char *out, unsigned char out_size, unsigned  char in_type);
    
    //print config
    kice_t global_config_print_cmd();
    
#ifdef __cplusplus
}
#endif



@interface ConnectPort : NSObject








@end

//
//  ProConnect.h
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/12.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef __S_MIX_PRO_PROTOCOL_H
#define __S_MIX_PRO_PROTOCOL_H

#ifdef __cplusplus
extern "C" {
#endif
    
    
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#pragma pack(1)//设定为4字节对齐
#define _FUNCTION_PACKET_5555_
    
#ifdef _FUNCTION_PACKET_5555_
    //注意协议的单位都为BYTE 所以将两个BYTE合成一个short的时候需要进行位移操作以交换顺序
    typedef struct _pack_5555_head_
    {
        unsigned short syn;
        unsigned short pack_len;
        unsigned short pack_count;
        unsigned char  method;
        unsigned short cmd;
        unsigned short cmd_parameter_len;
        
    }pack_5555_head_t,*pPack_5555_head_t;
    
    //METHOD
#define METHOD_GET            0x01
#define	METHOD_SET			  0x02
#define	METHOD_RETURN_GET     0x11
#define	METHOD_RETURN_SET     0x12
#define	METHOD_EVENT          0x05
    //CMD
#define	CMD_GLOBAL_ALL 		 				0x00FE
#define	CMD_GLOBAL_INPORT 	 				0x0001
#define	CMD_GLOBAL_OUTPORT 	 				0x0002
#define	CMD_GLOBAL_VERSION 	 				0x0004
#define	CMD_GLOBAL_SN 		 				0x0005
#define	CMD_GLOBAL_STARTCOUTER				0x0006
#define	CMD_GLOBAL_BUZZER 		 			0x0007
#define	CMD_GLOBAL_CONFIG_COM 		 		0x0008
#define	CMD_GLOBAL_CONFIG_NET 		 		0x0009
#define	CMD_GLOBAL_TEMPERATURE 		 		0x000A
#define	CMD_GLOBAL_LANGUAGE 		 		0x000B
    
#define	CMD_SCREEN_SWITCH_ALL 		 		0x01FE
#define	CMD_SCREEN_SWITCH_INPORT 		 	0x0101
#define	CMD_SCREEN_SWITCH_OUTPORT		 	0x0102
#define	CMD_SCREEN_SWITCH_STATUSTABLE		0x0103
#define	CMD_SCREEN_SWITCH_STATUSMAP 		0x0104
    
#define	CMD_BOARDCARD_ONLINE_ALL 		 	0x02FE
#define	CMD_BOARDCARD_ONLINE_INPORT 		0x0201
#define	CMD_BOARDCARD_ONLINE_OUTPORT		0x0202
#define	CMD_BOARDCARD_ONLINE_STATUSTABLE	0x0203
#define	CMD_BOARDCARD_ONLINE_STATUSSINGLE	0x0204
    
#define	CMD_BOARDCARD_CONFIG_ALL  		 	0x03FE
#define	CMD_BOARDCARD_CONFIG_INPORT 		0x0301
#define	CMD_BOARDCARD_CONFIG_OUTPORT		0x0302
    //设置板块相关信息
#define	CMD_BOARDCARD_CONFIG_ID 			0x0304
    
#define	CMD_SENCE_SWITCH_ALL 		 		0x04FE
#define	CMD_SENCE_SWITCH_NUMBER		 		0x0401
#define	CMD_SENCE_SWITCH_ID_GAIN		 	0x0402
#define	CMD_SENCE_SWITCH_ID_LOAD		 	0x0403
#define	CMD_SENCE_SWITCH_ID_SAVE		 	0x0404
    
#define	CMD_SENCE_BACKUP_STATE		 	0x0501
    
#define	CMD_SENCE_CORE_CTRL     0x0701
    
#define  V_SET_BOOT_CONFIG_INFO   0x0920
#define  V_GET_APP_FILE_INFO      0x0921
#define  V_GET_APP_FILE_BLOCK 	  0x0922
    
    //板块的具体命令通过矩阵发送
    
    //前面接;    CMD_BOARDCARD_CONFIG_ID 			0x0304
    // 输入输出号;
#define    CARD_INPUT				0x00
#define    CARD_OUTPUT				0x01
    
    
    //视屏输出方向相关命令;
#define    		V_RESOLUTION_OUTPUT		0x0001
#define    		V_COLOR_SPACE_OUTPUT	0x0002
#define    		V_BRIGHTNESS			0x0003
#define    		V_CONTRAST				0x0004
#define    		V_SATURATION			0x0005
#define    		V_HUE					0x0006
#define    		V_VGA_ADJUST			0x0007
#define    		V_GAIN_R				0x0008
#define    		V_GAIN_G				0x0009
#define    		V_GAIN_B				0x0010
#define    		V_OFFSET_R				0x0011
#define    		V_OFFSET_G				0x0012
#define    		V_OFFSET_B				0x0013
#define    		V_BRIGHTNESS_UP_DOWN	0x000a
#define    		V_CONTRAST_UP_DOWN		0x000b
#define    		V_SATURATION_UP_DOWN	0x000c
#define    		V_HUE_UP_DOWN			0x000d
#define    		V_ZOOM_IMAGE_UP_DOWN	0x000e
#define    		V_ZOOM_IMAGE_MIRROR		0x000F
    
    // 视屏输入方向相关命令
#define    		V_RESOLUTION_INPUT		0x0101
#define    		V_COLOR_SPACE_INPUT		0x0102
#define    		V_PORT_INPUT			0x0103
    
    //基本信息
#define    		B_NAME					0x0201
#define    		B_CLASS					0x0202
#define    		B_VERSION				0x0203
#define    		B_SITE					0x0204
#define    		B_USER_OSD				0x0205
#define    		B_ONLINE				0x0206
    
    
    //控制信息

#define    		C_SCREEN_ONOFF			0x0301
#define    		C_SCREEN_PAUSE			0x0302
#define    		C_UPDATE				0x0303
#define    		C_IR_ONOFF				0x0304
#define    		C_USART_ONOFF			0x0305
#define    		C_EVENT_ONOFF			0x0306
#define    		C_SYSTEM_RESET			0x0307
    
    //输入音频控制信息 
#define    		A_SOURCE				0x0401
    
    
    //注意协议的单位都为BYTE 所以将两个BYTE合成一个short的时候需要进行位移操作以交换顺序
#define EXCHANGE16BIT(X) ((((unsigned short)(X) & 0xff00) >> 8) |(((unsigned short)(X) & 0x00ff) << 8))
    
#define EXCHANGE32BIT(x) ((unsigned int)(				\
    (((unsigned int)(x) & (unsigned int)0x000000ffUL) << 24) |		\
    (((unsigned int)(x) & (unsigned int)0x0000ff00UL) <<  8) |		\
    (((unsigned int)(x) & (unsigned int)0x00ff0000UL) >>  8) |		\
    (((unsigned int)(x) & (unsigned int)0xff000000UL) >> 24)))

#endif
    
#pragma pack()//ª÷∏¥∂‘∆Î◊¥Ã¨;
    
#ifdef __cplusplus
}
#endif

#endif
@interface ProConnect : NSObject

int make_pack_5555(unsigned char method, unsigned short cmd, unsigned short cmd_parameter_len, unsigned char* cmd_parameter_data_in, unsigned char * buf_out);

int make_boardcard_pack_5555(unsigned char method, unsigned char input_output,unsigned char id,unsigned short cmd,unsigned short cmd_parameter_len,unsigned char* cmd_parameter_data_in, unsigned char * buf_out);

int make_ctr_pack_5555(unsigned char method, unsigned char input_output,unsigned char id,unsigned short cmd_parameter_len,unsigned char* cmd_parameter_data_in, unsigned char * buf_out);

@end

//
//  ProConnect.m
//  S-MixControl
//
//  Created by chenq@kensence.com on 16/1/12.
//  Copyright © 2016年 KaiXingChuangDa. All rights reserved.
//

#import "ProConnect.h"

#include<string.h>

#ifdef _FUNCTION_PACKET_5555_

#endif
@implementation ProConnect
int make_pack_5555(unsigned char method, unsigned short cmd, unsigned short cmd_parameter_len, unsigned char* cmd_parameter_data_in, unsigned char * buf_out)
{
    static unsigned short msg_pack_count = 0;
    
    unsigned char crc_check_data = 0;
    
    unsigned short total_pack_len = 0;
    
    pack_5555_head_t head;
    
    head.syn = 0x5555;
    
    total_pack_len = (sizeof(pack_5555_head_t)+cmd_parameter_len+1);//∞¸∫¨CRC 1 char;
    
    head.pack_len = EXCHANGE16BIT(total_pack_len);
    
    head.pack_count = EXCHANGE16BIT(msg_pack_count);
    
    msg_pack_count++;
    
    head.method = (method);
    
    head.cmd = EXCHANGE16BIT(cmd);
    head.cmd_parameter_len = EXCHANGE16BIT(cmd_parameter_len);
    
    memcpy(buf_out, &head, sizeof(pack_5555_head_t));//∞¸Õ∑;
    memcpy(buf_out+sizeof(pack_5555_head_t), cmd_parameter_data_in, cmd_parameter_len);    
    crc_check_data = 0;
    memcpy(buf_out+sizeof(pack_5555_head_t)+cmd_parameter_len,&crc_check_data,1);//crc≥§∂»1
    
    return total_pack_len;//º”…œCRC;
}

int make_boardcard_pack_5555(unsigned char method, unsigned char input_output,unsigned char id,unsigned short cmd,unsigned short cmd_parameter_len,unsigned char* cmd_parameter_data_in, unsigned char * buf_out)
{
    unsigned char temp_make_packet_buf_out[1024] = { 0 };
    unsigned char temp_card_param_buf[1024] = { 0 };
    unsigned short temp_short = 0;
    int res = 0;
    int temp_packet_len = 0;
    
    if (cmd_parameter_len > 254){ return 0; }
    
    //…Ë÷√ ‰»Î ‰≥ˆ;
    temp_card_param_buf[0] = input_output;
    temp_card_param_buf[1] = id;
    
    //…Ë÷√∞Âø®√¸¡Ó;
    temp_short = EXCHANGE16BIT(cmd);
    memcpy(&temp_card_param_buf[2], &temp_short, 2);
    
    //…Ë÷√∞Âø®√¸¡Ó≤Œ≥§;
    temp_short = EXCHANGE16BIT(cmd_parameter_len);
    memcpy(&temp_card_param_buf[4], &temp_short, 2);
    
    
    //∞Âø®√¸¡Ó ˝æ›;
    memcpy(&temp_card_param_buf[6], cmd_parameter_data_in, cmd_parameter_len);
    
    res = make_pack_5555(method, CMD_BOARDCARD_CONFIG_ID, cmd_parameter_len + 6, temp_card_param_buf, temp_make_packet_buf_out);
    
    memcpy(buf_out, temp_make_packet_buf_out, res);
    
    return res;
}

int make_ctr_pack_5555(unsigned char method, unsigned char input_output,unsigned char id,unsigned short cmd_parameter_len,unsigned char* cmd_parameter_data_in, unsigned char * buf_out)
{
    unsigned char temp_make_packet_buf_out[1024]={0};
    unsigned char temp_ctr_param_buf[1024]={0};
    unsigned short temp_short=0;
    int res=0;
    int temp_packet_len=0;
    
    if(cmd_parameter_len>254){return 0;}
    
    //…Ë÷√ ‰»Î ‰≥ˆ;
    temp_ctr_param_buf[0]=input_output;
    temp_ctr_param_buf[1]=id;
    
    //÷–øÿ√¸¡Ó ˝æ›;
    memcpy(&temp_ctr_param_buf[2],cmd_parameter_data_in,cmd_parameter_len);
    
    res=make_pack_5555(method,CMD_SENCE_CORE_CTRL,cmd_parameter_len+2,temp_ctr_param_buf,temp_make_packet_buf_out);
    
    memcpy(buf_out,temp_make_packet_buf_out,res);
    
    return res;
}
@end

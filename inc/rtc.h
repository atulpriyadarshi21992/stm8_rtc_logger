#ifndef __RTC_H__
#define __RTC_H__

#include "stm8s.h"
#include "stm8s_type.h"
#include "i2c_master_poll.h"

typedef struct 
{
    u8 Second;
    u8 Minute;
    u8 Hour;
    u8 Date;
    u8 Month;
    u8 Year;
}time_t;

extern time_t time_now;


bool SetTimeRTC(time_t *t);
bool ReadTimeRTC(void);
bool BufferToTime(time_t *t,u8 *buf);

u8 dec2bcd(u8 num);

u8 bcd2dec(u8 num);


bool Verify_RTC(void);
bool Setup_RTC_Chip(void);
void RTC_Start(void);
void RTC_Stop(void);

bool SetInternalTime(u8* time_buf);
#endif
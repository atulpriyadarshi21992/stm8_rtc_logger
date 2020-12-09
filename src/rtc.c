#include "rtc.h"

#include "stm8s_type.h"

#include "i2c_master_poll.h"

time_t time_now;



bool SetTimeRTC(time_t *t)
{
    // RTC_Stop();

    // I2C_WriteRegister(0x00,1,dec2bcd(t->Second));
    // I2C_WriteRegister(0x01,1,dec2bcd(t->Minute));
    // I2C_WriteRegister(0x02,1,dec2bcd(t->Hour));
    // I2C_WriteRegister(0x04,1,dec2bcd(t->Date));
    // I2C_WriteRegister(0x05,1,dec2bcd(t->Month));
    // I2C_WriteRegister(0x06,1,dec2bcd(t->Year-2000));

    // RTC_Start();
    return TRUE;
}
bool ReadTimeRTC(void)
{

    u8 rx_buff[7]={0};
    set_tout_ms(10);
    I2C_ReadRegister(0,7,rx_buff);
    if(!BufferToTime(&time_now,rx_buff))
        return FALSE;
    return TRUE;
    

}

bool BufferToTime(time_t *t,u8 *buf)
{
    if(!(buf[0] & 0b10000000))              //Oscillator Stopped
    {
        return FALSE;
    }

    t->Second=bcd2dec((buf[0]&0x7F));
    t->Minute=bcd2dec((buf[1]&0x7F));
    t->Hour  =bcd2dec((buf[2]&0x3F));
    t->Date=bcd2dec((buf[4]&0x3F));
    t->Month=bcd2dec((buf[5]&0x1F));
    t->Year=bcd2dec(buf[6])+2000;

    return TRUE;

}
/*----------------------------------------------------------------------------*/
/*BCDTODEC*/
/*----------------------------------------------------------------------------*/
u8 bcd2dec(u8 num)
{
    return ((num/16 * 10) + (num % 16));
}


/*----------------------------------------------------------------------------*/
/*DECTOBCD*/
/*----------------------------------------------------------------------------*/
u8 dec2bcd(u8 num)
{
    return ((num/10 * 16) + (num % 10));
}

bool Verify_RTC(void)
{
    u8 val=0;
    set_tout_ms(10);
    I2C_ReadRegister(0x03,1,&val);

    if(!(val & 0b00100000))         //Oscillator Stopped
        return FALSE;
    if((val & 0b00010000))          //Power Failed
        return FALSE;
    if(!(val & 0b00001000))         //Ext Power Not Enabled
        return FALSE;
    set_tout_ms(10);
    I2C_ReadRegister(0x02,1,&val);
    if(val & 0b01000000)
        return FALSE;

    return TRUE;
}
bool Setup_RTC_Chip(void)
{
		u8 val=0;
    RTC_Start();

    set_tout_ms(10);
    I2C_ReadRegister(0x03,1,&val);

    val|=(0b00001000);              //Enable Ext Power
    val&=(0b11101111);              //Clear Power Failed bit
    set_tout_ms(10);
    I2C_WriteRegister(0x03,1,&val);
    set_tout_ms(10);
    I2C_ReadRegister(0x02,1,&val);
    val&=(0b10111111);
    set_tout_ms(10);
    I2C_WriteRegister(0x02,1,&val);
    
    return Verify_RTC();
}
void RTC_Start(void)
{
    u8 val=0;
    set_tout_ms(10);
    I2C_ReadRegister(0,1,&val);
    val=val|0b10000000;
    set_tout_ms(10);
    I2C_WriteRegister(0,1,&val);
}
void RTC_Stop(void)
{
    u8 val=0;
    set_tout_ms(10);
    I2C_ReadRegister(0,1,&val);
    val=val&0b01111111;
    set_tout_ms(10);
    I2C_WriteRegister(0,1,&val);
}
bool SetInternalTime(u8* time_buf)
{
    time_t new_time;

    new_time.Second =time_buf[0];
    new_time.Minute =time_buf[1];
    new_time.Hour   =time_buf[2];
    new_time.Date   =time_buf[3];
    new_time.Month  =time_buf[4];
    new_time.Year   =time_buf[5]+2000;

    return SetTimeRTC(&new_time);
}
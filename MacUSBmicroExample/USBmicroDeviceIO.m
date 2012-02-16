//
//  USBmicroDeviceIO.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/17/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#include <CoreFoundation/CoreFoundation.h>
//#include <wchar.h>
//#include <locale.h>
//#include <pthread.h>
//#include <sys/time.h>
//#include <unistd.h>

#define READTIMEOUT 1

#import "USBmicroDeviceIO.h"

@implementation USBmicroDeviceIO

@synthesize usbMicroVendorId = _usbMicroVendorId;
@synthesize usbMicroProductId = _usbMicroProductId;
@synthesize usbMicroSerialNbr = _usbMicroSerialNbr;

@synthesize device = _device;
@synthesize portAReadWriteState = _portAReadWriteState;
@synthesize portBReadWriteState = _portBReadWriteState;
@synthesize portAValue = _portAValue;
@synthesize portBValue = _portBValue;

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.usbMicroVendorId = 0xde7;
        self.usbMicroProductId = 0;
        self.usbMicroSerialNbr = malloc(256);
        memset(self.usbMicroSerialNbr, 0, 256);
        self.device = NULL;
        self.portAReadWriteState = 0;
        self.portBReadWriteState = 0;
        self.portAValue = 0;
        self.portBValue = 0;
    }
    
    return self;
}

- (BOOL)initializeDevice
{
    @synchronized(self) 
    {
        self.device = hid_open(self.usbMicroVendorId, self.usbMicroProductId, self.usbMicroSerialNbr);
        if (self.device == NULL)
        {
            NSLog(@"initializeDevice: Couldn't open usbMicro device with serial number %ls", self.usbMicroSerialNbr);
            return NO;
        }
        
        hid_set_nonblocking(self.device, true);
        
        return YES;
    }
}

- (void)terminateDevice
{
    @synchronized(self) 
    {
        hid_close(self.device);
        self.device = NULL;
    }
}

- (unsigned char) stateForPort:(PortId)p_PortId
{
    if (p_PortId == PORTID_A)
        return self.portAReadWriteState;
    else
        return self.portBReadWriteState;
}

- (void) setStateForPort:(PortId)p_PortId 
                      to:(unsigned char)p_State
{
    if (p_PortId == PORTID_A)
        self.portAReadWriteState = p_State;
    else
        self.portBReadWriteState = p_State;
}

- (BOOL)setReadWriteStateForPort:(PortId)p_PortId
{
    unsigned char state;
    if (p_PortId == PORTID_A)
        state = self.portAReadWriteState;
    else
        state = self.portBReadWriteState;
    return [self setReadWriteStateForPort:p_PortId toState:state];
}

- (BOOL)setReadWriteStateForPort:(PortId)p_PortId 
                         toState:(unsigned char)p_State
{
    @synchronized(self) 
    {
        unsigned char data[8];
        memset(data, 0, 8);
        if (p_PortId == PORTID_A)
            data[0] = 0x9;  // DirectionA
        else
            data[0] = 0xa;  // DirectionB
        data[1] = p_State;
        
        return [self writeData:data length:8];
    }
}

- (BOOL)setReadWriteStateForPort:(PortId)p_PortId 
                          andPin:(unsigned char)p_PinNbr 
                         toWrite:(BOOL)p_Write
{
    unsigned char state = [self stateForPort:p_PortId];
        
    if (p_Write)
        state = state | (1<<p_PinNbr);
    else
        state = state ^ (1<<p_PinNbr);
    
    BOOL succeeded = [self setReadWriteStateForPort:p_PortId toState:state];
    if (succeeded)
    {
        [self setStateForPort:p_PortId to:state];            
    }
    
    return succeeded;
}

- (BOOL)readPort:(PortId)p_PortId
{
    @synchronized(self) 
    {
        unsigned char data[9];
        memset(data, 0, 8);
        if (p_PortId == PORTID_A)
            data[0] = 0x5; // ReadA
        else
            data[0] = 0x6; // ReadB
        if (![self writeData:data length:8])
            return NO;
        
        memset(data, 0, 8);
        if (![self readData:data length:8])
            return NO;

        [self setValueForPort:p_PortId to:data[1]];
        
        return YES;
    }
}

- (BOOL)writePort:(PortId)p_PortId
{
    @synchronized(self) 
    {
        unsigned char data[8];
        memset(data, 0, 8);
        if (p_PortId == PORTID_A)
        {
            data[0] = 0x1;  // WriteA
            data[1] = self.portAValue; 
        }
        else
        {
            data[0] = 0x2;  // WriteB
            data[1] = self.portBValue; 
        }
        if (![self writeData:data length:8])
            return NO;
        
        return YES;
    }
}

- (unsigned char)valueForPort:(PortId)p_PortId
{
    if (p_PortId == PORTID_A)
        return self.portAValue;
    else
        return self.portBValue;
}

- (void)setValueForPort:(PortId)p_PortId to:(unsigned char)p_Value
{
    @synchronized(self) 
    {
        if (p_PortId == PORTID_A)
            self.portAValue = p_Value;
        else
            self.portBValue = p_Value;
    }
}

- (BOOL)valueForPort:(PortId)p_PortId andPin:(unsigned char)p_PinNbr
{
    if (p_PortId == PORTID_A)
        return (BOOL)self.portAValue & (1<<p_PinNbr);
    else
        return (BOOL)self.portBValue & (1<<p_PinNbr);
}

- (void)setValueForPort:(PortId)p_PortId andPin:(unsigned char)p_PinNbr to:(BOOL)p_On
{
    unsigned char value = [self valueForPort:p_PortId];

    if (p_On)
        value = value | (1<<p_PinNbr);
    else
        value = value ^ (1<<p_PinNbr);

    [self setValueForPort:p_PortId to:value];
}

- (BOOL)readData: (unsigned char[])p_Data
          length: (int)p_DataLen
{
    int idx = 0;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    while (idx < p_DataLen && CFAbsoluteTimeGetCurrent() - startTime < READTIMEOUT)
    {
        int qtyRead = hid_read(self.device, p_Data + idx, p_DataLen);
        idx += qtyRead;
    }

    if (idx != p_DataLen)
    {
        NSLog(@"readPortB: hid_read returned %d", idx);
        return NO;
    }
    
    return YES;
}

- (BOOL)writeData: (unsigned char[])p_Data
           length: (int)p_DataLen
{
    int qtyWritten = hid_write(self.device, p_Data, p_DataLen);
    if (qtyWritten != p_DataLen)
    {
        NSLog(@"writeData: hid_write returned %d", qtyWritten);
        return NO;
    }
    
    return YES;
}

- (BOOL) init1WireForPort:(PortId)p_PortId 
                   andPin:(unsigned char)p_PinNbr
{
    // Make sure the pin is set to write
    unsigned char state = [self stateForPort:p_PortId];
    [self setStateForPort:p_PortId to:state|(1<<p_PinNbr)];
    return [self setReadWriteStateForPort:p_PortId];

//    // Not sure if this should maybe call initSPI or not.  There was commented code in the original.
//    return YES;
}

- (BOOL) reset1WireForPort:(PortId)p_PortId 
                    andPin:(unsigned char)p_PinNbr
{
    @synchronized(self) 
    {
        unsigned char data[8];
        memset(data, 0, 8);
        data[0] = 0x1d;  // Reset1Wire
        data[1] = [self pinCodeForPort:p_PortId andPin:p_PinNbr];
        
        return [self writeData:data length:8];
    }
}

- (BOOL) write1WireValue:(unsigned char)p_Value
                 forPort:(PortId)p_PortId 
                  andPin:(unsigned char)p_PinNbr
                 bitOnly:(BOOL)p_BitOnly
{
    @synchronized(self) 
    {
        unsigned char data[8];
        memset(data, 0, 8);
        data[0] = 0x1e;  // Write1Wire
        data[1] = p_Value;
        data[2] = (unsigned char)p_BitOnly;
        
        return [self writeData:data length:8];
    }
}

- (BOOL) read1WireValue:(unsigned char *)p_Value
                forPort:(PortId)p_PortId 
                 andPin:(unsigned char)p_PinNbr
                bitOnly:(BOOL)p_BitOnly
{
    @synchronized(self) 
    {
        unsigned char data[8];
        memset(data, 0, 8);
        data[0] = 0x1f;  // Read1Wire
        data[2] = (unsigned char)p_BitOnly;

        BOOL retVal = [self writeData:data length:8];
        if (retVal)
        {
            memset(data, 0, 8);
            retVal = [self readData:data length:8];
            if (retVal)
                *p_Value = data[1];
        }
        return retVal;
    }
}

- (unsigned char) pinCodeForPort:(PortId)p_PortId 
                          andPin:(unsigned char)p_PinNbr
{
    if (p_PortId == PORTID_A)
        return (unsigned char)p_PinNbr;
    else
        return (unsigned char)p_PinNbr + 8;
}

@end

//
//  USBmicroDeviceIO.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/17/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDManager.h>
#import <IOKit/hid/IOHIDKeys.h>
#import "USBmicroEnum.h"
#import "hidapi.h"

@interface USBmicroDeviceIO : NSObject
{
    unsigned short _usbMicroVendorId;
    unsigned short _usbMicroProductId;
    wchar_t *_usbMicroSerialNbr;
    
    hid_device *_device;
    unsigned char _portAReadWriteState;
    unsigned char _portBReadWriteState;
    unsigned char _portAValue;
    unsigned char _portBValue;
}

@property (nonatomic) unsigned short usbMicroVendorId;
@property (nonatomic) unsigned short usbMicroProductId;
@property (nonatomic) wchar_t *usbMicroSerialNbr;

@property (nonatomic) hid_device *device;
@property (nonatomic) unsigned char portAReadWriteState;
@property (nonatomic) unsigned char portBReadWriteState;
@property (nonatomic) unsigned char portAValue;
@property (nonatomic) unsigned char portBValue;

- (BOOL)initializeDevice;
- (void)terminateDevice;

- (unsigned char) stateForPort:(PortId)p_PortId;
- (void) setStateForPort:(PortId)p_PortId 
                      to:(unsigned char)p_State;

- (BOOL)setReadWriteStateForPort:(PortId)p_PortId;
- (BOOL)setReadWriteStateForPort:(PortId)p_PortId 
                         toState:(unsigned char)p_State;
- (BOOL)setReadWriteStateForPort:(PortId)p_PortId 
                          andPin:(unsigned char)p_PinNbr 
                         toWrite:(BOOL)p_Write;

- (BOOL)readPort:(PortId)p_PortId;
- (BOOL)writePort:(PortId)p_PortId;

- (unsigned char)valueForPort:(PortId)p_PortId;
- (void)setValueForPort:(PortId)p_PortId 
                     to:(unsigned char)p_Value;
- (BOOL)valueForPort:(PortId)p_PortId 
              andPin:(unsigned char)p_PinNbr;
- (void)setValueForPort:(PortId)p_PortId 
                 andPin:(unsigned char)p_PinNbr to:(BOOL)p_On;

- (BOOL)readData: (unsigned char[])p_Data
          length: (int)p_DataLen;
- (BOOL)writeData: (unsigned char[])p_Data
           length: (int)p_DataLen;

- (BOOL) init1WireForPort:(PortId)p_PortId 
                   andPin:(unsigned char)p_PinNbr;
- (BOOL) reset1WireForPort:(PortId)p_PortId 
                    andPin:(unsigned char)p_PinNbr;
- (BOOL) write1WireValue:(unsigned char)p_Value
                 forPort:(PortId)p_PortId 
                  andPin:(unsigned char)p_PinNbr
                 bitOnly:(BOOL)p_BitOnly;
- (BOOL) read1WireValue:(unsigned char *)p_Value
                 forPort:(PortId)p_PortId 
                 andPin:(unsigned char)p_PinNbr
                bitOnly:(BOOL)p_BitOnly;
- (unsigned char) pinCodeForPort:(PortId)p_PortId 
                          andPin:(unsigned char)p_PinNbr;

@end

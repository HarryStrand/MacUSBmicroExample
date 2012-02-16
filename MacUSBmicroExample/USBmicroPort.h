//
//  USBmicroPort.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>
#import "USBmicroEnum.h"
#import "USBmicroPin.h"

@class USBmicroDevice;
@class USBmicroDeviceIO;

@interface USBmicroPort : NSObject
{
@private
    PortId _portId;
    NSString *_portName;
    NSMutableArray *_pins;
    __weak USBmicroDevice *_parentDevice;
    id _notifyObject;
    SEL _notifySelector;
}

@property (nonatomic) PortId portId;
@property (nonatomic, retain) NSString *portName;
@property (nonatomic, retain) NSMutableArray *pins;
@property (nonatomic, weak) USBmicroDevice *parentDevice;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL notifySelector;

- (id) initWithPortId:(PortId)p_PortId;
- (void) addPins;
- (USBmicroPin *) findPin: (NSUInteger)p_PinNbr;
- (void) monitorPins: (USBmicroDeviceIO *)p_DeviceIO;
- (BOOL)checkPinsForChanges:(unsigned char)p_Value;

@end

//
//  USBmicroPin.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>
#import "TemperatureDS18x.h"

@class USBmicroDevice;
@class USBmicroPort;

typedef enum 
{
    IOTYPE_READ,
    IOTYPE_WRITE,
    IOTYPE_1WIRE
} IOType;

@interface USBmicroPin : NSObject
{
@private
    NSUInteger _pinNbr;
    IOType _ioType;
    BOOL _isOn;
    __weak USBmicroDevice *_parentDevice;
    __weak USBmicroPort *_parentPort;
    id _notifyObject;
    SEL _notifySelector;
    TemperatureDS18x *_temperatureSensor;
}

@property (nonatomic) NSUInteger pinNbr;
@property (nonatomic) IOType ioType;
@property (nonatomic) BOOL isOn;
@property (nonatomic, weak) USBmicroDevice *parentDevice;
@property (nonatomic, weak) USBmicroPort *parentPort;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL notifySelector;
@property (nonatomic, retain) TemperatureDS18x *temperatureSensor;

- (id) initWithPinNbr:(NSUInteger) p_PinNbr;
- (BOOL) initializeTemperatureSensor;
- (BOOL) notifyIfChanged:(unsigned char)p_Value;

@end

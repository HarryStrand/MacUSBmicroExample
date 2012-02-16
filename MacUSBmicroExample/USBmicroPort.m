//
//  USBmicroPort.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "USBmicroPort.h"
#import "USBmicroDeviceIO.h"

@implementation USBmicroPort

@synthesize portId = _portId;
@synthesize portName = _portName;
@synthesize pins = _pins;
@synthesize parentDevice = _parentDevice;
@synthesize notifyObject = _notifyObject;
@synthesize notifySelector = _notifySelector;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _portId = PORTID_A;
        _portName = @"";
        _pins = [[NSMutableArray alloc] initWithCapacity: 8];
        _notifyObject = nil;
        _notifySelector = nil;
    }
    
    return self;
}

- (id) initWithPortId:(PortId)p_PortId
{
    id object = [self init];
    
    self.portId = p_PortId;
    if (p_PortId == PORTID_A)
        self.portName = @"A";
    else
        self.portName = @"B";
    
    return object;
}

- (void) addPins
{
    [self.pins removeAllObjects];
    for (NSInteger pinNbr = 0; pinNbr < 8; pinNbr++)
    {
        USBmicroPin *pin = [[USBmicroPin alloc] initWithPinNbr:pinNbr];
        pin.parentDevice = self.parentDevice;
        pin.parentPort = self;
        [self.pins addObject:pin];
    }
}

- (USBmicroPin *) findPin: (NSUInteger)p_PinNbr
{
    for (USBmicroPin *pin in self.pins)
    {
        if (pin.pinNbr == p_PinNbr)
            return pin;
    }
    
    return nil;
}

- (void) monitorPins:(USBmicroDeviceIO *)p_DeviceIO
{
    [p_DeviceIO readPort:self.portId];
    [self checkPinsForChanges:[p_DeviceIO valueForPort:self.portId]];
}
    
- (BOOL)checkPinsForChanges:(unsigned char)p_Value
{
    BOOL hasChanges = NO;
    for (USBmicroPin *pin in self.pins)
    {
        if (pin.ioType == IOTYPE_READ || pin.ioType == IOTYPE_1WIRE)
        {
            if ([pin notifyIfChanged:p_Value])
                hasChanges = YES;
        }
    }
    
    return hasChanges;
}

@end

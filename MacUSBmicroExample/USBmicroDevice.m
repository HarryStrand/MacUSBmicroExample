//
//  USBmicroDevice.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "USBmicroDevice.h"

@implementation USBmicroDevice

@synthesize productType = _productType;
@synthesize serialNbr = _serialNbr;
@synthesize portA = _portA;
@synthesize portB = _portB;
@synthesize notifyObject = _notifyObject;
@synthesize notifySelector = _notifySelector;

@synthesize deviceIO = _deviceIO;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _productType = @"";
        _serialNbr = @"";
        _portA = [[USBmicroPort alloc] initWithPortId: PORTID_A];
        self.portA.parentDevice = self;
        [self.portA addPins];
        _portB = [[USBmicroPort alloc] initWithPortId: PORTID_B];
        self.portB.parentDevice = self;
        [self.portB addPins];
        _notifyObject = nil;
        _notifySelector = nil;
        
        _deviceIO = nil;
    }
    
    return self;
}

- (void) monitorPorts
{
    @synchronized(self) 
    {
        [self.portA monitorPins:self.deviceIO];
        [self.portB monitorPins:self.deviceIO];
    }
}

- (BOOL) writePort:(PortId)p_PortId
{
    if (p_PortId == PORTID_A)
        self.deviceIO.portAValue = [self portAValue];
    else
        self.deviceIO.portBValue = [self portBValue];

    return [self.deviceIO writePort:p_PortId];
}

- (unsigned char) portAValue
{
    unsigned char portValue = 0;
    for (USBmicroPin *pin in self.portA.pins)
    {
        if (pin.isOn)
            portValue |= (1<<pin.pinNbr);
    }
  
    return portValue;
}

- (unsigned char) portBValue
{
    unsigned char portValue = 0;
    for (USBmicroPin *pin in self.portB.pins)
    {
        if (pin.isOn)
            portValue |= (1<<pin.pinNbr);
    }
    
    return portValue;
}

@end

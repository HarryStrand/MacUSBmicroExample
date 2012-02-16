//
//  USBmicroPin.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "USBmicroPin.h"

@implementation USBmicroPin

@synthesize pinNbr = _pinNbr;
@synthesize ioType = _ioType;
@synthesize isOn = _isOn;
@synthesize parentDevice = _parentDevice;
@synthesize parentPort = _parentPort;
@synthesize notifyObject = _notifyObject;
@synthesize notifySelector = _notifySelector;
@synthesize temperatureSensor = _temperatureSensor;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _pinNbr = 0;
        _ioType = IOTYPE_READ;
        _isOn = NO;
        _parentDevice = nil;
        _parentPort = nil;
        _notifyObject = nil;
        _notifySelector = nil;
        _temperatureSensor = nil;
    }
    
    return self;
}


- (id) initWithPinNbr:(NSUInteger) p_PinNbr
{
    id object = [self init];
    self.pinNbr = p_PinNbr;
    return object;
}

- (BOOL) initializeTemperatureSensor
{
    if (self.temperatureSensor == nil)
        self.temperatureSensor = [[TemperatureDS18x alloc] init];
    
    self.temperatureSensor.device = self.parentDevice;
    self.temperatureSensor.port = self.parentPort;
    self.temperatureSensor.pin = self;
    self.temperatureSensor.notifyObject = self.notifyObject;
    self.temperatureSensor.notifySelector = self.notifySelector;
    self.temperatureSensor.readFrequency = 0;
    self.temperatureSensor.displayType = TDT_FAHRENHEIT;
    
    return [self.temperatureSensor initializeDevice];
}

- (BOOL) notifyIfChanged:(unsigned char)p_Value
{
    if (self.ioType == IOTYPE_1WIRE)
        [self.temperatureSensor process1WireTemperatureSensor];
    else
    {
        BOOL newIsOn = p_Value & (1<<self.pinNbr);
        if (self.isOn != newIsOn)
        {
            self.isOn = newIsOn;
            
            if (self.notifyObject != nil && self.notifySelector != nil)
                [self.notifyObject performSelector:self.notifySelector withObject: self];
                
            return YES;
        }
    }
    
    return NO;
}

@end

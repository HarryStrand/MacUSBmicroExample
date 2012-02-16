//
//  TemperatureDS18x.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/26/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "TemperatureDS18x.h"
#import "USBmicroDevice.h"
#import "USBmicroPort.h"
#import "USBmicroPin.h"

// It's supposed to come back with the time in .75 seconds max
#define DELAY_AFTER_CONVERSION 1.0  

@implementation TemperatureDS18x

@synthesize device = _device;
@synthesize port = _port;
@synthesize pin = _pin;
@synthesize notifyObject = _notifyObject;
@synthesize notifySelector = _notifySelector;
@synthesize readFrequency = _readFrequency;
@synthesize displayType = _displayType;

@synthesize familyCode = _familyCode;
@synthesize romData = _romData;
@synthesize conversionStarted = _conversionStarted;
@synthesize startTime = _startTime;
@synthesize readDone = _readDone;
@synthesize lastReadTemperature = _lastReadTemperature;
@synthesize initialized = _initialized;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _device = nil;
        _port = nil;
        _pin = nil;
        _notifyObject = nil;
        _notifySelector = nil;
        _displayType = TDT_FAHRENHEIT;
        
        _familyCode = 0;
        _romData = malloc(ROMBYTES);
        memset(_romData, 0, ROMBYTES);
        _conversionStarted = NO;
        _startTime = nil;
        _readDone = NO;
        _initialized = NO;
    }
    
    return self;
}

- (void)dealloc
{
    free(_romData);
}

- (BOOL) initializeDevice
{
    @synchronized(self.device) 
    {
        BOOL succeeded;
        
        // Initialize
        succeeded = [self.device.deviceIO init1WireForPort:self.port.portId andPin:self.pin.pinNbr];
        if (!succeeded)
        {
            [self processFailureForFunction:@"init1WireForPort" withId:1];
            return NO;
        }
        
        // Reset device
        succeeded = [self.device.deviceIO reset1WireForPort:self.port.portId andPin:self.pin.pinNbr];
        if (!succeeded)
        {
            [self processFailureForFunction:@"reset1WireForPort" withId:1];
            return NO;
        }
         
        // Read the serial number for the device(s)
        // Check to see if the m_ROMData is blank
        if ([self isROMDataBlank])
        {
            // Write "ReadROM" command
            succeeded = [self.device.deviceIO write1WireValue:0x33 forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
            if (!succeeded)
            {
                [self processFailureForFunction:@"write1WireValue" withId:1];
                return NO;
            }
            
            unsigned char familyCode = 0;
            succeeded = [self.device.deviceIO read1WireValue:&familyCode forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
            if (!succeeded)
            {
                [self processFailureForFunction:@"read1WireValue" withId:1];
                return NO;
            }

            self.familyCode = familyCode;

            for (int idx = 0; idx < 6; idx++)
            {
                unsigned char serialNbrChar = 0;
                succeeded = [self.device.deviceIO read1WireValue:&serialNbrChar forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
                if (!succeeded)
                {
                    [self processFailureForFunction:@"read1WireValue" withId:1];
                    return NO;
                }
            }
            
            unsigned char crc = 0;
            succeeded = [self.device.deviceIO read1WireValue:&crc forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
            if (!succeeded)
            {
                [self processFailureForFunction:@"read1WireValue" withId:1];
                return NO;
            }
        }
        else
            self.familyCode = self.romData[0];
        
        if (self.familyCode != 0x10 && self.familyCode != 0x28 && self.familyCode != 0x22)
        {
            NSLog(@"The family code of %d isn't a supported 1Wire temperature sensor", self.familyCode);
            return NO;
        }
        
        self.initialized = YES;

        return YES;
    }
}

- (void)process1WireTemperatureSensor
{
    if (!self.initialized)
        return;
    
    if (!self.conversionStarted)
    {
        [self startConversion];
        self.startTime = [NSDate date];
    }
    else
    {
        if (!self.readDone)
        {
            // Check to make sure there's been enough of a delay since the 
            // conversion took place.
            if ([[NSDate date] timeIntervalSinceDate: self.startTime] > DELAY_AFTER_CONVERSION)
            {
                [self readTemperature];
                
                self.readDone = YES;
                self.startTime = [NSDate date];
            }
        }
        else
        {
            NSTimeInterval readDelay = self.readFrequency - DELAY_AFTER_CONVERSION;
            if (readDelay < 0)
                readDelay = 0;
            if ([[NSDate date] timeIntervalSinceDate: self.startTime] > readDelay)
            {
                self.conversionStarted = NO;
                self.readDone = NO;
            }
        }
    }
}

- (void)select1WireDevice
{
    BOOL succeeded;
    
    // Reset device
    succeeded = [self.device.deviceIO reset1WireForPort:self.port.portId andPin:self.pin.pinNbr];
    if (!succeeded)
    {
        [self processFailureForFunction:@"reset1WireForPort" withId:1];
        return;
    }
    
    if (![self isROMDataBlank])
    {
        // Write the "MatchRom" command (only talk to this specific device)
        succeeded = [self.device.deviceIO write1WireValue:0x55 forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
        if (!succeeded)
        {
            [self processFailureForFunction:@"write1WireValue" withId:1];
            return;
        }
        
        succeeded = [self.device.deviceIO writeData:self.romData length:8];
        if (!succeeded)
        {
            [self processFailureForFunction:@"writeData" withId:1];
            return;
        }
    }
    else
    {
        // Write the "SkipRom" command (assume there's only one device on the wire)
        succeeded = [self.device.deviceIO write1WireValue:0xCC forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
        if (!succeeded)
        {
            [self processFailureForFunction:@"write1WireValue" withId:2];
            return;
        }
    }
}

- (void)startConversion
{
    BOOL succeeded;
    
    // Tell it which 1Wire device we're talking to
    [self select1WireDevice];
    
    // Write the "Conversion" command
    succeeded = [self.device.deviceIO write1WireValue:0x44 forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
    if (!succeeded)
    {
        [self processFailureForFunction:@"write1WireValue" withId:3];
        return;
    }
    
    self.conversionStarted = TRUE;
    self.readDone = FALSE;
}

- (void) readTemperature
{
    BOOL succeeded;

    // Tell it which 1Wire device we're talking to
    [self select1WireDevice];

    // Write "Read Scratchpad" and "Conversion" command
    succeeded = [self.device.deviceIO write1WireValue:0xBE forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
    if (!succeeded)
    {
        [self processFailureForFunction:@"write1WireValue" withId:1];
        return;
    }
    
    unsigned char portValue1 = 0;
    succeeded = [self.device.deviceIO read1WireValue:&portValue1 forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
    if (!succeeded)
    {
        [self processFailureForFunction:@"read1WireValue" withId:1];
        return;
    }
    
    unsigned char portValue2 = 0;
    succeeded = [self.device.deviceIO read1WireValue:&portValue2 forPort:self.port.portId andPin:self.pin.pinNbr bitOnly:NO];
    if (!succeeded)
    {
        [self processFailureForFunction:@"read1WireValue" withId:2];
        return;
    }
    
    int newPortValue = (int)(((int)portValue2 << 8) | portValue1);
    
    int divisor = 2;
    switch (self.familyCode)
    {
        case 0x10:
            divisor = 2;
            break;
        case 0x28:
        case 0x22:
            divisor = 16;
            break;
            
            //default:
            //ASSERT(0);
    }
    
    // Calculate the temperature in 10ths of a unit
    switch (self.displayType)
    {
        case TDT_CELSIUS:
            newPortValue = (newPortValue * 10) / divisor;
            break;
        case TDT_FAHRENHEIT:
            newPortValue = (((newPortValue * 18)) / divisor) + 320;
            break;
    }
    
    // Convert the temperature to a float value
    self.lastReadTemperature = (double)newPortValue / 10;
    
    // Alert the sensors
    if (self.notifyObject != nil && self.notifySelector != nil)
    {
        [self.notifyObject performSelectorOnMainThread:self.notifySelector withObject:self waitUntilDone: NO];
    }
}

- (BOOL) isROMDataBlank
{
    // Check to see if the m_ROMData is blank
    BOOL romDataIsBlank = YES;
    for (int idx = 0; idx < ROMBYTES; idx++)
    {
        if (self.romData[idx] != 0)
            romDataIsBlank = FALSE;
    }
    
    return romDataIsBlank;
}

- (void) processFailureForFunction:(NSString *)p_Function 
                            withId:(int)p_Id
{
    NSLog(@"Function %@ (%d) failed", p_Function, p_Id);
}

@end

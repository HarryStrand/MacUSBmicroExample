//
//  USBmicroDevices.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "USBmicroDevices.h"
#import "USBmicroDetectDevices.h"

@implementation USBmicroDevices

@synthesize devices = _devices;
@synthesize continueMonitoring = _continueMonitoring;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _devices = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL) autoDetectDevices
{
    [USBmicroDetectDevices autoDetectDevices: self.devices];
    
    return YES;
}

- (void) startMonitoring
{
    self.continueMonitoring = YES;
    [self performSelectorInBackground:@selector(monitorDevices) withObject:nil];
}

- (void) monitorDevices
{
    while (self.continueMonitoring) 
    {
        for (USBmicroDevice *device in self.devices)
        {
            [device monitorPorts];
            usleep(10000);  // Sleep for a 100th of a second
        }
    }
    NSLog(@"The monitorDevices function ended");
}

- (void) stopMonitoring
{
    self.continueMonitoring = NO;
}

- (NSUInteger) count
{
    return [self.devices count];
}

- (USBmicroDevice *) deviceAtIndex:(NSUInteger)p_DeviceIdx
{
    return [self.devices objectAtIndex:p_DeviceIdx];
}

@end

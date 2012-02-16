//
//  USBmicroDevices.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>
#import "USBmicroDevice.h"

@interface USBmicroDevices : NSObject
{
@private
    NSMutableArray *_devices;
    BOOL _continueMonitoring;
}

@property (nonatomic, retain) NSMutableArray *devices;
@property (atomic) BOOL continueMonitoring;

- (BOOL) autoDetectDevices;
- (void) startMonitoring;
- (void) stopMonitoring;
- (NSUInteger) count;
- (USBmicroDevice *) deviceAtIndex:(NSUInteger)p_DeviceIdx;

@end

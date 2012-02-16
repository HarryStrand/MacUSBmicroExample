//
//  USBmicroDetectDevices.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/17/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#include <IOKit/hid/IOHIDManager.h>
#include <IOKit/hid/IOHIDKeys.h>
#include <CoreFoundation/CoreFoundation.h>
#include <wchar.h>
#include <locale.h>
#include <pthread.h>
#include <sys/time.h>
#include <unistd.h>
#include "hidapi.h"

#import "USBmicroDetectDevices.h"
#import "USBmicroDevice.h"
#import "USBmicroDeviceIO.h"

@implementation USBmicroDetectDevices

+ (void) autoDetectDevices:(NSMutableArray *)p_Devices
{
    unsigned short usbMicroVendorId = 0xde7;
    
    IOHIDManagerRef mgr;
    int i;
    
    mgr = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    IOHIDManagerSetDeviceMatching(mgr, NULL);
    IOHIDManagerOpen(mgr, kIOHIDOptionsTypeNone);
    
    CFSetRef device_set = IOHIDManagerCopyDevices(mgr);
    
    CFIndex num_devices = CFSetGetCount(device_set);
    IOHIDDeviceRef *device_array = calloc(num_devices, sizeof(IOHIDDeviceRef));
    CFSetGetValues(device_set, (const void **)device_array);
    
    setlocale(LC_ALL, "");
    
    for (i = 0; i < num_devices; i++) 
    {
        IOHIDDeviceRef dev = device_array[i];
        unsigned short vendorId = get_vendor_id(dev);
        unsigned short productId = get_product_id(dev);
        
        wchar_t serial[256];
        memset(serial, 0, 256);
        get_serial_number(dev, serial, 256);
        
        if (vendorId == usbMicroVendorId)
        {
            USBmicroDevice *device = [[USBmicroDevice alloc] init];
            device.productType = [NSString stringWithFormat: @"U%d", productId];
            device.serialNbr = [[NSString alloc] initWithBytes:serial length:wcslen(serial) * 4 encoding:NSUTF8StringEncoding];
            
            USBmicroDeviceIO *deviceIO = [[USBmicroDeviceIO alloc] init];
            deviceIO.usbMicroProductId = productId;
            deviceIO.usbMicroVendorId = vendorId;
            memcpy(deviceIO.usbMicroSerialNbr, serial, 256);
            BOOL succeeded = [deviceIO initializeDevice];
            if (succeeded)
            {
                device.deviceIO = deviceIO;
                
                [p_Devices addObject:device];
            }
        }
    }
}

@end

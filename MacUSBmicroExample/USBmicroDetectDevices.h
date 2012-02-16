//
//  USBmicroDetectDevices.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/17/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>

@interface USBmicroDetectDevices : NSObject

+ (void) autoDetectDevices:(NSMutableArray *)p_Devices;

@end

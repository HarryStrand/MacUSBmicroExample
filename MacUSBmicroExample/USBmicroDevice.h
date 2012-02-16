//
//  USBmicroDevice.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>
#import "USBmicroPort.h"
#import "USBmicroDeviceIO.h"

@interface USBmicroDevice : NSObject
{
@private
    NSString *_productType;
    NSString *_serialNbr;
    USBmicroPort *_portA;
    USBmicroPort *_portB;
    id _notifyObject;
    SEL _notifySelector;
    
    USBmicroDeviceIO *_deviceIO;
}

@property (nonatomic, retain) NSString *productType;
@property (nonatomic, retain) NSString *serialNbr;
@property (nonatomic, retain) USBmicroPort *portA;
@property (nonatomic, retain) USBmicroPort *portB;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL notifySelector;

@property (nonatomic, retain) USBmicroDeviceIO *deviceIO;

- (void) monitorPorts;
- (BOOL) writePort:(PortId)p_PortId;
- (unsigned char) portAValue;
- (unsigned char) portBValue;

@end

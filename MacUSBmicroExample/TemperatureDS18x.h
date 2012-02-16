//
//  TemperatureDS18x.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/26/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Foundation/Foundation.h>

@class USBmicroDevice;
@class USBmicroPort;
@class USBmicroPin;

#define ROMBYTES 8

typedef enum 
{
    TDT_FAHRENHEIT,
    TDT_CELSIUS
} TemperatureDisplayType;

@interface TemperatureDS18x : NSObject
{
@private
    __weak USBmicroDevice *_device;
    __weak USBmicroPort *_port;
    __weak USBmicroPin *_pin;
    id _notifyObject;
    SEL _notifySelector;
    NSTimeInterval _readFrequency;
    TemperatureDisplayType _displayType;
    double _lastReadTemperature;

    unsigned char _familyCode;
    unsigned char *_romData;
    BOOL _conversionStarted;
    NSDate *_startTime;
    BOOL _readDone;
    BOOL _initialized;
}

@property (nonatomic, weak) USBmicroDevice *device;
@property (nonatomic, weak) USBmicroPort *port;
@property (nonatomic, weak) USBmicroPin *pin;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL notifySelector;
@property (nonatomic) NSTimeInterval readFrequency;
@property (nonatomic) TemperatureDisplayType displayType;
@property (nonatomic) double lastReadTemperature;

@property (nonatomic) unsigned char familyCode;
@property (nonatomic) unsigned char *romData;
@property (nonatomic) BOOL conversionStarted;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic) BOOL readDone;
@property (nonatomic) BOOL initialized;

- (BOOL) initializeDevice;
- (void) process1WireTemperatureSensor;
- (void) select1WireDevice;
- (void) startConversion;
- (void) readTemperature;
- (BOOL) isROMDataBlank;
- (void) processFailureForFunction:(NSString *)p_Function withId:(int)p_Id;

@end

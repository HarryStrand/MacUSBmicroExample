//
//  AppDelegate.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
    GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
    located at the root of the source distribution. */

#import <Cocoa/Cocoa.h>
#import "USBmicroDevices.h"
#import "MainWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
@private
    USBmicroDevices *_devices;
    MainWindowController *_mainWindowController;
}

@property (nonatomic, retain) USBmicroDevices *devices;
@property (nonatomic, retain) MainWindowController *mainWindowController;

@end

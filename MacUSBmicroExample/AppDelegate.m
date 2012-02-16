//
//  AppDelegate.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize devices = _devices;
@synthesize mainWindowController = _mainWindowController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.devices = [[USBmicroDevices alloc] init];
    [self.devices autoDetectDevices];
     
	self.mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    self.mainWindowController.devices = self.devices;
    
	[self.mainWindowController showWindow: self];
}

- (void)loadMainWindow
{
}

@end

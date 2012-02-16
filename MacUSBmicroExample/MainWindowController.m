//
//  MainWindowController.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import "MainWindowController.h"

@implementation MainWindowController

@synthesize deviceTableView = _deviceTableView;
@synthesize titleTextField = _titleTextField;
@synthesize productTypeTextField = _productTypeTextField;
@synthesize serialNumberTextField = _serialNumberTextField;

@synthesize portA0Button = _portA0Button;
@synthesize portA0ImageView = _portA0ImageView;
@synthesize portA0TextField = _portA0TextField;

@synthesize portA1Button = _portA1Button;
@synthesize portA1ImageView = _portA1ImageView;
@synthesize portA1TextField = _portA1TextField;

@synthesize portA2Button = _portA2Button;
@synthesize portA2ImageView = _portA2ImageView;
@synthesize portA2TextField = _portA2TextField;

@synthesize portA3Button = _portA3Button;
@synthesize portA3ImageView = _portA3ImageView;
@synthesize portA3TextField = _portA3TextField;

@synthesize portA4Button = _portA4Button;
@synthesize portA4ImageView = _portA4ImageView;
@synthesize portA4TextField = _portA4TextField;

@synthesize portA5Button = _portA5Button;
@synthesize portA5ImageView = _portA5ImageView;
@synthesize portA5TextField = _portA5TextField;

@synthesize portA6Button = _portA6Button;
@synthesize portA6ImageView = _portA6ImageView;
@synthesize portA6TextField = _portA6TextField;

@synthesize portA7Button = _portA7Button;
@synthesize portA7ImageView = _portA7ImageView;
@synthesize portA7TextField = _portA7TextField;


@synthesize portB0Button = _portB0Button;
@synthesize portB0ImageView = _portB0ImageView;
@synthesize portB0TextField = _portB0TextField;

@synthesize portB1Button = _portB1Button;
@synthesize portB1ImageView = _portB1ImageView;
@synthesize portB1TextField = _portB1TextField;

@synthesize portB2Button = _portB2Button;
@synthesize portB2ImageView = _portB2ImageView;
@synthesize portB2TextField = _portB2TextField;

@synthesize portB3Button = _portB3Button;
@synthesize portB3ImageView = _portB3ImageView;
@synthesize portB3TextField = _portB3TextField;

@synthesize portB4Button = _portB4Button;
@synthesize portB4ImageView = _portB4ImageView;
@synthesize portB4TextField = _portB4TextField;

@synthesize portB5Button = _portB5Button;
@synthesize portB5ImageView = _portB5ImageView;
@synthesize portB5TextField = _portB5TextField;

@synthesize portB6Button = _portB6Button;
@synthesize portB6ImageView = _portB6ImageView;
@synthesize portB6TextField = _portB6TextField;

@synthesize portB7Button = _portB7Button;
@synthesize portB7ImageView = _portB7ImageView;
@synthesize portB7TextField = _portB7TextField;

@synthesize devices = _devices;
@synthesize selectedDevice = _selectedDevice;
@synthesize lastPortButton = _lastPortButton;
@synthesize lastPortImageView = _lastPortImageView;
@synthesize lastPortTextField = _lastPortTextField;
@synthesize lastPin = _lastPin;
@synthesize lastPort = _lastPort;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) 
    {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    if ([self.devices count] > 0)
    {
        self.selectedDevice = [self.devices deviceAtIndex: 0];
        [self.deviceTableView selectRowIndexes: [NSIndexSet indexSetWithIndex: 0] byExtendingSelection:NO];
    }
    
    [self updateViewWithData:self.selectedDevice selectionChanged:NO];
    
    [self setupEvents];
}

- (void) setupEvents
{
    for (USBmicroDevice *device in self.devices.devices)
    {
        [self setupEventsForDevice:device];
    }
}

- (void) setupEventsForDevice: (USBmicroDevice *)p_Device
{
    USBmicroPin *pin;

    pin = [p_Device.portA findPin:0];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA0Updated:);
    
    pin = [p_Device.portA findPin:1];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA1Updated:);
    
    pin = [p_Device.portA findPin:2];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA2Updated:);
    
    pin = [p_Device.portA findPin:3];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA3Updated:);
    
    pin = [p_Device.portA findPin:4];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA4Updated:);
    
    pin = [p_Device.portA findPin:5];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA5Updated:);
    
    pin = [p_Device.portA findPin:6];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA6Updated:);
    
    pin = [p_Device.portA findPin:7];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portA7Updated:);
    
    
    pin = [p_Device.portB findPin:0];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB0Updated:);
    
    pin = [p_Device.portB findPin:1];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB1Updated:);
    
    pin = [p_Device.portB findPin:2];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB2Updated:);
    
    pin = [p_Device.portB findPin:3];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB3Updated:);
    
    pin = [p_Device.portB findPin:4];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB4Updated:);
    
    pin = [p_Device.portB findPin:5];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB5Updated:);
    
    pin = [p_Device.portB findPin:6];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB6Updated:);
    
    pin = [p_Device.portB findPin:7];
    pin.notifyObject = self;
    pin.notifySelector = @selector(portB7Updated:);
    
    [self.devices startMonitoring];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTable
{
	if (self.devices == nil)
		return 0;
	NSInteger qty = [self.devices count];
	return qty;
}

- (id)tableView:(NSTableView *)aTable objectValueForTableColumn:(NSTableColumn *)aCol row:(NSInteger)aRow
{
    // Sometimes this can happen
    if (aRow >= [self.devices count])
        return @"";
    
    USBmicroDevice *device = [self.devices deviceAtIndex:aRow];
    if (device != nil)
        return [NSString stringWithFormat:@"%@ - %@", device.productType, device.serialNbr];
    else
        return @"";
}

- (IBAction) selectionChanged:(id)sender
{
    NSInteger selectedRow = [self.deviceTableView selectedRow];
    self.selectedDevice = [self.devices deviceAtIndex: selectedRow];
    [self updateViewWithData:self.selectedDevice selectionChanged:YES];
}

- (void) setLastValuesFor: (id)sender
{
    if ([sender isKindOfClass: [NSButton class]])
    {
        NSButton *setupButton = (NSButton *)sender;
        if ([setupButton.identifier isEqualToString: @"A"])
        {
            self.lastPortButton = nil;
            self.lastPortImageView = nil; 
            self.lastPortTextField = nil;
            self.lastPin = nil;
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A0"])
        {
            self.lastPortButton = self.portA0Button;
            self.lastPortImageView = self.portA0ImageView; 
            self.lastPortTextField = self.portA0TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:0];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A1"])
        {
            self.lastPortButton = self.portA1Button;
            self.lastPortImageView = self.portA1ImageView; 
            self.lastPortTextField = self.portA1TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:1];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A2"])
        {
            self.lastPortButton = self.portA2Button;
            self.lastPortImageView = self.portA2ImageView; 
            self.lastPortTextField = self.portA2TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:2];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A3"])
        {
            self.lastPortButton = self.portA3Button;
            self.lastPortImageView = self.portA3ImageView; 
            self.lastPortTextField = self.portA3TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:3];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A4"])
        {
            self.lastPortButton = self.portA4Button;
            self.lastPortImageView = self.portA4ImageView; 
            self.lastPortTextField = self.portA4TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:4];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A5"])
        {
            self.lastPortButton = self.portA5Button;
            self.lastPortImageView = self.portA5ImageView; 
            self.lastPortTextField = self.portA5TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:5];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A6"])
        {
            self.lastPortButton = self.portA6Button;
            self.lastPortImageView = self.portA6ImageView; 
            self.lastPortTextField = self.portA6TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:6];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"A7"])
        {
            self.lastPortButton = self.portA7Button;
            self.lastPortImageView = self.portA7ImageView; 
            self.lastPortTextField = self.portA7TextField; 
            self.lastPin = [self.selectedDevice.portA findPin:7];
            self.lastPort = self.selectedDevice.portA;
        }
        else if ([setupButton.identifier isEqualToString: @"B"])
        {
            self.lastPortButton = nil;
            self.lastPortImageView = nil; 
            self.lastPortTextField = nil; 
            self.lastPin = nil;
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B0"])
        {
            self.lastPortButton = self.portB0Button;
            self.lastPortImageView = self.portB0ImageView; 
            self.lastPortTextField = self.portB0TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:0];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B1"])
        {
            self.lastPortButton = self.portB1Button;
            self.lastPortImageView = self.portB1ImageView; 
            self.lastPortTextField = self.portB1TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:1];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B2"])
        {
            self.lastPortButton = self.portB2Button;
            self.lastPortImageView = self.portB2ImageView; 
            self.lastPortTextField = self.portB2TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:2];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B3"])
        {
            self.lastPortButton = self.portB3Button;
            self.lastPortImageView = self.portB3ImageView; 
            self.lastPortTextField = self.portB3TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:3];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B4"])
        {
            self.lastPortButton = self.portB4Button;
            self.lastPortImageView = self.portB4ImageView; 
            self.lastPortTextField = self.portB4TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:4];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B5"])
        {
            self.lastPortButton = self.portB5Button;
            self.lastPortImageView = self.portB5ImageView; 
            self.lastPortTextField = self.portB5TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:5];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B6"])
        {
            self.lastPortButton = self.portB6Button;
            self.lastPortImageView = self.portB6ImageView; 
            self.lastPortTextField = self.portB6TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:6];
            self.lastPort = self.selectedDevice.portB;
        }
        else if ([setupButton.identifier isEqualToString: @"B7"])
        {
            self.lastPortButton = self.portB7Button;
            self.lastPortImageView = self.portB7ImageView; 
            self.lastPortTextField = self.portB7TextField; 
            self.lastPin = [self.selectedDevice.portB findPin:7];
            self.lastPort = self.selectedDevice.portB;
        }
    }
}

- (IBAction) portASetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:-1];
}

- (IBAction) portA0ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:0];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA0Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA0Button orImage:self.portA0ImageView orTextField:self.portA0TextField forPin:self.lastPin];
}

- (IBAction) portA0SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:0];
}

- (IBAction) portA1ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:1];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA1Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA1Button orImage:self.portA1ImageView orTextField:self.portA1TextField forPin:self.lastPin];
}

- (IBAction) portA1SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:1];
}

- (IBAction) portA2ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:2];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA2Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA2Button orImage:self.portA2ImageView orTextField:self.portA2TextField forPin:self.lastPin];
}

- (IBAction) portA2SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:2];
}

- (IBAction) portA3ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:3];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA3Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA3Button orImage:self.portA3ImageView orTextField:self.portA3TextField forPin:self.lastPin];
}

- (IBAction) portA3SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:3];
}

- (IBAction) portA4ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:4];
    self.lastPin.isOn = (self.portA4Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA4Button orImage:self.portA4ImageView orTextField:self.portA4TextField forPin:self.lastPin];
}

- (IBAction) portA4SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:4];
}

- (IBAction) portA5ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:5];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA5Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA5Button orImage:self.portA5ImageView orTextField:self.portA5TextField forPin:self.lastPin];
}

- (IBAction) portA5SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:5];
}

- (IBAction) portA6ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin:6];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA6Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA6Button orImage:self.portA6ImageView orTextField:self.portA6TextField forPin:self.lastPin];
}

- (IBAction) portA6SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:6];
}

- (IBAction) portA7ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portA findPin: 7];
    self.lastPort = self.selectedDevice.portA;
    self.lastPin.isOn = (self.portA7Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_A];
    [self setPinStateForButton:self.portA7Button orImage:self.portA7ImageView orTextField:self.portA7TextField forPin:self.lastPin];
}

- (IBAction) portA7SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"A" andPin:7];
}

- (IBAction) portBSetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:-1];
}

- (IBAction) portB0ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:0];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB0Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB0Button orImage:self.portB0ImageView orTextField:self.portB0TextField forPin:self.lastPin];
}

- (IBAction) portB0SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:0];
}

- (IBAction) portB1ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:1];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB1Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB1Button orImage:self.portB1ImageView orTextField:self.portB1TextField forPin:self.lastPin];
}

- (IBAction) portB1SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:1];
}

- (IBAction) portB2ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:2];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB2Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB2Button orImage:self.portB2ImageView orTextField:self.portB2TextField forPin:self.lastPin];
}

- (IBAction) portB2SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:2];
}

- (IBAction) portB3ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:3];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB3Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB3Button orImage:self.portB3ImageView orTextField:self.portB3TextField forPin:self.lastPin];
}

- (IBAction) portB3SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:3];
}

- (IBAction) portB4ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:4];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB4Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB4Button orImage:self.portB4ImageView orTextField:self.portB4TextField forPin:self.lastPin];
}

- (IBAction) portB4SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:4];
}

- (IBAction) portB5ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:5];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB5Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB5Button orImage:self.portB5ImageView orTextField:self.portB5TextField forPin:self.lastPin];
}

- (IBAction) portB5SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:5];
}

- (IBAction) portB6ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin:6];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB6Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB6Button orImage:self.portB6ImageView orTextField:self.portB6TextField forPin:self.lastPin];
}

- (IBAction) portB6SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:6];
}

- (IBAction) portB7ButtonClicked: (id) sender
{
    self.lastPin = [self.selectedDevice.portB findPin: 7];
    self.lastPort = self.selectedDevice.portB;
    self.lastPin.isOn = (self.portB7Button.state == NSOnState);
    [self.selectedDevice writePort:PORTID_B];
    [self setPinStateForButton:self.portB7Button orImage:self.portB7ImageView orTextField:self.portB7TextField forPin:self.lastPin];
}

- (IBAction) portB7SetupButtonClicked: (id) sender
{
    [self setLastValuesFor: sender];
    [self displayMenuOnButton:sender forPort:@"B" andPin:7];
}

- (void) portA0Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:0];
    [self setPinStateForButton:self.portA0Button orImage:self.portA0ImageView orTextField:self.portA0TextField forPin:pin];
}

- (void) portA1Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:1];
    [self setPinStateForButton:self.portA1Button orImage:self.portA1ImageView orTextField:self.portA1TextField forPin:pin];
}

- (void) portA2Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:2];
    [self setPinStateForButton:self.portA2Button orImage:self.portA2ImageView orTextField:self.portA2TextField forPin:pin];
}

- (void) portA3Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:3];
    [self setPinStateForButton:self.portA3Button orImage:self.portA3ImageView orTextField:self.portA3TextField forPin:pin];
}

- (void) portA4Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:4];
    [self setPinStateForButton:self.portA4Button orImage:self.portA4ImageView orTextField:self.portA4TextField forPin:pin];
}

- (void) portA5Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:5];
    [self setPinStateForButton:self.portA5Button orImage:self.portA5ImageView orTextField:self.portA5TextField forPin:pin];
}

- (void) portA6Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:6];
    [self setPinStateForButton:self.portA6Button orImage:self.portA6ImageView orTextField:self.portA6TextField forPin:pin];
}

- (void) portA7Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portA findPin:7];
    [self setPinStateForButton:self.portA7Button orImage:self.portA7ImageView orTextField:self.portA7TextField forPin:pin];
}

- (void) portB0Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:0];
    [self setPinStateForButton:self.portB0Button orImage:self.portB0ImageView orTextField:self.portB0TextField forPin:pin];
}

- (void) portB1Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:1];
    [self setPinStateForButton:self.portB1Button orImage:self.portB1ImageView orTextField:self.portB1TextField forPin:pin];
}

- (void) portB2Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:2];
    [self setPinStateForButton:self.portB2Button orImage:self.portB2ImageView orTextField:self.portB2TextField forPin:pin];
}

- (void) portB3Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:3];
    [self setPinStateForButton:self.portB3Button orImage:self.portB3ImageView orTextField:self.portB3TextField forPin:pin];
}

- (void) portB4Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:4];
    [self setPinStateForButton:self.portB4Button orImage:self.portB4ImageView orTextField:self.portB4TextField forPin:pin];
}

- (void) portB5Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:5];
    [self setPinStateForButton:self.portB5Button orImage:self.portB5ImageView orTextField:self.portB5TextField forPin:pin];
}

- (void) portB6Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:6];
    [self setPinStateForButton:self.portB6Button orImage:self.portB6ImageView orTextField:self.portB6TextField forPin:pin];
}

- (void) portB7Updated: (id) sender
{
    USBmicroPin *pin = [self.selectedDevice.portB findPin:7];
    [self setPinStateForButton:self.portB7Button orImage:self.portB7ImageView orTextField:self.portB7TextField forPin:pin];
}

- (void) displayMenuOnButton: (id) sender
                     forPort: (NSString *)p_Port 
                      andPin: (NSUInteger)p_Pin
{
    NSButton *menuButton = sender;
    NSRect frame = [menuButton frame];
    NSPoint menuOrigin = [[menuButton superview] convertPoint:NSMakePoint(frame.origin.x + 24, frame.origin.y+frame.size.height) toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType: NSLeftMouseDown
                                         location: menuOrigin
                                    modifierFlags: NSLeftMouseDownMask // 0x100
                                        timestamp: [NSDate timeIntervalSinceReferenceDate]
                                     windowNumber: [[menuButton window] windowNumber]
                                          context: [[menuButton window] graphicsContext]
                                      eventNumber: 0
                                       clickCount: 1
                                         pressure: 1];
    
    [NSMenu popUpContextMenu: [self buttonMenu] withEvent: event forView:menuButton];
}

- (NSMenu *) buttonMenu
{
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *menuItem;
    menuItem = [menu addItemWithTitle: NSLocalizedString(@"Set As Read", @"Set As Read") action: @selector(setAsRead:) keyEquivalent: @""];
    [menuItem setTarget: self];
    
    menuItem = [menu addItemWithTitle: NSLocalizedString(@"Set As Write", @"Set As Write") action: @selector(setAsWrite:) keyEquivalent: @""];
    [menuItem setTarget: self];
    
    menuItem = [menu addItemWithTitle: NSLocalizedString(@"Set As 1Wire", @"Set As 1Wire") action: @selector(setAs1Wire:) keyEquivalent: @""];
    [menuItem setTarget: self];
    
    return menu;        
}

- (void) setLastButtonForPort:(USBmicroPort *)p_Port andPin:(USBmicroPin *)p_Pin
{
    if (p_Port.portId == PORTID_A)
        [self setLastButtonForPortAPin:p_Pin];
    else
        [self setLastButtonForPortBPin:p_Pin];
}

- (void) setLastButtonForPortAPin:(USBmicroPin *)p_Pin
{
    switch(p_Pin.pinNbr)
    {
        case 0:
            self.lastPortButton = self.portA0Button;
            self.lastPortImageView = self.portA0ImageView; 
            self.lastPortTextField = self.portA0TextField; 
            break;
        case 1:
            self.lastPortButton = self.portA1Button;
            self.lastPortImageView = self.portA1ImageView; 
            self.lastPortTextField = self.portA1TextField; 
            break;
        case 2:
            self.lastPortButton = self.portA2Button;
            self.lastPortImageView = self.portA2ImageView; 
            self.lastPortTextField = self.portA2TextField; 
            break;
        case 3:
            self.lastPortButton = self.portA3Button;
            self.lastPortImageView = self.portA3ImageView; 
            self.lastPortTextField = self.portA3TextField; 
            break;
        case 4:
            self.lastPortButton = self.portA4Button;
            self.lastPortImageView = self.portA4ImageView; 
            self.lastPortTextField = self.portA4TextField; 
            break;
        case 5:
            self.lastPortButton = self.portA5Button;
            self.lastPortImageView = self.portA5ImageView; 
            self.lastPortTextField = self.portA5TextField; 
            break;
        case 6:
            self.lastPortButton = self.portA6Button;
            self.lastPortImageView = self.portA6ImageView; 
            self.lastPortTextField = self.portA6TextField; 
            break;
        case 7:
            self.lastPortButton = self.portA7Button;
            self.lastPortImageView = self.portA7ImageView; 
            self.lastPortTextField = self.portA7TextField; 
            break;
    }
}

- (void) setLastButtonForPortBPin:(USBmicroPin *)p_Pin
{
    switch(p_Pin.pinNbr)
    {
        case 0:
            self.lastPortButton = self.portB0Button;
            self.lastPortImageView = self.portB0ImageView; 
            self.lastPortTextField = self.portB0TextField; 
            break;
        case 1:
            self.lastPortButton = self.portB1Button;
            self.lastPortImageView = self.portB1ImageView; 
            self.lastPortTextField = self.portB1TextField; 
            break;
        case 2:
            self.lastPortButton = self.portB2Button;
            self.lastPortImageView = self.portB2ImageView; 
            self.lastPortTextField = self.portB2TextField; 
            break;
        case 3:
            self.lastPortButton = self.portB3Button;
            self.lastPortImageView = self.portB3ImageView; 
            self.lastPortTextField = self.portB3TextField; 
            break;
        case 4:
            self.lastPortButton = self.portB4Button;
            self.lastPortImageView = self.portB4ImageView; 
            self.lastPortTextField = self.portB4TextField; 
            break;
        case 5:
            self.lastPortButton = self.portB5Button;
            self.lastPortImageView = self.portB5ImageView; 
            self.lastPortTextField = self.portB5TextField; 
            break;
        case 6:
            self.lastPortButton = self.portB6Button;
            self.lastPortImageView = self.portB6ImageView; 
            self.lastPortTextField = self.portB6TextField; 
            break;
        case 7:
            self.lastPortButton = self.portB7Button;
            self.lastPortImageView = self.portB7ImageView; 
            self.lastPortTextField = self.portB7TextField; 
            break;
    }
}

- (IBAction) setAsRead: (id)sender
{
    [self setLastValuesFor: sender];
    if (self.lastPin == nil)
    {
        for (USBmicroPin *pin in self.lastPort.pins)
        {
            [self setAsReadPort:self.lastPort andPin:pin];
            [self setLastButtonForPort:self.lastPort andPin:pin];
            [self setAsReadWithButton:self.lastPortButton andImageView:self.lastPortImageView andTextField:self.lastPortTextField];
        }
    }
    else
    {
        [self setAsReadPort: self.lastPort andPin: self.lastPin];
    }
}

- (void) setAsReadPort: (USBmicroPort *)p_Port
                andPin: (USBmicroPin *)p_Pin
{
    p_Pin.ioType = IOTYPE_READ;
    [self.selectedDevice.deviceIO setReadWriteStateForPort:p_Port.portId andPin:p_Pin.pinNbr toWrite:NO];
    
    if (self.lastPortButton != nil)
        [self setAsReadWithButton: self.lastPortButton andImageView: self.lastPortImageView andTextField:self.lastPortTextField];
}

- (void) setAsReadWithButton: (NSButton *)p_Button
                andImageView: (NSImageView *)p_ImageView 
                andTextField: (NSTextField *)p_TextField
{
    [p_Button setHidden: YES];
    [p_ImageView setHidden: NO];
    [p_TextField setHidden: YES];
}

- (IBAction) setAsWrite: (id)sender
{
    [self setLastValuesFor: sender];
    if (self.lastPin == nil)
    {
        for (USBmicroPin *pin in self.lastPort.pins)
        {
            [self setAsWritePort: self.lastPort andPin: pin];
            [self setLastButtonForPort:self.lastPort andPin:pin];
            [self setAsWriteWithButton: self.lastPortButton andImageView: self.lastPortImageView andTextField: self.lastPortTextField];
        }
    }
    else
    {
        [self setAsWritePort: self.lastPort andPin: self.lastPin];
    }
}

- (void) setAsWritePort: (USBmicroPort *)p_Port
                 andPin: (USBmicroPin *)p_Pin
{
    p_Pin.ioType = IOTYPE_WRITE;
    [self.selectedDevice.deviceIO setReadWriteStateForPort:p_Port.portId andPin:p_Pin.pinNbr toWrite:YES];
    
    if (self.lastPortButton != nil)
        [self setAsWriteWithButton: self.lastPortButton andImageView: self.lastPortImageView andTextField: self.lastPortTextField];
}

- (void) setAsWriteWithButton: (NSButton *)p_Button
                 andImageView: (NSImageView *)p_ImageView 
                 andTextField: (NSTextField *)p_TextField
{
    [p_Button setHidden: NO];
    [p_ImageView setHidden: YES];
    [p_TextField setHidden: YES];
}

- (IBAction) setAs1Wire: (id)sender
{
    [self setLastValuesFor: sender];
    if (self.lastPin == nil)
    {
        for (USBmicroPin *pin in self.lastPort.pins)
        {
            [self setAs1WirePort:self.lastPort andPin:pin];
            [self setLastButtonForPort:self.lastPort andPin:pin];
            [self setAs1WireWithButton: self.lastPortButton andImageView: self.lastPortImageView andTextField: self.lastPortTextField];
        }
    }
    else
    {
        [self setAs1WirePort: self.lastPort andPin: self.lastPin];
    }
}

- (void) setAs1WirePort: (USBmicroPort *)p_Port
                 andPin: (USBmicroPin *)p_Pin
{
    p_Pin.ioType = IOTYPE_1WIRE;
    BOOL succeeded = [p_Pin initializeTemperatureSensor];
    if (self.lastPortButton != nil)
        [self setAs1WireWithButton: self.lastPortButton andImageView: self.lastPortImageView andTextField: self.lastPortTextField];
    
    if (!succeeded)
    {
        self.lastPortTextField.stringValue = @"ERR";
        [self beep];
    }
}

- (void) setAs1WireWithButton: (NSButton *)p_Button
                 andImageView: (NSImageView *)p_ImageView 
                 andTextField: (NSTextField *)p_TextField
{
    [p_Button setHidden: YES];
    [p_ImageView setHidden: YES];
    [p_TextField setHidden: NO];
}

- (void) setAsHiddenWithButton: (NSButton *)p_Button
                  andImageView: (NSImageView *)p_ImageView 
                  andTextField: (NSTextField *)p_TextField
{
    [p_Button setHidden: YES];
    [p_ImageView setHidden: YES];
    [p_TextField setHidden: YES];
}

- (void) updateViewWithData: (USBmicroDevice *)p_Device
           selectionChanged: (BOOL) p_SelectionChanged
{
    if (p_Device != nil)
    {
        self.productTypeTextField.stringValue = p_Device.productType;
        self.serialNumberTextField.stringValue = p_Device.serialNbr;
    }
    else
    {
        self.productTypeTextField.stringValue = @"No U4x1 device selected";
        self.serialNumberTextField.stringValue = @"";
    }
    
    [self setPinIOType: p_Device];
    [self setPinState: p_Device];
}

- (void) setPinIOType: (USBmicroDevice *)p_Device
{
    [self setPinIOTypeForButton: self.portA0Button andImageView: self.portA0ImageView andTextField: self.portA0TextField withPin: [p_Device.portA findPin: 0]];
    [self setPinIOTypeForButton: self.portA1Button andImageView: self.portA1ImageView andTextField: self.portA1TextField  withPin: [p_Device.portA findPin: 1]];
    [self setPinIOTypeForButton: self.portA2Button andImageView: self.portA2ImageView andTextField: self.portA2TextField  withPin: [p_Device.portA findPin: 2]];
    [self setPinIOTypeForButton: self.portA3Button andImageView: self.portA3ImageView andTextField: self.portA3TextField  withPin: [p_Device.portA findPin: 3]];
    [self setPinIOTypeForButton: self.portA4Button andImageView: self.portA4ImageView andTextField: self.portA4TextField  withPin: [p_Device.portA findPin: 4]];
    [self setPinIOTypeForButton: self.portA5Button andImageView: self.portA5ImageView andTextField: self.portA5TextField  withPin: [p_Device.portA findPin: 5]];
    [self setPinIOTypeForButton: self.portA6Button andImageView: self.portA6ImageView andTextField: self.portA6TextField  withPin: [p_Device.portA findPin: 6]];
    [self setPinIOTypeForButton: self.portA7Button andImageView: self.portA7ImageView andTextField: self.portA7TextField  withPin: [p_Device.portA findPin: 7]];
    
    [self setPinIOTypeForButton: self.portB0Button andImageView: self.portB0ImageView andTextField: self.portB0TextField withPin: [p_Device.portB findPin: 0]];
    [self setPinIOTypeForButton: self.portB1Button andImageView: self.portB1ImageView andTextField: self.portB1TextField withPin: [p_Device.portB findPin: 1]];
    [self setPinIOTypeForButton: self.portB2Button andImageView: self.portB2ImageView andTextField: self.portB2TextField withPin: [p_Device.portB findPin: 2]];
    [self setPinIOTypeForButton: self.portB3Button andImageView: self.portB3ImageView andTextField: self.portB3TextField withPin: [p_Device.portB findPin: 3]];
    [self setPinIOTypeForButton: self.portB4Button andImageView: self.portB4ImageView  andTextField: self.portB4TextField withPin: [p_Device.portB findPin: 4]];
    [self setPinIOTypeForButton: self.portB5Button andImageView: self.portB5ImageView andTextField: self.portB5TextField withPin: [p_Device.portB findPin: 5]];
    [self setPinIOTypeForButton: self.portB6Button andImageView: self.portB6ImageView andTextField: self.portB6TextField withPin: [p_Device.portB findPin: 6]];
    [self setPinIOTypeForButton: self.portB7Button andImageView: self.portB7ImageView andTextField: self.portB7TextField withPin: [p_Device.portB findPin: 7]];
}

- (void) setPinIOTypeForButton: (NSButton *)p_Button 
                  andImageView: (NSImageView *)p_ImageView
                  andTextField: (NSTextField *)p_TextField
                       withPin: (USBmicroPin *)p_Pin
{
    if (p_Pin == nil)
    {
        [self setAsHiddenWithButton:p_Button andImageView:p_ImageView andTextField:p_TextField];
    }
    else
    {
        switch (p_Pin.ioType) 
        {
            case IOTYPE_READ:
                [self setAsReadWithButton:p_Button andImageView:p_ImageView andTextField:p_TextField];
                break;
                
            case IOTYPE_WRITE:
                [self setAsWriteWithButton:p_Button andImageView:p_ImageView andTextField:p_TextField];
                break;
                
            case IOTYPE_1WIRE:
                [self setAs1WireWithButton:p_Button andImageView:p_ImageView andTextField:p_TextField];
                break;
        }
    }
}

- (void) setPinState: (USBmicroDevice *)p_Device
{
    [self setPinStateForButton:self.portA0Button orImage:self.portA0ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 0]];
    [self setPinStateForButton:self.portA1Button orImage:self.portA1ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 1]];
    [self setPinStateForButton:self.portA2Button orImage:self.portA2ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 2]];
    [self setPinStateForButton:self.portA3Button orImage:self.portA3ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 3]];
    [self setPinStateForButton:self.portA4Button orImage:self.portA4ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 4]];
    [self setPinStateForButton:self.portA5Button orImage:self.portA5ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 5]];
    [self setPinStateForButton:self.portA6Button orImage:self.portA6ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 6]];
    [self setPinStateForButton:self.portA7Button orImage:self.portA7ImageView orTextField:self.portB0TextField forPin:[p_Device.portA findPin: 7]];

    [self setPinStateForButton:self.portB0Button orImage:self.portB0ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 0]];
    [self setPinStateForButton:self.portB1Button orImage:self.portB1ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 1]];
    [self setPinStateForButton:self.portB2Button orImage:self.portB2ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 2]];
    [self setPinStateForButton:self.portB3Button orImage:self.portB3ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 3]];
    [self setPinStateForButton:self.portB4Button orImage:self.portB4ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 4]];
    [self setPinStateForButton:self.portB5Button orImage:self.portB5ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 5]];
    [self setPinStateForButton:self.portB6Button orImage:self.portB6ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 6]];
    [self setPinStateForButton:self.portB7Button orImage:self.portB7ImageView orTextField:self.portB0TextField forPin:[p_Device.portB findPin: 7]];
}

- (void)setPinStateForButton: (NSButton *)p_Button 
                     orImage: (NSImageView *)p_ImageView
                 orTextField: (NSTextField *)p_TextField
                      forPin: (USBmicroPin *)p_Pin
{
    switch (p_Pin.ioType)
    {
        case IOTYPE_READ:
            p_ImageView.image = p_Pin.isOn ? [NSImage imageNamed: @"OnDot.png"] : [NSImage imageNamed: @"OffDot.png"];
            break;
        case IOTYPE_WRITE:
            p_Button.state = p_Pin.isOn ? NSOnState : NSOffState;
            break;
        case IOTYPE_1WIRE:
            p_TextField.stringValue = [NSString stringWithFormat:@"%.01f˚%@", p_Pin.temperatureSensor.lastReadTemperature, p_Pin.temperatureSensor.displayType == TDT_FAHRENHEIT ? @"F" : @"C"];
            break;
    }
}

- (BOOL) updateDataFromView: (USBmicroDevice *)p_Data
           selectionChanged: (BOOL) p_SelectionChanged
{
    // This is set individually each time a button is pressed
    return YES;
}

- (void) beep
{
    // 10.6 and before
    NSString *soundFile = @"/System/Library/Components/CoreAudio.component/Contents/Resources/SystemSounds/system/burn failed.aif";
    if ([[NSFileManager defaultManager] fileExistsAtPath: soundFile] == NO)
    {
        // 10.7 and above
        soundFile = @"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/system/burn failed.aif";
    }
    
    NSSound *sound = [[NSSound alloc] initWithContentsOfFile: soundFile byReference:YES];
    [sound play];
}

@end

//
//  MainWindowController.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/15/12.
//  Copyright (c) 2012 StrandControl, LLC. All rights reserved.
//
/*  This software is licensed under the terms of the
 GNU Public License v3 as outlined in the LICENSE-gpl3.txt 
 located at the root of the source distribution. */

#import <Cocoa/Cocoa.h>
#import "USBmicroDevices.h"

@interface MainWindowController : NSWindowController
{
@private
    NSTableView *_deviceTableView;
    NSTextField *_titleTextField;
    NSTextField *_productTypeTextField;
    NSTextField *_serialNumberTextField;

	NSButton *_portA0Button;
    NSImageView *_portA0ImageView;
    NSTextField *_portA0TextField;
    
	NSButton *_portA1Button;
    NSImageView *_portA1ImageView;
    NSTextField *_portA1TextField;
    
	NSButton *_portA2Button;
    NSImageView *_portA2ImageView;
    NSTextField *_portA2TextField;
    
	NSButton *_portA3Button;
    NSImageView *_portA3ImageView;
    NSTextField *_portA3TextField;
    
	NSButton *_portA4Button;
    NSImageView *_portA4ImageView;
    NSTextField *_portA4TextField;
    
	NSButton *_portA5Button;
    NSImageView *_portA5ImageView;
    NSTextField *_portA5TextField;
    
	NSButton *_portA6Button;
    NSImageView *_portA6ImageView;
    NSTextField *_portA6TextField;
    
	NSButton *_portA7Button;
    NSImageView *_portA7ImageView;
    NSTextField *_portA7TextField;
  
    
	NSButton *_portB0Button;
    NSImageView *_portB0ImageView;
    NSTextField *_portB0TextField;
    
	NSButton *_portB1Button;
    NSImageView *_portB1ImageView;
    NSTextField *_portB1TextField;
    
	NSButton *_portB2Button;
    NSImageView *_portB2ImageView;
    NSTextField *_portB2TextField;
    
	NSButton *_portB3Button;
    NSImageView *_portB3ImageView;
    NSTextField *_portB3TextField;
    
	NSButton *_portB4Button;
    NSImageView *_portB4ImageView;
    NSTextField *_portB4TextField;
    
	NSButton *_portB5Button;
    NSImageView *_portB5ImageView;
    NSTextField *_portB5TextField;
    
	NSButton *_portB6Button;
    NSImageView *_portB6ImageView;
    NSTextField *_portB6TextField;
    
	NSButton *_portB7Button;
    NSImageView *_portB7ImageView;
    NSTextField *_portB7TextField;
    
    USBmicroDevices *_devices;
    USBmicroDevice *_selectedDevice;
    NSButton *_lastPortButton;
    NSImageView *_lastPortImageView;
    NSTextField *_lastPortTextField;
    USBmicroPin *_lastPin;
    BOOL _lastPortIsB;
}

@property (nonatomic, retain) IBOutlet NSTableView *deviceTableView;
@property (nonatomic, retain) IBOutlet NSTextField *titleTextField;
@property (nonatomic, retain) IBOutlet NSTextField *productTypeTextField;
@property (nonatomic, retain) IBOutlet NSTextField *serialNumberTextField;

@property (nonatomic, retain) IBOutlet NSButton *portA0Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA0ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA0TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA1Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA1ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA1TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA2Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA2ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA2TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA3Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA3ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA3TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA4Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA4ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA4TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA5Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA5ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA5TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA6Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA6ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA6TextField;

@property (nonatomic, retain) IBOutlet NSButton *portA7Button;
@property (nonatomic, retain) IBOutlet NSImageView *portA7ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portA7TextField;


@property (nonatomic, retain) IBOutlet NSButton *portB0Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB0ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB0TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB1Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB1ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB1TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB2Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB2ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB2TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB3Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB3ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB3TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB4Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB4ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB4TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB5Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB5ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB5TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB6Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB6ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB6TextField;

@property (nonatomic, retain) IBOutlet NSButton *portB7Button;
@property (nonatomic, retain) IBOutlet NSImageView *portB7ImageView;
@property (nonatomic, retain) IBOutlet NSTextField *portB7TextField;

@property (nonatomic, retain) USBmicroDevices *devices;
@property (nonatomic, retain) USBmicroDevice *selectedDevice;
@property (nonatomic, retain) NSButton *lastPortButton;
@property (nonatomic, retain) NSImageView *lastPortImageView;
@property (nonatomic, retain)NSTextField *lastPortTextField;
@property (nonatomic, retain) USBmicroPin *lastPin;
@property (nonatomic, retain) USBmicroPort *lastPort;

- (IBAction) portASetupButtonClicked: (id) sender;

- (IBAction) portA0ButtonClicked: (id) sender;
- (IBAction) portA0SetupButtonClicked: (id) sender;

- (IBAction) portA1ButtonClicked: (id) sender;
- (IBAction) portA1SetupButtonClicked: (id) sender;

- (IBAction) portA2ButtonClicked: (id) sender;
- (IBAction) portA2SetupButtonClicked: (id) sender;

- (IBAction) portA3ButtonClicked: (id) sender;
- (IBAction) portA3SetupButtonClicked: (id) sender;

- (IBAction) portA4ButtonClicked: (id) sender;
- (IBAction) portA4SetupButtonClicked: (id) sender;

- (IBAction) portA5ButtonClicked: (id) sender;
- (IBAction) portA5SetupButtonClicked: (id) sender;

- (IBAction) portA6ButtonClicked: (id) sender;
- (IBAction) portA6SetupButtonClicked: (id) sender;

- (IBAction) portA7ButtonClicked: (id) sender;
- (IBAction) portA7SetupButtonClicked: (id) sender;


- (IBAction) portBSetupButtonClicked: (id) sender;

- (IBAction) portB0ButtonClicked: (id) sender;
- (IBAction) portB0SetupButtonClicked: (id) sender;

- (IBAction) portB1ButtonClicked: (id) sender;
- (IBAction) portB1SetupButtonClicked: (id) sender;

- (IBAction) portB2ButtonClicked: (id) sender;
- (IBAction) portB2SetupButtonClicked: (id) sender;

- (IBAction) portB3ButtonClicked: (id) sender;
- (IBAction) portB3SetupButtonClicked: (id) sender;

- (IBAction) portB4ButtonClicked: (id) sender;
- (IBAction) portB4SetupButtonClicked: (id) sender;

- (IBAction) portB5ButtonClicked: (id) sender;
- (IBAction) portB5SetupButtonClicked: (id) sender;

- (IBAction) portB6ButtonClicked: (id) sender;
- (IBAction) portB6SetupButtonClicked: (id) sender;

- (IBAction) portB7ButtonClicked: (id) sender;
- (IBAction) portB7SetupButtonClicked: (id) sender;

- (void) setupEvents;
- (void) setupEventsForDevice: (USBmicroDevice *)p_Device;
- (void) displayMenuOnButton: (id) sender
                     forPort: (NSString *)p_Port 
                      andPin: (NSUInteger)p_Pin;
- (NSMenu *) buttonMenu;
- (void) setLastButtonForPort:(USBmicroPort *)p_Port andPin:(USBmicroPin *)p_Pin;
- (void) setLastButtonForPortAPin:(USBmicroPin *)p_Pin;
- (void) setLastButtonForPortBPin:(USBmicroPin *)p_Pin;
- (IBAction) setAsRead: (id)sender;
- (void) setAsReadPort: (USBmicroPort *)p_Port
                andPin: (USBmicroPin *)p_Pin;
- (void) setAsReadWithButton: (NSButton *)p_Button
                andImageView: (NSImageView *)p_ImageView 
                andTextField: (NSTextField *)p_TextField;
- (IBAction) setAsWrite: (id)sender;
- (void) setAsWritePort: (USBmicroPort *)p_Port
                andPin: (USBmicroPin *)p_Pin;
- (void) setAsWriteWithButton: (NSButton *)p_Button
                 andImageView: (NSImageView *)p_ImageView 
                 andTextField: (NSTextField *)p_TextField;
- (IBAction) setAs1Wire: (id)sender;
- (void) setAs1WirePort: (USBmicroPort *)p_Port
                 andPin: (USBmicroPin *)p_Pin;
- (void) setAs1WireWithButton: (NSButton *)p_Button
                 andImageView: (NSImageView *)p_ImageView 
                 andTextField: (NSTextField *)p_TextField;
- (void) setAsHiddenWithButton: (NSButton *)p_Button
                  andImageView: (NSImageView *)p_ImageView 
                  andTextField: (NSTextField *)p_TextField;

- (void) updateViewWithData: (USBmicroDevice *)p_Data
           selectionChanged: (BOOL) p_SelectionChanged;
- (void) setPinIOType: (USBmicroDevice *)p_Device;
- (void) setPinIOTypeForButton: (NSButton *)p_Button 
                  andImageView: (NSImageView *)p_ImageView 
                  andTextField: (NSTextField *)p_TextField 
                       withPin: (USBmicroPin *)p_Pin;
- (void) setPinState: (USBmicroDevice *)p_Device;
- (void)setPinStateForButton: (NSButton *)p_Button 
                     orImage: (NSImageView *)p_ImageView 
                 orTextField: (NSTextField *)p_TextField 
                      forPin: (USBmicroPin *)p_Pin;

- (BOOL) updateDataFromView: (USBmicroDevice *)p_Data
           selectionChanged: (BOOL) p_SelectionChanged;
- (void) beep;

@end

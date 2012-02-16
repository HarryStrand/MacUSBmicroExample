//
//  OutlineView.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OutlineView : NSOutlineView 
{
@private
    id _notifyObject;
    SEL _notifyKeyDown;
    BOOL _indentAfterTopLevelOn10_7;
    BOOL _is10_7orGreater;
    BOOL _isOsVersionChecked;
}

/*!
 @abstract The object that implements the notification selector
 */
@property (nonatomic, retain) id notifyObject;

/*!
 @abstract The function to call to notify about the keystroke.  The function is passed an NSEvent * parameter.  You can get the get the character by calling [[p_Event characters] characterAtIndex:0].
 */
@property (nonatomic) SEL notifyKeyDown;

/*!
 @abstract The only purpose of this is to deal with the goofiness of 10.7 where it wouldn't indent the first level for some reason.
 */
@property (nonatomic) BOOL indentAfterTopLevelOn10_7;


- (void) checkOsVersion;

@end

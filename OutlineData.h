//
//  OutlineData.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@class OutlineNode;
 
/*!
 @header
 @abstract OutlineData is the base class of data used with view controllers that are used with a OutlineViewDelegate.
 @discussion This object is used as the base class of data objects that are used with updateViewWithData and updateDataFromView call.  to supply to create the structure of the data to be used with the OutlineViewDelegate object.  The object inheriting this object should provide the view, title, image, and override methods for the needed functionality of the item.
 */

@interface OutlineData : NSObject 
{
@private
    __weak OutlineNode *_node;
}

@property (weak) OutlineNode *node;

/*!
 @abstract Overridden by the child class with a function that provides the current NSView to display
 */
- (NSView *) currentView;

/*!
 @abstract Overridden by the child class with a function that provides the view with data.  Overriding it is required.
 */
- (void) updateViewWithData: (OutlineNode *)p_Node
           selectionChanged: (BOOL) p_SelectionChanged;

/*!
 @abstract Overridden by the child class with a function that updates the data with the current contents of the view.  Overriding it is optional.
 @returns Return YES if it should allow selecting of the next row, or NO if it should prevent moving to the new row.
 */
- (BOOL) updateDataFromView: (OutlineNode *)p_Node
           selectionChanged: (BOOL) p_SelectionChanged;

/*!
 @abstract Overridden by the child class with a function that updates the externalControlsEnabled dictionary with items that are to be enabled or disabled.  Overriding it is optional.
 */
- (void) updateToolbarAndMenuControls: (OutlineNode *)p_Node;

/*!
 @abstract Overridden by the child class with a function that returns an NSMenu to display when right clicking on the item.  It is not required that it be defined by the child class. 
 @returns Returns an NSMenu to display on a right click, or nil for none.
 */
- (NSMenu *) rightClickMenu: (OutlineNode *)p_Node;

/*!
 @abstract Overridden by the child class with a function that returns an NSArray of NSMenuItems to display on the file menu in the variable menu item area.  It is not required that it be defined by the child class. 
 @returns Returns an NSArray of NSMenuItems to display on a right click, or nil for none.
 */
- (NSArray *) variableMenuItems: (OutlineNode *)p_Node;

/*!
 @abstract Gets the first tab control for the view.  It returns nil if there isn't one.
 */
- (NSView *) firstTabControl: (OutlineNode *)p_Node;

/*!
 @abstract Gets the last tab control for the view.  It returns nil if there isn't one.
 */
- (NSView *) lastTabControl: (OutlineNode *)p_Node;

/*!
 @abstract Overridden by the child class if it needs to only allow specific files to be dropped on the node.  Otherwise it doesn't need to be overridden.
 @returns Returns YES if the file is OK for a drop, otherwise NO.
 */
- (BOOL) isValidDropFile: (NSString *)p_File;

/*!
 @abstract Overridden by the child class if it needs to make a change when a parent, grandparent, etc. changes.  Otherwise it doesn't need to be overridden.
 */
- (void) parentNode: (OutlineNode *)p_ParentNode 
        changedFrom: (NSString *)p_From 
                 to: (NSString *)p_To;

/*!
 @abstract Called when file system monitoring is turned on and something with a path was changed.  Properties for the path and all its immediate children should be updated.
 @returns If the change is handled and no other nodes need to be informed, it should return YES, otherwise it should return NO.
 */
- (BOOL) notifyAboutFileSystemChange: (NSString *)p_Path
                                node: (OutlineNode *)p_Node;

@end

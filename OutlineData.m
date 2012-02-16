//
//  OutlineData.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "OutlineData.h"

@implementation OutlineData

@synthesize node = _node;

- (id)init
{
    self = [super init];
    if (self) 
	{
        _node = nil;
    }
    
    return self;
}

- (NSView *) currentView
{
    // This should be overridden by the child object, but it's optional if no view should be displayed.
    return nil;
}

- (void) updateViewWithData: (OutlineNode *)p_Node
           selectionChanged: (BOOL) p_SelectionChanged
{
    [NSException raise: @"updateViewWithData not implemented" format: @"updateViewWithData should be overriden by the child object"];
}

- (BOOL) updateDataFromView: (OutlineNode *)p_Node
           selectionChanged: (BOOL) p_SelectionChanged
{
    // This should be overridden by the child object, but it's optional.
    return YES;
}

- (void) updateToolbarAndMenuControls: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
}

- (NSMenu *) rightClickMenu: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
    return nil;
}

- (NSArray *) variableMenuItems: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
    return nil;
}

- (NSView *) firstTabControl: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
    return nil;
}

- (NSView *) lastTabControl: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
    return nil;
}

- (BOOL) isValidDropFile: (NSString *)p_File
{
    // This should be overridden by the child object, but it's optional.
    // If it doesn't override, it's essentially saying that it's not picky about specifically what type of file can be dropped on it.  It won't even ask if the node doesn't have isDropable set to YES. 
    return YES;
}

- (void) parentNode: (OutlineNode *)p_Node
        changedFrom: (NSString *)p_From
                 to: (NSString *)p_To
{
    // This should be overridden by the child object, but it's optional.
}

- (BOOL) notifyAboutFileSystemChange: (NSString *)p_Path
                                node: (OutlineNode *)p_Node
{
    // This should be overridden by the child object, but it's optional.
    return NO;
}

@end

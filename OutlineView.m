//
//  OutlineView.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "OutlineView.h"
#import "OutlineNode.h"
#import "OutlineViewDelegate.h"

@implementation OutlineView

@synthesize notifyObject = _notifyObject;
@synthesize notifyKeyDown = _notifyKeyDown;
@synthesize indentAfterTopLevelOn10_7 = _indentAfterTopLevelOn10_7;

- (id)init
{
    self = [super init];
    if (self) 
	{
        _indentAfterTopLevelOn10_7 = NO;
        _is10_7orGreater = NO;
        _isOsVersionChecked = NO;
    }
    
    return self;
}

- (void)reloadData;
{
	[super reloadData];
	
    NSInteger i;
	for (i = 0; i < [self numberOfRows]; i++) 
    {
		NSTreeNode *item = [self itemAtRow:i];
        OutlineNode *node = [item representedObject];
		if(node.isExpanded == YES)
			[self expandItem:item];
	}
}

-(NSMenu*)menuForEvent:(NSEvent*)evt 
{
    if (self.isEnabled == NO)
        return nil;
        
    NSPoint pt = [self convertPoint:[evt locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:pt];
    
    
    NSTreeNode *item = [self itemAtRow: row];
    OutlineNode *node = nil;
    if (item != nil)
        node = [item representedObject];
    
    NSMenu *menu = nil;
    if (node != nil)
    {
        // Select the node
        OutlineViewDelegate *outlineViewDelegate = [self delegate];
        
        BOOL shouldSelect = [outlineViewDelegate outlineView: self shouldSelectItem:item];
        if (shouldSelect == YES)
        {
            BOOL extendSelection = NO;
            if ([self allowsMultipleSelection] == YES)
            {
                if ([self isRowSelected: row])
                    extendSelection = YES;
            }
            
            [self selectRowIndexes: [NSIndexSet indexSetWithIndex: row] byExtendingSelection: extendSelection];

            // If the data object is nil, try expanding the parent
            if (node.dataObject == nil)
                [node.parent outlineNodeDidExpand];
            
            if (node.dataObject != nil)
                menu = [node.dataObject rightClickMenu: node];
        }
    }

    return menu;
}

- (BOOL)becomeFirstResponder
{
    NSLog(@"becomeFirstResponder");
    
    if ([self selectedRow] < 0)
        [self selectRowIndexes: [NSIndexSet indexSetWithIndex: 0] byExtendingSelection: NO];

    if ([self.delegate isKindOfClass: [OutlineViewDelegate class]])
    {
        OutlineViewDelegate *outlineViewDelegate = [self delegate];
        [outlineViewDelegate refreshExternalControls];
    }
    
    if ([super respondsToSelector: @selector(becomeFirstResponder)])
        return [super becomeFirstResponder];
    else
        return YES;
}

- (BOOL)resignFirstResponder
{
    NSLog(@"resignFirstResponder");
    
    BOOL result = YES;
    if ([super respondsToSelector: @selector(becomeFirstResponder)])
        result = [super becomeFirstResponder];

    if ([self.delegate isKindOfClass: [OutlineViewDelegate class]])
    {
        OutlineViewDelegate *outlineViewDelegate = [self delegate];
        [outlineViewDelegate refreshExternalControls];
    }
    
    return result;
}

-(void)keyDown:(NSEvent *)p_Event 
{
    NSLog(@"OutlineView: keyDown: %c", [[p_Event characters] characterAtIndex:0]);
    
    if (self.notifyObject != nil)
    {
        [self.notifyObject performSelector: self.notifyKeyDown withObject: p_Event];
    }
    
    [super keyDown: p_Event];
}

- (void) mouseDown:(NSEvent *)theEvent
{
	if (self.allowsEmptySelection == YES)
    {
        NSPoint event_location = [theEvent locationInWindow];
        NSPoint local_point = [self convertPoint:event_location toView:nil];
        
        if ([self rowAtPoint: local_point] < 0)
        {
            if ([self.delegate isKindOfClass: [OutlineViewDelegate class]])
            {
               NSTreeNode *selectedTreeNode = [self itemAtRow: [self selectedRow]];
                OutlineViewDelegate *outlineViewDelegate = [self delegate];
                
                if ([outlineViewDelegate outlineView: self shouldSelectItem: selectedTreeNode])
                {
                    [outlineViewDelegate selectNode: nil];
                }
            }
        }
    }
    
	[super mouseDown:theEvent];
}

// Indent the contents extra in Lion.
- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row
{
    if (_isOsVersionChecked == NO)
        [self checkOsVersion];
        
    NSRect frame = [super frameOfCellAtColumn:column row:row];

    if (_is10_7orGreater && self.indentAfterTopLevelOn10_7 && [self levelForRow: row] > 0)
    {
        frame.origin.x += 14;
        frame.size.width -= 14;
    }
    
    return frame;
}

// Indent the disclosure triangle extra in Lion.
- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
{
    if (_isOsVersionChecked == NO)
        [self checkOsVersion];
    
    NSRect frame = [super frameOfOutlineCellAtRow:row];
    
    if (_is10_7orGreater && self.indentAfterTopLevelOn10_7 && [self levelForRow: row] > 0)
    {
        frame.origin.x += 14;
    }
    
    return frame;
}

- (void) checkOsVersion
{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *version = [processInfo operatingSystemVersionString];
    if ([version compare: @"10.7"] == NSOrderedAscending)
        _is10_7orGreater = NO;
    else
        _is10_7orGreater = YES;

    _isOsVersionChecked = YES;
}

#pragma mark - NSResponder 
// Method called by Cocoa when ESC or CMD . is pressed.
// See documentation for NSResponder for details
- (void)cancelOperation:(id)sender
{
    [self abortEditing];
    [[self window] makeFirstResponder:self];
}

@end

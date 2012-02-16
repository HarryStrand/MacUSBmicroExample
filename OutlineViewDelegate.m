//
//  OutlineViewDelegate.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "OutlineViewDelegate.h"
#import "ImageAndTextCell.h"

@implementation OutlineViewDelegate

@synthesize outlineView = _outlineView;
@synthesize treeController = _treeController; 
@synthesize viewController = _viewController;
@synthesize contents = _contents;
@synthesize notifyObject = _notifyObject;
@synthesize notifySelectionChanged = _notifySelectionChanged;
@synthesize notifyMultipleSelectionChanged = _notifyMultipleSelectionChanged;
@synthesize dropBegin = _dropBegin;
@synthesize newNodeForFileDrop = _newNodeForFileDrop;
@synthesize newNodeForWebUrlDrop = _newNodeForWebUrlDrop;
@synthesize dropEnd = _dropEnd;
@synthesize overrideView = _overrideView;
@synthesize noSelectionView = _noSelectionView;
@synthesize allowDragAndDrop = _allowDragAndDrop;
@synthesize allowDropOnNoNode = _allowDropOnNoNode;
@synthesize parentWindow = _parentWindow;
@synthesize prevTabControl = _prevTabControl;
@synthesize nextTabControl = _nextTabControl;

@synthesize externalControlsEnabled = _externalControlsEnabled;
@synthesize prevRenameString = _prevRenameString;
@synthesize dragNodesArray = _dragNodesArray;
@synthesize lastSelectedNode = _lastSelectedNode;
@synthesize deleteInProgess = _deleteInProgress;
@synthesize isEditing = _isEditing;
@synthesize rootNode = _rootNode;
@synthesize stream = _stream;
@synthesize isExpanding = _isExpanding;
@synthesize pathsToWatch = _pathsToWatch;
@synthesize refreshingExternalControls = _refreshingExternalControls;
@synthesize dragAndDropContext = _dragAndDropContext;
@synthesize stopMonitoringQty = _stopMonitoringQty;

#define COLUMNID_NAME			@"NameColumn"	// the single column name in our outline view

- (id)init
{
    self = [super init];
    if (self) 
    {
        _viewController = nil;
        _contents = [[NSMutableArray alloc] init];
        _notifyObject = nil;
        _dropBegin = nil;
        _newNodeForFileDrop = nil;
        _newNodeForWebUrlDrop = nil;
        _dropEnd = nil;
        _overrideView = nil;
        _noSelectionView = nil;
        _allowDragAndDrop = YES;
        _allowDropOnNoNode = YES;
        _parentWindow = nil;
        _prevTabControl = nil;
        _nextTabControl = nil;
        
        _prevRenameString = nil;
        _dragNodesArray = nil;
        _lastSelectedNode = nil;
        _deleteInProgress = NO;
        _isEditing = NO;
        _rootNode = nil;
        _stream = NULL;
        _isExpanding = NO;
        _pathsToWatch = nil;
        _nodesToSelect = nil;
        _refreshingExternalControls = NO;
        _dragAndDropContext = nil;
        _stopMonitoringQty = 0;
    }
    
    return self;
}

- (void)onAwakeFromNib
{
}

- (void)setContent: (OutlineNode *)p_Node
{
    // Make sure this function is only called on the main thread since it's not thread safe
    if ([NSThread isMainThread] == NO)
    {
        [self performSelectorOnMainThread: @selector(setContent:) withObject:p_Node waitUntilDone: YES];
        return;
    }
        
/*
    [self.treeController removeObjectAtArrangedObjectIndexPath: [NSIndexPath indexPathWithIndex: 0]]; 
    [self addChildNodes: p_Node];
*/
    // NOTE: When setContent is called instead of addChildNodes, the root node should not be part of the index paths for the children.  You can remove the first node by calling the node's removeFirstIndexPath function, however make sure this is only called once, not each time the content is set.
    
    self.rootNode = p_Node;
    p_Node.treeController = self.treeController;
    [self.rootNode updateChildIndexPaths];
    [self.treeController setContent: p_Node.children];
    
    [self.outlineView reloadData];
    
    if ([self.outlineView selectedRow] < 0)
    {
        // Clear the view until a selection is made again
        if (self.overrideView == nil)
            [self replaceContentsWithView: nil];
    }
    
    [self setupTabbing];
}

- (void)startRenameOfSelectedNode
{
    NSTreeNode *selectedNode = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    BOOL shouldEdit = [self outlineView: self.outlineView shouldEditTableColumn:[self.outlineView outlineTableColumn] item: selectedNode];
    
    if (shouldEdit == YES)
    {
        [self.outlineView editColumn: (NSInteger)0 row: [self.outlineView selectedRow] withEvent: nil select: YES];
    }
}

- (void) selectNode: (OutlineNode *)p_Node
{
    [self selectNode: p_Node byExtendingSelection: NO];
}

- (void)  selectNode: (OutlineNode *)p_Node 
byExtendingSelection: (BOOL)p_ExtendSelection
{
    if (p_Node == nil)
    {
        [self.outlineView deselectAll: nil];
        return;
    }

    NSTreeNode *treeNode = [self treeNodeForOutlineNode: p_Node];
    if (treeNode != nil)
    {
        NSInteger row = [self.outlineView rowForItem: treeNode];

        BOOL shouldSelect = [self outlineView: self.outlineView shouldSelectItem: treeNode];
        if (shouldSelect)
        {
            [self.outlineView selectRowIndexes: [NSIndexSet indexSetWithIndex: row] byExtendingSelection: p_ExtendSelection];
            
            [self switchNode: self.lastSelectedNode toNode: p_Node];   
        }
    }
    else
    {
        NSLog(@"The treenode was not found when selecting node");
    }
}

- (void) selectAndExpandNodes: (NSArray *)p_Nodes
{
    NSUInteger qty = [p_Nodes count];
    for (int idx = 0; idx < qty; idx++)
    {
        OutlineNode *item = [p_Nodes objectAtIndex: idx];
        [item expandParentNodes: self.rootNode];
    }
    
    [self setContent: self.rootNode];
    
    for (int idx = 0; idx < qty; idx++)
    {
        OutlineNode *item = [p_Nodes objectAtIndex: idx];
        OutlineNode *equivalentNode = [self.rootNode findEquivalentChildRecursive: item];
        [self selectNode: equivalentNode byExtendingSelection: (idx != 0)];
    }
}

- (NSTreeNode *) treeNodeForOutlineNode: (OutlineNode *)p_Node
{
    NSInteger qty = [self.outlineView numberOfRows];
    for (NSInteger row = 0; row < qty; row++)
    {
        NSTreeNode *treeNode = [self.outlineView itemAtRow: row];
        OutlineNode *node = (OutlineNode *)treeNode.representedObject;
        if (node == p_Node)
            return treeNode;
    }
    return nil;
}

- (BOOL) selectFirstSelectableNode: (OutlineNode *)p_Node
{
    if (p_Node.canSelect == YES)
    {
        [self selectNode: p_Node];
        if (self.overrideView == nil)
            [self replaceContentsWithView: [p_Node.dataObject currentView]];
        return YES;
    }
    else
    {
        BOOL found = NO;
        NSUInteger qty = [p_Node.children count];
        for (int idx = 0; idx < qty && found == NO; idx++)
        {
            OutlineNode *node = [p_Node.children objectAtIndex: idx];

            if (node.canSelect == YES)
            {
                [self.outlineView selectRowIndexes: [NSIndexSet indexSetWithIndex: idx] byExtendingSelection:NO];
            }
            
            found = [self selectFirstSelectableNode: node];
        }
        
        return found;
    }
}

#pragma mark - NSOutlineView delegate

// -------------------------------------------------------------------------------
//	shouldSelectItem:item
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
    NSTreeNode *treeNode = (NSTreeNode *)item;
    OutlineNode *node = (OutlineNode *)treeNode.representedObject;
    
    if (node.canSelect)
    {
        // Get the current selection item
        OutlineNode *currentNode = nil;
        id item = [outlineView itemAtRow:[outlineView selectedRow]];
        if (item != nil)
        {
            NSTreeNode *currentTreeNode = (NSTreeNode *)item;
            currentNode = (OutlineNode *)currentTreeNode.representedObject;
            
            if (self.isEditing)
                [self restoreAfterEdit: currentNode];
        }
        
        BOOL shouldSelect = YES;
        if (currentNode != nil && currentNode.dataObject != nil)
        {
            shouldSelect = [currentNode.dataObject updateDataFromView: currentNode selectionChanged: (node != currentNode)];
        }
        
        if (self.isExpanding == NO)
            self.lastSelectedNode = currentNode;

        return shouldSelect;
    }
    else
        return NO;
}

- (void) switchNode: (OutlineNode *)p_FromNode toNode: (OutlineNode *)p_ToNode   
{
    // Disable any control that depends on the selection.  The appropriate items should be re-enabled by the the updateViewWithData function.
    [self disableAllExternalControls];
    
    if (p_ToNode.dataObject != nil)
    {
        [p_ToNode.dataObject updateViewWithData: p_ToNode selectionChanged: YES];
        [p_ToNode.dataObject updateToolbarAndMenuControls: p_ToNode];
        [self setupTabbing];
    }
    
    if (self.notifyObject != nil && self.notifySelectionChanged != nil)
    {
        [self.notifyObject performSelector: self.notifySelectionChanged withObject: p_FromNode withObject: p_ToNode]; 
    }
    
    if (self.overrideView == nil)
    {
        [self replaceContentsWithView: [p_ToNode.dataObject currentView]];
    }
}
    
- (void) refreshExternalControls
{
    NSLog(@"refreshExternalControls");
    
    // It's possible for data objects to call this recursively, so we need to make sure it ignores subsequent calls.
    if (self.refreshingExternalControls == YES)
        return;
    
    self.refreshingExternalControls = YES;
    
    [self disableAllExternalControls];
    
    [self refreshCurrentSelection];
    
    if (self.lastSelectedNode != nil && self.lastSelectedNode.dataObject != nil)
    {
        [self.lastSelectedNode.dataObject updateToolbarAndMenuControls: self.lastSelectedNode];
    }
    
    self.refreshingExternalControls = NO;
}

- (void) switchToOverrideView: (NSView *)p_View
{
    // Switch to a view that overrides any data views
    self.overrideView = p_View;
    [self replaceContentsWithView: self.overrideView];
}

- (void) replaceContentsWithView: (NSView *)p_View
{
    NSView *view = p_View;

    if (view == nil)
        view = self.noSelectionView;
    
    [self.viewController replaceMyContentsWithView: view];
}

- (void) switchToDataView
{
    // Switch back to data views
    NSView *currentDataView = nil;
    OutlineNode *currentNode = nil;
    NSInteger selectedRow = [self.outlineView selectedRow];
    id item = [self.outlineView itemAtRow: selectedRow];
    if (item != nil)
    {
        NSTreeNode *currentTreeNode = (NSTreeNode *)item;
        currentNode = (OutlineNode *)currentTreeNode.representedObject;
    }
    if (currentNode != nil)
        currentDataView = [currentNode.dataObject currentView];
        
    self.overrideView = nil;
    [self replaceContentsWithView: currentDataView];
}

- (BOOL) refreshCurrentSelection
{
    // Get the current selection item
    OutlineNode *selectedItem = nil;
    id item = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (item != nil)
    {
        NSTreeNode *selectedNode = (NSTreeNode *)item;
        selectedItem = (OutlineNode *)selectedNode.representedObject;
    }
    
    BOOL shouldSelect = YES;
    if (selectedItem != nil && selectedItem.dataObject != nil)
    {
        shouldSelect = [selectedItem.dataObject updateDataFromView: selectedItem selectionChanged: NO];
    }
    
    if (shouldSelect == YES)
    {
        if (selectedItem.dataObject != nil)
            [selectedItem.dataObject updateViewWithData: selectedItem selectionChanged: NO];
        
        if (self.notifyObject != nil)
        {
            [self.notifyObject performSelector: self.notifySelectionChanged withObject: selectedItem withObject: selectedItem]; 
        }
        
        if (self.overrideView == nil)
            [self replaceContentsWithView: [selectedItem.dataObject currentView]];
    }

    return shouldSelect;
}

- (void) updateToolbarAndMenuControls
{
    // Get the current selection item
    OutlineNode *selectedItem = nil;
    id item = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (item != nil)
    {
        NSTreeNode *selectedNode = (NSTreeNode *)item;
        selectedItem = (OutlineNode *)selectedNode.representedObject;
    }

    if (selectedItem.dataObject != nil)
    {
        [selectedItem.dataObject updateDataFromView: selectedItem selectionChanged: NO];
        [selectedItem.dataObject updateToolbarAndMenuControls: selectedItem];
    }
}

// -------------------------------------------------------------------------------
//	dataCellForTableColumn:tableColumn:row
// -------------------------------------------------------------------------------
- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSCell* returnCell = [tableColumn dataCell];
	
	return returnCell;
}

// -------------------------------------------------------------------------------
//	textShouldEndEditing:
// -------------------------------------------------------------------------------
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    static BOOL inProgress = NO;
    if (inProgress == YES)
        return YES;
    inProgress = YES;
    
    BOOL allowEndEditing = YES;
    NSString *renameText = [fieldEditor string];
    
    // Get the current selection item
    OutlineNode *selectedItem = nil;
    NSTreeNode *selectedNode = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (selectedNode != nil)
        selectedItem = (OutlineNode *)selectedNode.representedObject;
    
    if (selectedItem != nil)
    {
        if ([selectedItem.dataObject respondsToSelector: @selector(rename:to:)])
        {
            NSString *renameFrom = selectedItem.title;
            NSNumber *allowEndEditingValue = [selectedItem.dataObject performSelector: @selector(rename:to:) withObject: selectedItem withObject: renameText];
            allowEndEditing = [allowEndEditingValue boolValue];
            if (allowEndEditing == YES)
            {
                [selectedItem parentNode: selectedItem changedFrom: renameFrom to: renameText];
                
                if (![self.prevRenameString isEqualToString: [self.prevRenameString lastPathComponent]])
                {
                    NSString *basePath = [self.prevRenameString stringByDeletingLastPathComponent];
                    NSString *newPath = [basePath stringByAppendingPathComponent: renameText];
                    selectedItem.title = newPath;
                }
            }
        }
    }
    
    if (allowEndEditing == YES)
    {
        self.isEditing = NO;
        // This needed to be called indirectly with a delay because otherwise it would recursively call into this function.  The static inProgress field prevents it from crashing, but it didn't quite work properly.
        [self performSelector: @selector(restoreAfterEdit:) withObject: selectedItem afterDelay: .1];
    }
    
    inProgress = NO;
    
    return allowEndEditing;
}

- (void) restoreAfterEdit: (OutlineNode *)p_Node
{
    [self setContent: self.rootNode];
    self.isEditing = NO;
}

// -------------------------------------------------------------------------------
//	shouldEditTableColumn:tableColumn:item
//
//	Decide to allow the edit of the given outline view "item".
// -------------------------------------------------------------------------------
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    //need to filter out tab events and shift tab events so it does not try to edit.
    NSEvent *event = [NSApp currentEvent];
    BOOL tabbedIn = NO;
    if ([event type] == NSKeyDown) 
    {
        tabbedIn = ([[event characters] characterAtIndex:0] == NSTabCharacter) || ([[event characters] characterAtIndex:0] == NSBackTabCharacter);
    }
	
    OutlineNode *node = [item representedObject];
    BOOL result = node.isEditable;
    if (tabbedIn) 
    {
        result = NO;
    }
    else 
    {
    
        if (result == YES)
        {
            // Change the value to just the last component
            self.prevRenameString = node.title;
            
            // This strips off the first part of package names with embedded '/' characters.
//            node.title = [node.title lastPathComponent];
        }

        if (result == YES)
            self.isEditing = YES;
    }

    NSLog(@"outlineView:shouldEditTableColumn:item: isEditable = %@", result ? @"YES" : @"NO");
    
	return result;
}

// -------------------------------------------------------------------------------
//	outlineView:willDisplayCell
// -------------------------------------------------------------------------------
- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if ([[tableColumn identifier] isEqualToString:COLUMNID_NAME])
	{
		// we are displaying the single and only column
		if ([cell isKindOfClass:[ImageAndTextCell class]])
		{
            OutlineNode *node = nil;
            if ([[item representedObject] isKindOfClass: [OutlineNode class]])
            {
                node = [item representedObject];
            }

            if (node != nil)
            {
                // set the cell's image
                [(ImageAndTextCell*)cell setImage: [node icon]];
            }
		}
	}
}

// -------------------------------------------------------------------------------
//	removeSubview:
// -------------------------------------------------------------------------------
- (void)removeSubview
{

}

// -------------------------------------------------------------------------------
//	outlineViewSelectionDidChange:notification
// -------------------------------------------------------------------------------
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	// Ask the tree controller for the current selection
	NSArray *selections = [self.treeController selectedObjects];
	if ([selections count] > 1)
	{
		// multiple selection - clear the right side view
		[self removeSubview];
		self.lastSelectedNode = nil;
        
        if (self.notifyObject != nil && self.notifyMultipleSelectionChanged != nil)
        {
            [self.notifyObject performSelector: self.notifyMultipleSelectionChanged withObject: selections]; 
        }
	}
	else
	{
		if ([selections count] == 1)
		{
            OutlineNode *node = [selections objectAtIndex: 0];
            if (node != self.lastSelectedNode)
            {
                // single selection
                [self switchNode: self.lastSelectedNode toNode: node];
                if (self.isExpanding == NO)
                    self.lastSelectedNode = node;
            }
		}
		else
		{
			// there is no current selection - no view to display
            if (self.lastSelectedNode != nil)
                [self switchNode: self.lastSelectedNode toNode: nil];

			[self removeSubview];
			self.lastSelectedNode = nil;
		}
	}
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
    // Need to prevent the lastSelectedNode from getting set when 
    BOOL wasExpanding = self.isExpanding;
    self.isExpanding = YES;
    
    OutlineNode *node = [[[notification userInfo]valueForKey:@"NSObject"]representedObject];
    [node outlineNodeDidExpand];
    
    // Need to reselect this because when nodes are added, they get selected as well
    [self selectNode: self.lastSelectedNode];
    
    if (wasExpanding == NO)
        self.isExpanding = NO;
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    OutlineNode *node =
    [[[notification userInfo]valueForKey:@"NSObject"]representedObject];
    [node outlineNodeDidCollapse];
}


- (NSTreeNode *) treeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.treeController arrangedObjects] descendantNodeAtIndexPath: indexPath];
}

- (BOOL)  node: (NSTreeNode *)p_NodeToAdd 
intersectsWith: (NSTreeNode *)p_ParentNode
{
    if (p_NodeToAdd == nil || p_ParentNode == nil)
        return NO;
    
    NSIndexPath *nodeToAddIndexPath = [p_NodeToAdd indexPath];
    NSUInteger nodeToAddIndexQty = [nodeToAddIndexPath length];
    
    NSIndexPath *parentNodeIndexPath = [p_ParentNode indexPath];
    NSUInteger parentNodeIndexQty = [parentNodeIndexPath length];
    
    if (nodeToAddIndexQty > parentNodeIndexQty)
        return NO;
    
    // If all the parts of one index match the other index, we're in for trouble
    BOOL intersects = YES;
    for (NSUInteger idx = 0; idx < nodeToAddIndexQty && idx < parentNodeIndexQty && intersects == YES; idx++)
    {
        if ([nodeToAddIndexPath indexAtPosition: idx] != [parentNodeIndexPath indexAtPosition: idx])
            intersects = NO;
    }
        
    return intersects;
}

- (BOOL) prepareToSwitchNodes
{
    OutlineNode *currentItem = nil;
    id item = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (item != nil)
    {
        NSTreeNode *currentNode = (NSTreeNode *)item;
        currentItem = (OutlineNode *)currentNode.representedObject;
    }
    
    BOOL shouldSelect = YES;
    if (currentItem != nil && currentItem.dataObject != nil)
    {
        shouldSelect = [currentItem.dataObject updateDataFromView: currentItem selectionChanged: YES];
    }

    if (shouldSelect == YES)
        self.lastSelectedNode = currentItem;
    
    return shouldSelect;
}

- (OutlineNode *) outlineNodeAtIndexPath: (NSIndexPath *)indexPath
{
    NSTreeNode *treeNode = [[self.treeController arrangedObjects] descendantNodeAtIndexPath: indexPath];
    OutlineNode *node = (OutlineNode *)treeNode.representedObject;
    
    return node;
}

- (OutlineNode *) outlineNodeAtRow: (NSInteger)row
{
    NSTreeNode *treeNode = [self.outlineView itemAtRow: row];
    OutlineNode *node = (OutlineNode *)treeNode.representedObject;
    
    return node;
}

/*
- (NSIndexPath *) removeFirstIndexPath: (NSIndexPath *)indexPath
{
    int qty = [indexPath length];
    NSUInteger *indexes = malloc(sizeof(NSUInteger) * (qty + 1));
    [indexPath getIndexes: indexes];
    memmove(indexes, indexes + sizeof(NSUInteger), sizeof(NSUInteger) * (qty - 1));
    qty--;
    return [NSIndexPath indexPathWithIndexes: indexes length: qty];
}
*/

- (void) disableAllExternalControls
{
    NSEnumerator *enumerator = [self.externalControlsEnabled keyEnumerator];
    NSString *key;
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    while ((key = [enumerator nextObject])) 
        [keys addObject: key];
    
    // Needed to get the keys first then make changes, otherwise it blows chow.
    NSUInteger qty = [keys count];
    for (int idx = 0; idx < qty; idx++)
    {
        key = [keys objectAtIndex: idx];
        [self.externalControlsEnabled setObject: [NSNumber numberWithBool: NO] forKey: key];
    }
}

- (BOOL) performActionOnSelectedItems: (id)sender
{
    NSLog(@"performActionOnSelectedItems");

    // Get the current selection item
    OutlineNode *selectedItem = nil;
    NSTreeNode *selectedNode = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (selectedNode != nil)
        selectedItem = (OutlineNode *)selectedNode.representedObject;

    return [self performActionOnItem: selectedItem withSender: sender];
}    
    
- (BOOL) performActionOnItem: (OutlineNode *)selectedItem 
                  withSender: (id)sender
{
    if (selectedItem != nil)
    {
        if ([selectedItem.dataObject respondsToSelector: @selector(performAction:)])
        {
            NSNumber *succeeded = [selectedItem.dataObject performSelector: @selector(performAction:) withObject: sender];
            return [succeeded boolValue];
        }
    }
    
    return NO;
}

- (NSMenu *) currentSelectionRightClickMenu
{
    // Get the current selection item
    OutlineNode *selectedItem = nil;
    NSTreeNode *selectedNode = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (selectedNode != nil)
        selectedItem = (OutlineNode *)selectedNode.representedObject;

    NSMenu *menu = nil;
    if (selectedItem.dataObject != nil)
        menu = [selectedItem.dataObject rightClickMenu: selectedItem];
    
    return menu;
}

- (void) setupTabbing
{
    if (self.prevTabControl == nil && self.nextTabControl == nil)
        return;
    
    NSView *firstTabControl = nil;
    NSView *lastTabControl = nil;

    // Get the current selection item
    OutlineNode *selectedItem = nil;
    NSTreeNode *selectedNode = [self.outlineView itemAtRow:[self.outlineView selectedRow]];
    if (selectedNode != nil)
        selectedItem = (OutlineNode *)selectedNode.representedObject;
    
    if (selectedItem.dataObject != nil)
    {
        firstTabControl = [selectedItem.dataObject firstTabControl: selectedItem];
        lastTabControl = [selectedItem.dataObject lastTabControl: selectedItem];
    }

    if (firstTabControl != nil)
        self.outlineView.nextKeyView = firstTabControl;
    else
        self.outlineView.nextKeyView = self.nextTabControl;
    
    if (lastTabControl != nil)
        lastTabControl.nextKeyView = self.nextTabControl;
}

@end

//
//  OutlineViewDelegate.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

#import "OutlineDataView.h"
#import "OutlineNode.h"

#define kInternalNodesPBoardType		@"internalNodesPBoardType"	// drag and drop pasteboard type
#define HTTP_PREFIX                     @"http://"

@class OutlineDragAndDropContext;

/*!
 @header
 @abstract OutlineViewDelegate is used to control an outline view and an associated view.
 @discussion This object is used to control an outline view and an associated view that changes depending on the selected tree item.  To use it, add this object to a view along with an NSTreeController and a OutlineDataView.  Wire up the parts to the corresponding IBOutlet fields in this object.
 
 NOTE:
     The tree controller’s Controller Content should be bound to the OutlineViewDelegate object with a Model Key Path of “contents”.  In the Tree Controller properties, set Children to “children” and Leaf to “isLeaf” and for the Object Controller properties, set the Class Name to “OutlineNode” and add keys of “title” and “children”.
     
     The NSOutlineView object needs to have the dataSource and delegate outlets set to the OutlineViewDelegate object.  Bind the Outline View Content to the tree controller with a controller key of “arrangedObjects”.  Bind the Selection Index Paths to the tree controller with a controller key of “selectionIndexPaths”.  In the NSTableColumn for the NSOutlineView, bind the value to the tree controller with a Controller Key of “arrangedObjects” and a Model Key Path of “title”.
 */
#if _MAC_OSX_10_6_OR_LATER
@interface OutlineViewDelegate: NSObject <NSOutlineViewDelegate>
#else
@interface OutlineViewDelegate: NSObject
#endif
{
@private
    NSOutlineView *_outlineView;
	NSTreeController *_treeController;
    OutlineDataView *_viewController;
	
	NSMutableArray *_contents;
    id _notifyObject;
    SEL _notifySelectionChanged;
    SEL _notifyMultipleSelectionChanged;
    SEL _dropBegin;
    SEL _newNodeForFileDrop;
    SEL _newNodeForWebUrlDrop;
    SEL _dropEnd;
    NSView *_overrideView;
    NSView *_noSelectionView;
    BOOL _allowDragAndDrop;
    BOOL _allowDropOnNoNode;
    __weak NSWindow *_parentWindow;
    NSView *_prevTabControl;
    NSView *_nextTabControl;
    
    NSMutableDictionary *_externalControlsEnabled;
    NSString *_prevRenameString;
    NSArray *_dragNodesArray;
    OutlineNode *_lastSelectedNode;
    NSMutableArray *_lastContent;
    BOOL _deleteInProgress;
    BOOL _isEditing;
    OutlineNode *_rootNode;
    FSEventStreamRef _stream;
    BOOL _isExpanding;
    NSArray *_pathsToWatch;
    NSMutableArray *_nodesToSelect;
    BOOL _refreshingExternalControls;
    OutlineDragAndDropContext *_dragAndDropContext;
    int _stopMonitoringQty;
}

@property (nonatomic, retain) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, retain) IBOutlet NSTreeController	*treeController;
@property (nonatomic, retain) IBOutlet OutlineDataView *viewController;
@property (nonatomic, retain) IBOutlet NSView *prevTabControl;
@property (nonatomic, retain) IBOutlet NSView *nextTabControl;
@property (nonatomic, retain) NSMutableArray *contents;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL notifySelectionChanged;
@property (nonatomic) SEL notifyMultipleSelectionChanged;
@property (nonatomic) SEL dropBegin;
@property (nonatomic) SEL newNodeForFileDrop;
@property (nonatomic) SEL newNodeForWebUrlDrop;
@property (nonatomic) SEL dropEnd;
@property (nonatomic, retain) NSView *overrideView;
@property (nonatomic, retain) NSView *noSelectionView;
@property (nonatomic) BOOL allowDragAndDrop;
@property (nonatomic) BOOL allowDropOnNoNode;
@property (nonatomic, weak) NSWindow *parentWindow;

@property (nonatomic, retain) NSMutableDictionary *externalControlsEnabled;
@property (nonatomic, retain) NSString *prevRenameString;
@property (nonatomic, retain) NSArray *dragNodesArray;
@property (nonatomic, retain) OutlineNode *lastSelectedNode;
@property (nonatomic) BOOL deleteInProgess;
@property (nonatomic) BOOL isEditing;
@property (nonatomic, retain) OutlineNode *rootNode;
@property (nonatomic) FSEventStreamRef stream;
@property (nonatomic) BOOL isExpanding;
@property (nonatomic, retain) NSArray *pathsToWatch;
@property (nonatomic) BOOL refreshingExternalControls;
@property (nonatomic, retain) OutlineDragAndDropContext *dragAndDropContext;
@property (nonatomic) int stopMonitoringQty;

- (void) onAwakeFromNib;
- (void) setContent: (OutlineNode *)p_Node;
- (void) startRenameOfSelectedNode;
- (void) restoreAfterEdit: (OutlineNode *)p_Node;
- (void) selectNode: (OutlineNode *)node;
- (void)  selectNode: (OutlineNode *)p_Node 
byExtendingSelection: (BOOL)p_ExtendSelection;
- (void) selectAndExpandNodes: (NSArray *)p_Nodes;
- (NSTreeNode *) treeNodeForOutlineNode: (OutlineNode *)p_Node;
- (void) switchNode: (OutlineNode *)p_FromNode toNode: (OutlineNode *)p_ToNode;
- (void) refreshExternalControls;
- (void) switchToOverrideView: (NSView *)p_View;
- (void) replaceContentsWithView: (NSView *)p_View;
- (void) switchToDataView;
- (BOOL) selectFirstSelectableNode: (OutlineNode *)p_Node;
- (BOOL) refreshCurrentSelection;
- (void) updateToolbarAndMenuControls;

- (void) disableAllExternalControls;
- (BOOL) performActionOnSelectedItems: (id)sender;
- (BOOL) performActionOnItem: (OutlineNode *)selectedItem 
                  withSender: (id)sender;
- (NSTreeNode *) treeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)  node: (NSTreeNode *)p_NodeToAdd 
intersectsWith: (NSTreeNode *)p_ParentNode;
- (NSMenu *) currentSelectionRightClickMenu;
- (BOOL) prepareToSwitchNodes;
- (OutlineNode *) outlineNodeAtIndexPath: (NSIndexPath *)indexPath;
- (OutlineNode *) outlineNodeAtRow: (NSInteger)row;

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item;
- (void) setupTabbing;

@end


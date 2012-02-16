//
//  OutlineNode.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OutlineData.h"

typedef enum 
{
    /*!
     @abstract The root node that contains all other nodes.  There should only be one of these.
     */
    ONT_ROOT = 0,
    /*!
     @abstract Header nodes are displayed as a bold font.
     */
    ONT_HEADER,
    /*!
     @abstract Normal nodes are nothing special
     */
    ONT_NORMAL,
    /*!
     @abstract Separator nodes display a horizontal line.
     */
    ONT_SEPARATOR
} outlineNodeType;


/*!
 @header
 @abstract OutlineNode is the base class of all items used with OutlineViewDelegate.
 @discussion This object is used to create the structure of the data to be used with the OutlineViewDelegate object.  The object inheriting this object should provide the view, title, image, and override methods for the needed functionality of the item.
 */
@interface OutlineNode : NSObject
{
@private
    NSImage *_icon;
    NSString *_title;
    NSString *_toolTip;
    outlineNodeType _nodeType;
    BOOL _canSelect;
    BOOL _isExpanded;
    BOOL _isEditable;
    BOOL _isDropable;
    id _tag;
    id _notifyObject;
    SEL _nodeCreatedSelector;
    
    __weak OutlineNode *_parent;
    NSMutableArray *_children;
    NSIndexPath *_indexPath;
    OutlineData *_dataObject;
    NSTreeController *_treeController;
    BOOL _notifyingTreeController;
    int _lastIdx;
}

@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *toolTip;
@property (nonatomic) outlineNodeType nodeType;
@property (nonatomic) BOOL canSelect;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) BOOL isEditable;
@property (nonatomic) BOOL isDropable;
@property (nonatomic, retain) id tag;
@property (nonatomic, retain) id notifyObject;
@property (nonatomic) SEL nodeCreatedSelector;

@property (nonatomic, weak) OutlineNode *parent;
@property (nonatomic, retain) NSMutableArray *children;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) OutlineData *dataObject;
@property (nonatomic, retain) NSTreeController *treeController;
@property (nonatomic) BOOL notifyingTreeController;
@property (nonatomic) int lastIdx;

- (BOOL) isLeaf;

/*!
 @abstract This function is called when an item is selected and should be overridden by the child class if it needs to do something when it is selected.  The current view should be set here if needed as well.
 */
- (void) selected;


/*!
 @abstract Removes all the child items.
 */
- (void) removeChildren;

/*!
 @abstract If a tree controller is set, this will alert the tree controller that new child nodes have been added.  This is used by the delayed loading of FolderItem and could be used by other subclasses.
 */
- (void) notifyTreeControllerOfNewChildNodes;

/*!
 @abstract If a tree controller is set, this will alert the tree controller that a new node has been added.  This is used by the delayed loading of FolderItem and could be used by other subclasses.
 */
- (void) notifyTreeControllerOfNewNode;

/*!
 @abstract This is called when a node is expanded.  This can be used by subclasses to add more nodes.
 */
- (void) outlineNodeDidExpand;

/*!
 @abstract This is called when a node is collapsed.  This can be used by subclasses to free up memory for collapsed nodes.
 */
- (void) outlineNodeDidCollapse;

/*!
 @abstract Removes the first index from this node and updates the children
 */
- (void) removeFirstIndexPath;

/*!
 @abstract This updates an index path so it's beneath the parent index path.
 */
- (void) updateIndexPath: (OutlineNode *)p_Parent;

/*!
 @abstract This updates the children's index paths so they're in line with this object's index path.
 */
- (void) updateChildIndexPaths;

/*!
 @abstract Adds a child to the end of the children list.
 */
- (void) addChild: (OutlineNode *)p_Node;

/*!
 @abstract Inserts a child in the children list sorted based on the title of the node.
 */
- (void) insertChildSorted: (OutlineNode *)p_Node;

/*!
 @abstract Removes the descendant child that matches the node that's passed.  It returns false if it was not found.
 */
- (BOOL) removeChild: (OutlineNode *)p_Node;

/*!
 @abstract Removes the first descendant child that is equivalent to the node that's passed.  It returns false if it was not found.
 */
- (BOOL) removeEquivalentChild: (OutlineNode *)p_Node;

/*!
 @abstract Removes the first descendant child whose title matches what is passed.
 */
- (BOOL) removeChildWithTitle: (NSString *)p_Title;

/*!
 @abstract Returns whether the node is equivalent to another, and therefor shouldn't be readded.
 */
- (BOOL) isEquivalentTo: (OutlineNode *)p_Node;

/*!
 @abstract Returns a child node of this object that is equivalent to the search node passed, or nil if not found.  This is not recursive.
 */
- (OutlineNode *) findEquivalentChild: (OutlineNode *)p_Node;

/*!
 @abstract Returns a child node of this object that is equivalent to the search node passed, or nil if not found.  This is recursive.
 */
- (OutlineNode *) findEquivalentChildRecursive: (OutlineNode *)p_Node;

/*!
 @abstract Returns a descendant node that contains the node as one of its children, or nil if not found.
 */
- (OutlineNode *) findParentOfChild: (OutlineNode *)p_Node;

/* @abstract Makes sure that all the parent nodes of the current node are expanded.
 */
- (void) expandParentNodes: (OutlineNode *)p_RootNode;

/*!
 @abstract Returns a descendant node that has an equivalent node as one of its children, or nil if not found.
 */
- (OutlineNode *) findParentOfEquivalentChild: (OutlineNode *)p_Node;

/*!
 @abstract Returns the first descendant node that matches the title, or nil if not found.
 */
- (OutlineNode *) findNodeWithTitle: (NSString *)p_Title;

/*!
 @abstract Called when file system monitoring is turned on and something with a path was changed.  Properties for the path and all its immediate children should be updated.  This function will call OutlineData's notifyAboutFileSystemChange function also.
 @returns If the change is handled and no other nodes need to be informed, it should return YES, otherwise it should return NO.
 */
- (BOOL) notifyAboutFileSystemChange: (NSString *)p_Path;

/*!
 @abstract This is called for the children of a node that has been renamed.
 */
- (void) parentNode: (OutlineNode *)p_Node
        changedFrom: (NSString *)p_From
                 to: (NSString *)p_To;
 
/*!
 @abstract Removes the first index from the index path.
 */
+ (NSIndexPath *) removeFirstIndexPath: (NSIndexPath *)indexPath;

@end

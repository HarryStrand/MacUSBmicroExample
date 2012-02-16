//
//  OutlineNode.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "OutlineNode.h"

@implementation OutlineNode

@synthesize icon = _icon;
@synthesize title = _title;
@synthesize toolTip = _toolTip;
@synthesize nodeType = _nodeType;
@synthesize canSelect = _canSelect;
@synthesize isExpanded = _isExpanded;
@synthesize isEditable = _isEditable;
@synthesize isDropable = _isDropable;
@synthesize tag = _tag;
@synthesize notifyObject = _notifyObject;
@synthesize nodeCreatedSelector = _nodeCreatedSelector;

@synthesize parent = _parent;
@synthesize children = _children;
@synthesize indexPath = _indexPath;
@synthesize dataObject = _dataObject;
@synthesize treeController = _treeController;
@synthesize notifyingTreeController = _notifyingTreeController;
@synthesize lastIdx = _lastIdx;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _icon = nil;
        _title = @"";
        _toolTip = @"";
        _nodeType = ONT_NORMAL;
        _canSelect = YES;
        _isExpanded = NO;
        _isEditable = NO;
        _isDropable = NO;
        _tag = nil;
        _notifyObject = nil;
        _nodeCreatedSelector = nil;
        
        _parent = nil;
        _children = [[NSMutableArray alloc] init];
        _indexPath = nil;
        _dataObject = nil;
        _treeController = nil;
        
        _notifyingTreeController = NO;
        _lastIdx = 0;
    }
    
    return self;
}

- (void) setDataObject: (OutlineData *)p_DataObject
{
    _dataObject = p_DataObject;
    _dataObject.node = self;
}

- (void) selected
{
    // This function should be overridden by a child class if anything needs to respond to this.
}


- (BOOL) isLeaf
{
    if ([self.children count] > 0)
        return NO;
    else
        return YES;
}

- (void) removeChildren
{
    self.lastIdx = 0;
    _children = [[NSMutableArray alloc] init];
}

- (void) notifyTreeControllerOfNewChildNodes
{
    for (OutlineNode *child in self.children)
    {
        [child notifyTreeControllerOfNewNode];
    }
}

- (void) notifyTreeControllerOfNewNode
{
    self.parent.notifyingTreeController = YES;
    self.notifyingTreeController = YES;
    if (self.treeController != nil)
    {
        [self.treeController insertObject: self atArrangedObjectIndexPath: self.indexPath];
        [self notifyTreeControllerOfNewChildNodes];
    }
    self.parent.notifyingTreeController = NO;
    self.notifyingTreeController = NO;
}

- (void) setTreeController:(NSTreeController *)p_TreeController
{
    _treeController = p_TreeController;
    
    for (OutlineNode *child in self.children)
    {
        [child setTreeController: p_TreeController];
    }
}

- (void) outlineNodeDidExpand
{
    // For some odd reason, when the tree controller is notified of a new child node, it says the child node expanded even though it isn't supposed to.
    // Update: The reason for that was because the setIsExpanded function was doing the work, and that caused the expansion to take place at unexpected times.  So the if test may no longer be needed, but I didn't have the courage to remove it.  It's been a long couple of days already.
    if (self.notifyingTreeController == NO)
        self.isExpanded = YES;
}

- (void) outlineNodeDidCollapse
{
    self.isExpanded = NO;
}

- (void) removeFirstIndexPath
{
    for (OutlineNode *child in self.children)
    {
        child.indexPath = [OutlineNode removeFirstIndexPath: child.indexPath];
        [child removeFirstIndexPath];
    }
}

- (void) updateNode: (OutlineNode *)p_Node 
      withIndexPath: (NSIndexPath *)p_IndexPath
{
    p_Node.indexPath = p_IndexPath;
    
}

- (void) updateIndexPath: (OutlineNode *)p_Parent
{
    if (p_Parent == nil)
    {
        self.indexPath = [NSIndexPath indexPathWithIndex: 0];
    }
    else if (p_Parent.indexPath == nil)
    {
        self.indexPath = [NSIndexPath indexPathWithIndex: p_Parent.lastIdx];
    }
    else
    {
        self.indexPath = [p_Parent.indexPath indexPathByAddingIndex: p_Parent.lastIdx];
    }
    
    if (p_Parent != nil)
        p_Parent.lastIdx++;
    
    // Let's bring the children with us
    [self updateChildIndexPaths];
}

- (void) updateChildIndexPaths
{
    self.lastIdx = 0;
    for (OutlineNode *child in self.children)
    {
        [child updateIndexPath: self];
    }
}

- (void) addChild: (OutlineNode *)p_Node
{
    p_Node.parent = self;
    [self.children addObject: p_Node];
}

- (void) insertChildSorted: (OutlineNode *)p_Node
{
    NSUInteger qty = [self.children count];
    NSInteger sortedIdx = -1;
    for (NSUInteger idx = 0; idx < qty && sortedIdx < 0; idx++)
    {
        OutlineNode *child = [self.children objectAtIndex: idx];
        if ([child.title compare: p_Node.title options: NSCaseInsensitiveSearch] == NSOrderedDescending)
        {
            sortedIdx = idx;
        }
    }
    
    if (sortedIdx < 0)
        [self addChild: p_Node];
    else
    {
        p_Node.parent = self;
        [self.children insertObject: p_Node atIndex: sortedIdx];
    }
}

- (BOOL) removeChild: (OutlineNode *)p_Node
{
    BOOL succeeded = NO;
    NSUInteger qty = [self.children count];
    for (NSUInteger idx = 0; idx < qty && succeeded == NO; idx++)
    {
        OutlineNode *childNode = [self.children objectAtIndex: idx];
        if (childNode == p_Node)
        {
            [self.children removeObjectAtIndex: idx];
            qty--;
            succeeded = YES;
        }
        else
            succeeded = [childNode removeChild: p_Node];
    }

    return succeeded;
}

- (BOOL) removeEquivalentChild: (OutlineNode *)p_Node
{
    BOOL succeeded = NO;
    NSUInteger qty = [self.children count];
    for (NSUInteger idx = 0; idx < qty && succeeded == NO; idx++)
    {
        OutlineNode *childNode = [self.children objectAtIndex: idx];
        if ([childNode isEquivalentTo: p_Node])
        {
            [self.children removeObjectAtIndex: idx];
            qty--;
            succeeded = YES;
        }
        else
            succeeded = [childNode removeEquivalentChild: p_Node];
    }
    
    return succeeded;
}

- (BOOL) removeChildWithTitle: (NSString *)p_Title
{
    BOOL succeeded = NO;
    NSUInteger qty = [self.children count];
    for (NSUInteger idx = 0; idx < qty && succeeded == NO; idx++)
    {
        OutlineNode *childNode = [self.children objectAtIndex: idx];
        if (childNode.title == p_Title)
            [self.children removeObjectAtIndex: idx];
        else
            succeeded = [childNode removeChildWithTitle: p_Title];
    }
    
    return succeeded;
}

- (BOOL) isEquivalentTo: (OutlineNode *)p_Node
{
    return ([p_Node class] == [self class] && [self.title isEqualToString: p_Node.title]);
}

- (OutlineNode *) findEquivalentChild: (OutlineNode *)p_Node
{
    for (OutlineNode *childNode in self.children)
    {
        if ([childNode isEquivalentTo: p_Node])
            return childNode;
    }
    
    return nil;
}

- (OutlineNode *) findEquivalentChildRecursive: (OutlineNode *)p_Node
{
    OutlineNode *nodeFound = nil;
    NSUInteger qty = [self.children count];
    for (NSUInteger idx = 0; idx < qty && nodeFound == nil; idx++)
    {
        OutlineNode *childNode = [self.children objectAtIndex: idx];
        if ([childNode isEquivalentTo: p_Node])
            return childNode;
        else
        {
            OutlineNode *node = [childNode findEquivalentChildRecursive: p_Node];
            if (node != nil)
                nodeFound = node;
        }
    }
    
    return nodeFound;
}

- (OutlineNode *) findParentOfChild: (OutlineNode *)p_Node
{
    for (OutlineNode *childNode in self.children)
    {
        if (childNode == p_Node)
            return self;
        else
        {
            OutlineNode *node = [childNode findParentOfChild: p_Node];
            if (node != nil)
                return node;
        }
    }
    
    return nil;
}

- (OutlineNode *) findParentOfEquivalentChild: (OutlineNode *)p_Node
{
    for (OutlineNode *childNode in self.children)
    {
        if ([childNode isEquivalentTo: p_Node])
            return self;
        else
        {
            OutlineNode *node = [childNode findParentOfEquivalentChild: p_Node];
            if (node != nil)
                return node;
        }
    }
    
    return nil;
}

- (OutlineNode *) findNodeWithTitle: (NSString *)p_Title
{
    if ([self.title isEqualToString: p_Title])
        return self;
    
    for (OutlineNode *childNode in self.children)
    {
        OutlineNode *node = [childNode findNodeWithTitle: p_Title];
        if (node != nil)
            return node;
    }
    
    return nil;
}

- (void) expandParentNodes: (OutlineNode *)p_RootNode
{
    OutlineNode *parentNode = [p_RootNode findParentOfChild: self];
    if (parentNode != nil)
    {
        parentNode.isExpanded = YES;
        [parentNode expandParentNodes: p_RootNode];
    }
}

- (void) parentNode: (OutlineNode *)p_Node
        changedFrom: (NSString *)p_From
                 to: (NSString *)p_To
{
    if (self.dataObject != nil)
    {
        [self.dataObject parentNode: p_Node changedFrom: p_From to: p_To];
    }
    
    for (OutlineNode *childNode in self.children)
    {
        [childNode parentNode: p_Node changedFrom: p_From to: p_To];
    }
}

- (BOOL) notifyAboutFileSystemChange: (NSString *)p_Path
{
    BOOL handled = NO;
    NSUInteger qty = [self.children count];
    for (NSUInteger idx = 0; idx < qty && handled == NO; idx++)
    {
        OutlineNode *childNode = [self.children objectAtIndex: idx];
        if (childNode.dataObject != nil)
        {
            handled = [childNode.dataObject notifyAboutFileSystemChange: p_Path node: childNode];
            if (handled == NO)
            {
                handled = [childNode notifyAboutFileSystemChange: p_Path];
            }
        }
    }
    
    return handled;
}

+ (NSIndexPath *) removeFirstIndexPath: (NSIndexPath *)indexPath
{
    NSUInteger qty = [indexPath length];
    NSUInteger *indexes = malloc(sizeof(NSUInteger) * (qty + 1));
    [indexPath getIndexes: indexes];
    memmove(indexes, indexes + 1, sizeof(NSUInteger) * (qty - 1));
    qty--;
    NSIndexPath *newIndexPath = [NSIndexPath indexPathWithIndexes: indexes length: qty];
    free(indexes);
    return newIndexPath;
}

@end

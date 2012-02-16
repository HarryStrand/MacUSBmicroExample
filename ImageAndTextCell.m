//
//  ImageAndTextCell.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "ImageAndTextCell.h"
#import "OutlineNode.h"

@implementation ImageAndTextCell

#define kIconImageSize		16.0

#define kImageOriginXOffset 3
#define kImageOriginYOffset 0/*1*/

#define kTextOriginXOffset	2
#define kTextOriginYOffset	0/*2*/
#define kTextHeightAdjust	0/*4*/

- (id)init
{
	self = [super init];
	
	// we want a smaller font
	[self setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];
    [self setLineBreakMode: NSLineBreakByTruncatingTail];
    
	return self;
}

- (id)copyWithZone:(NSZone*)zone
{
    ImageAndTextCell *cell = (ImageAndTextCell*)[super copyWithZone:zone];
    cell->image = image;
    return cell;
}

- (void)setImage:(NSImage*)anImage
{
    if (anImage != image)
	{
        image = anImage;
		[image setSize:NSMakeSize(kIconImageSize, kIconImageSize)];
    }
}

- (NSImage*)image
{
    return image;
}

- (BOOL)isGroupCell
{
    return ([self image] == nil && [[self title] length] > 0);
}

- (NSRect)titleRectForBounds:(NSRect)cellRect
{	
	// the cell has an image: draw the normal item cell
	NSSize imageSize;
	NSRect imageFrame;

	imageSize = [image size];
	NSDivideRect(cellRect, &imageFrame, &cellRect, 3 + imageSize.width, NSMinXEdge);

	imageFrame.origin.x += kImageOriginXOffset;
	imageFrame.origin.y -= kImageOriginYOffset;
	imageFrame.size = imageSize;
	
	imageFrame.origin.y += ceil((cellRect.size.height - imageFrame.size.height) / 2);
	
	NSRect newFrame = cellRect;
	newFrame.origin.x += kTextOriginXOffset;
	newFrame.origin.y += kTextOriginYOffset;
	newFrame.size.height -= kTextHeightAdjust;

	return newFrame;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject event:(NSEvent*)theEvent
{
	NSRect textFrame = [self titleRectForBounds:aRect];
	[super editWithFrame:textFrame inView:controlView editor:textObj delegate:anObject event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
	NSRect textFrame = [self titleRectForBounds:aRect];
	[super selectWithFrame:textFrame inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView
{
	if (image != nil)
	{
		// the cell has an image: draw the normal item cell
		NSSize imageSize;
        NSRect imageFrame;

        imageSize = [image size];
        NSDivideRect(cellFrame, &imageFrame, &cellFrame, 3 + imageSize.width, NSMinXEdge);
 
        imageFrame.origin.x += kImageOriginXOffset;
		imageFrame.origin.y -= kImageOriginYOffset;
        imageFrame.size = imageSize;
		
        if ([controlView isFlipped])
            imageFrame.origin.y += ceil((cellFrame.size.height + imageFrame.size.height) / 2);
        else
            imageFrame.origin.y += ceil((cellFrame.size.height - imageFrame.size.height) / 2);
		[image compositeToPoint:imageFrame.origin operation:NSCompositeSourceOver];

		NSRect newFrame = cellFrame;
		newFrame.origin.x += kTextOriginXOffset;
		newFrame.origin.y += [self getVerticalAlignmentOffsetForTextOnly];
		newFrame.size.height -= kTextHeightAdjust;
		[super drawWithFrame:newFrame inView:controlView];
    }
	else
	{
		if ([self isGroupCell])
		{
			// Center the text in the cellFrame, and call super to do the work of actually drawing. 
			CGFloat yOffset = floor((NSHeight(cellFrame) - [[self attributedStringValue] size].height) / 2.0);
			cellFrame.origin.y += yOffset;
			cellFrame.size.height -= (kTextOriginYOffset*yOffset);
			[super drawWithFrame:cellFrame inView:controlView];
		}
	}
}

- (int)getVerticalAlignmentOffsetForTextOnly
{
    return kTextOriginYOffset;
}

- (NSSize)cellSize
{
    NSSize cellSize = [super cellSize];
    cellSize.width += (image ? [image size].width : 0) + 3;
    return cellSize;
}

#ifdef JUNK // This was making it so you couldn't edit a cell
// -------------------------------------------------------------------------------
//	hitTestForEvent:
//
//	In 10.5, we need you to implement this method for blocking drag and drop of a given cell.
//	So NSCell hit testing will determine if a row can be dragged or not.
//
//	NSTableView calls this cell method when starting a drag, if the hit cell returns
//	NSCellHitTrackableArea, the particular row will be tracked instead of dragged.
//
// -------------------------------------------------------------------------------
- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView
{
	NSInteger result = NSCellHitContentArea;
	
	NSOutlineView* hostingOutlineView = (NSOutlineView*)[self controlView];
	if (hostingOutlineView)
	{
		NSInteger selectedRow = [hostingOutlineView selectedRow];
		OutlineNode *node = [[hostingOutlineView itemAtRow:selectedRow] representedObject];

/*		if (![node isDraggable])	// is the node isDraggable (i.e. non-file system based objects)
			result = NSCellHitTrackableArea;*/
	}
 
		
	return result;
}
#endif // JUNK

@end


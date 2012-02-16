//
//  ImageAndTextCell.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageAndTextCell : NSTextFieldCell
{
@private
	NSImage *image;
}

- (void)setImage:(NSImage *)anImage;
- (NSImage *)image;

/**
 * Used to fine tune the vertical position of the text relative to the image and arrow
 * For some reason the outline view for composer needed to be tweaked
 * TODO - look into why this is an issue and solve it correctly
 */
- (int)getVerticalAlignmentOffsetForTextOnly;

@end

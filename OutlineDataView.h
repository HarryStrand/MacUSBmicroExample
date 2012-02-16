//
//  OutlineDataView.h
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

@interface OutlineDataView : NSViewController
{
    BOOL _debugLayout;
}

@property (nonatomic, getter=isDebugLayout) BOOL debugLayout;

- (void)replaceContentsOfView:(NSView *)contentView withView:(NSView *)view;
- (void)replaceMyContentsWithView:(NSView *)contentView;
- (void)injectMyViewIntoContentView:(NSView *)contentView;

@end

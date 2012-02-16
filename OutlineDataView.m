//
//  OutlineDataView.m
//  MacUSBmicroExample
//
//  Created by Harry Strand on 1/14/12.
//  Copyright 2012 StrandControl, LLC. All rights reserved.
//

#import "OutlineDataView.h"

@implementation OutlineDataView

@synthesize debugLayout = _debugLayout;

- (void)replaceContentsOfView:(NSView *)contentView withView:(NSView *)view
{
    if (contentView)
    {
        if (view == nil)
        {
            NSArray *subViews = [[self view] subviews];
            if ([subViews count] > 0)
            {
                [[subViews objectAtIndex:0] removeFromSuperview];
            }
            [[self view] displayIfNeeded];
        }
        else
        {
            // Resize the new view to fit the existing content view.
            NSRect newFrame = { view.frame.origin, contentView.frame.size };
            view.frame = newFrame;
            
            [contentView setSubviews:[NSArray arrayWithObject:view]];
        }
    }
}

- (void)replaceMyContentsWithView:(NSView *)contentView
{
    [self replaceContentsOfView:self.view withView:contentView];
}

- (void)injectMyViewIntoContentView:(NSView *)contentView
{
    [self replaceContentsOfView:contentView withView:self.view];
}

- (void)awakeFromNib
{
}

- (void)loadView
{
    [super loadView];
}

@end

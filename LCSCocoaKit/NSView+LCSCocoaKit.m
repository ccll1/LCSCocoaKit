//
//  NSView+LCSCocoaKit.m
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSView+LCSCocoaKit.h"

@implementation NSView (LCSCocoaKit)

- (NSView*)subviewWithIdentifier:(NSString*)identifier
{
    for (NSView *subview in self.subviews) {
        if ([subview.identifier isEqualToString:identifier]) {
            return subview;
        }
        else {
            NSView *view = [subview subviewWithIdentifier:identifier];
            
            if (view) {
                return view;
            }
        }
    }
    
    return nil;
}

- (BOOL)isSubviewOfFirstResponder
{
    if (self.window && self.superview && self != self.window.contentView &&
        (self.window.firstResponder == self ||
         self.superview.isSubviewOfFirstResponder)) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSImage *)imageRepresentation
{
    BOOL wasHidden      = self.isHidden;
    BOOL wantedLayer = self.wantsLayer;
    BOOL hadShouldRasterize = self.layer.shouldRasterize;

    self.hidden         = NO;
    self.wantsLayer     = YES;
    self.layer.shouldRasterize = YES;

    CGFloat originalRasterizationScale = self.layer.rasterizationScale;
    self.layer.rasterizationScale = 2.0;
    
    CGSize size = self.bounds.size;
//    size.width *= self.layer.rasterizationScale;
//    size.height *= self.layer.rasterizationScale;
    
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    CGContextRef ctx = [NSGraphicsContext currentContext].graphicsPort;
    [self.layer renderInContext:ctx];
    [image unlockFocus];
    
    self.layer.rasterizationScale = originalRasterizationScale;
    self.layer.shouldRasterize = hadShouldRasterize;
    self.wantsLayer = wantedLayer;
    self.hidden = wasHidden;
    
    return image;
}


@end

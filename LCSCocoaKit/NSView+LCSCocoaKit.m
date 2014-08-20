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

@end

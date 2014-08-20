//
//  NSView+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (LCSCocoaKit)

/**
 *  Recursively walks the receivers subviews and returns the first view with the passed <code>identifier</code>. The search is done depth-first.
 *
 *  @param identifier An identifier string to test for.
 *
 *  @return The first subview with the given <code>identifier</code>.
 */
- (NSView*)subviewWithIdentifier:(NSString*)identifier;

@end


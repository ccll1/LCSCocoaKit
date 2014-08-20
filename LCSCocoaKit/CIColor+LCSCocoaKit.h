//
//  CIColor+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CIColor (LCSCocoaKit)

/**
 *  Creates and returns an instance of <code>CIColor></code> using an <code>NSColor</code> instance.
 *
 *  This is a convenience method for <code>[[CIColor alloc] initWithColor:(NSColor*)color]</code>.
 *
 *  @param color The initial color value, which can belong to any available colorspace.
 *
 *  @return The resulting <code>CIColor</code> object, or <code>nil</code> if the object cannot be initialized with the specified value.
 */
+ (instancetype)colorWithColor:(NSColor *)color;

@end
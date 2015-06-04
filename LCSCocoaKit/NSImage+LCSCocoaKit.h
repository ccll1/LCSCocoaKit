//
//  NSImage+LCSCocoaKit.h
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 02.02.15.
//  Copyright (c) 2015 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (LCSCocoaKit)

- (NSImage*)resizeTo:(CGSize)newSize;
- (NSImage *)imageTintedWithColor:(NSColor *)tint;
- (BOOL)writePngToUrl:(NSURL*)url error:(NSError *__autoreleasing *)error;


@end

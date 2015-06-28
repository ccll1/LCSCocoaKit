//
//  NSImage+LCSCocoaKit.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 02.02.15.
//  Copyright (c) 2015 Christoph Lauterbach. All rights reserved.
//

#import "NSImage+LCSCocoaKit.h"

@implementation NSImage (LCSCocoaKit)

- (NSImage*)resizeTo:(CGSize)newSize
{
    if (!self.isValid) {
        return nil;
    }

    NSImage *smallImage = [[NSImage alloc] initWithSize:newSize];
    [smallImage lockFocus];
    self.size = newSize;
    [NSGraphicsContext currentContext].imageInterpolation = NSImageInterpolationHigh;
    [self drawAtPoint:NSZeroPoint fromRect:CGRectMake(0, 0, newSize.width, newSize.height) operation:NSCompositeCopy fraction:1.0];
    [smallImage unlockFocus];
    return smallImage;
}

- (NSImage *)imageTintedWithColor:(NSColor *)tint
{
    NSImage *image = [self copy];
    if (tint) {
        [image lockFocus];
        [tint set];
        NSRect imageRect = {NSZeroPoint, image.size};
        NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
        [image unlockFocus];
    }
    return image;
}

- (BOOL)writePngToUrl:(NSURL*)url error:(NSError *__autoreleasing *)error
{
    CGImageRef cgRef = [self CGImageForProposedRect:NULL
                                            context:nil
                                              hints:nil];
    NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    newRep.size = self.size;
    NSData *pngData = [newRep representationUsingType:NSPNGFileType properties:@{}];

    return [pngData writeToURL:url options:NSDataWritingAtomic error:error];
}

@end

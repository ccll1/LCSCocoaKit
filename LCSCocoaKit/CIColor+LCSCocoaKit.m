//
//  CIColor+LCSCocoaKit.m
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "CIColor+LCSCocoaKit.h"

@implementation CIColor (LCSCocoaKit)

+ (instancetype)colorWithColor:(NSColor *)color
{
    return [[[self class] alloc] initWithColor:color];
}

@end
//
//  CIColor+ColorWithNSColor.m
//  Stack
//
//  Created by Christoph Lauterbach on 30.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "CIColor+LCSCocoaKit.h"

@implementation CIColor (LCSCocoaKit)

+ (instancetype)colorWithColor:(NSColor *)color
{
    return [[[self class] alloc] initWithColor:color];
}

@end
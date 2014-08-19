//
//  CIColor+ColorWithNSColor.h
//  Stack
//
//  Created by Christoph Lauterbach on 30.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface CIColor (LCSCocoaKit)

+ (instancetype)colorWithColor:(NSColor *)color;

@end
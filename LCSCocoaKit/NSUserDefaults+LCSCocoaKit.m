//
//  NSUserDefaults+LCSCocoaKit.m
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSUserDefaults+LCSCocoaKit.h"

@implementation NSUserDefaults (LCSCocoaKit)

- (void)setColor:(NSColor *)color forKey:(NSString *)aKey
{
    NSData *theData = [NSArchiver archivedDataWithRootObject:color];
    [self setObject:theData forKey:aKey];
}

- (NSColor *)colorForKey:(NSString *)key
{
    NSData *theData = [self dataForKey:key];
    
    if (theData != nil) {
        NSColor *color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
        
        if (color && [color isKindOfClass:[NSColor class]]) {
            return color;
        }
    }
    
    return nil;
}

@end

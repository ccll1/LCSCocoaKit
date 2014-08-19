//
//  NSUserDefaults+SuportForNSColor.m
//  Stack
//
//  Created by Christoph Lauterbach on 09.09.13.
//  Copyright (c) 2013 Lauterbach Beratung. All rights reserved.
//

#import "NSUserDefaults+LCSCocoaKit.h"

@implementation NSUserDefaults (LCSCocoaKit)

- (void)setColor:(NSColor *)color forKey:(NSString *)aKey
{
    NSData *theData=[NSArchiver archivedDataWithRootObject:color];
    [self setObject:theData forKey:aKey];
}

- (NSColor *)colorForKey:(NSString *)key
{
    NSColor *color;
    
    NSData *theData = [self dataForKey:key];
    
    if (theData != nil)
        
        color = (NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
    
    return color;
}

@end

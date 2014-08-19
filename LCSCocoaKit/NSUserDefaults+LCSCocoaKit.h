//
//  NSUserDefaults+SuportForNSColor.h
//  Stack
//
//  Created by Christoph Lauterbach on 09.09.13.
//  Copyright (c) 2013 Lauterbach Beratung. All rights reserved.
//

@interface NSUserDefaults (LCSCocoaKit)

- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey;
- (NSColor *)colorForKey:(NSString *)aKey;

@end

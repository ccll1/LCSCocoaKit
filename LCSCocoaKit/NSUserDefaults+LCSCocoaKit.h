//
//  NSUserDefaults+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

@interface NSUserDefaults (LCSCocoaKit)

/**
 *  This method encodes the passed <code>NSColor</code> instance with <code>NSArchiver</code> and stores the resulting <code>NSData</code> instance in the receiver.
 *
 *  @param aColor The color to store in the user defaults database.
 *  @param aKey   The key with which to associate with the value.
 */
- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey;

/**
 *  This method fetches the data associated with the given key and decodes it with <code>NSUnarchiver</code>. If the unarchived object is a kind of <code>NSColor</code> class, the color is returned.
 *
 *  @param aKey A key in the current user's defaults database.
 *
 *  @return The unarchived <code>NSColor</code> instance or <code>nil</code> otherwise.
 */
- (NSColor *)colorForKey:(NSString *)aKey;

@end

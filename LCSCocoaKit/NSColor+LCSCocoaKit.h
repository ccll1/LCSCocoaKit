//
//  NSColor+LCSCocoaKit.h
//  Christoph Lauterbach's Standard Cocoa Kit
//
//  Created by Christoph Lauterbach on 11.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface NSColor (LCSCocoaKit)

/**
 *  Creates and returns an instance of <code>NSColor</code> created by parsing the given color encoded as a web-standard hexadecimal string, using the SRGB color space. The alpha value of the color is set to <code>1.0</code>, i. e. fully opaque.
 *
 *  @param hex A string in the format <code>#00ff00</code> or <code>#0f0</code>.
 *
 *  @return A new instance of <code>NSColor</code> in the SRGB color space if the passed string is a valid web-standard hexadecimal color or nil if it is not valid.
 */
+ (NSColor *)SRGBColorFromHexadecimalValue:(NSString *)hex;

/**
 *  Creates and returns an instance of <code>NSColor</code> created by parsing the given color encoded as a CSS color string, using the SRGB color space.
 *
 *  Accepted formats for the string are (all of the examples are equal representations of fully opaque green):
 *
 *  - <code>#00ff00</code>
 *  - <code>#0f0</code>
 *  - <code>rgb(0, 255, 0)</code>
 *  - <code>rgba(0, 255, 0, 255)</code>
 *  - <code>rgb(0%, 100%, 0%)</code>
 *  - <code>rgb(0.0%, 100.0%, 0.0%)</code>
 *  - <code>rgba(0%, 100%, 0%, 100%)</code>
 *  - <code>hsl(120, 100%, 100%)</code>
 *  - <code>hsla(120, 100%, 100%, 1.0)</code>
 *  - <code>hsla(120.0, 100.0%, 100.0%, 1.0)</code>
 *  @param cssValue A string in one of the above formats.
 *
 *  @return A new instance of <code>NSColor</code> in the SRGB color space if the passed string is a valid CSS color string or nil if it is not valid.
 */
+ (NSColor *)SRGBColorFromCSSValue:(NSString *)cssValue;

/**
 *  Creates and returns a string with the web-standard hexadecimal representation of the receiver in the format <code>#00ff00</code>.
 */
@property (nonatomic,readonly) NSString *hexadecimalValue;

@property (nonatomic,readonly) CIColor *CIColor;

@end

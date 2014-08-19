//
//  NSColor+Hex.h
//  Stack
//
//  Created by Christoph Lauterbach on 04.09.13.
//  Copyright (c) 2013 Lauterbach Beratung. All rights reserved.
//

@interface NSColor (LCSCocoaKit)

+ (NSColor *)deviceColorFromHexadecimalValue:(NSString *)hex;
+ (NSColor *)calibratedColorFromHexadecimalValue:(NSString *)hex;

+ (NSColor *)deviceColorFromCSSValue:(NSString *)cssValue;

+ (NSArray *)deviceColorsFromHexadecimalValues:(NSArray *)hexList;
+ (NSArray *)hexadecimalValuesFromDeviceColors:(NSArray *)colorList;

@property (nonatomic,readonly) NSString *deviceColorHexadecimalValue;
@property (nonatomic,readonly) NSString *calibratedColorHexadecimalValue;

@end

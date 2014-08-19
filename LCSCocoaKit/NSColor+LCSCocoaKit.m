//
//  NSColor+Hex.m
//  Stack
//
//  Created by Christoph Lauterbach on 04.09.13.
//  Copyright (c) 2013 Lauterbach Beratung. All rights reserved.
//

#import "NSColor+LCSCocoaKit.h"
#import <LCSFoundationKit/NSString+LCSFoundationKit.h>
#import <LCSFoundationKit/NSRegularExpression+LCSFoundationKit.h>

@interface NSColor (LCSCocoaKitPrivate)

+ (BOOL)convertHexadecimalString:(NSString*)hexString toRed:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue;

@property (nonatomic,readonly) NSString *genericHexadecimalValue;

@end

static NSRegularExpression *Css2RGB8ByteRegex;
static NSRegularExpression *Css2RGBPercentRegex;

@implementation NSColor (LCSCocoaKit)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Css2RGB8ByteRegex = [NSRegularExpression re:@"^rgba?\\((-?\\d{1,3})(?:(?: ?,? )|,)(-?\\d{1,3})(?:(?: ?,? )|,)(-?\\d{1,3})(?:(?:(?: ?,? )|,)(-?\\d{1,3}))?\\)$"];
        Css2RGBPercentRegex = [NSRegularExpression re:@"^rgba?\\((-?\\d{1,3})%(?:(?: ?,? )|,)(-?\\d{1,3})%(?:(?: ?,? )|,)(-?\\d{1,3})%(?:(?:(?: ?,? )|,)(-?\\d{1,3})%)?\\)$"];
    });
}

- (NSString *)deviceColorHexadecimalValue {
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    return [convertedColor genericHexadecimalValue];
}

- (NSString *)calibratedColorHexadecimalValue {
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    return [convertedColor genericHexadecimalValue];
}

- (NSString*)genericHexadecimalValue
{
    double redFloatValue;
    double greenFloatValue;
    double blueFloatValue;
    int redIntValue;
    int greenIntValue;
    int blueIntValue;
    
    [self getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
    
    redIntValue = redFloatValue * 0xFF;
    greenIntValue = greenFloatValue * 0xFF;
    blueIntValue = blueFloatValue * 0xFF;
    
    return [NSString stringWithFormat:@"#%02x%02x%02x", redIntValue, greenIntValue, blueIntValue];
}

+ (NSColor *)deviceColorFromHexadecimalValue:(NSString *)hex
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    if ([NSColor convertHexadecimalString:hex toRed:&red green:&green blue:&blue]) {
        return [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
    }
    else {
        return nil;
    }
}

+ (NSColor *)calibratedColorFromHexadecimalValue:(NSString *)hex
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    
    if ([NSColor convertHexadecimalString:hex toRed:&red green:&green blue:&blue]) {
        return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0];
    }
    else {
        return nil;
    }
}

+ (BOOL)convertHexadecimalString:(NSString*)hexString toRed:(CGFloat*)red green:(CGFloat*)green blue:(CGFloat*)blue
{
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringWithRange:NSMakeRange(1, hexString.length - 1)];
    }
    
    NSAssert(hexString.length == 6 || hexString.length == 3, @"Passed hex string must be 3 or 6 hex digits with an optionally prefixed dash.");
    
    if (hexString.length != 6 && hexString.length != 3) {
        return NO;
    }
    
	unsigned int colorCode = 0;
	
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    BOOL didScan = [scanner scanHexInt:&colorCode];
    
    NSAssert(didScan, @"Couldn't scan from hex string.");
    
    if (!didScan) {
        return NO;
    }
    
    if (hexString.length == 3) {
        *red = ((colorCode >>   8) & 0xF) / 15.0;
        *green = ((colorCode >> 4) & 0xF) / 15.0;
        *blue = ((colorCode >>  0) & 0xF) / 15.0;
    }
    else {
        *red = ((colorCode >>  16) & 0xFF) / 255.0;
        *green = ((colorCode >> 8) & 0xFF) / 255.0;
        *blue = ((colorCode >>  0) & 0xFF) / 255.0;
    }
    
    return YES;
}

+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex {
    
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringWithRange:NSMakeRange(1, hex.length - 1)];
    }
    NSAssert(hex.length == 6, @"Passed hex string must be 6 or 7 characters long.");
    
	unsigned int colorCode = 0;
	
    NSColor *color;
    
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    BOOL didScan = [scanner scanHexInt:&colorCode];
    
    NSAssert(didScan, @"Couldn't scan from hex string.");
    
    color = [NSColor colorWithDeviceRed:((colorCode>>16)&0xFF)/255.0
                                  green:((colorCode>>8)&0xFF)/255.0
                                   blue:((colorCode)&0xFF)/255.0 alpha:1.0];

	return color;
}

+ (NSArray *)deviceColorsFromHexadecimalValues:(NSArray *)hexList
{
    NSMutableArray *colorList = [NSMutableArray arrayWithCapacity:hexList.count];
    [hexList enumerateObjectsUsingBlock:^(NSString *hex, NSUInteger idx, BOOL *stop) {
        [colorList addObject:[NSColor deviceColorFromHexadecimalValue:hex]];
    }];
    
    return colorList;
}

+ (NSArray *)hexadecimalValuesFromDeviceColors:(NSArray *)colorList
{
    NSMutableArray *hexList = [NSMutableArray arrayWithCapacity:colorList.count];
    [hexList enumerateObjectsUsingBlock:^(NSColor *color, NSUInteger idx, BOOL *stop) {
        [hexList addObject:[color deviceColorHexadecimalValue]];
    }];
    
    return colorList;
}

+ (NSColor *)deviceColorFromCSSValue:(NSString *)cssValue
{
    /*
     EM { color: #f00 }             #rgb
     EM { color: #ff0000 }           #rrggbb
     EM { color: rgb(255,0,0) }      integer range 0 - 255
     EM { color: rgb(100%, 0%, 0%) } float range 0.0% - 100.0%
     */
    
    if ([cssValue hasPrefix:@"#"]) {
        return [NSColor deviceColorFromHexadecimalValue:cssValue];
    }
    else if ([cssValue hasPrefix:@"rgb"]) {
        NSTextCheckingResult *result;
        
        result = [Css2RGB8ByteRegex firstMatchInString:cssValue options:NSMatchingAnchored range:cssValue.completeRange];
        if (result) {
            NSInteger red = [cssValue substringWithRange:[result rangeAtIndex:1]].integerValue;
            red = MAX(0, MIN(red, 255));
            NSInteger green = [cssValue substringWithRange:[result rangeAtIndex:2]].integerValue;
            green = MAX(0, MIN(green, 255));
            NSInteger blue = [cssValue substringWithRange:[result rangeAtIndex:3]].integerValue;
            blue = MAX(0, MIN(blue, 255));
            NSInteger alpha = 255;
            if ([cssValue hasPrefix:@"rgba"] && result.numberOfRanges == 5 && [result rangeAtIndex:4].location != NSNotFound) {
                alpha = [cssValue substringWithRange:[result rangeAtIndex:4]].integerValue;
                alpha = MAX(0, MIN(alpha, 255));
            }
            
            return [NSColor colorWithDeviceRed:(CGFloat)red/255.0
                                         green:(CGFloat)green/255.0
                                          blue:(CGFloat)blue/255.0
                                         alpha:(CGFloat)alpha/255.0];
        }
        else {
            result = [Css2RGBPercentRegex firstMatchInString:cssValue options:NSMatchingAnchored range:cssValue.completeRange];
            if (result) {
                CGFloat red = [cssValue substringWithRange:[result rangeAtIndex:1]].doubleValue;
                red = MAX(0.0, MIN(red, 100.0));
                CGFloat green = [cssValue substringWithRange:[result rangeAtIndex:2]].doubleValue;
                green = MAX(0.0, MIN(green, 100.0));
                CGFloat blue = [cssValue substringWithRange:[result rangeAtIndex:3]].doubleValue;
                blue = MAX(0.0, MIN(blue, 100.0));
                CGFloat alpha = 100.0;
                if ([cssValue hasPrefix:@"rgba"] && result.numberOfRanges == 5 && [result rangeAtIndex:4].location != NSNotFound) {
                    alpha = [cssValue substringWithRange:[result rangeAtIndex:4]].doubleValue;
                    alpha = MAX(0.0, MIN(alpha, 100.0));
                }
                
                
                return [NSColor colorWithDeviceRed:red/100.0
                                             green:green/100.0
                                              blue:blue/100.0
                                             alpha:alpha/100.0];
            }
        }
    }
    
    return nil;
}

@end

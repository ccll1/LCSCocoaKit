//
//  LCSCocoaKitTests.m
//  LCSCocoaKitTests
//
//  Created by Christoph Lauterbach on 12.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSColor+LCSCocoaKit.h"

@interface NSColor_LCSCocoaKit_Tests : XCTestCase
- (BOOL)isColor:(NSColor*)colorA equalToColor:(NSColor*)colorB withComponentTolerance:(CGFloat)tolerance;

@end

@implementation NSColor_LCSCocoaKit_Tests

- (void)testThrowOnNil
{
    XCTAssertThrows([NSColor deviceColorFromHexadecimalValue:nil]);
}

- (void)testThrowOnNonConformingValue
{
    NSArray *wrongHexStrings = @[@"", @"---", @"#", @"#ZZZZZZ"];
    for (NSString *wrongHexString in wrongHexStrings) {
        XCTAssertThrows([NSColor deviceColorFromHexadecimalValue:wrongHexString], @"%@", wrongHexString);
    }
}

- (void)testRGBColorRandomAndBack
{
    for (NSUInteger i = 0; i < 100000; i++) {
        CGFloat red = (CGFloat)arc4random_uniform(255) / 255.0;
        CGFloat green = (CGFloat)arc4random_uniform(255) / 255.0;
        CGFloat blue = (CGFloat)arc4random_uniform(255) / 255.0;
        
        NSColor *color = [NSColor colorWithDeviceRed:red green:green blue:blue alpha:1.0];
        NSString *hexString = color.deviceColorHexadecimalValue;
        NSColor *convertedColor = [NSColor deviceColorFromHexadecimalValue:hexString];
        XCTAssertEqualObjects(color, convertedColor);
    }
}

- (void)testHSBColorRandomAndBack
{
    for (NSUInteger i = 0; i < 100000; i++) {
        CGFloat hue = (CGFloat)arc4random_uniform(100.0) / 100.0;
        CGFloat saturation = (CGFloat)arc4random_uniform(100.0) / 100.0;
        CGFloat brightness = (CGFloat)arc4random_uniform(100.0) / 100.0;
        
        NSColor *color = [NSColor colorWithDeviceHue:hue saturation:saturation brightness:brightness alpha:1.0];
        NSString *hexString = color.deviceColorHexadecimalValue;
        NSColor *convertedColor = [NSColor deviceColorFromHexadecimalValue:hexString];
        
        XCTAssertTrue([self isColor:color equalToColor:convertedColor withComponentTolerance:0.004]);
    }
}

- (BOOL)isColor:(NSColor*)colorA equalToColor:(NSColor*)colorB withComponentTolerance:(CGFloat)tolerance;
{
    CGFloat redA;
    CGFloat greenA;
    CGFloat blueA;
    
    CGFloat redB;
    CGFloat greenB;
    CGFloat blueB;
    
    [colorA getRed:&redA green:&greenA blue:&blueA alpha:NULL];
    [colorB getRed:&redB green:&greenB blue:&blueB alpha:NULL];
    
    return (fabs(redA - redB) < tolerance &&
            fabs(greenA - greenB) < tolerance &&
            fabs(blueA - blueB) < tolerance);
}

- (void)test3digitHexColor
{
    NSString *hexValue;
    NSColor *color;
    NSColor *supposedColor;
    
    hexValue = @"#f00";
    supposedColor = [NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    color = [NSColor deviceColorFromHexadecimalValue:hexValue];
    
    XCTAssertEqualObjects(color, supposedColor);
    
    hexValue = @"#0f0";
    supposedColor = [NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    color = [NSColor deviceColorFromHexadecimalValue:hexValue];
    
    XCTAssertEqualObjects(color, supposedColor);
    
    hexValue = @"#00f";
    supposedColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0];
    color = [NSColor deviceColorFromHexadecimalValue:hexValue];
    
    XCTAssertEqualObjects(color, supposedColor);
}

- (void)testCss8ByteColor
{
    NSDictionary *stringsToColors = @{@"rgb(255,0,0)": [NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:1.0],
                                      @"rgb(0,255,0)": [NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(0,0,255)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgb(255,255,0)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(255,255,255)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                      @"rgba(0,255,0,0)": [NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(0,0,255,0)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:0.0],
                                      @"rgba(255,255,0,0)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(255,255,255,0)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:0.0],
                                      @"rgba(0,255,0,255)": [NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(0,0,255,255)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgba(255,255,0,255)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(255,255,255,255)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                                      };
    
    for (NSString *cssValue in stringsToColors) {
        NSColor *supposedColor = stringsToColors[cssValue];
        NSColor *color = [NSColor deviceColorFromCSSValue:cssValue];
        
        XCTAssertEqualObjects(color, supposedColor);
    }
}

- (void)testCssPercentColor
{
    NSDictionary *stringsToColors = @{@"rgb(100%,0%,0%)": [NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:1.0],
                                      @"rgb(0%,100%,0%)": [NSColor colorWithDeviceRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(0%,0%,100%)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgb(100%,100%,0%)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(100%,100%,100%)": [NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                      @"rgb(50%,0%,0%)": [NSColor colorWithDeviceRed:0.5 green:0.0 blue:0.0 alpha:1.0],
                                      @"rgb(0%,50%,0%)": [NSColor colorWithDeviceRed:0.0 green:0.5 blue:0.0 alpha:1.0],
                                      @"rgb(0%,0%,50%)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.5 alpha:1.0],
                                      @"rgb(50%,50%,0%)": [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.0 alpha:1.0],
                                      @"rgb(50%,50%,50%)": [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0],
                                      @"rgba(50%,0%,0%,50%)": [NSColor colorWithDeviceRed:0.5 green:0.0 blue:0.0 alpha:0.5],
                                      @"rgba(0%,50%,0%,50%)": [NSColor colorWithDeviceRed:0.0 green:0.5 blue:0.0 alpha:0.5],
                                      @"rgba(0%,0%,50%,50%)": [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.5 alpha:0.5],
                                      @"rgba(50%,50%,0%,50%)": [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.0 alpha:0.5],
                                      @"rgba(50%,50%,50%,50%)": [NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:0.5]
                                      };
    
    for (NSString *cssValue in stringsToColors) {
        NSColor *supposedColor = stringsToColors[cssValue];
        NSColor *color = [NSColor deviceColorFromCSSValue:cssValue];
        
        XCTAssertEqualObjects(color, supposedColor);
    }
}


@end

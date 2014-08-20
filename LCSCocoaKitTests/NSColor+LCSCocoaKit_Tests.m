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
    XCTAssertThrows([NSColor SRGBColorFromHexadecimalValue:nil]);
}

- (void)testThrowOnNonConformingValue
{
    NSArray *wrongHexStrings = @[@"", @"---", @"#", @"#ZZZZZZ"];
    for (NSString *wrongHexString in wrongHexStrings) {
        XCTAssertThrows([NSColor SRGBColorFromHexadecimalValue:wrongHexString], @"%@", wrongHexString);
    }
}

- (void)testRGBColorRandomAndBack
{
    for (NSUInteger i = 0; i < 100000; i++) {
        CGFloat red = (CGFloat)arc4random_uniform(255) / 255.0;
        CGFloat green = (CGFloat)arc4random_uniform(255) / 255.0;
        CGFloat blue = (CGFloat)arc4random_uniform(255) / 255.0;
        
        NSColor *color = [NSColor colorWithSRGBRed:red green:green blue:blue alpha:1.0];
        NSString *hexString = color.hexadecimalValue;
        NSColor *convertedColor = [NSColor SRGBColorFromHexadecimalValue:hexString];
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
        NSString *hexString = color.hexadecimalValue;
        NSColor *convertedColor = [NSColor SRGBColorFromHexadecimalValue:hexString];
        
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
    NSDictionary *hexToColors = @{@"#f00": [NSColor colorWithSRGBRed:1.0 green:0.0 blue:0.0 alpha:1.0],
                                  @"#0f0": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                  @"#00f": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:1.0]};
    
    for (NSString *hexColor in hexToColors) {
        NSColor *supposedColor = hexToColors[hexColor];
        NSColor *color = [NSColor SRGBColorFromHexadecimalValue:hexColor];
        
        XCTAssertEqualObjects(color, supposedColor);
    }
}

- (void)testCssRGBColor
{
    NSDictionary *stringsToColors = @{@"rgb(255,0,0)": [NSColor colorWithSRGBRed:1.0 green:0.0 blue:0.0 alpha:1.0],
                                      @"rgb(0,255,0)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(0,0,255)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgb(255,255,0)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(255,255,255)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                      @"rgba(0,255,0,0)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(0,0,255,0)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:0.0],
                                      @"rgba(255,255,0,0)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(255,255,255,0)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:0.0],
                                      @"rgba(0,255,0,255)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(0,0,255,255)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgba(255,255,0,255)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(255,255,255,255)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                      @"rgb(100%,0%,0%)": [NSColor colorWithSRGBRed:1.0 green:0.0 blue:0.0 alpha:1.0],
                                      @"rgb(0%,100%,0%)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(0%,0%,100%)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgb(100%,100%,0%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgb(100%,100%,100%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                      @"rgba(0%,100%,0%,0%)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(0.0%,0%,100%,0%)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:0.0],
                                      @"rgba(100.0%,100.0%,0.0%,0%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:0.0],
                                      @"rgba(100%,100%,100%,0%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:0.0],
                                      @"rgba(0%,100%,0%,100%)": [NSColor colorWithSRGBRed:0.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(0%,0%,100%,100%)": [NSColor colorWithSRGBRed:0.0 green:0.0 blue:1.0 alpha:1.0],
                                      @"rgba(100%,100%,0%,100%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:0.0 alpha:1.0],
                                      @"rgba(100%,100%,100%,100%)": [NSColor colorWithSRGBRed:1.0 green:1.0 blue:1.0 alpha:1.0]
                                      };
    
    for (NSString *cssValue in stringsToColors) {
        NSColor *supposedColor = stringsToColors[cssValue];
        NSColor *color = [NSColor SRGBColorFromCSSValue:cssValue];
        
        XCTAssertEqualObjects(color, supposedColor);
    }
}

- (void)testCssHSLColor
{
    NSDictionary *stringsToColors = @{@"hsl(0,100%,100%)": [NSColor colorWithDeviceHue:0.0 saturation:1.0 brightness:1.0 alpha:1.0],
                                      @"hsl(90,100%,100%)": [NSColor colorWithDeviceHue:0.25 saturation:1.0 brightness:1.0 alpha:1.0],
                                      @"hsl(180,100%,100%)": [NSColor colorWithDeviceHue:0.5 saturation:1.0 brightness:1.0 alpha:1.0],
                                      @"hsl(270,100.0%,100.0%)": [NSColor colorWithDeviceHue:0.75 saturation:1.0 brightness:1.0 alpha:1.0],
                                      @"hsl(360,100%,100%)": [NSColor colorWithDeviceHue:1.0 saturation:1.0 brightness:1.0 alpha:1.0],
                                      @"hsla(0,100%,100%,0)": [NSColor colorWithDeviceHue:0.0 saturation:1.0 brightness:1.0 alpha:0.0],
                                      @"hsla(90,100%,100%,0.25)": [NSColor colorWithDeviceHue:0.25 saturation:1.0 brightness:1.0 alpha:0.25],
                                      @"hsla(180,100%,100%,0.5)": [NSColor colorWithDeviceHue:0.5 saturation:1.0 brightness:1.0 alpha:0.5],
                                      @"hsla(270,100%,100%,0.75)": [NSColor colorWithDeviceHue:0.75 saturation:1.0 brightness:1.0 alpha:0.75],
                                      @"hsla(360,100%,100%,1.0)": [NSColor colorWithDeviceHue:1.0 saturation:1.0 brightness:1.0 alpha:1.0]
                                      };
    
    for (NSString *cssValue in stringsToColors) {
        NSColor *supposedColor = stringsToColors[cssValue];
        supposedColor = [supposedColor colorUsingColorSpace:[NSColorSpace sRGBColorSpace]];
        NSColor *color = [NSColor SRGBColorFromCSSValue:cssValue];
        
        XCTAssertEqualObjects(color, supposedColor);
    }
}

@end

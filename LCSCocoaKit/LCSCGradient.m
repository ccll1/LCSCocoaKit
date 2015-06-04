//
//  LCSCGradient.m
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 13.10.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "LCSCGradient.h"

@interface LCSCGradient ()

@property (nonatomic, readwrite) BOOL isValid;

- (void)checkValidity;

@end

@implementation LCSCGradient

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addObserver:self forKeyPath:@"colors" options:0 context:nil];
        [self addObserver:self forKeyPath:@"locations" options:0 context:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"colors"];
    [self removeObserver:self forKeyPath:@"locations"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [@[@"colors", @"locations"] containsObject:keyPath]) {
        [self checkValidity];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)checkValidity
{
    if (self.colors.count != self.locations.count ||
        self.colors.count < 2) {
        self.isValid = NO;
        return;
    }

    __block BOOL isValid = YES;
    [self.colors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSColor class]]) {
            isValid = NO;
            *stop = YES;
        }
    }];
    
    if (!isValid) {
        self.isValid = NO;
        return;
    }

    [self.locations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSNumber class]] ||
            ([obj floatValue] < 0.0 || [obj floatValue] > 1.0)) {
            isValid = NO;
            *stop = YES;
        }
    }];

    if (!isValid) {
        self.isValid = NO;
        return;
    }

    self.isValid = YES;
}

- (NSColor *)colorAtLocation:(CGFloat)location
{
    if (location < 0.0 ||
        location > 1.0) {
        NSLog(@"WARNING: For querying a LCSCGradient, the location parameter must be between 0.0 and 1.0. Returning green color.");
        return [NSColor greenColor];
    }
    if (!self.isValid) {
        NSLog(@"WARNING: Gradient not valid, returning red color");
        return [NSColor redColor];
    }
    
    __block NSUInteger startColorIdx = 0;
    NSUInteger colorCount = self.colors.count;
    
    [self.locations enumerateObjectsUsingBlock:^(NSNumber *colorLocation, NSUInteger idx, BOOL *stop) {
        if (location >= [colorLocation floatValue]) {
            startColorIdx = idx;
        }
        else {
            *stop = YES;
        }
    }];
    
    if (startColorIdx == NSNotFound) {
        return nil;
    }
    
    NSUInteger endColorIdx;
    CGFloat relativeLocation;
    
    if (startColorIdx == colorCount - 1) {
        endColorIdx = startColorIdx;
        relativeLocation = 0.0;
    }
    else {
        endColorIdx = startColorIdx + 1;
        relativeLocation = ((location - [self.locations[startColorIdx] floatValue]) /
                            ([self.locations[endColorIdx] floatValue] - [self.locations[startColorIdx] floatValue]));
    }
    
    NSColor *startColor = self.colors[startColorIdx];
    NSColor *endColor   = self.colors[endColorIdx];
    NSColor *colorAtLocation;
    
    if (self.mode == LCSCGradientModeHSB) {
        CGFloat hueStart;
        CGFloat saturationStart;
        CGFloat brightnessStart;
        CGFloat alphaStart;
        
        [startColor getHue:&hueStart saturation:&saturationStart brightness:&brightnessStart alpha:&alphaStart];
        
        CGFloat hueEnd;
        CGFloat saturationEnd;
        CGFloat brightnessEnd;
        CGFloat alphaEnd;
        
        [endColor getHue:&hueEnd saturation:&saturationEnd brightness:&brightnessEnd alpha:&alphaEnd];
        
        CGFloat hueDifference        = hueEnd - hueStart;
        CGFloat saturationDifference = saturationEnd - saturationStart;
        CGFloat brightnessDifference = brightnessEnd - brightnessStart;
        CGFloat alphaDifference      = alphaEnd - alphaStart;
        
        colorAtLocation = [NSColor colorWithHue:hueStart + hueDifference * relativeLocation
                                     saturation:saturationStart + saturationDifference * relativeLocation
                                     brightness:brightnessStart + brightnessDifference * relativeLocation
                                          alpha:alphaStart + alphaDifference * relativeLocation];
        
    }
    else if (self.mode == LCSCGradientModeRGB) {
        CGFloat redStart;
        CGFloat greenStart;
        CGFloat blueStart;
        CGFloat alphaStart;
        
        [startColor getRed:&redStart green:&greenStart blue:&blueStart alpha:&alphaStart];
        
        CGFloat redEnd;
        CGFloat greenEnd;
        CGFloat blueEnd;
        CGFloat alphaEnd;
        
        [endColor getRed:&redEnd green:&greenEnd blue:&blueEnd alpha:&alphaEnd];
        
        CGFloat redDifference   = redEnd - redStart;
        CGFloat greenDifference = greenEnd - greenStart;
        CGFloat blueDifference  = blueEnd - blueStart;
        CGFloat alphaDifference = alphaEnd - alphaStart;
        
        colorAtLocation = [NSColor colorWithRed:redStart + redDifference * relativeLocation
                                          green:greenStart + greenDifference * relativeLocation
                                           blue:blueStart + blueDifference * relativeLocation
                                          alpha:alphaStart + alphaDifference * relativeLocation];
    }
    
    return colorAtLocation;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    else if (![super isEqual:other]) {
        return NO;
    }
    else {
        LCSCGradient *otherGradient = other;
        return [self.colors isEqual:otherGradient.colors] &&
        [self.locations isEqual:otherGradient.locations];
    }
}

- (NSUInteger)hash
{
    return self.colors.hash ^ self.locations.hash;
}

- (NSString *)description
{
    NSMutableArray *componentsStrings = [NSMutableArray new];
    
    for (NSUInteger i = 0; i < self.colors.count; i++) {
        NSString *locationString;
        if (i >= self.locations.count) {
            locationString = @"(not set)";
        }
        else {
            locationString = [NSString stringWithFormat:@"%f", [self.locations[i] floatValue]];
        }
        
        [componentsStrings addObject:[NSString stringWithFormat:@"%@: %@", locationString, self.colors[i]]];
    }
    
    return [NSString stringWithFormat:@"%@(%@)", NSStringFromClass([self class]), [componentsStrings componentsJoinedByString:@", "]];
}

@end

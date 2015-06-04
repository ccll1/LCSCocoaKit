//
//  LCSCGradient.h
//  LCSCocoaKit
//
//  Created by Christoph Lauterbach on 13.10.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, LCSCGradientMode) {
    LCSCGradientModeRGB,
    LCSCGradientModeHSB
};

@interface LCSCGradient : NSObject

@property (nonatomic, readonly) BOOL isValid;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) LCSCGradientMode  mode;

- (NSColor *)colorAtLocation:(CGFloat)location;

@end

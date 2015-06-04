//
//  ColoredBackgroundView.m
//  Stack
//
//  Created by Christoph Lauterbach on 27.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "LCSCColoredBackgroundView.h"

@interface LCSCColoredBackgroundView () {
    NSColor *_backgroundColor;
}

@property (readwrite, nonatomic) BOOL opaque;

- (void)update;

@end

@implementation LCSCColoredBackgroundView

@synthesize opaque;

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    
    [self update];
}
- (NSColor*)backgroundColor
{
    return _backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    [self update];
}

- (void)setOutlineColor:(NSColor *)outlineColor
{
    _outlineColor = outlineColor;
    
    [self update];
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    _outlineWidth = outlineWidth;
    
    [self update];
}

- (void)update
{
    if (_backgroundColor == nil && (_outlineColor == nil || _outlineWidth == 0.0)) {
        self.wantsLayer = NO;
    }
    else {
        self.wantsLayer = YES;
        self.layer.backgroundColor = _backgroundColor.CGColor;
        self.layer.cornerRadius = _cornerRadius;
        
        self.layer.borderColor = _outlineColor.CGColor;
        self.layer.borderWidth = _outlineWidth;

        self.opaque = (_backgroundColor.alphaComponent == 1.0 &&
                       _cornerRadius == 0.0 &&
                       ((_outlineColor &&_outlineColor.alphaComponent == 1.0) ||
                        _outlineWidth == 0.0 ));
    }
}

@end

//
//  ColoredBackgroundView.h
//  Stack
//
//  Created by Christoph Lauterbach on 27.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LCSCColoredBackgroundView : NSView

@property (nonatomic) IBInspectable NSColor *backgroundColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable NSColor *outlineColor;
@property (nonatomic) IBInspectable CGFloat outlineWidth;

@end

//
//  NSBezierPath+CGPath.h
//  Yosemite_Sandbox
//
//  Created by Christoph Lauterbach on 29.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSBezierPath (CGPath)

@property (readonly,nonatomic) CGPathRef CGPath;

@end

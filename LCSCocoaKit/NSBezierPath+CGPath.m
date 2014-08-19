//
//  NSBezierPath+CGPath.m
//  Yosemite_Sandbox
//
//  Created by Christoph Lauterbach on 29.07.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSBezierPath+CGPath.h"

@implementation NSBezierPath (CGPath)

- (CGPathRef)CGPath
{
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    NSInteger numElements = [self elementCount];
    if (numElements == 0) {
        return immutablePath;
    }
    
    CGMutablePathRef    path = CGPathCreateMutable();
    NSPoint             points[3];
    BOOL                didClosePath = YES;
    
    for (NSUInteger i = 0; i < numElements; i++)
    {
        switch ([self elementAtIndex:i associatedPoints:points])
        {
            case NSMoveToBezierPathElement:
                CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                break;
                
            case NSLineToBezierPathElement:
                CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                didClosePath = NO;
                break;
                
            case NSCurveToBezierPathElement:
                CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                      points[1].x, points[1].y,
                                      points[2].x, points[2].y);
                didClosePath = NO;
                break;
                
            case NSClosePathBezierPathElement:
                CGPathCloseSubpath(path);
                didClosePath = YES;
                break;
        }
    }
    
    if (!didClosePath)
        CGPathCloseSubpath(path);
    
    immutablePath = CGPathCreateCopy(path);
    CGPathRelease(path);
    
    return immutablePath;
}

@end
//
//  LCSCTextField.m
//  Stack
//
//  Created by Christoph Lauterbach on 25.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "LCSCTextField.h"

@implementation LCSCTextField

- (CGSize)intrinsicContentSize
{
    if ( ![self.cell wraps] ) {
        return [super intrinsicContentSize];
    }
    
    NSRect frame = self.frame;
    
    frame.size.height = CGFLOAT_MAX;
    frame.size.width = CGFLOAT_MAX;
    
    return [self.cell cellSizeForBounds:frame];
}

@end
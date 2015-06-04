//
//  NSTableColumn+LCSCocoaKit.m
//  Stack
//
//  Created by Christoph Lauterbach on 25.08.14.
//  Copyright (c) 2014 Christoph Lauterbach. All rights reserved.
//

#import "NSTableColumn+LCSCocoaKit.h"

@implementation NSTableColumn (LCSCocoaKit)

- (void)lcsc_sizeToFit
{
    if (!self.tableView) {
        return;
    }
    
    CGFloat minFittingWidth = 0.0;
    
    NSUInteger numberOfRows = self.tableView.numberOfRows;
    NSUInteger columnIndex = [self.tableView.tableColumns indexOfObject:self];
    
    NSAssert(columnIndex < self.tableView.tableColumns.count, @"table column index not found!");
    
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSTableCellView *cellView = [self.tableView viewAtColumn:columnIndex row:i makeIfNecessary:NO];
        
        if (!cellView) {
            continue;
        }
        
        CGFloat fittingWidth = cellView.fittingSize.width;
        
        if (fittingWidth > minFittingWidth) {
            minFittingWidth = fittingWidth;
        }
    }
    
    if (minFittingWidth >= self.minWidth && minFittingWidth <= self.maxWidth) {
        self.width = minFittingWidth;
    }
}

@end
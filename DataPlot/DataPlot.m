//
//  Plot.m
//  DataPlot
//
//  Created by Fred Dijkstra on 05/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import "DataPlot.h"

@implementation DataPlot

// ------------------------------------------------------------------------------------
- (id)initWithColor:(DPPlotColor)color andStyle:(DPPlotStyle)style;
{
    self = [super init];
    
    _dataPoints = [[NSMutableArray alloc]init];
    
    // Initial non-zero values.
    _scale = 1;
    
    _style  = style;
    _color = color;
    
    return self;
}

// ------------------------------------------------------------------------------------
- (void)addDataValue:(CGFloat)value atTime:(CGFloat)timestamp
{
    [_dataPoints addObject:[[DataPoint alloc] initWithValue:value atTime:timestamp]];
}

// ------------------------------------------------------------------------------------
- (CGPoint)getPointAtIndex:(NSUInteger)index
{
    return ((DataPoint*)[_dataPoints objectAtIndex:index]).point;
}


@end

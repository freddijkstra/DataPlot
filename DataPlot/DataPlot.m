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

// ------------------------------------------------------------------------------------
- (CGFloat)getValueAtTime:(CGFloat)timestamp
{
    DataPoint* dataPoint;
    
    // Boundary check.
    dataPoint = [_dataPoints firstObject];
    if( timestamp < dataPoint.point.x ) return dataPoint.point.x;
    dataPoint = [_dataPoints lastObject];
    if( timestamp > dataPoint.point.x ) return dataPoint.point.x;

    CGFloat firstTime = ((DataPoint*)[_dataPoints firstObject]).point.x;
    CGFloat lastTime  = ((DataPoint*)[_dataPoints lastObject] ).point.x;
    
    // Estimate
    CGFloat avgTimeStep = (lastTime-firstTime)/(CGFloat)_dataPoints.count;
    NSUInteger index = (timestamp-firstTime)/avgTimeStep;
    
    // Finetune
    DataPoint* beginPoint = [_dataPoints objectAtIndex:index];
    if( beginPoint.point.x > timestamp )
    {
        while( (index > 0) && ((DataPoint*)[_dataPoints objectAtIndex:index]).point.x > timestamp )
            index--;
    }
    else
    {
        while( (index < _dataPoints.count-2) && ((DataPoint*)[_dataPoints objectAtIndex:index+1]).point.x < timestamp )
            index++;
    }
    
    // Interpolate
    DataPoint* endPoint = [_dataPoints objectAtIndex:index+1];

    CGFloat dx = endPoint.point.x - beginPoint.point.x;
    CGFloat dy = endPoint.point.y - beginPoint.point.y;
    
    return beginPoint.point.y + dy*(timestamp-beginPoint.point.x)/dx;
}



@end

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
    _zeroPoints = [[NSMutableArray alloc]init];
    
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

// ------------------------------------------------------------------------------------
- (void)determineCrossPointsBetweenBeginIndex:(NSUInteger)beginIndex andEndIndex:(NSUInteger)endIndex
{
    _maxPoint = CGPointMake(CGFLOAT_MAX, -CGFLOAT_MIN);
    _minPoint = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    [_zeroPoints removeAllObjects];
    
    DataPoint* dataPoint;
    DataPoint* zeroPoint;
    
    // Remember previous point to determine whether the line went through zero.
    DataPoint* prevPoint = [_dataPoints objectAtIndex:beginIndex];
    
    for( NSUInteger i=beginIndex+1; i<endIndex; i++)
    {
        dataPoint = [_dataPoints objectAtIndex:i];
        
        if( dataPoint.point.y > _maxPoint.y ) _maxPoint = dataPoint.point;
        if( dataPoint.point.y < _minPoint.y ) _minPoint = dataPoint.point;
        
        if( (prevPoint.point.y<0 && dataPoint.point.y >=0 ) ||
            (prevPoint.point.y>0 && dataPoint.point.y <=0 ) )
        {
            CGFloat zeroTime = prevPoint.point.x+(dataPoint.point.x-prevPoint.point.x)*prevPoint.point.y/(prevPoint.point.y-dataPoint.point.y);
            zeroPoint = [[DataPoint alloc]initWithValue:0 atTime:zeroTime];
            [_zeroPoints addObject:zeroPoint];
        }
        prevPoint = dataPoint;
    }
}











































@end

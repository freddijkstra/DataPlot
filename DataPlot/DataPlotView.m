//
//  DataPlotView.m
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import "DataPlotView.h"
#import "DataPoint.h"


@implementation DataPlotView
{
    CGFloat    viewBeginTime;
    CGFloat    viewEndTime;
    NSUInteger indexOfFirstDataPointInView;
    NSUInteger indexOfLastDataPointInView;
    CGFloat    viewInterval;
    CGFloat    viewTimeScale;
}


// ------------------------------------------------------------------------------------
- (void)awakeFromNib
{
    _dataPoints = [[NSMutableArray alloc]init];
}

// ------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* plotColor = [UIColor colorWithRed: 1 green: 0 blue: 0 alpha: 1];
    
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(3.1, 3.1)];
    [shadow setShadowBlurRadius: 5];
    
    // Evaluation
    if( _dataPoints.count == 0 ) return;
    if( indexOfFirstDataPointInView == indexOfLastDataPointInView ) return;
    
    // -- Create path to plot --
    UIBezierPath* plotPath = [UIBezierPath bezierPath];
    
    // Scale and shift first point
    CGPoint prevPoint = [self scaleDataPointAtIndex:indexOfFirstDataPointInView];
    [plotPath moveToPoint:prevPoint];

    CGPoint nextPoint;
    CGFloat dx, dy;
    for( NSUInteger i=indexOfFirstDataPointInView+1; i<=indexOfLastDataPointInView; i++)
    {
        nextPoint = [self scaleDataPointAtIndex:i];
        // Only plot if enough distance.
        dx = prevPoint.x - nextPoint.x;
        dy = prevPoint.y - nextPoint.y;
        if( dx*dx+dy*dy > 1.0 )
        {
            [plotPath addLineToPoint:nextPoint];
            prevPoint = nextPoint;
        }
    }

    if( _dotted )
    {
        plotPath.lineCapStyle = kCGLineCapRound;
        plotPath.lineJoinStyle = kCGLineJoinRound;
        
        [plotColor setStroke];
        plotPath.lineWidth = 1;
        CGFloat pattern[] = {0, 5};
        [plotPath setLineDash: pattern count: 2 phase: 0];
        [plotPath stroke];
    }
    else
    {
        [plotColor setStroke];
        
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
        [plotColor setStroke];
        plotPath.lineWidth = 1;
        [plotPath stroke];
        CGContextRestoreGState(context);
    }
}

// ------------------------------------------------------------------------------------
- (CGPoint)scaleDataPointAtIndex:(NSUInteger)index
{
    CGPoint scaledPoint = ((DataPoint*)[_dataPoints objectAtIndex:index]).point;
    scaledPoint.x = (scaledPoint.x-viewBeginTime) * viewTimeScale;
    return scaledPoint;
}

// ------------------------------------------------------------------------------------
- (void)setViewBeginTime:(CGFloat)beginTime endTime:(CGFloat)endTime
{
    if( endTime-beginTime == 0 )
    {
        NSLog(@"DataPlotView: begin and end time equal.");
        return;
    }

    viewBeginTime = beginTime;
    viewEndTime   = endTime;
    viewInterval  = endTime-beginTime;
    viewTimeScale = self.bounds.size.width / viewInterval;
    
    // TODO: outside values
    
    // -- Determine the index of the first and last data point --
    
    CGFloat firstTime = ((DataPoint*)[_dataPoints firstObject]).point.x;
    CGFloat lastTime  = ((DataPoint*)[_dataPoints lastObject] ).point.x;
    
    CGFloat avgTimeStep = (lastTime-firstTime)/(CGFloat)_dataPoints.count;
    
    // Estimate
    NSUInteger beginIndex = (beginTime-firstTime)/avgTimeStep;

    NSUInteger endIndex   = (lastTime-endTime)/avgTimeStep;
    if( endTime > lastTime ) endIndex = _dataPoints.count-1;
    
    // Finetune
    DataPoint* beginPoint = [_dataPoints objectAtIndex:beginIndex];
    if( beginPoint.point.x > beginTime )
    {
        while( (beginIndex > 0) && ((DataPoint*)[_dataPoints objectAtIndex:beginIndex]).point.x > beginTime )
            beginIndex--;
    }
    else
    {
        while( (beginIndex < _dataPoints.count-2) && ((DataPoint*)[_dataPoints objectAtIndex:beginIndex+1]).point.x < beginTime )
            beginIndex++;
    }
    
    indexOfFirstDataPointInView = beginIndex;
    
    DataPoint* endPoint = [_dataPoints objectAtIndex:endIndex];
    if( endPoint.point.x < endTime )
    {
        while( (endIndex < _dataPoints.count-1) && ((DataPoint*)[_dataPoints objectAtIndex:endIndex]).point.x < endTime )
            endIndex++;
    }
    else
    {
        while( (endIndex > 0) && ((DataPoint*)[_dataPoints objectAtIndex:endIndex-1]).point.x > endTime )
            endIndex--;
    }
    
    indexOfLastDataPointInView = endIndex;
    
    //[self.layer setNeedsDisplay];
}

         
         
         

// ------------------------------------------------------------------------------------
- (void) addDataValue:(CGFloat)value atTime:(CGFloat)timestamp
{
    [_dataPoints addObject:[[DataPoint alloc]initWithValue:value atTime:timestamp]];
}


// ------------------------------------------------------------------------------------
- (void)panWithTranslation:(CGPoint)translation
{
    // Determine new begin and end times.
    
    viewBeginTime -= translation.x/viewTimeScale;
    viewEndTime   -= translation.x/viewTimeScale;
//    
//    NSLog(@"viewBeginTime = %f", viewBeginTime);
//    NSLog(@"translation.x = %f", translation.x);
//    NSLog(@"translation.x = %f", translation.x);
//    
    
    [self setViewBeginTime:viewBeginTime endTime:viewEndTime];
    
}

@end

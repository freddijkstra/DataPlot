//
//  DataPlotView.m
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import "DataPlotView.h"
#import "DataPoint.h"
#import "DataPlotFormat.h"


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
    _plots = [[NSMutableArray alloc]init];
    _isPlotSelected = NO;
}

// ------------------------------------------------------------------------------------
- (DataPlot*)createNewPlotWith:(DPPlotColor)color andStyle:(DPPlotStyle)style
{
    DataPlot* newPlot = [[DataPlot alloc]initWithColor:color andStyle:style];
    [_plots addObject:newPlot];
    return newPlot;
}

// ------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
{
    [self drawTimeAxis];
    
    for( DataPlot* plot in _plots )
    {
        [self drawPlot:plot];
    }
}

// ------------------------------------------------------------------------------------
- (void)drawTimeAxis
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, CGRectGetMidY(self.bounds))];
    [bezierPath addLineToPoint: CGPointMake(self.bounds.size.width, CGRectGetMidY(self.bounds))];
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    // Use first plot for the timestamps.
    DataPlot* plot = [_plots firstObject];
    CGFloat firstTime = ((DataPoint*)[plot.dataPoints firstObject]).point.x;
    CGFloat lastTime  = ((DataPoint*)[plot.dataPoints lastObject] ).point.x;
    CGFloat avgTimeStep = (lastTime-firstTime)/(CGFloat)plot.dataPoints.count;
    
    NSUInteger labelStep = MAX(1,100/(viewTimeScale*avgTimeStep));
    
    DataPoint* dataPoint;
    CGPoint scaledPoint;
    for( NSUInteger i=indexOfFirstDataPointInView; i<indexOfLastDataPointInView; i++)
    {
        if( i%labelStep == 0 )
        {
            dataPoint = [plot.dataPoints objectAtIndex:i];
            scaledPoint = [self scaleDataPoint:dataPoint.point];
            
            CGRect textRect = CGRectMake(scaledPoint.x-25, CGRectGetMidY(self.bounds)+12, 50, 10);
            CGRect iconRect = CGRectMake(scaledPoint.x-6.5, CGRectGetMidY(self.bounds)+1, 13, 10);
            [self drawFrameIconInFrame:iconRect];
    
            CGFloat timestamp = dataPoint.point.x;
            uint min = timestamp/60.0;
            timestamp -= min*60;
            
            NSString* textContent = [NSString stringWithFormat:@"%d:%06.3f",min,timestamp];
            
            NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            textStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: 10], NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle};
            
            CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, textRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
            CGContextRestoreGState(context);
        }
    }
}

// ------------------------------------------------------------------------------------
- (void)drawFrameIconInFrame: (CGRect)frame
{
    
    //// Group
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 1, CGRectGetMinY(frame) + 1, 13, 10)];
        [UIColor.blackColor setFill];
        [rectanglePath fill];
        
        
        //// Rectangle 2 Drawing
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle2Path fill];
        
        
        //// Rectangle 3 Drawing
        UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 8, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle3Path fill];
        
        
        //// Rectangle 4 Drawing
        UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle4Path fill];
        
        
        //// Rectangle 5 Drawing
        UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle5Path fill];
        
        
        //// Rectangle 6 Drawing
        UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 4, 7, 4)];
        [UIColor.whiteColor setFill];
        [rectangle6Path fill];
        
        
        //// Rectangle 7 Drawing
        UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle7Path fill];
        
        
        //// Rectangle 8 Drawing
        UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 8, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle8Path fill];
        
        
        //// Rectangle 9 Drawing
        UIBezierPath* rectangle9Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 6, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle9Path fill];
        
        
        //// Rectangle 10 Drawing
        UIBezierPath* rectangle10Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 10, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle10Path fill];
        
        
        //// Rectangle 11 Drawing
        UIBezierPath* rectangle11Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 12, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle11Path fill];
        
        
        //// Rectangle 12 Drawing
        UIBezierPath* rectangle12Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle12Path fill];
        
        
        //// Rectangle 13 Drawing
        UIBezierPath* rectangle13Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 9, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle13Path fill];
        
        
        //// Rectangle 14 Drawing
        UIBezierPath* rectangle14Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 12, CGRectGetMinY(frame) + 2, 1, 1)];
        [UIColor.whiteColor setFill];
        [rectangle14Path fill];
        
        
        //// Rectangle 15 Drawing
        UIBezierPath* rectangle15Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + 4, 2, 4)];
        [UIColor.whiteColor setFill];
        [rectangle15Path fill];
        
        
        //// Rectangle 16 Drawing
        UIBezierPath* rectangle16Path = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame) + 13, CGRectGetMinY(frame) + 4, 2, 4)];
        [UIColor.whiteColor setFill];
        [rectangle16Path fill];
    }
}

// ------------------------------------------------------------------------------------
- (void)drawPlot:(DataPlot*)plot
{
    UIColor* plotColor = [self determineColor:plot.color];
    
    if( _isPlotSelected && !plot.selected )
    {
        plotColor = [plotColor colorWithAlphaComponent:0.2];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Evaluation
    if( plot.dataPoints.count == 0 ) return;
    if( indexOfFirstDataPointInView == indexOfLastDataPointInView ) return;
    
    // -- Create path to plot --
    UIBezierPath* plotPath = [UIBezierPath bezierPath];
    
    // Scale and shift first point
    CGPoint prevPoint = [self scaleDataPoint:[plot getPointAtIndex:indexOfFirstDataPointInView]];

    prevPoint.y *= plot.scale;
    prevPoint.y = CGRectGetMidY(self.bounds)-prevPoint.y;
    
    [plotPath moveToPoint:prevPoint];
    
    CGPoint nextPoint;
    for( NSUInteger i=indexOfFirstDataPointInView+1; i<=indexOfLastDataPointInView; i++)
    {
        nextPoint = [self scaleDataPoint:[plot getPointAtIndex:i]];

        // Only plot if enough distance.
        if( fabs(prevPoint.y - nextPoint.y) > 1.0 || fabs(prevPoint.x - nextPoint.x) > 1.0)
        {
            nextPoint.y *= plot.scale;
            nextPoint.y = CGRectGetMidY(self.bounds)-nextPoint.y;
            [plotPath addLineToPoint:nextPoint];
            prevPoint = nextPoint;
        }
    }
        
    plotPath.lineCapStyle = kCGLineCapRound;

    CGContextSaveGState(context);
    
    if( plot.selected )
    {
        /// Shadow Declarations
        NSShadow* shadow = [[NSShadow alloc] init];
        [shadow setShadowColor: UIColor.blackColor];
        [shadow setShadowOffset: CGSizeMake(3.1, 3.1)];
        [shadow setShadowBlurRadius: 5];
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    }

    if( plot.style == DPPlotStyleDotted)
    {
        plotPath.lineJoinStyle = kCGLineJoinRound;
        CGFloat pattern[] = {0, 5};
        [plotPath setLineDash: pattern count: 2 phase: 0];
    }
    else if( plot.style == DPPlotStyleDashed )
    {
        // TODO
    }
    
    [plotColor setStroke];
    
    plotPath.lineWidth = 2;
    [plotPath stroke];
    CGContextRestoreGState(context);
}


// ------------------------------------------------------------------------------------
// Determine color
// ------------------------------------------------------------------------------------
- (UIColor*)determineColor:(DPPlotColor)color
{
    UIColor* returnColor;
    
    switch (color)
    {
        case DPPlotColorBlue:
            returnColor = [UIColor blueColor];
            break;
        case DPPlotColorGreen:
            returnColor = [UIColor greenColor];
            break;
        case DPPlotColorRed:
            returnColor = [UIColor redColor];
            break;
        default:
            returnColor = [UIColor blackColor];
            break;
    }
    return returnColor;
}


// ------------------------------------------------------------------------------------
- (CGPoint)scaleDataPoint:(CGPoint)dataPoint
{
    CGPoint scaledPoint = dataPoint;
    scaledPoint.x = (scaledPoint.x-viewBeginTime) * viewTimeScale;
    return scaledPoint;
}

// ------------------------------------------------------------------------------------
- (void)setViewBeginTime:(CGFloat)beginTime endTime:(CGFloat)endTime
{
    DataPlot* plot = [_plots firstObject];
    
    DataPoint* beginPoint = [plot.dataPoints firstObject];
    DataPoint* endPoint  = [plot.dataPoints lastObject];

    if( (beginTime < beginPoint.point.x) ||
        (endTime > endPoint.point.x)     ||
        (endTime-beginTime <= 0) ) return;
    
    viewBeginTime = beginTime;
    viewEndTime   = endTime;
    viewInterval  = endTime-beginTime;
    viewTimeScale = self.bounds.size.width/viewInterval;
    
    // -- Determine the index of the first and last data point --
    
    CGFloat firstTime = ((DataPoint*)[plot.dataPoints firstObject]).point.x;
    CGFloat lastTime  = ((DataPoint*)[plot.dataPoints lastObject] ).point.x;
    
    CGFloat avgTimeStep = (lastTime-firstTime)/(CGFloat)plot.dataPoints.count;
    
    // Estimate
    NSUInteger beginIndex = (beginTime-firstTime)/avgTimeStep;
    NSUInteger endIndex   = MIN(plot.dataPoints.count-1,(endTime-firstTime)/avgTimeStep);
    
    // Finetune
    beginPoint = [plot.dataPoints objectAtIndex:beginIndex];
    if( beginPoint.point.x > beginTime )
    {
        while( (beginIndex > 0) && ((DataPoint*)[plot.dataPoints objectAtIndex:beginIndex]).point.x > beginTime )
            beginIndex--;
    }
    else
    {
        while( (beginIndex < plot.dataPoints.count-2) && ((DataPoint*)[plot.dataPoints objectAtIndex:beginIndex+1]).point.x < beginTime )
            beginIndex++;
    }
    
    indexOfFirstDataPointInView = beginIndex;
    
    endPoint = [plot.dataPoints objectAtIndex:endIndex];
    if( endPoint.point.x < endTime )
    {
        while( (endIndex < plot.dataPoints.count-1) && ((DataPoint*)[plot.dataPoints objectAtIndex:endIndex]).point.x < endTime )
            endIndex++;
    }
    else
    {
        while( (endIndex > 0) && ((DataPoint*)[plot.dataPoints objectAtIndex:endIndex-1]).point.x > endTime )
            endIndex--;
    }
    
    indexOfLastDataPointInView = endIndex;
    
    [self.layer setNeedsDisplay];
}

// ------------------------------------------------------------------------------------
- (void)panWithTranslation:(CGPoint)translation
{
    // Determine new begin and end times.
    DataPlot* plot = [_plots firstObject];
    
    CGFloat minTime = ((DataPoint*)[plot.dataPoints firstObject]).point.x;
    CGFloat maxTime = ((DataPoint*)[plot.dataPoints lastObject]).point.x;
    
    CGFloat timeShift = translation.x/viewTimeScale;
    
    CGFloat newBeginTime = viewBeginTime - timeShift;
    CGFloat newEndTime   = viewEndTime   - timeShift;
    
    if( newBeginTime < minTime )
    {
        timeShift    = viewBeginTime - minTime;
        newBeginTime = minTime;
        newEndTime   = viewEndTime   - timeShift;
    }
    else if( newEndTime > maxTime )
    {
        timeShift    = maxTime - viewEndTime;
        newBeginTime = viewBeginTime - timeShift;
        newEndTime   = maxTime;
    }
    
    [self setViewBeginTime:newBeginTime endTime:newEndTime];
}

// ------------------------------------------------------------------------------------
- (void)pinchWithScale:(CGFloat)scale aroundPosition:(CGPoint)pinchPosition
{
    // Determine new begin and end times.
    DataPlot* plot = [_plots firstObject];
    
    CGFloat minTime = ((DataPoint*)[plot.dataPoints firstObject]).point.x;
    CGFloat maxTime = ((DataPoint*)[plot.dataPoints lastObject]).point.x;
    
    CGFloat timePoint = viewBeginTime+pinchPosition.x/viewTimeScale;
    
    // The new times can be determined by calculating the difference between the
    // current distance to the pinch time and what it would be when scaled.
    CGFloat newBeginTime = viewBeginTime - (1/scale-1)*(timePoint-viewBeginTime);
    CGFloat newEndTime   = viewEndTime   + (1/scale-1)*(viewEndTime-timePoint);
    
    if( newBeginTime < minTime )newBeginTime = minTime;
    else if( newEndTime > maxTime ) newEndTime = maxTime;
    
    [self setViewBeginTime:newBeginTime endTime:newEndTime];
}

// ------------------------------------------------------------------------------------
- (void)tapAtPosition:(CGPoint)tapPosition
{
    CGFloat radius = 20; // TODO: make define
        
    DataPoint* dataPoint;
    
    CGPoint minPoint = CGPointMake(tapPosition.x-radius, tapPosition.y-radius);
    CGPoint maxPoint = CGPointMake(tapPosition.x+radius, tapPosition.y+radius);
    
    CGFloat minTimePoint = viewBeginTime+(minPoint.x)/viewTimeScale;
    CGFloat maxTimePoint = viewBeginTime+(maxPoint.x)/viewTimeScale;

    for( DataPlot* plot in _plots ) plot.selected = NO;
    _isPlotSelected = NO;
    
    for( DataPlot* plot in _plots )
    {
        CGFloat firstTime = ((DataPoint*)[plot.dataPoints firstObject]).point.x;
        CGFloat lastTime  = ((DataPoint*)[plot.dataPoints lastObject] ).point.x;
        
        // Rough estimate, is ok for now (TODO)
        CGFloat avgTimeStep = (lastTime-firstTime)/(CGFloat)plot.dataPoints.count;
        NSInteger minIndex = (minTimePoint<firstTime)?0:(minTimePoint-firstTime)/avgTimeStep;
        NSInteger maxIndex = MIN(plot.dataPoints.count,(maxTimePoint-firstTime)/avgTimeStep);
        
        for( NSUInteger i=minIndex; i<maxIndex; i++)
        {
            dataPoint = [plot.dataPoints objectAtIndex:i];
            
            CGFloat dx = [self getPointFromTime:dataPoint.point.x]-tapPosition.x;
            CGFloat dy = CGRectGetMidY(self.bounds)-plot.scale*dataPoint.point.y-tapPosition.y;

            CGFloat squareDistance = dx*dx+dy*dy;
    
            if( radius*radius > squareDistance )
            {
                // Plot selected
                plot.selected   = YES;
                _isPlotSelected = YES;
                break;
            }
        }
        if( plot.selected ) break;
    }
    
    [self.layer setNeedsDisplay];
}

// ------------------------------------------------------------------------------------
- (CGFloat)getPointFromTime:(CGFloat)timestamp
{
    return (timestamp-viewBeginTime)*viewTimeScale;
}

// ------------------------------------------------------------------------------------
- (void)setScale:(CGFloat)scale
{
    for( DataPlot* plot in _plots ) if( plot.selected || !_isPlotSelected  ) plot.scale *= scale;
    [self.layer setNeedsDisplay];
}


@end

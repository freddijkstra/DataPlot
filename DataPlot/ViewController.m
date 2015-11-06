//
//  ViewController.m
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    
}

// ------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createDataSet];
    
    [_dataPlotView setViewBeginTime:0 endTime:5];
    
    [_dataPlotView.layer setNeedsDisplay];
    
    //[self startTimer];
}

- (void) startTimer
{
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

// ------------------------------------------------------------------------------------
- (void) tick:(NSTimer *) timer
{
    [_dataPlotView.layer setNeedsDisplay];
}

// ------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ------------------------------------------------------------------------------------
- (void) createDataSet
{
    DataPlot* plot = [_dataPlotView createNewPlotWith:DPPlotColorRed andStyle:DPPlotStyleSolid];
    
    NSUInteger numPoints = 3600;
    
    for(NSInteger i=0; i<numPoints; i++)
    {
        [plot addDataValue:(i%100)-50 atTime:(float)i/120.0];
    }
    
    plot = [_dataPlotView createNewPlotWith:DPPlotColorBlue andStyle:DPPlotStyleDotted];
    
    for(NSInteger i=0; i<numPoints; i++)
    {
        [plot addDataValue:(i%50)-40 atTime:(float)i/120.0];
    }
    
    [_dataPlotView.layer setNeedsDisplay];
}


// ------------------------------------------------------------------------------------
- (IBAction)handlePlotPan:(UIPanGestureRecognizer *)recognizer
{
    if( [recognizer numberOfTouches] != 1 ) return;
    
    [_dataPlotView panWithTranslation:[recognizer translationInView:_dataPlotView]];
    
    // Reset the translation.
    [recognizer setTranslation:CGPointMake(0, 0) inView:_dataPlotView];
}

// ------------------------------------------------------------------------------------
- (IBAction)handlePlotPinch:(UIPinchGestureRecognizer *)recognizer
{
    if( [recognizer numberOfTouches] < 2 ) return;
    
    CGPoint firstLocation = [recognizer locationOfTouch:0 inView:_dataPlotView];
    CGPoint secondLocation = [recognizer locationOfTouch:1 inView:_dataPlotView];
    
    CGFloat dx = fabs(firstLocation.x - secondLocation.x);
    CGFloat dy = fabs(firstLocation.y - secondLocation.y);
    
    if( dx >= dy )
    {
        // Zooming.
        [_dataPlotView pinchWithScale:recognizer.scale aroundPosition:[recognizer locationInView:_dataPlotView]];
    }
    else
    {
        // Scaling.
        [_dataPlotView setScale:recognizer.scale];
    }
    
    // Reset the scaling
    [recognizer setScale:1];
}

// ------------------------------------------------------------------------------------
- (IBAction)handlePlotSelect:(UITapGestureRecognizer *)recognizer
{
    if( [recognizer numberOfTouches] != 1 ) return;
    
    [_dataPlotView tapAtPosition:[recognizer locationInView:_dataPlotView]];
}



@end

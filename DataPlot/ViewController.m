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
    
    [self startTimer];
    

}

- (void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}

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
    for(NSUInteger i; i<36000; i++)
    {
        [_dataPlotView addDataValue:i%100 atTime:(float)i/120.0];
    }
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider* slider = sender;
    
    [_dataPlotView setViewBeginTime:0 endTime:slider.value];
}

- (IBAction)dootedChanged:(id)sender
{
    UISwitch* switcher = sender;
    _dataPlotView.dotted = switcher.isOn;
}

- (IBAction)handlePlotPan:(UIPanGestureRecognizer *)recognizer
{
    
    [_dataPlotView panWithTranslation:[recognizer translationInView:_dataPlotView]];
    
    // Reset the translation.
    [recognizer setTranslation:CGPointMake(0, 0) inView:_dataPlotView];
}

@end

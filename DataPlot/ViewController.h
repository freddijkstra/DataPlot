//
//  ViewController.h
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPlotView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet DataPlotView *dataPlotView;


- (IBAction)handlePlotPan:(UIPanGestureRecognizer *)recognizer;
- (IBAction)handlePlotPinch:(UIPinchGestureRecognizer *)recognizer;

@end


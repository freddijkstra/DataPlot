//
//  DataPlotView.h
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataPlot.h"


@interface DataPlotView : UIView

@property (nonatomic, strong) NSMutableArray* plots;

// ---------------------------------------------------------------------------------
// Creates a new plot and returns the pointer.
// ---------------------------------------------------------------------------------
- (DataPlot*)createNewPlotWith:(DPPlotColor)color andStyle:(DPPlotStyle)style;


// ---------------------------------------------------------------------------------
// User interface
// ---------------------------------------------------------------------------------
- (void)panWithTranslation:(CGPoint)translation;
- (void)pinchWithScale:(CGFloat)scale aroundPosition:(CGPoint)pinchPosition;
- (void)tapAtPosition:(CGPoint)tapPosition;
- (void)setViewBeginTime:(CGFloat)beginTime endTime:(CGFloat)endTime;
- (void)setScale:(CGFloat)scale;



// ---------------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------------


// TEST

@property (nonatomic) BOOL dotted;

@end

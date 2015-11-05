//
//  Plot.h
//  DataPlot
//
//  Created by Fred Dijkstra on 05/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DataPlotFormat.h"
#import "DataPoint.h"

@interface DataPlot : NSObject

@property (nonatomic, strong) NSMutableArray* dataPoints;

@property (nonatomic) BOOL        selected;

@property (nonatomic) DPPlotStyle style;
@property (nonatomic) DPPlotColor color;
@property (nonatomic) CGFloat     scale;

- (id)initWithColor:(DPPlotColor)color andStyle:(DPPlotStyle)style;

- (void)addDataValue:(CGFloat)value atTime:(CGFloat)timestamp;

- (CGPoint)getPointAtIndex:(NSUInteger)index;

@end

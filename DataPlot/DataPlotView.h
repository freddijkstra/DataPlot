//
//  DataPlotView.h
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataPlotView : UIView


@property (nonatomic, strong) NSMutableArray* dataPoints;


// TEST

@property (nonatomic) BOOL dotted;

- (void)setViewBeginTime:(CGFloat)beginTime endTime:(CGFloat)endTime;
- (void)addDataValue:(CGFloat)value atTime:(CGFloat)timestamp;
- (void)panWithTranslation:(CGPoint)translation;




@end

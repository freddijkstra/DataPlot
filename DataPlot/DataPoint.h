//
//  DataPoint.h
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataPoint : NSObject

@property (nonatomic) CGPoint point;

- (id) initWithValue:(CGFloat)value atTime:(CGFloat)timestamp;

- (void)panWithPoints:(CGFloat)x;

@end

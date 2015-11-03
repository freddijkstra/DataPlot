//
//  DataPoint.m
//  DataPlot
//
//  Created by Fred Dijkstra on 03/11/15.
//  Copyright © 2015 Computerguided B.V. All rights reserved.
//

#import "DataPoint.h"


@implementation DataPoint

- (id) initWithValue:(CGFloat)value atTime:(CGFloat)timestamp
{
    self = [super init];
    
    _point.x = timestamp;
    _point.y = value;
    
    return self;
}

@end

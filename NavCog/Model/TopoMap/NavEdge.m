/*******************************************************************************
 * Copyright (c) 2015 Chengxiong Ruan
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *******************************************************************************/

#import "NavEdge.h"
#import "NavNode.h"
#import "TopoMap.h"
#import <AVFoundation/AVFoundation.h>

@interface NavEdge ()

@property (strong, nonatomic) KDTreeLocalization *localization;

@end

@implementation NavEdge

- (float)getOriFromNode:(NavNode *)node {
    if (node == _node1) {
        return _ori1;
    } else {
        return _ori2;
    }
}

- (NSString *)getInfoFromNode:(NavNode *)node {
    if (node == _node1) {
        return _info1;
    } else {
        return _info2;
    }
}

- (void)setLocalizationWithDataString:(NSString *)dataStr {
    _localization = [[KDTreeLocalization alloc] init];

    // sscanf is very slow so save as temp file before loading
    // https://bugs.launchpad.net/ubuntu/+source/glibc/+bug/1391510
    NSString *tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent: @"nav_edge_temp.txt"];
    NSError *error;
    [dataStr writeToFile:tempPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    [_localization initializeWithAbsolutePath:tempPath];
}

- (void)initLocalization {
    [_localization initializaState];
}

- (struct NavPoint)getCurrentPositionInEdgeUsingBeacons:(NSArray *)beacons {
    return [_localization localizeWithBeacons:beacons];
}

- (void)setLocalizationWithInstance:(KDTreeLocalization *)localization {
    _localization = localization;
}

- (NavNode *)checkValidEndNodeAtLocation:(NavLocation *)location {
    float y1 = [_node1 getYInEdgeWithID:_edgeID];
    float y2 = [_node2 getYInEdgeWithID:_edgeID];
    float start = y1 < y2 ? y1 : y2;
    float end = y1 < y2 ? y2 : y1;
    if (location.yInEdge < start) {
        return y1 < y2 ? _node1 : _node2;
    }
    if (location.yInEdge > end) {
        return y1 < y2 ? _node2 : _node1;
    }
    if (ABS(location.yInEdge - y1) < 5) {
        return _node1;
    }
    if (ABS(location.yInEdge - y2) < 5) {
        return _node1;
    }
    return nil;
}

- (NavEdge *)clone {
    NavEdge *edge = [[NavEdge alloc] init];
    edge.type = _type;
    edge.edgeID = _edgeID;
    edge.len = _len;
    edge.ori1 = _ori1;
    edge.ori2 = _ori2;
    edge.minKnnDist = _minKnnDist;
    edge.maxKnnDist = _maxKnnDist;
    edge.node1 = _node1;
    edge.node2 = _node2;
    edge.nodeID1 = _nodeID1;
    edge.nodeID2 = _nodeID2;
    edge.info1 = _info1;
    edge.info2 = _info2;
    edge.parentLayer = _parentLayer;
    [edge setLocalizationWithInstance:_localization];
    return edge;
}

@end

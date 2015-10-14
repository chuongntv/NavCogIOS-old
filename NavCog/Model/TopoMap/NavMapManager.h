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

#import <Foundation/Foundation.h>
#import "TopoMap.h"

@protocol NavMapManagerDelegate;

@interface NavMapManager : NSObject <NSURLSessionDownloadDelegate>

@property (strong, nonatomic) id <NavMapManagerDelegate> delegate;
@property NSProgress *progress;
@property NSString *loadingMapName;

+ (void)setMapManagerDelegate:(id)obj;
+ (void)updateMapList;
+ (void)loadTopoMapWithName:(NSString *)name withProgressHandler:(void (^)(long long, long long)) handler;
+ (NSArray *)getMapNameList;
+ (NSDictionary *)getMapDict;

@end

@protocol NavMapManagerDelegate <NSObject>

- (void)mapListUpdated:(NSArray *)mapList withError:(NSError *)error;
- (void)topoMapLoaded:(TopoMap *)topoMap withMapDataString:(NSString *)dataStr withError:(NSError *)error;

@end

//
//  BaseQueueController.h
//  HuiLife
//
//  Created by lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//
//  对所有网络请求队列的一个管理，一个应用可能会有多个网络请求队列，具体有哪些队列由继承自它的子类处理

#import <Foundation/Foundation.h>
#import "BaseDataHandler.h"

@interface BaseQueueController : NSObject

@property (nonatomic, strong) NSMutableDictionary *queueDict;

+ (BaseQueueController *)sharedBaseQueueController;

@end

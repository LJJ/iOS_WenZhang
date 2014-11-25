//
//  BaseSimpleQueueController.h
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//
//  一种相对简单的网络管理方式，不支持重发机制：Handler请求完数据后直接告诉Model


#import "BaseQueueController.h"

@interface BaseSimpleQueueController : BaseQueueController

+ (BaseSimpleQueueController *)sharedSimpleQueueController;

- (void)addHandler:(BaseDataHandler *)handler withUserInfo:(NSDictionary *)userInfo;

@end

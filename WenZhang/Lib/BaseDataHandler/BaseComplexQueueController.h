//
//  BaseComplexQueueController.h
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//  
//  继承自BaseQueueController
//  考虑到请求失败后的重发机制，所以增加者中模式的管理：Model的代理为AWBaseComplexQueueController，当Handler数据请求完成后，会告诉AWBaseComplexQueueController，AWBaseComplexQueueController告诉Model

#import "BaseQueueController.h"

@interface BaseComplexQueueController : BaseQueueController

+ (BaseComplexQueueController *)sharedBaseComplexQueueController;

- (void)addHandlerAndModel:(BaseDataHandler *)handler model:(id)model withUserInfo:(NSDictionary *)userInfo;

@end

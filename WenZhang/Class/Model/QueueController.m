//
//  QueueController.m
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "QueueController.h"

@interface QueueController ()

@property (nonatomic, strong) NSOperationQueue *listQueue;
@property (nonatomic, strong) NSOperationQueue *statisticalQueue;

@end

@implementation QueueController

+ (QueueController *)sharedQueueController
{
    static QueueController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QueueController alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if(self){
        self.listQueue = [[NSOperationQueue alloc] init];
        self.statisticalQueue = [[NSOperationQueue alloc] init];
        [self.queueDict setObject:_listQueue forKey:@"ListQueue"];
        [self.queueDict setObject:_statisticalQueue forKey:@"StatisticalQueue"];        
    }
    return self;
}

- (void)addHandler:(BaseDataHandler *)handler withUserInfo:(NSDictionary *)userInfo
{
    [super addHandler:handler withUserInfo:userInfo];
    
    if ([handler isKindOfClass:[BaseDataHandler class]]) {
        [_listQueue addOperation:handler.operation];
    }
}

- (void)dealloc
{
    [_listQueue cancelAllOperations];
    [_statisticalQueue cancelAllOperations];
}

@end

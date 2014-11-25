//
//  BaseQueueController.m
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "BaseQueueController.h"
#import "BaseDataHandler.h"
#import "AFHTTPRequestOperation.h"

@interface BaseQueueController ()


@end

@implementation BaseQueueController


+ (BaseQueueController *)sharedBaseQueueController
{
    static BaseQueueController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       manager = [[BaseQueueController alloc] init];        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queueDict = [NSMutableDictionary dictionary];        
    }
    return self;
}


@end

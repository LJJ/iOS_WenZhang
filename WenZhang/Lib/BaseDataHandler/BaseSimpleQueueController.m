//
//  BaseSimpleQueueController.m
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "BaseSimpleQueueController.h"
@interface BaseSimpleQueueController()
@end

@implementation BaseSimpleQueueController

#pragma mark - Single

+ (BaseSimpleQueueController *)sharedSimpleQueueController
{
    static BaseSimpleQueueController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BaseSimpleQueueController alloc] init];
    });
    
    return manager;
}
 
- (id)init
{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)addHandler:(BaseDataHandler *)handler withUserInfo:(NSDictionary *)userInfo
{
}

@end

//
//  BaseComplexQueueController.m
//  HuiLife
//
//  Created by Lockerios on 14-8-7.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "BaseComplexQueueController.h"

@interface BaseComplexQueueController ()

//存放Model和Handler之间的关系
@property (nonatomic, strong)  NSMutableDictionary *relationshipDict;

@end

@implementation BaseComplexQueueController

+ (BaseComplexQueueController *)sharedBaseComplexQueueController
{
    static BaseComplexQueueController *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BaseComplexQueueController alloc] init];
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


- (void)addHandlerAndModel:(BaseDataHandler *)handler model:(id)model withUserInfo:(NSDictionary *)userInfo
{
    
}

@end

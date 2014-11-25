//
//  BaseDataModel.m
//  HuiLife
//
//  Created by LJJ on 8/20/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "BaseDataModel.h"
@interface BaseDataModel()
@property (nonatomic, copy) BaseDataModelStartHandler startBlk;
@property (nonatomic, copy) BaseDataModelSuccessHandler successBlk;
@property (nonatomic, copy) BaseDataModelFailureHandler failBlk;
@end

@implementation BaseDataModel

- (id)init
{
    if (self = [super init]) {
        self.errorDict = [@{
                           @"system error":@"系统错误 或 无法获取的异常",
                           @"configuration error":@"配置文件错误",
                           @"sign verify failure":@"Sign签名校验失败",
                           @"user is not login":@"用户未登录"
                           } mutableCopy];
    }
    return self;
}

- (void)setStartBlock:(void(^)(BaseDataModel *model))start
{
    self.startBlk = start;
}

- (void)setCompleteBlockWithSuccess:(void(^)(BaseDataModel *model, id responseObject))success failure:(void(^)(BaseDataModel *model, NSError *error))fail
{
    self.successBlk = success;
    self.failBlk = fail;
}

@end

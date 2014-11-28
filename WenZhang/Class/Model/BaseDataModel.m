//
//  BaseDataModel.m
//  WenZhang
//
//  Created by LJJ on 11/27/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "BaseDataModel.h"
@interface BaseDataModel()
@end

@implementation BaseDataModel

- (id)init
{
    if (self = [super init]) {
        self.httpManager = [AFHTTPRequestOperationManager manager];
//        _httpManager.completionQueue = []
    }
    return self;
}

@end

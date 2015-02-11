//
//  BaseDataModel.h
//  WenZhang
//
//  Created by LJJ on 11/27/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "WebRequestUtils.h"
@class BaseDataModel;

@interface BaseDataModel : NSObject
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
@property (nonatomic, strong) NSMutableDictionary *errorDict;
@end



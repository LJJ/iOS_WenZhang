//
//  BaseDataModel.h
//  HuiLife
//
//  Created by LJJ on 8/20/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequestUtils.h"
#import "JSONKit.h"
@class BaseDataModel;

typedef enum
{
    BDMErrorNeedRequiredParameter = 5000
}BDMErrorCode;

typedef void(^BaseDataModelStartHandler)(BaseDataModel *model);
typedef void(^BaseDataModelSuccessHandler)(BaseDataModel *model, id responseObject);
typedef void(^BaseDataModelFailureHandler)(BaseDataModel *model, NSError *error);

@interface BaseDataModel : NSObject
@property (nonatomic, copy, readonly) BaseDataModelStartHandler startBlk;
@property (nonatomic, copy, readonly) BaseDataModelSuccessHandler successBlk;
@property (nonatomic, copy, readonly) BaseDataModelFailureHandler failBlk;
@property (nonatomic, strong) NSMutableDictionary *errorDict;

- (void)setStartBlock:(void(^)(BaseDataModel *model))start;

- (void)setCompleteBlockWithSuccess:(void(^)(BaseDataModel *model, id responseObject))success failure:(void(^)(BaseDataModel *model, NSError *error))fail;
@end

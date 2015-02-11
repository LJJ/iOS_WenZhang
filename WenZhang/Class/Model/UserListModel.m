//
//  UserListModel.m
//  WenZhang
//
//  Created by LJJ on 2/11/15.
//  Copyright (c) 2015 LJJ. All rights reserved.
//

#import "UserListModel.h"

@implementation UserListModel
- (void)userListGetListWithType:(UserListType)type
                       pageSize:(NSInteger) size
                      pageIndex:(NSInteger)index
                        orderBy:(NSString *)order
                       strWhere:(NSString *)where
                           success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                           failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *action;
    switch (type) {
        case UserListAll:
            action = @"ListAllAppUser";
            break;
        case UserListCensored:
            action = @"ListCheckAppUser";
            break;
        case UserListUncensored:
            action = @"ListUnCheckAppUser";
            break;
            case UserListFailCensored:
            action = @"ListNoCheckAppUser";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{
                                 @"action":action,
                                 @"pageSize":@(size),
                                 @"pageIndex":@(index),
                                 @"orderby":order,
                                 @"strWhere":where
                                 };
    
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error.userInfo setValue:@"加载失败，请重试" forKey:NSLocalizedDescriptionKey];
        failBlk(self,error);
    }];
}

- (void)UserListHandleSingleWithArticleId:(NSInteger)articleId
                                   andAction:(UserListAction)action
                                     success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                     failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *actionStr;
    switch (action) {
        case UserListActionCheck:
            actionStr = @"CheckAppUser";
            break;
        case UserListActionCheckFail:
            actionStr = @"NoCheckAppUser";
            break;
        case UserListActionDelete:
            actionStr = @"DeleteAppUser";
            break;
        case UserListActionGetDetail:
            actionStr = @"SingleAppUser";
            break;
            
        default:
            break;
    }
    
    NSDictionary *parameters = @{
                                 @"infoId":@(articleId),
                                 @"action":actionStr
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (action == UserListActionGetDetail) {
            [error.userInfo setValue:@"加载失败，请重试" forKey:NSLocalizedDescriptionKey];
        }
        else
        {
            [error.userInfo setValue:@"错做失败，请重试" forKey:NSLocalizedDescriptionKey];
        }
        failBlk(self,error);
    }];
}
@end

//
//  ArticleListModel.m
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleListModel.h"
#import "WebRequestUtils.h"

@interface ArticleListModel()
@end

@implementation ArticleListModel

- (id)init
{
    if (self = [super init]) {
//        [self.errorDict addEntriesFromDictionary:@{
//                                                   @"username is not correct":@"用户名不合法",
//                                                   @"mobile is not correct":@"手机号码不合法",
//                                                   @"password is not correct":@"登录密码不合法",
//                                                   @"passwords not match":@"两次输入的密码不匹配",
//                                                   @"username is already exists":@"用户名已存在",
//                                                   @"mobile is already exists":@"手机号码已注册",
//                                                   @"user is not exists":@"用户名不存在",
//                                                   @"nickname illegal":@"昵称不合法",
//                                                   @"nickname is exists":@"昵称已存在",
//                                                   @"login fail too much":@"连续登录失败5次\n请稍后再试",
//                                                   @"account illegal":@"您的账号或密码不正确",
//                                                   @"password illegal":@"您的账号或密码不正确",
//                                                   @"login failure":@"您的账号或密码不正确"
//                                                   }];
    }
    return self;
}

- (void)articleListGetListWithType:(ArticleListType)type
                                      pageSize:(NSInteger) size
                                     pageIndex:(NSInteger)index
                                       orderBy:(NSString *)order
                                      strWhere:(NSString *)where
                                       success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                       failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *action;
    switch (type) {
        case ArticleListAll:
            action = @"ListAll";
            break;
        case ArticleListCensored:
            action = @"ListCheck";
            break;
        case ArticleListUncensored:
            action = @"NoListCheck";
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
        failBlk(self,error);
    }];
}

- (void)articleListHandleSingleWithArticleId:(NSInteger)articleId
                                   andAction:(ArticleListAction)action
                                     success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                     failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *actionStr;
    switch (action) {
        case ArticleListActionCancelTop:
            actionStr = @"NoTop";
            break;
        case ArticleListActionCheck:
            actionStr = @"Check";
            break;
        case ArticleListActionCheckFail:
            actionStr = @"NoCheck";
            break;
        case ArticleListActionDelete:
            actionStr = @"Delete";
            break;
        case ArticleListActionGetDetail:
            actionStr = @"Single";
            break;
        case ArticleListActionTop:
            actionStr = @"Top";
            break;
            
        default:
            break;
    }
    
    NSDictionary *parameters = @{
                                 @"infold":@(articleId),
                                 @"action":actionStr
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlk(self,error);
    }];
}

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                      failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"password":password,
                                 @"action":@"CheckLogin"
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlk(self,error);
    }];
}

- (void)uploadingImage:(UIImage *)image
               success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
               failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSDictionary *parameters = @{
                                 @"action":@"UploadImg"
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1.0) name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlk(self,error);
    }];
}

@end

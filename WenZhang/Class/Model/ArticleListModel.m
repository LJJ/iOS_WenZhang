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
        [error.userInfo setValue:@"加载失败，请重试" forKey:NSLocalizedDescriptionKey];
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
                                 @"infoId":@(articleId),
                                 @"action":actionStr
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (action == ArticleListActionGetDetail) {
            [error.userInfo setValue:@"加载失败，请重试" forKey:NSLocalizedDescriptionKey];
        }
        else
        {
            [error.userInfo setValue:@"错做失败，请重试" forKey:NSLocalizedDescriptionKey];
        }
        failBlk(self,error);
    }];
}

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                      failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *errorMsg;
    if (userName.length < 1) errorMsg = @"用户名不能为空";
    else if (password.length < 1) errorMsg = @"密码不能为空";
    if(errorMsg) {
        NSError *error = [NSError errorWithDomain:@"com.ljj" code:5000 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        failBlk(self,error);
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"password":password,
                                 @"action":@"CheckLogin"
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"message"] isEqualToString:@"fail"]) {
            NSError *error = [NSError errorWithDomain:@"com.ljj" code:5001 userInfo:@{NSLocalizedDescriptionKey:@"用户名或密码错误"}];
            failBlk(self,error);
            return;
        }
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [error.userInfo setValue:@"登录失败" forKey:NSLocalizedDescriptionKey];
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
        [error.userInfo setValue:@"图片上传失败，请重试" forKey:NSLocalizedDescriptionKey];
        failBlk(self,error);
    }];
}

- (void)articleGetPagesAndModulesWithPageId:(NSInteger)pageId
                                moduleWhere:(NSString *)moduleWhere
                                    success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                    failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSDictionary *parameters = @{
                                 @"moduleWhere":moduleWhere,
                                 @"modulePageId":@(pageId),
                                 @"action":@"AllWebModule"
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlk(self,error);
    }];
}

- (void)updateArticleDataWithAction:(ArticleUpdateType)type
                             infoId:(NSInteger)infoId
                              title:(NSString *)title
                             source:(NSString *)source
                         authorName:(NSString *)authorName
                               edit:(NSString *)edit
                        redirectUrl:(NSString *)redirectUrl
                             remark:(NSString *)remark
                            created:(NSString *)created
                                top:(NSInteger)top
                         checkState:(NSInteger)checkState
                          infoValue:(NSString *)value
                             pageId:(NSInteger)pageId
                           moduleId:(NSInteger)moduleId
                            infoimg:(NSString *)img
                         infoCreate:(NSInteger)userId
                            success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                            failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk
{
    NSString *errorMsg;
    if (title.length < 1) errorMsg = @"标题不能为空";
    else if (value.length < 1) errorMsg = @"内容不能为空";
    else if (!pageId || !moduleId) errorMsg = @"请选择所属页面和模块";
    
    if(errorMsg) {
        NSError *error = [NSError errorWithDomain:@"com.ljj" code:5000 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        failBlk(self,error);
        return;
    }
    
    NSString *actionStr;
    switch (type) {
        case ArticleUpdateAdd:
            actionStr = @"Add";
            break;
        case ArticleUpdateUpdate:
            actionStr = @"Update";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{
                                 @"action":actionStr,
                                 @"infoId":@(infoId),
                                 @"infoTitle":title,
//                                 @"infoSource":source,       这些暂时可以不传
//                                 @"infoAuthorName":authorName,
//                                 @"infoEdit":edit,
//                                 @"infoRedirectUrl":redirectUrl,
//                                 @"infoRemark":remark,
//                                 @"infoCreated":created,
//                                 @"infoTop":@(top),
//                                 @"infoCheckState":@(checkState),
                                 @"infoValue":value,
                                 @"infoPageID":@(pageId),
                                 @"infoModuleID":@(moduleId),
                                 @"infoimg":img,
                                 @"infoCreateUser":@(userId)
                                 };
    [self.httpManager POST:[WebRequestUtils appRequestHost] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlk(self, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failBlk(self,error);
    }];
}

@end

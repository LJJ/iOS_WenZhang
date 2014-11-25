//
//  ArticleListModel.m
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleListModel.h"
#import "QueueController.h"
#import "ArticleListHandler.h"
#import "WebRequestUtils.h"

@interface ArticleListModel()<BaseDataHandlerDelegate, NSURLConnectionDelegate>
@property (nonatomic, strong) ArticleListHandler *handler;
@end

@implementation ArticleListModel

- (id)init
{
    if (self = [super init]) {
        self.handler = [[ArticleListHandler alloc] initWithDelegate:self];
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


- (void)articleListGetUncensoredListWithAction:(ArticleListType)type
                                      pageSize:(NSInteger) size
                                     pageIndex:(NSInteger)index
                                       orderBy:(NSString *)order
                                      strWhere:(NSString *)where
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
//    [_handler handleUserRequestParameters:parameters method:HTTP_POST];
//    [[QueueController sharedQueueController] addHandler:_handler withUserInfo:nil];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[WebRequestUtils appRequestHost]]];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//同步请求
    
}

- (void)articleListHandleSingleWithArticleId:(NSInteger)articleId
                                   andAction:(ArticleListAction)action
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
    [_handler handleUserRequestParameters:parameters method:HTTP_POST];
    [[QueueController sharedQueueController] addHandler:_handler withUserInfo:nil];
}

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
{
    NSDictionary *parameters = @{
                                 @"username":userName,
                                 @"password":password,
                                 @"action":@"CheckLogin"
                                 };
    [_handler handleUserRequestParameters:parameters method:HTTP_POST];
    [[QueueController sharedQueueController] addHandler:_handler withUserInfo:nil];
}

#pragma mark - BaseDataHandlerDelegate
- (void)handlerDidStart:(BaseDataHandler *)handler
{
    if (self.startBlk) {
        self.startBlk(self);
    }
}

- (void)handler:(BaseDataHandler *)handler didSucceedLoadWithData:(NSData *)data
{
    NSDictionary *result = [data objectFromJSONData];
        if (self.successBlk) {
            self.successBlk(self,result);
        }
//    NSDictionary *result = [data objectFromJSONData];
//    if ([result[@"err_msg"] isEqualToString:@"success"]) {
//        if (self.successBlk) {
//            self.successBlk(self,result);
//        }
//    }
//    else
//    {
//        if (self.failBlk) {
//            NSString *errorMsg = [NSString stringWithFormat:@"%@",result[@"err_msg"]];
//            if (self.errorDict[errorMsg]) {
//                errorMsg = self.errorDict[errorMsg];
//            }
//            NSError *error = [[NSError alloc] initWithDomain:@"com.ljj.HuiLife" code:[result[@"err_no"] integerValue] userInfo:[NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey]];
//            self.failBlk(self,error);
//        }
//    }
    
}

- (void)handler:(BaseDataHandler *)handler didFailLoadWithError:(NSError *)error
{
    if (self.failBlk) {
        self.failBlk(self,error);
    }
}
@end

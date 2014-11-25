//
//  ArticleListModel.h
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "BaseDataModel.h"

typedef enum
{
    ArticleListCensored,
    ArticleListUncensored,
    ArticleListAll
}ArticleListType;

typedef enum
{
    ArticleListActionCheck,
    ArticleListActionCheckFail,
    ArticleListActionTop,
    ArticleListActionCancelTop,
    ArticleListActionDelete,
    ArticleListActionGetDetail
}ArticleListAction;

@interface ArticleListModel : BaseDataModel
- (void)articleListGetUncensoredListWithAction:(ArticleListType)type
                                      pageSize:(NSInteger) size
                                     pageIndex:(NSInteger)index
                                       orderBy:(NSString *)order
                                      strWhere:(NSString *)where;

- (void)articleListHandleSingleWithArticleId:(NSInteger)articleId
                                   andAction:(ArticleListAction)action;

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password;

@end

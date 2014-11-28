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
    ArticleUpdateAdd,
    ArticleUpdateUpdate
}ArticleUpdateType;

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
- (void)articleListGetListWithType:(ArticleListType)type
                                      pageSize:(NSInteger) size
                                     pageIndex:(NSInteger)index
                                       orderBy:(NSString *)order
                                      strWhere:(NSString *)where
                                       success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                       failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;

- (void)articleListHandleSingleWithArticleId:(NSInteger)articleId
                                   andAction:(ArticleListAction)action
                                     success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                                     failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;

- (void)userLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                      failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;

- (void)uploadingImage:(UIImage *)image
                      success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                      failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;

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
                            success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                            failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;


@end

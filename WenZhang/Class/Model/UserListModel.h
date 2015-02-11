//
//  UserListModel.h
//  WenZhang
//
//  Created by LJJ on 2/11/15.
//  Copyright (c) 2015 LJJ. All rights reserved.
//

#import "BaseDataModel.h"
typedef enum
{
    UserListActionCheck,
    UserListActionCheckFail,
    UserListActionDelete,
    UserListActionGetDetail
}UserListAction;

typedef enum
{
    UserListCensored,
    UserListUncensored,
    UserListFailCensored,
    UserListAll
}UserListType;

@interface UserListModel : BaseDataModel
- (void)userListGetListWithType:(UserListType)type
                       pageSize:(NSInteger) size
                      pageIndex:(NSInteger)index
                        orderBy:(NSString *)order
                       strWhere:(NSString *)where
                        success:(void (^)(BaseDataModel *dataModel, id responseObject)) successBlk
                        failure:(void (^)(BaseDataModel *dataModel, NSError *error)) failBlk;
@end

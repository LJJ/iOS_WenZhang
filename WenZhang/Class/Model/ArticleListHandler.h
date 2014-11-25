//
//  ArticleListHandler.h
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "BaseDataHandler.h"

@interface ArticleListHandler : BaseDataHandler
- (void)handleUserRequestParameters:(NSDictionary *)parameters method:(NSString *)method;
@end

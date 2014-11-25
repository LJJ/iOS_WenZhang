//
//  ArticleListHandler.m
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleListHandler.h"
#import "QueueController.h"
#import "WebRequestUtils.h"

@implementation ArticleListHandler
- (void)handleUserRequestParameters:(NSDictionary *)parameters method:(NSString *)method
{
    NSString* url = [NSString stringWithFormat:@"%@", [WebRequestUtils appRequestHost]];
    [self prepareRequestForUrl:url method:HTTP_POST userAgent:[WebRequestUtils defaultUserAgent] parameters:parameters priority:NSOperationQueuePriorityNormal];
}
@end

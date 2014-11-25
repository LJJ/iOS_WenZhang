//
//  BaseDataHandler.h
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//
//  负责：1.组装请求接口，生成符合条件的URL 2.组装一次请求Operation 3.将请求返回的结果给Model
//  

#import "AFHTTPRequestOperation.h"

#define HTTP_POST   @"POST"
#define HTTP_GET    @"GET"

@class BaseDataHandler;

@protocol BaseDataHandlerDelegate <NSObject>

@optional
- (void)handlerDidStart:(BaseDataHandler *)handler;
- (void)handlerDidStop:(BaseDataHandler *)handler;

- (void)handler:(BaseDataHandler *)handler didSucceedLoadWithData:(NSData*)data;
- (void)handler:(BaseDataHandler *)handler didFailLoadWithError:(NSError*)error;

- (void)handler:(BaseDataHandler *)handler progressUpload:(NSNumber*)progress;
- (void)handler:(BaseDataHandler *)handler progressDownload:(NSNumber*)progress;

@end

@interface BaseDataHandler : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation *operation;
@property (nonatomic, weak) id<BaseDataHandlerDelegate> delegate;

- (instancetype)initWithDelegate:(id<BaseDataHandlerDelegate>)delegate;

- (void)prepareRequestForUrl:(NSString *)url userAgent:(NSString *)userAgent;

- (void)prepareRequestForUrl:(NSString *)url userAgent:(NSString *)userAgent priority:(NSOperationQueuePriority)priority;

- (void)prepareRequestForUrl:(NSString *)url method:(NSString *)method userAgent:(NSString *)userAgent parameters:(NSDictionary *)parameters priority:(NSOperationQueuePriority)priority;

// not cancel previous request
- (void)prepareRequestContinueForUrl:(NSString *)url method:(NSString *)method userAgent:(NSString *)userAgent parameters:(NSDictionary *)parameters priority:(NSOperationQueuePriority)priority;

// 用于指定对响应的序列化，子类可通过重写指定
- (AFHTTPResponseSerializer *)getResponseSerializer;
- (void)loadStart;
- (void)loadSuccess:(id)responseObject;
- (void)loadFail:(NSError *)error;
- (void)progressUpload:(NSNumber *)progress;
- (void)progressDownload:(NSNumber *)progress;

- (void)cancel;

@end

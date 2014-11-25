//
//  BaseDataHandler.m
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "BaseDataHandler.h"
#import "AFHTTPRequestOperationManager.h"

@interface BaseDataHandler ()

@property (nonatomic, strong) AFHTTPResponseSerializer <AFURLResponseSerialization> *responseSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

@end

@implementation BaseDataHandler

- (instancetype)initWithDelegate:(id<BaseDataHandlerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.responseSerializer = [self getResponseSerializer];
    }
    return self;
}

- (void)prepareRequestForUrl:(NSString *)url userAgent:(NSString *)userAgent
{
    [self prepareRequestForUrl:url userAgent:userAgent priority:NSOperationQueuePriorityNormal];
}

- (void)prepareRequestForUrl:(NSString *)url userAgent:(NSString *)userAgent priority:(NSOperationQueuePriority)priority
{
    [self prepareRequestForUrl:url method:HTTP_GET userAgent:userAgent parameters:nil priority:priority];
}

- (void)prepareRequestForUrl:(NSString *)url method:(NSString *)method userAgent:(NSString *)userAgent parameters:(NSDictionary *)parameters priority:(NSOperationQueuePriority)priority
{
    if (!self.responseSerializer || !self.responseSerializer) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Serializer is not complete"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"com.appwill" code:1000 userInfo:userInfo];
        [self loadFail:error];  
        return;
    }
    if (!url) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"Parameter is not complete"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"com.appwill" code:1001 userInfo:userInfo];
        [self loadFail:error];
        return;
    }
    
    [self loadStart];

    NSMutableURLRequest *request = request = [self.requestSerializer requestWithMethod:method URLString:url parameters:parameters error:nil];
    
    if (userAgent) {
        [request setAllHTTPHeaderFields:@{@"User-Agent": userAgent}];        
    }

    self.operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];    
    self.operation.responseSerializer = _responseSerializer;
    __weak BaseDataHandler *handler = self;
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [handler loadSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {      
        [handler loadFail:error];
    }];
    
    [_operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSNumber *progress = [NSNumber numberWithFloat:totalBytesWritten/bytesWritten];
        [handler progressUpload:progress];
    }];
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSNumber *progress = [NSNumber numberWithFloat:totalBytesRead/bytesRead];
        [handler progressDownload:progress];
    }];
    
    [_operation setQueuePriority:priority];
}

- (AFHTTPResponseSerializer *)getResponseSerializer
{
    return [[AFHTTPResponseSerializer alloc] init];
}

- (void)loadStart
{
    if (_delegate && [_delegate respondsToSelector:@selector(handlerDidStart:)]) {
        [_delegate handlerDidStart:self];
    }
}

- (void)loadSuccess:(id)responseObject
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handler:didSucceedLoadWithData:)]) {
        [self.delegate handler:self didSucceedLoadWithData:responseObject];
    }       
}

- (void)loadFail:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handler:didFailLoadWithError:)]) {
        [self.delegate handler:self didFailLoadWithError:error];
    } 
}

- (void)progressUpload:(NSNumber *)progress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handler:progressUpload:)]) {
        [self.delegate handler:self progressUpload:progress];
    } 
}

- (void)progressDownload:(NSNumber *)progress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(handler:progressDownload:)]) {
        [self.delegate handler:self progressDownload:progress];
    }
}

- (void)cancel
{
    [self.operation cancel];
}

@end

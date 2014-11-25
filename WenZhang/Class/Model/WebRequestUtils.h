//
//  WebRequestUtils.h
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequestUtils : NSObject

#pragma mark - network

+ (NSDictionary *)getRequiredParametersExceptSign;

+ (NSString*)appRequestHost;

+ (NSInteger)screenScale;
+ (NSLocale *)getCurrentLocale;
+ (NSString *)specificMachineModel;
//+ (NSString *)customHTTPGETParams;
//+ (NSDictionary *)customHTTPPOSTParams;
+ (NSString *)defaultUserAgent;

+ (NSString *)urlByAddCustomParamsForURL:(NSString*)strURL;
+ (NSString *)urlByAddParamsForURL:(NSString *)strURL params:(NSString *)params;

+ (NSData *)dataWithContentsOfURL:(NSURL *)url timeout:(NSTimeInterval)timeout;
+ (NSData *)dataWithContentsOfStrURL:(NSString *)strURL;


#pragma mark - File
+ (NSString *)fullPathInDocument:(NSString *)path;
+ (NSString *)fullPathInLibrary:(NSString *)path;

#pragma mark - string
+(BOOL) isValidateMobile:(NSString *)mobile;
+(BOOL) isValidatePhoneNum:(NSString *)phoneNum;
+ (NSString *)md5HashOfStr:(NSString *)str;

+ (BOOL)isValidString:(NSString *)str;

+ (NSString *)openUDID;
+ (NSString *)appName;
+ (NSString*)appVersion;
+ (void)setAppName:(NSString*)name;
+ (BOOL)isJailBroken;
+ (BOOL)isVersionSupport:(NSString *)reqSysVer;
+ (BOOL)isPad;
+ (BOOL)isLanscape;

#pragma mark - encryption
+ (NSString *)generateSignByParametersDict:(NSDictionary *)keyAndValue;
@end

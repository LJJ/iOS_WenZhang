//
//  WebRequestUtils.m
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import "WebRequestUtils.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
//#import "NSString+HTMLEncoding.h"
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#define kPublicKey @"TczAFlw@SyhYEyh*"

@implementation WebRequestUtils

#pragma mark - network

+ (NSString*)appRequestHost
{
#warning Debug here.
    return @"http://test.ngac.cn/Handler/WebInfoHandler.ashx";
    
//        return @"http://www.ngac.cn/Handler/WebInfoHandler.ashx";
}

static NSInteger scale = 0;

+ (NSInteger)screenScale
{
    if (scale > 0) {
        return scale;
    }
    
    scale = (int)[[UIScreen mainScreen] scale];
    return scale;
}

+ (NSLocale *)getCurrentLocale
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    if (languages && [languages count]>0) {
        NSString *currentLang = [languages objectAtIndex:0];
        return [[NSLocale alloc] initWithLocaleIdentifier:currentLang];
    } else {
        return [NSLocale currentLocale];
    }
}

+ (NSString *)specificMachineModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
	
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

static NSString *HTTPGETParams = nil;

+ (NSString *)customHTTPGETParams
{
    if (HTTPGETParams == nil) {
		UIDevice *device = [UIDevice currentDevice];
		NSBundle *bundle = [NSBundle mainBundle];
		NSLocale *locale = [self getCurrentLocale];
		NSString *model = [[self specificMachineModel] lowercaseString];
        
		NSString* deviceid = [@"NA" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *macaddr = @"NA";
        NSInteger timezone = [[NSTimeZone systemTimeZone] secondsFromGMT];
        NSString *phonetype = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"ipad" : @"iphone";
		HTTPGETParams = [NSString stringWithFormat:@"app=%@&v=%@&lang=%@&model=%@&osv=%@&jb=%d&as=%d&mobclix=0&deviceid=%@&macaddr=%@&openudid=%@&tz=%d&phonetype=%@&osn=%@",
						 [[WebRequestUtils appName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						 [[bundle objectForInfoDictionaryKey:@"CFBundleVersion"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						 [[locale localeIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         [model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         [[device systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						 [self isJailBroken],
						 0,
						 deviceid,
                         macaddr,
                         [OpenUDID value],
                         (int)timezone/3600,
                         phonetype,
						 [[device systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return HTTPGETParams;
}

static NSDictionary *HTTPPOSTParams = nil;

+ (NSDictionary *)customHTTPPOSTParams
{
    if (HTTPPOSTParams == nil) {
		UIDevice *device = [UIDevice currentDevice];
		NSBundle *bundle = [NSBundle mainBundle];
		NSLocale *locale = [self getCurrentLocale];
		NSString *model = [[self specificMachineModel] lowercaseString];
        
		NSString* deviceid = [@"NA" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *macaddr = @"NA";
        NSString *phonetype = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"ipad" : @"iphone";
        
        HTTPPOSTParams = [NSDictionary dictionaryWithObjects:@[[[WebRequestUtils appName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                               [[bundle objectForInfoDictionaryKey:@"CFBundleVersion"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                               [[locale localeIdentifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                               [model stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                               [[device systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                               deviceid,
                                                               macaddr,
                                                               [OpenUDID value],
                                                               phonetype,
                                                               [[device systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] forKeys:@[@"app",@"v",@"lang",@"model",@"osv",@"deviceid",@"macaddr",@"openudid",@"phonetype",@"osn"]];
    }
    
    return HTTPPOSTParams;
}

static NSString* defaultUserAgent = nil;

+ (NSString*)defaultUserAgent {
    if (defaultUserAgent==nil) {
        UIDevice *device = [UIDevice currentDevice];
        NSBundle *bundle = [NSBundle mainBundle];
        NSLocale *locale = [WebRequestUtils getCurrentLocale];
        
        defaultUserAgent = [NSString stringWithFormat:@"%@/%@ (%@; %@ %@; %@; %@; %@; %@; %@; JB_%d; AS_%d)",
                            [[WebRequestUtils appName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                            [bundle objectForInfoDictionaryKey:@"CFBundleVersion"],
                            [device model],
                            [device systemName],
                            [device systemVersion],
                            [locale localeIdentifier],
                            [WebRequestUtils specificMachineModel],
                            @"NA",
                            @"NA",
                            @"0",
                            0,
                            [WebRequestUtils isJailBroken]
                            ];
    }
    return defaultUserAgent;
}

+ (NSString *)openUDID
{
    return [OpenUDID value];
}

static NSString *APPNAME = nil;
+ (NSString *)appName
{
    if (APPNAME) {
        return APPNAME;
    }
    APPNAME = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    return APPNAME;
}

+ (void)setAppName:(NSString *)name
{
    APPNAME = name;
    HTTPGETParams = nil;
}

+ (BOOL)isJailBroken {
	NSString *filePath = @"/Applications/Cydia.app";
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		return YES;
	}
    
    FILE *f = fopen("/bin/bash", "r");
    if (f != NULL)
    {
        return YES;
    }
    fclose(f);
	
	return NO;
}

+ (BOOL)isVersionSupport:(NSString *)reqSysVer {
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	return osVersionSupported;
}

+ (NSString *)urlByAddParamsForURL:(NSString *)strURL params:(NSString *)params
{
    NSString *sep = @"&";
    if ([strURL rangeOfString:@"?"].location == NSNotFound) {
        sep = @"?";
    }
    return [NSString stringWithFormat:@"%@%@%@", strURL, sep, params];
}

+ (NSString *)urlByAddCustomParamsForURL:(NSString*)strURL
{
    NSString* params = [WebRequestUtils customHTTPGETParams];
    return [self urlByAddParamsForURL:strURL params:params];
}

+ (NSData *)dataWithContentsOfURL:(NSURL *)url timeout:(NSTimeInterval)timeout
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:timeout];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error) {
        return nil;
    }
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            return data;
        } else {
            return nil;
        }
    }
    
    return data;
}

+ (NSData *)dataWithContentsOfStrURL:(NSString *)strURL
{
    return [WebRequestUtils dataWithContentsOfURL:[NSURL URLWithString:strURL]
                                      timeout:30];
}

+ (BOOL)isPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isLanscape
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft
    || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight;
}

#pragma mark - File
+ (NSString *)fullPathInDocument:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:path];
}

+ (NSString *)fullPathInLibrary:(NSString *)path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libDir = [paths objectAtIndex:0];
    return [libDir stringByAppendingPathComponent:path];
}

#pragma mark - string
+ (NSString *)md5HashOfStr:(NSString *)str
{
    if (str) {
        const char *cStr = [str UTF8String];
		unsigned char result[CC_MD5_DIGEST_LENGTH];
        
		CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
        
		NSMutableString *md5str = [NSMutableString stringWithCapacity: 33];
		int i;
		for( i = 0; i < 16; i++ ) {
			[md5str appendFormat: @"%02x", result[i]];
		}
		return md5str;
    }
    
    return nil;
}

+ (BOOL)isValidString:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]] && [str length] > 0) {
        return YES;
    }
    
    return NO;
}

+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
//^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$

+(BOOL) isValidatePhoneNum:(NSString *)phoneNum
{
    NSString *phoneRegex = @"^(0[0-9]{2,3})?([2-9][0-9]{6,7})([0-9]{1,4})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

+ (NSString*)appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}
#pragma mark - encryption
+ (NSArray *)p_ascendingAllKeys:(NSArray *)keyArray
{
    return [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
}


+(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSString *)generateSignByParametersDict:(NSDictionary *)keyAndValue;
{
    if (!keyAndValue) {
        return nil;
    }
    NSMutableString *token = [[NSMutableString alloc] initWithCapacity:10];
    
    NSArray *allTheKeys = [self p_ascendingAllKeys:[keyAndValue allKeys]];//key升序
    
    for (NSString *keyWord in allTheKeys) {
        [token appendString:[keyAndValue objectForKey:keyWord]];
    }
    
    token = [[self md5HashOfStr:[NSString stringWithString:token]] mutableCopy];
    token = [[NSString stringWithFormat:@"%@%@",token,kPublicKey] mutableCopy];
    NSString *sign = [self md5HashOfStr:token]; //加密
    
    return sign;
}
@end

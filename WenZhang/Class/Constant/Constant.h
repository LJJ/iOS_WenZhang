//
//  Constant.h
//  HuiLife
//
//  Created by Lockerios on 14-8-14.
//  Copyright (c) 2014年 LJJ. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CONKeyUserName @"CONKeyUserName"
#define CONKeyUserAlias @"CONKeyUserAlias"
#define CONKeyUserId @"CONKeyUserId"
#define CONKeyIsLogin @"CONKeyIsLogin"
#define CONkeyPassword @"CONkeyPassword"
#define CONkeyPageAndModule @"CONkeyPageAndModule"


static NSString *const CONNotificationArticleListChanged = @"CONNotificationArticleListChanged";
static NSString *const CONNotificationSelectPageAndModule = @"CONNotificationSelectPageAndModule";

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HexColor(hexColor) [Constant getHexColor:hexColor]
#define IsPad [Constant isPad]

#define iOS8AndLater ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)

#define mainScreenWidth [UIScreen mainScreen].bounds.size.width
#define mainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface Constant : NSObject

+ (UIColor *)getHexColor:(NSString *)hexColor;
+ (BOOL)isPad;
@end

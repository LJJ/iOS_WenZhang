//
//  AppDelegate.m
//  WenZhang
//
//  Created by LJJ on 11/19/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "AppDelegate.h"
#import "ArticleListModel.h"

@interface AppDelegate ()
@property (nonatomic, strong) ArticleListModel *dataModel;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self launchConfig];
    
    //第一次打开客户端，将是否登录初始化为未登录
    if (![[NSUserDefaults standardUserDefaults] objectForKey:CONKeyIsLogin]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:CONKeyIsLogin];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - method

- (void)launchConfig
{
    self.dataModel = [[ArticleListModel alloc] init];
    [_dataModel articleGetPagesAndModulesWithPageId:0 moduleWhere:@"" success:^(BaseDataModel *dataModel, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"rows"] forKey:CONkeyPageAndModule];
        NSLog(@"success load page and module");
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        //how?
    }];
}

@end

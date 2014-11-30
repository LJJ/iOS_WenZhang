//
//  PageAndModuleTableViewController.h
//  WenZhang
//
//  Created by LJJ on 11/30/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ModuleSelectBlk)(NSString *moduleName, NSInteger moduleId, NSInteger pageId);

@interface PageAndModuleTableViewController : UITableViewController
@property (nonatomic, strong) ModuleSelectBlk selectBlk;
@end

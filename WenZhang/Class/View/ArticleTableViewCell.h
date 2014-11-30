//
//  ArticleTableViewCell.h
//  WenZhang
//
//  Created by LJJ on 11/30/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell
- (void)setArticleCellWithTitle:(NSString *)title articleContent:(NSString *)articleContent time:(NSString *)time;
@end

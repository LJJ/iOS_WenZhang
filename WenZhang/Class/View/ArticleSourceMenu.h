//
//  ArticleSourceMenu.h
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ArticleSourceMenuDelegate <NSObject>

@required
- (void)articleSourceMenuSelectSourceAtRow:(NSInteger)row;

@end

@interface ArticleSourceMenu : UIView
@property (nonatomic, weak) id<ArticleSourceMenuDelegate> delegate;
- (void)showFromPoint:(CGPoint)point inView:(UIView *)aView;
- (void)selectButtonAtRow:(NSInteger)row;
@end

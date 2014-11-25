//
//  LoadMoreFooterView.h
//  HuiLife
//
//  Created by LJJ on 9/12/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadMoreFooterView : UICollectionReusableView
- (void)footerViewStatusLoading;
- (void)footerViewStatusLastPage;
- (void)footerViewStatusNoData;
- (void)footerViewStatusFinishLoading;
- (void)footerViewShowStatus:(NSString *)title isLoading:(BOOL)isLoading;
- (void)resignFirstResponse;
- (void)footerViewShowStatus:(NSString *)title refreshMode:(BOOL)refresh addTarget:(id)target selector:(SEL)selector;
@end

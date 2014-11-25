//
//  ArticleListViewController.m
//  WenZhang
//
//  Created by LJJ on 11/21/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleListModel.h"
#import "LoadMoreFooterView.h"

@interface ArticleListViewController()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *articleTV;
@property (weak, nonatomic) IBOutlet LoadMoreFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *articleData;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (nonatomic, strong) NSDictionary *pageInfo;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSInteger currentPage;
@end

@implementation ArticleListViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isLoading = NO;
    self.articleData = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void)viewDidLoad
{
    self.dataModel = [[ArticleListModel alloc] init];
    [self p_loadMoreArticle];
}

#pragma mark - method
- (void)p_loadMoreArticle
{
    if (!_isLoading) {
        _isLoading = YES;
        [_footerView footerViewShowStatus:@"正在读取订单列表" isLoading:YES];
        __weak ArticleListViewController *tmp = self;
        [_dataModel setCompleteBlockWithSuccess:^(BaseDataModel *model, id responseObject) {
            if ([responseObject[@"rows"] isKindOfClass:[NSArray class]]) {
                [tmp.articleData addObjectsFromArray:responseObject[@"rows"]];
                [tmp.articleTV reloadData];
                if ([tmp.articleData count] <1) {
                    [tmp.footerView footerViewShowStatus:@"您目前没有订单" isLoading:NO];
                }
                else if (tmp.currentPage == [tmp.pageInfo[@"pages"] integerValue]) {
                    [tmp.footerView resignFirstResponse];
                }
                else
                {
                    [tmp.footerView footerViewStatusFinishLoading];
                    tmp.isLoading = NO;
                }
            }
        } failure:^(BaseDataModel *model, NSError *error) {
            tmp.isLoading = NO;
            [tmp.footerView footerViewShowStatus:[error.userInfo objectForKey:NSLocalizedDescriptionKey] refreshMode:YES addTarget:tmp selector:@selector(p_loadMoreArticle)];
        }];
        _currentPage ++;
        [_dataModel articleListGetUncensoredListWithAction:ArticleListAll pageSize:10 pageIndex:_currentPage orderBy:@"" strWhere:@""];
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _articleData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ArticleListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.textLabel.text = _articleData[indexPath.row][@"Info_Title"];
    return cell;
}

@end

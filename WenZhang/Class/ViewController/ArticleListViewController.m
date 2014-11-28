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
#import "ArticleDetailViewController.h"
#import "ArticleSourceMenu.h"
#import "MoreMenu.h"

@interface ArticleListViewController()<UITableViewDataSource, UITableViewDelegate, ArticleSourceMenuDelegate>
@property (weak, nonatomic) IBOutlet UITableView *articleTV;
@property (weak, nonatomic) IBOutlet LoadMoreFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *articleData;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (nonatomic, strong) NSDictionary *pageInfo;
@property (nonatomic) BOOL isLoading;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic, assign) ArticleListType listType;
@end

@implementation ArticleListViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isLoading = NO;
    self.articleData = [[NSMutableArray alloc] initWithCapacity:20];
    _listType = ArticleListAll;
}

- (void)viewDidLoad
{
    self.dataModel = [[ArticleListModel alloc] init];
    [self p_loadMoreArticle];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ArticalDetailSegue"]) {
        ((ArticleDetailViewController *)segue.destinationViewController).foldId = [_articleData[[_articleTV indexPathForSelectedRow].row][@"Info_ID"] integerValue];
    }
}

#pragma mark - method
- (void)p_loadMoreArticle
{
    if (!_isLoading) {
        _isLoading = YES;
        [_footerView footerViewShowStatus:@"正在读取订单列表" isLoading:YES];
        _currentPage ++;
        
        [_dataModel articleListGetListWithType:_listType pageSize:10 pageIndex:_currentPage orderBy:@"" strWhere:@"" success:^(BaseDataModel *dataModel, id responseObject) {
            if ([responseObject[@"rows"] isKindOfClass:[NSArray class]]) {
                [self.articleData addObjectsFromArray:responseObject[@"rows"]];
                [self.articleTV reloadData];
                if ([self.articleData count] <1) {
                    [self.footerView footerViewShowStatus:@"您目前没有订单" isLoading:NO];
                }
                else if (self.currentPage == [self.pageInfo[@"pages"] integerValue]) {
                    [self.footerView resignFirstResponse];
                }
                else
                {
                    [self.footerView footerViewStatusFinishLoading];
                    self.isLoading = NO;
                }
            }
            if ([ArticleSourceMenu sharedArticleSourceMenu].superview) {
                [[ArticleSourceMenu sharedArticleSourceMenu] removeFromSuperview];
            }
        } failure:^(BaseDataModel *dataModel, NSError *error) {
            self.isLoading = NO;
            [self.footerView footerViewShowStatus:[error.userInfo objectForKey:NSLocalizedDescriptionKey] refreshMode:YES addTarget:self selector:@selector(p_loadMoreArticle)];
        }];
    }
}

#pragma mark - actions
- (IBAction)showSourceMenu:(UIButton *)sender {
    if ([ArticleSourceMenu sharedArticleSourceMenu].superview) {
        [[ArticleSourceMenu sharedArticleSourceMenu] removeFromSuperview];
        return;
    }
    [ArticleSourceMenu showFromPoint:CGPointMake(self.view.frame.size.width/2, 70) inView:self.view];
    [ArticleSourceMenu sharedArticleSourceMenu].delegate = self;
    NSInteger row;
    switch (_listType) {
        case ArticleListAll:
            row = 0;
            break;
        case ArticleListCensored:
            row =2;
            break;
        case ArticleListUncensored:
            row = 1;
            break;
            
        default:
            break;
    }
    [[ArticleSourceMenu sharedArticleSourceMenu]  selectButtonAtRow:row];
}

- (IBAction)showMoreMenue:(UIBarButtonItem *)sender {
    if ([MoreMenu sharedMoreView].superview) {
        [[MoreMenu sharedMoreView] removeFromSuperview];
        return;
    }
    [MoreMenu showFromPoint:CGPointMake(self.view.frame.size.width-30, 70) inView:self.view];
    
    [[MoreMenu sharedMoreView].firstButton addTarget:self action:@selector(createArticle:) forControlEvents:UIControlEventTouchUpInside];
    [[MoreMenu sharedMoreView].secondButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createArticle:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"CreateSegue" sender:self];
    [[MoreMenu sharedMoreView] removeFromSuperview];
}

- (void)login:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    [[MoreMenu sharedMoreView] removeFromSuperview];
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

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _articleData.count -1) {
        [self p_loadMoreArticle];
    }
}

#pragma mark - article source menu delegate
- (void)articleSourceMenuSelectSourceAtRow:(NSInteger)row
{
    switch (row) {
        case 0:
            _listType = ArticleListAll;
            break;
        case 1:
            _listType = ArticleListUncensored;
            break;
        case 2:
            _listType = ArticleListCensored;
            break;
            
        default:
            break;
    }
    
    _isLoading = NO;
    [_articleData removeAllObjects];
    [self p_loadMoreArticle];
}

@end

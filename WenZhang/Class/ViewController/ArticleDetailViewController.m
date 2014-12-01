//
//  ArticleDetailViewController.m
//  WenZhang
//
//  Created by LJJ on 11/27/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "ArticleListModel.h"

@interface ArticleDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@end

@implementation ArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel = [[ArticleListModel alloc] init];
    [self p_loadArticleDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - method
- (void)p_loadArticleDetail
{
    [SVProgressHUD showWithStatus:@"正在读取文章"];
    [_dataModel articleListHandleSingleWithArticleId:_infoId andAction:ArticleListActionGetDetail success:^(BaseDataModel *dataModel, id responseObject) {
        _detailTextView.text = responseObject[@"Info_Value"];
        _titleLabel.text = responseObject[@"Info_Title"];
        _infoLabel.text = [NSString stringWithFormat:@"编著者：%@    %@",responseObject[@"Info_AuthorName"], [responseObject[@"Info_CreatedStr"] componentsSeparatedByString:@" "][0]];
        if ([responseObject[@"Info_Top"] boolValue]) {
            [_topBtn setTitle:@"取消置顶" forState:UIControlStateNormal];
            [_topBtn setTitleColor:RGB(172, 172, 172) forState:UIControlStateNormal];
            [_topBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 28, 10, -28)];
            [_topBtn setImage:[UIImage imageNamed:@"cancel_top.png"] forState:UIControlStateNormal];
        }
        if ([responseObject[@"Info_CheckAdvice"] isKindOfClass:[NSString class]] && [responseObject[@"Info_CheckAdvice"] isEqualToString:@"通过"]) {
            [_checkBtn setTitle:@"取消审核" forState:UIControlStateNormal];
            [_checkBtn setTitleColor:RGB(172, 172, 172) forState:UIControlStateNormal];
            [_checkBtn setImageEdgeInsets:UIEdgeInsetsMake(-10, 28, 10, -28)];
            [_checkBtn setImage:[UIImage imageNamed:@"cancel_check.png"] forState:UIControlStateNormal];
        }
        [SVProgressHUD dismiss];
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)articleAction:(ArticleListAction)method
{
    [SVProgressHUD showWithStatus:@"正在进行操作"];
    [_dataModel articleListHandleSingleWithArticleId:_infoId andAction:method success:^(BaseDataModel *dataModel, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"success %d",method]];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:CONNotificationArticleListChanged object:nil];
        [SVProgressHUD dismiss];
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

#pragma mark - action
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkArticle:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消审核"]) {
        [self articleAction:ArticleListActionCheckFail];
    }
    else [self articleAction:ArticleListActionCheck];
}

- (IBAction)topArticle:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消置顶"]) {
        [self articleAction:ArticleListActionCancelTop];
    }
    else [self articleAction:ArticleListActionTop];
}

- (IBAction)deleteArticle:(UIButton *)sender {
    [self articleAction:ArticleListActionDelete];
}



@end

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
    [_dataModel articleListHandleSingleWithArticleId:_infoId andAction:ArticleListActionGetDetail success:^(BaseDataModel *dataModel, id responseObject) {
//        _detailTextView.text = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",];
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        
    }];
}

- (void)articleAction:(ArticleListAction)method
{
    [_dataModel articleListHandleSingleWithArticleId:_infoId andAction:method success:^(BaseDataModel *dataModel, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"success %d",method]];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:CONNotificationArticleListChanged object:nil];
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"fail action"];
    }];
}

#pragma mark - action
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkArticle:(UIButton *)sender {
    [self articleAction:ArticleListActionCheck];
}

- (IBAction)topArticle:(UIButton *)sender {
    [self articleAction:ArticleListActionTop];
}

- (IBAction)deleteArticle:(UIButton *)sender {
    [self articleAction:ArticleListActionDelete];
}



@end

//
//  CreateArticleViewController.m
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "CreateArticleViewController.h"
#import "WebRequestUtils.h"
#import "ArticleListModel.h"
#import "PageAndModuleTableViewController.h"

@interface CreateArticleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectModuleBtn;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (nonatomic,strong) UIImage *willSendImage;
@property (nonatomic, strong) NSString *imgUrlStr;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;

@property (nonatomic) NSInteger pageId;
@property (nonatomic) NSInteger moduleId;
@end

@implementation CreateArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel =[[ArticleListModel alloc] init];
    _pageId = 0;
    _moduleId = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectModuleSegue"]) {
        __weak CreateArticleViewController *tmp = self;
        ((PageAndModuleTableViewController *)segue.destinationViewController).selectBlk = ^(NSString *moduleName, NSInteger moduleId, NSInteger pageId){
            [tmp.selectModuleBtn setTitle:moduleName forState:UIControlStateNormal];
            tmp.pageId = pageId;
            tmp.moduleId = moduleId;
        };
    }
}

#pragma mark - action
- (IBAction)choosePhoto:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postArticle:(UIBarButtonItem *)sender {
    if (_willSendImage) {
        [_dataModel uploadingImage:_willSendImage success:^(BaseDataModel *dataModel, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject[@"state"] isEqualToString:@"SUCCESS"]) {
                self.imgUrlStr = responseObject[@"infoimg"];
                [self p_addArticle];
            }
            
        } failure:^(BaseDataModel *dataModel, NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else
    {
        self.imgUrlStr = @"";
        [self p_addArticle];
    }
}

- (void)p_addArticle
{
    [_dataModel updateArticleDataWithAction:ArticleUpdateAdd
                                     infoId:0
                                      title:_titleTextField.text
                                     source:@""
                                 authorName:@""
                                       edit:@""
                                redirectUrl:@""
                                     remark:@""
                                    created:@""
                                        top:0
                                 checkState:0
                                  infoValue:_contentTextView.text
                                     pageId:_pageId
                                   moduleId:_moduleId
                                    infoimg:_imgUrlStr
                                 infoCreate:[[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyUserId] integerValue]
                                    success:^(BaseDataModel *dataModel, id responseObject) {
                                        [SVProgressHUD showSuccessWithStatus:@"成功添加新文章"];
                                        [self.navigationController popViewControllerAnimated:YES];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:CONNotificationArticleListChanged object:nil];
                                    }
                                    failure:^(BaseDataModel *dataModel, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                    }];
}
#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image picker delegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.willSendImage = image;
    [_selectImageButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end

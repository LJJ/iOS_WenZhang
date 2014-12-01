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

@interface CreateArticleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectModuleBtn;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (nonatomic,strong) UIImage *willSendImage;
@property (nonatomic, strong) NSString *imgUrlStr;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic) NSInteger pageId;
@property (nonatomic) NSInteger moduleId;
@end

@implementation CreateArticleViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_savePageAndModule:) name:CONNotificationSelectPageAndModule object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel =[[ArticleListModel alloc] init];
    _pageId = 0;
    _moduleId = 0;
    [self.doneBtn.layer setMasksToBounds:YES];
    [self.doneBtn.layer setCornerRadius:5];
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
//    if ([segue.identifier isEqualToString:@"SelectSegue"]) {
//        __weak CreateArticleViewController *tmp = self;
//        ((PageAndModuleTableViewController *)segue.destinationViewController).selectBlk = ^(NSString *moduleName, NSInteger moduleId, NSInteger pageId){
//            [tmp.selectModuleBtn setTitle:moduleName forState:UIControlStateNormal];
//            tmp.pageId = pageId;
//            tmp.moduleId = moduleId;
//        };
//    }
}

- (void)p_savePageAndModule:(NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    NSDictionary *info = notification.object;
    [_selectModuleBtn setTitle:[NSString stringWithFormat:@"    页面：%@    模块：%@",info[@"pageName"],info[@"moduleName"]] forState:UIControlStateNormal];
    _pageId = [info[@"pageId"] integerValue];
    _moduleId =[info[@"moduleId"] integerValue];
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
    NSString *errorMsg;
    if (_titleTextField.text.length < 1) errorMsg = @"标题不能为空";
    else if (_contentTextView.text.length < 1) errorMsg = @"内容不能为空";
    else if (!_pageId || !_moduleId) errorMsg = @"请选择所属页面和模块";
    
    if(errorMsg)
    {
        [SVProgressHUD showErrorWithStatus:errorMsg];
        return;
    }
    
    if (_willSendImage) {
        [SVProgressHUD showWithStatus:@"正在上传图片" maskType:SVProgressHUDMaskTypeClear];
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
    [SVProgressHUD showWithStatus:@"正在提交文章" maskType:SVProgressHUDMaskTypeClear];
//    NSInteger userId = 0;
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyIsLogin] boolValue]) {
//        userId =[[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyUserId] integerValue];
//    }
    [_dataModel updateArticleDataWithAction:ArticleUpdateAdd
                                     infoId:0
                                      title:_titleTextField.text
                                     source:@""
                                 authorName:[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyUserAlias]
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
                                        [self.navigationController popViewControllerAnimated:YES];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:CONNotificationArticleListChanged object:nil];
                                        [SVProgressHUD showSuccessWithStatus:@"成功添加新文章"];
                                    }
                                    failure:^(BaseDataModel *dataModel, NSError *error) {
                                        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                    }];
}

- (IBAction)done:(UIButton *)sender {
    [_contentTextView resignFirstResponder];
    sender.hidden = YES;
}


#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
            break;
    }
    
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

#pragma mark - text delegte

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _doneBtn.hidden = NO;
    if ([textView.text isEqualToString:@"输入内容"]) {
        textView.text = @"";
    }
    return YES;
}

@end

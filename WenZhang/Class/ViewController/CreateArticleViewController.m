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

@interface CreateArticleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (nonatomic,strong) UIImage *willSendImage;
@end

@implementation CreateArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataModel =[[ArticleListModel alloc] init];
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
#pragma mark - action
- (IBAction)choosePhoto:(UIButton *)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postArticle:(UIBarButtonItem *)sender {
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
    [_dataModel uploadingImage:image success:^(BaseDataModel *dataModel, id responseObject) {
        
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end

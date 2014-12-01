//
//  LoginViewController.m
//  WenZhang
//
//  Created by LJJ on 11/28/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "LoginViewController.h"
#import "ArticleListModel.h"
#import "MoreMenu.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, strong) ArticleListModel *dataModel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *loginUserBV;
@property (weak, nonatomic) IBOutlet UIView *loginPasswordBV;
@end

@implementation LoginViewController

- (void)loadView
{
    [super loadView];
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:5];
    [_backBtn.layer setMasksToBounds:YES];
    [_backBtn.layer setCornerRadius:5];
    [_loginPasswordBV.layer setMasksToBounds:YES];
    [_loginPasswordBV.layer setCornerRadius:5];
    [_loginPasswordBV.layer setBorderWidth:1];
    [_loginPasswordBV.layer setBorderColor:RGB(230, 230, 230).CGColor];
    [_loginUserBV.layer setMasksToBounds:YES];
    [_loginUserBV.layer setCornerRadius:5];
    [_loginUserBV.layer setBorderWidth:1];
    [_loginUserBV.layer setBorderColor:RGB(230, 230, 230).CGColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _userNameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:CONKeyUserName];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:CONKeyIsLogin] boolValue]) {
        _password.text = [[NSUserDefaults standardUserDefaults] objectForKey:CONkeyPassword];
    }
    
    self.dataModel = [[ArticleListModel alloc] init];
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

#pragma mark - actions
- (IBAction)login:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:_userNameTF.text forKey:CONKeyUserName];
    [_dataModel userLoginWithUserName:_userNameTF.text password:_password.text success:^(BaseDataModel *dataModel, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"message"] isEqualToString:@"success"]) {
                [self back:sender];
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:CONKeyIsLogin];
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"UserID"] forKey:CONKeyUserId];
                [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:CONkeyPassword];
                [[MoreMenu sharedMoreView].secondButton setTitle:@"注销" forState:UIControlStateNormal];
            }
        }
    } failure:^(BaseDataModel *dataModel, NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

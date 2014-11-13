//
//  UserLogonViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "UserLogonViewController.h"
#import "ColorHandler.h"
#import "MainViewController.h"
#import "UserInfoViewController.h"
#import "ForgetPasswordViewController.h"
#import "Contants.h"

@interface UserLogonViewController () {
    UIView *logonView;
    UIView *registerView;
    NSString *mainView;
    UIGestureRecognizer *tapGestureRecognizer;
    UITextField *emailTextField;
    UITextField *passwordTextField;
    UITextField *confirmPasswordTextField;
    UIButton *registerButton;
    NSInteger offset;
    BOOL accountIsValid;
    NSString *email;
    UIImageView *verifyImageView;
    NSString *userType;
}

@end

@implementation UserLogonViewController
@synthesize deviceToken = _deviceToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [ShareEngine sharedInstance].delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ShareEngine sharedInstance].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    accountIsValid = NO;
    
    [self.navigationItem setTitle:@"Welcome"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 25, 90, 90)];
    logoImageView.image = [UIImage imageNamed:@"logo_big"];
    [self.view addSubview:logoImageView];
    UIImageView *textLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 124, 40, 23)];
    textLogoView.image = [UIImage imageNamed:@"logo_text_big"];
    [self.view addSubview:textLogoView];
    /*
    UILabel *logoTextView = [[UILabel alloc] initWithFrame:CGRectMake(140, 124, 40, 20)];
    logoTextView.text = @"稀客";
    logoTextView.textAlignment = NSTextAlignmentCenter;
    logoTextView.textColor = [UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    [logoTextView setFont:[UIFont fontWithName:@"FZZhiYi-M12" size:20]];//not work?
    [self.view addSubview:logoTextView];
    */
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    [self buildLogonView];
    //[self buildRegisterView];
}

- (void)buildLogonView {
    logonView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, self.view.bounds.size.height - 160)];
    UIControl *forgotPasswordCtl = [[UIControl alloc] initWithFrame:CGRectMake(31, 168-160, 80, 30)];
    UILabel *forgotPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    forgotPasswordLabel.text = @"忘记密码？";
    [forgotPasswordLabel setFont:[UIFont systemFontOfSize:12]];
    forgotPasswordLabel.textColor = [UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    [forgotPasswordCtl addSubview:forgotPasswordLabel];
    [forgotPasswordCtl addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *underLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 191-160, 55, 0.5)];
    underLine1.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:forgotPasswordCtl];
    [logonView addSubview:underLine1];
    /*
     NSMutableAttributedString *forgotPasswordString = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
     NSRange forgotPasswordRange = {0,[forgotPasswordString length]};
     [forgotPasswordString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:forgotPasswordRange];
     [forgotPasswordString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:forgotPasswordRange];
     [forgotPasswordString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f] range:forgotPasswordRange];
     forgotPasswordLabel.attributedText = forgotPasswordString;
     [self.view addSubview:forgotPasswordLabel];
     */
    UIControl *registerCtl = [[UIControl alloc] initWithFrame:CGRectMake(259, 168-160, 40, 30)];
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    registerLabel.text = @"注册";
    [registerLabel setFont:[UIFont systemFontOfSize:12]];
    registerLabel.textColor = [UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    [registerCtl addSubview:registerLabel];
    [registerCtl addTarget:self action:@selector(changeMainView) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(259, 191-160, 24, 0.5)];
    underLine2.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:registerCtl];
    [logonView addSubview:underLine2];
    /*
     NSMutableAttributedString *logonString = [[NSMutableAttributedString alloc] initWithString:@"登录"];
     NSRange logonRange = {0,[logonString length]};
     [logonString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:logonRange];
     [logonString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:logonRange];
     [logonString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f] range:logonRange];
     logonLabel.attributedText = logonString;
     [self.view addSubview:logonLabel];
     */
    
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 220-160, 16, 10)];
    emailImageView.image = [UIImage imageNamed:@"emailImage"];
    [logonView addSubview:emailImageView];
    UIImageView *underLine3 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 240-160, 268, 0.5)];
    underLine3.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:underLine3];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(64, 220-160, 250, 15)];
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    emailTextField.font = [UIFont systemFontOfSize:15];
    emailTextField.delegate = self;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.tag = 1;
    [logonView addSubview:emailTextField];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 268-160, 16, 15)];
    passwordImageView.image = [UIImage imageNamed:@"passwordImage"];
    [logonView addSubview:passwordImageView];
    UIImageView *underLine4 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 293-160, 268, 0.5)];
    underLine4.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:underLine4];
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(64, 268-160, 250, 15)];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.tag = 2;
    [logonView addSubview:passwordTextField];
    
    UIButton *logonButton = [[UIButton alloc] initWithFrame:CGRectMake(31, 330-160, 268, 42)];
    logonButton.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonButton setTitle:@"登录" forState:UIControlStateNormal];
    [logonButton addTarget:self action:@selector(logon) forControlEvents:UIControlEventTouchUpInside];
    [logonView addSubview:logonButton];
    // will release on v1.1
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(31, 400-160, 77, 0.5)];
    leftLine.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:leftLine];

    UILabel *otherLogonLable = [[UILabel alloc] initWithFrame:CGRectMake(112, 394-160, 100, 12)];
    otherLogonLable.text = @"或从以下方式登录";
    otherLogonLable.textColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    otherLogonLable.font = [UIFont systemFontOfSize:12];
    [logonView addSubview:otherLogonLable];
    UIImageView *rightLine = [[UIImageView alloc] initWithFrame:CGRectMake(212, 400-160, 87, 0.5)];
    rightLine.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [logonView addSubview:rightLine];
    
    UIControl *WXLogonCtl = [[UIControl alloc] initWithFrame:CGRectMake(95, 428-160, 30, 24)];
    UIImageView *WXImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
    WXImageView.image = [UIImage imageNamed:@"WX_logon"];
    [WXLogonCtl addSubview:WXImageView];
    WXLogonCtl.tag = 1;
    [WXLogonCtl addTarget:self action:@selector(otherLogon:) forControlEvents:UIControlEventTouchUpInside];
    [logonView addSubview:WXLogonCtl];
    UIControl *WBLogonCtl = [[UIControl alloc] initWithFrame:CGRectMake(195, 428-160, 29, 24)];
    UIImageView *weiboImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 29, 24)];
    weiboImageView.image = [UIImage imageNamed:@"weibo_logon"];
    [WBLogonCtl addSubview:weiboImageView];
    WBLogonCtl.tag = 2;
    [WBLogonCtl addTarget:self action:@selector(otherLogon:) forControlEvents:UIControlEventTouchUpInside];
    [logonView addSubview:WBLogonCtl];
    
    mainView = @"logon";
    [self.view addSubview:logonView];
}

- (void)buildRegisterView {
    registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, self.view.bounds.size.width, self.view.bounds.size.height - 160)];
    
    UIControl *logonCtl = [[UIControl alloc] initWithFrame:CGRectMake(259, 168-160, 40, 30)];
    UILabel *logonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    logonLabel.text = @"登录";
    [logonLabel setFont:[UIFont systemFontOfSize:12]];
    logonLabel.textColor = [UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    [logonCtl addSubview:logonLabel];
    [logonCtl addTarget:self action:@selector(changeMainView) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(259, 191-160, 24, 0.5)];
    underLine2.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [registerView addSubview:logonCtl];
    [registerView addSubview:underLine2];
    /*
     NSMutableAttributedString *logonString = [[NSMutableAttributedString alloc] initWithString:@"登录"];
     NSRange logonRange = {0,[logonString length]};
     [logonString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:logonRange];
     [logonString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:logonRange];
     [logonString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0f/255.0f green:191.0f/255.0f blue:165.0f/255.0f alpha:1.0f] range:logonRange];
     logonLabel.attributedText = logonString;
     [registerView addSubview:logonLabel];
     */
    
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 220-160, 16, 10)];
    emailImageView.image = [UIImage imageNamed:@"emailImage"];
    [registerView addSubview:emailImageView];
    UIImageView *underLine3 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 240-160, 268, 0.5)];
    underLine3.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [registerView addSubview:underLine3];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(64, 220-160-3, 250, 15)];
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的邮箱" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    emailTextField.font = [UIFont systemFontOfSize:15];
    emailTextField.delegate = self;
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.tag = 3;
    [registerView addSubview:emailTextField];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 268-160, 16, 15)];
    passwordImageView.image = [UIImage imageNamed:@"passwordImage"];
    [registerView addSubview:passwordImageView];
    UIImageView *underLine4 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 288-160, 268, 0.5)];
    underLine4.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [registerView addSubview:underLine4];
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(64, 268-160, 250, 15)];
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    passwordTextField.font = [UIFont systemFontOfSize:15];
    passwordTextField.delegate = self;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.tag = 4;
    [registerView addSubview:passwordTextField];
    
    UIImageView *confirmPasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(31, 316-160, 16, 15)];
    confirmPasswordImageView.image = [UIImage imageNamed:@"passwordImage"];
    [registerView addSubview:confirmPasswordImageView];
    UIImageView *underLine5 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 336-160, 268, 0.5)];
    underLine5.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [registerView addSubview:underLine5];
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(64, 316-160, 250, 15)];
    confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请再输入您的密码" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    confirmPasswordTextField.font = [UIFont systemFontOfSize:15];
    confirmPasswordTextField.delegate = self;
    confirmPasswordTextField.secureTextEntry = YES;
    confirmPasswordTextField.tag = 5;
    [registerView addSubview:confirmPasswordTextField];

    
    registerButton = [[UIButton alloc] initWithFrame:CGRectMake(31, 378-160, 268, 42)];
    registerButton.backgroundColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    [registerButton setEnabled:NO];
    [registerView addSubview:registerButton];

    
    mainView = @"register";
    [self.view addSubview:registerView];
}

- (void)otherLogon:(UIControl *)sender {
    if (sender.tag == 1) {
        //WX
        userType = @"WX";
        [self WXLogon];
    } else if (sender.tag == 2) {
        //WB
        userType = @"WB";
        [self WBLogon];
    }
}

- (void)WXLogon {
    [[ShareEngine sharedInstance] sendAuthRequest];
}

- (void)WBLogon {
    [[ShareEngine sharedInstance] sendSSOAuthRequest];
}

- (void)didLogon:(NSString *)logonType :(NSDictionary *)userDic {
    if ([logonType isEqualToString:@"WX"]) {
        UserInfo *user = [UserInfo new];
        user.userID = [userDic valueForKey:@"unionid"];
        user.name = [userDic valueForKey:@"nickname"];
        user.photo = [self getUserPic:[userDic valueForKey:@"headimgurl"]];
        //check whether user exists on server. if yes, login app; if no, register on server
        [self checkAccount:user];
        
    } else if ([logonType isEqualToString:@"WB"]) {
        UserInfo *user = [UserInfo new];
        user.userID = [[NSString alloc] initWithFormat:@"SinaWB-%@",[userDic valueForKey:@"idstr"]];
        user.name = [userDic valueForKey:@"name"];
        if ([[userDic valueForKey:@"gender"] isEqualToString:@"m"]) {
            user.gender = @"男";
        } else {
            user.gender = @"女";
        }
        user.photo = [self getUserPic:[userDic valueForKey:@"profile_image_url"]];
        [self checkAccount:user];
    }
}

- (NSData *)getUserPic:(NSString *)URLString {
    NSData *picData;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    picData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    return picData;
}

- (void)checkAccount:(UserInfo *)user {
    NSString *verifyService = @"/services/user/checkName";
    NSString *param = [[NSString alloc] initWithFormat:@"/%@",user.userID];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST,verifyService,param];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"data"] intValue] == 0) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [self registerOther:user];// register on server
        } else {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            //login
            [self logon:user];
        }
        
    }];
    
    [sessionDataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
    

- (void)registerOther:(UserInfo *)user {
    NSString *registerService = @"/services/user/register";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,registerService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *emailString = [[NSString alloc] initWithFormat:@"username=%@",user.userID];
    NSString *passwordString = [[NSString alloc] initWithFormat:@"password=%@",@"otherLogon"];
    NSString *deviceTokenString = [[NSString alloc] initWithFormat:@"deviceToken=%@",_deviceToken];
    NSString *registerDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",emailString,passwordString,deviceTokenString];
    [request setHTTPBody:[registerDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success register on phone
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        NSString *ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            user.ID = ID;
            [self createAccount:user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"系统繁忙，请稍后尝试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];

}

- (void)registerAccount {
    userType = @"mail";
    //account verification
    if (!accountIsValid) {
        UIAlertView *accountAlertView = [[UIAlertView alloc] initWithTitle:@"创建账户" message:@"用户名可能已被占用，请换一个用户名" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [accountAlertView show];
        return;
    }
    if (![self verifyPassword]) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [passwordAlertView show];
        return;
    }
    if (![self confirmPassword]) {
        UIAlertView *confirmPasswordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不一致，请重新输入密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [confirmPasswordAlertView show];
        return;
    }
    //register on server
    NSString *registerService = @"/services/user/register";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,registerService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *emailString = [[NSString alloc] initWithFormat:@"username=%@",emailTextField.text];
    NSString *passwordString = [[NSString alloc] initWithFormat:@"password=%@",passwordTextField.text];
    NSString *deviceTokenString = [[NSString alloc] initWithFormat:@"deviceToken=%@",_deviceToken];
    NSString *registerDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",emailString,passwordString,deviceTokenString];
    [request setHTTPBody:[registerDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success register on phone
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //NSString *a = (NSString *)[dataDic valueForKey:@"data"];
        NSString *ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
        
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            UserInfo * user = [UserInfo new];
            user.userID = emailTextField.text;
            user.password = passwordTextField.text;
            user.ID = ID;
            [self createAccount:user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册账号" message:@"邮箱已被注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    
    
}


- (void)createAccount:(UserInfo *)user {
    UINavigationController *navigationController;
    if (_deviceToken) {
        user.deviceToken = _deviceToken;
    } else {
        user.deviceToken = @"";
    }
    if ([_database setUser:user]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [_database setLastUesdUser:user];
        if ([_database updateUser:user]) {
            [self updateAccountOnServer:user];
            [self uploadProfileOnServer:user];
        }
        if ([userType isEqualToString:@"mail"]) {
            UserInfoViewController *setUserViewController = [UserInfoViewController new];
            setUserViewController.database = _database;
            setUserViewController.user = user;
            navigationController = [[UINavigationController alloc] initWithRootViewController:setUserViewController];
        } else if ([userType isEqualToString:@"WX"]) {
            MainViewController *mainViewController = [MainViewController new];
            mainViewController.database = _database;
            mainViewController.user = user;
            navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        } else if ([userType isEqualToString:@"WB"]) {
            MainViewController *mainViewController = [MainViewController new];
            mainViewController.database = _database;
            mainViewController.user = user;
            navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        } else {
            return;
        }
        
        [self presentViewController:navigationController animated:YES completion:^{
            [defaults setBool:YES forKey:@"everLaunched"];
            [defaults setBool:YES forKey:@"isLogin"];
        }];
    }
}

- (void)logon:(UserInfo *)user {
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *emailString = [[NSString alloc] initWithFormat:@"username=%@",user.userID];
    NSString *passwordString = [[NSString alloc] initWithFormat:@"password=%@",@"otherLogon"];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@",emailString,passwordString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            [self loginApp:user];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)logon {
    //TODO
    if (![self isValidEmail:emailTextField.text]) {
        accountIsValid = NO;
        verifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220-160, 12, 12)];
        verifyImageView.image = [UIImage imageNamed:@"invalid"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if (![self verifyPassword]) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"设置密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [passwordAlertView show];
        return;
    }
    
    NSString *loginService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *emailString = [[NSString alloc] initWithFormat:@"username=%@",emailTextField.text];
    NSString *passwordString = [[NSString alloc] initWithFormat:@"password=%@",passwordTextField.text];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@",emailString,passwordString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            UserInfo *user = [UserInfo new];
            user.userID = emailTextField.text;
            user.password = passwordTextField.text;
            user.ID = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            user.name = [[dataDic valueForKey:@"data"] valueForKey:@"nickname"];
            [self loginApp:user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"邮箱或密码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
    
}

- (void)loginApp:(UserInfo *)user {
    if (_deviceToken) {
        user.deviceToken = _deviceToken;
    } else {
        user.deviceToken = @"";
    }
    
    if (![_database whetherUserExisted:user]) {
        [_database setUser:user];
        //DownLoad From Server
    }
    [_database setLastUesdUser:user];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.database = _database;
    mainViewController.user = user;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    [self presentViewController:navigationController animated:YES completion:^{
        [defaults setBool:YES forKey:@"isLogin"];
    }];

}

- (BOOL)verifyPassword {
    if ([passwordTextField.text length] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)confirmPassword {
    return [confirmPasswordTextField.text isEqualToString:passwordTextField.text];
}

- (void)verifyAccount {
    email = emailTextField.text;
    [registerButton setEnabled:NO];
    registerButton.backgroundColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    if (![self isValidEmail:email]) {
        accountIsValid = NO;
        verifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 220-160, 12, 12)];
        verifyImageView.image = [UIImage imageNamed:@"invalid"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册" message:@"请输入正确的邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    NSString *verifyService = @"/services/user/checkName";
    NSString *param = [[NSString alloc] initWithFormat:@"/%@",emailTextField.text];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST,verifyService,param];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
       // NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        //NSInteger cnt = [[dataDic valueForKey:@"data"] intValue];
        if ([[dataDic valueForKey:@"data"] intValue] == 0) {
            verifyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(268, 220-160, 12, 12)];
            verifyImageView.image = [UIImage imageNamed:@"valid"];
            [registerView addSubview:verifyImageView];
            accountIsValid = YES;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            registerButton.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
            [registerButton setEnabled:YES];
        } else {
            accountIsValid = NO;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册账号" message:@"邮箱已被注册" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)forgetPassword {
    ForgetPasswordViewController *forgetPasswordController = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:forgetPasswordController animated:YES];
}


- (void)updateAccountOnServer:(UserInfo *)user {
    //TODO
    NSString *updateAccountService = @"/services/user/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateAccountService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",user.ID];
    NSString *nicknameString = [[NSString alloc] initWithFormat:@"nickname=%@",user.name];
    //NSString *profileString = [[NSString alloc] initWithFormat:@"profile=%@",[self get64BasedPhoto]];
    //NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",IDString,nicknameString,profileString];
    NSString *parameterString = [[NSString alloc] initWithFormat:@"%@&%@",IDString,nicknameString];
    [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
}

- (void)uploadProfileOnServer:(UserInfo *)user {
    NSData *imgData = user.photo;
    
    NSString *uploadProfileService = @"/services/user/upload";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,uploadProfileService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    NSMutableData *body = [NSMutableData new];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[user.ID dataUsingEncoding:NSUTF8StringEncoding]];
    if (imgData) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"profile",user.name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request HTTPHeader
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@",[dataDic valueForKey:@"status"]);
            NSLog(@"%@",[[dataDic valueForKey:@"data"] valueForKey:@"nickname"]);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    [sessionDataTask resume];
}


- (void)changeMainView {
    if ([mainView isEqual:@"logon"] ) {
        [UIView animateWithDuration:0.5f animations:^{
            logonView.alpha = 0.0f;
        } completion:^(BOOL finished){
            [logonView removeFromSuperview];
            [self buildRegisterView];
            registerView.alpha = 0.0f;
            [UIView animateWithDuration:0.5f animations:^{
                registerView.alpha = 1.0f;
            }completion:^(BOOL finished){
                nil;
            }];
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            registerView.alpha = 0.0f;
        } completion:^(BOOL finished){
            [registerView removeFromSuperview];
            [self buildLogonView];
            logonView.alpha = 0.0f;
            [UIView animateWithDuration:0.5f animations:^{
                logonView.alpha = 1.0f;
            } completion:^(BOOL finished){
                nil;
            }];
        }];
    }
}

- (void)resignKeyBoard
{
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [confirmPasswordTextField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    offset = 100;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 3 && ![email isEqualToString:emailTextField.text]) {
        [self verifyAccount];
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
}


- (BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

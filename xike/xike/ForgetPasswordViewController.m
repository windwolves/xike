//
//  ForgetPasswordViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ColorHandler.h"

@interface ForgetPasswordViewController () {
    UITextField *emailTextField;
    UIGestureRecognizer *tapGestureRecognizer;
}

@end

@implementation ForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"忘记密码"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToLogon)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    UIImageView *changePasswordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-77/2, 84, 77, 90)];
    changePasswordImageView.image = [UIImage imageNamed:@"changePasswordPic"];
    [self.view addSubview:changePasswordImageView];
    
    UILabel *resetPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 307, self.view.bounds.size.width, 20)];
    resetPasswordLabel.font = [UIFont systemFontOfSize:20];
    resetPasswordLabel.textAlignment = NSTextAlignmentCenter;
    resetPasswordLabel.textColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    resetPasswordLabel.text = @"找回密码";
    [self.view addSubview:resetPasswordLabel];
    
    UILabel *explainationLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 340, self.view.bounds.size.width, 12)];
    explainationLabel1.font = [UIFont systemFontOfSize:12];
    explainationLabel1.textAlignment = NSTextAlignmentCenter;
    explainationLabel1.textColor = [ColorHandler colorWithHexString:@"#515151"];
    explainationLabel1.text = @"请输入您要找回的邮箱";
    [self.view addSubview:explainationLabel1];
    UILabel *explainationLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 355, self.view.bounds.size.width, 12)];
    explainationLabel2.font = [UIFont systemFontOfSize:12];
    explainationLabel2.textAlignment = NSTextAlignmentCenter;
    explainationLabel2.textColor = [ColorHandler colorWithHexString:@"#515151"];
    explainationLabel2.text = @"我们会将重置密码发送给您";
    [self.view addSubview:explainationLabel2];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 382, 258, 1)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 382, 1, 41)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(31, 423, 258, 1)];
    line3.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(289, 382, 1, 41)];
    line4.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(49, 397, 17, 10)];
    emailImageView.image = [UIImage imageNamed:@"emailImage"];
    [self.view addSubview:emailImageView];
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(77, 397, 150, 15)];
    emailTextField.placeholder = @"请输入您的邮箱";
    emailTextField.font = [UIFont systemFontOfSize:15];
    emailTextField.delegate = self;
    [self.view addSubview:emailTextField];
    
    UIButton *DoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(31, 435, 258, 42)];
    DoneBtn.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [DoneBtn setTintColor:[ColorHandler colorWithHexString:@"#ffffff"]];
    [DoneBtn setTitle:@"发送" forState:UIControlStateNormal];
    DoneBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [DoneBtn addTarget:self action:@selector(resetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DoneBtn];
    
}

- (void)resetPassword {
    if ([self isValidEmail:emailTextField.text]) {
        [self sendResetPassword];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码" message:@"重置密码已发送，请去注册邮箱查看并尽快更换新密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好哒", nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重置密码" message:@"请输入正确邮箱" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好哒", nil];
        [alertView show];
    }

}

- (void)sendResetPassword {
    //TODO
}

- (void)resignKeyBoard
{
    [emailTextField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)returnToLogon {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    NSInteger offset = 150;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
}

@end

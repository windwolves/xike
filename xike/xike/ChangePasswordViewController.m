//
//  ChangePasswordViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-15.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ColorHandler.h"

@interface ChangePasswordViewController () {
    UIGestureRecognizer *tapGestureRecognizer;
    UITextField *oldPwdField;
    UITextField *newPwdField;
    UITextField *confirmPwdField;
    
}

@end

@implementation ChangePasswordViewController

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
    [self.navigationItem setTitle:@"设置"];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(savePassword)];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(3, 64, self.view.bounds.size.width-6, 144)];
    whiteView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    
    UILabel *oldPwd = [[UILabel alloc] initWithFrame:CGRectMake(7, 17, 100, 15)];
    oldPwd.font = [UIFont systemFontOfSize:15];
    //oldPwd.textColor = [ColorHandler colorWithHexString:@"c7c7c7"];
    oldPwd.text = @"请输入旧密码";
    oldPwdField = [[UITextField alloc] initWithFrame:CGRectMake(107, 17, self.view.bounds.size.width-107, 15)];
    oldPwdField.font = [UIFont systemFontOfSize:12];
    oldPwdField.delegate = self;
    oldPwdField.secureTextEntry = YES;
    [whiteView addSubview:oldPwd];
    [whiteView addSubview:oldPwdField];
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48, whiteView.bounds.size.width, 0.5)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#cccccc"];
    [whiteView addSubview:line1];
    
    UILabel *newPwd = [[UILabel alloc] initWithFrame:CGRectMake(7, 65, 100, 15)];
    newPwd.font = [UIFont systemFontOfSize:15];
    //newPwd.textColor = [ColorHandler colorWithHexString:@"c7c7c7"];
    newPwd.text = @"请输入新密码";
    newPwdField = [[UITextField alloc] initWithFrame:CGRectMake(107, 65, self.view.bounds.size.width-107, 15)];
    newPwdField.font = [UIFont systemFontOfSize:12];
    newPwdField.delegate = self;
    newPwdField.secureTextEntry = YES;
    [whiteView addSubview:newPwd];
    [whiteView addSubview:newPwdField];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 96, whiteView.bounds.size.width, 0.5)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#cccccc"];
    [whiteView addSubview:line2];
    
    UILabel *confirmPwd = [[UILabel alloc] initWithFrame:CGRectMake(7, 113, 100, 15)];
    confirmPwd.font = [UIFont systemFontOfSize:15];
    //confirmPwd.textColor = [ColorHandler colorWithHexString:@"c7c7c7"];
    confirmPwd.text = @"请输入新密码";
    confirmPwdField = [[UITextField alloc] initWithFrame:CGRectMake(107, 113, self.view.bounds.size.width-107, 15)];
    confirmPwdField.font = [UIFont systemFontOfSize:12];
    confirmPwdField.delegate = self;
    confirmPwdField.secureTextEntry = YES;
    [whiteView addSubview:confirmPwd];
    [whiteView addSubview:confirmPwdField];
    
    
    [self.view addSubview:whiteView];
}

- (void)savePassword {
    if ([self verifyPassword]) {
        _user.password = newPwdField.text;
        if ([_database updateUserPassword:_user]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (BOOL)verifyPassword {
    if (![[_database getUserPassword:_user] isEqualToString:oldPwdField.text]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"旧密码错误" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];

        return NO;
    }
    if ([oldPwdField.text length] == 0 || [newPwdField.text length] == 0 || [confirmPwdField.text length] == 0) {
        return NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"密码不能为空" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
    }
    if (![self confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改密码" message:@"两次输入的新密码不匹配" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
        return NO;
    }

    return YES;
}

- (BOOL)confirmPassword {
    return [newPwdField.text isEqualToString:confirmPwdField.text];
}

- (void)resignKeyBoard {
    [oldPwdField resignFirstResponder];
    [newPwdField resignFirstResponder];
    [confirmPwdField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
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

#pragma mark UITextViewDelegate
- (void)textFieldDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)textFieldDidEndEditing:(UITextView *)textView {
    
}


@end

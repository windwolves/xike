//
//  SuggestionViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-10.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "SuggestionViewController.h"
#import "ColorHandler.h"
#import "MainViewController.h"

@interface SuggestionViewController ()

@end

#define HOST @"http://121.40.139.180:8081"

@implementation SuggestionViewController {
    UITextView *suggestionTextView;
    UIGestureRecognizer *tapGestureRecognizer;
    NSString *suggestionPlaceholderString;
}

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
    [self.navigationItem setTitle:@"意见反馈"];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    shareBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    UIView *suggestionView = [[UIView alloc] initWithFrame:CGRectMake(3, 0, 314, 303)];
    suggestionView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    
    UIImageView *border1 = [[UIImageView alloc] initWithFrame:CGRectMake(7, 28, 300, 0.5)];
    border1.backgroundColor = [UIColor blackColor];
    UIImageView *border2 = [[UIImageView alloc] initWithFrame:CGRectMake(7, 28, 0.5, 200)];
    border2.backgroundColor = [UIColor blackColor];
    UIImageView *border3 = [[UIImageView alloc] initWithFrame:CGRectMake(7, 228, 300, 0.5)];
    border3.backgroundColor = [UIColor blackColor];
    UIImageView *border4 = [[UIImageView alloc] initWithFrame:CGRectMake(307, 28, 0.5, 200)];
    border4.backgroundColor = [UIColor blackColor];
    [suggestionView addSubview:border1];
    [suggestionView addSubview:border2];
    [suggestionView addSubview:border3];
    [suggestionView addSubview:border4];
    
    suggestionTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 37, 280, 180)];
    suggestionTextView.font = [UIFont systemFontOfSize:15];
    suggestionTextView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    suggestionPlaceholderString = @"感谢您的使用，请留下您的宝贵意见哦~";
    suggestionTextView.text = suggestionPlaceholderString;
    suggestionTextView.delegate = self;
    
    [suggestionView addSubview:suggestionTextView];
    [self.view addSubview:suggestionView];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send {
    //TODO still miss sending
    
    NSString *feedbackService = @"/services/suggestion/create";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,feedbackService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *userString = [[NSString alloc] initWithFormat:@"senderId=%@",_user.ID];
    NSString *suggestionString = [[NSString alloc] initWithFormat:@"content=%@",suggestionTextView.text];
    NSString *suggestionDataString = [[NSString alloc] initWithFormat:@"%@&%@",userString,suggestionString];
    [request setHTTPBody:[suggestionDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"建议或意见" message:@"谢谢你的宝贵建议或意见！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resignKeyBoard
{
    [suggestionTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[MainViewController class]]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        
    }
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
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if ([textView.text isEqualToString:suggestionPlaceholderString]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    [textView becomeFirstResponder];

}

- (void)textViewDidEndEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
        textView.text = suggestionPlaceholderString;
    }
    [textView resignFirstResponder];

}

@end

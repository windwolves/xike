//
//  CreateGreetingCardViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CreateGreetingCardViewController.h"
#import "ColorHandler.h"
#import "FastInpuGreetingWordsViewController.h"
#import "Contants.h"
#import "PreViewController.h"

@interface CreateGreetingCardViewController ()

@end

@implementation CreateGreetingCardViewController {
    UITextView *contentTextView;
    UIGestureRecognizer *tapGestureRecognizer;
    NSString *contentPlaceholderString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    [self.navigationItem setTitle:@"制作"];
    
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClicked)];
    nextBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setRightBarButtonItem:nextBtn];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    contentPlaceholderString = @"输入祝福语(内页展示,100字以内)";
    //Create greeting card if new
    if (!_greeting) {
        [self createGreetingCard];
    }
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self buildView];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
}

- (void)createGreetingCard {
    _greeting = [GreetingInfo new];
    _greeting.senderID = _user.ID;
    _greeting.templateID = _template.ID;
    _greeting.theme = _theme;
    [self createGreetingCardOnServer];
}

- (void)buildView {
    //Content Text View  Text is at wrong position!!TODO
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(4, 4+64, self.view.bounds.size.width-8, 110)];
    contentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    contentView.layer.borderWidth = 0.5f;
    contentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(22, 10, contentView.bounds.size.width-44, contentView.bounds.size.height-20)];
    contentTextView.font = [UIFont systemFontOfSize:15];
    if (_greeting.content.length == 0) {
        contentTextView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
        contentTextView.text = contentPlaceholderString;
    } else {
        contentTextView.textColor = [ColorHandler colorWithHexString:@"#413445"];
        contentTextView.text = _greeting.content;
    }
    contentTextView.delegate = self;
    [contentView addSubview:contentTextView];
    [self.view addSubview:contentView];
    
    //Fast Input View
    UIControl *fastInputCtl = [[UIControl alloc] initWithFrame:CGRectMake(4, 120+64, self.view.bounds.size.width-8, 47)];
    fastInputCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    fastInputCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    fastInputCtl.layer.borderWidth = 0.5f;
    [fastInputCtl addTarget:self action:@selector(popFastInputForGreetingCard) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *editImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(22, 13, 22, 22)];
    editImageVIew.image = [UIImage imageNamed:@"fast_input_edit_icon"];
    [fastInputCtl addSubview:editImageVIew];
    UILabel *editLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 16, 105, 15)];
    editLabel.font = [UIFont systemFontOfSize:15];
    editLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    editLabel.text = @"快速添加祝福语";
    [fastInputCtl addSubview:editLabel];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(290, 21, 7, 13)];
    arrowImageView.image = [UIImage imageNamed:@"arrow_right"];
    [fastInputCtl addSubview:arrowImageView];
    
    [self.view addSubview:fastInputCtl];
    
}

- (void)popFastInputForGreetingCard {
    FastInpuGreetingWordsViewController *fastInputViewController = [FastInpuGreetingWordsViewController new];
    fastInputViewController.greeting = _greeting;
    fastInputViewController.delegate = self;
    [self.navigationController pushViewController:fastInputViewController animated:YES];
}

- (void)returnBtnClicked {
    self.navigationController.navigationBarHidden = YES;
    if (_greeting.content.length == 0) {
        if (_isCreate) {
            [self deleteGreetingCard:_greeting];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消创建" message:@"贺卡尚未保存，真的要离开么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }
}

- (void)nextBtnClicked {
    [self updateGreetingCardOnserver];
    PreViewController *previewController = [PreViewController new];
    previewController.greeting = _greeting;
    previewController.database = _database;
    previewController.createItem = @"GreetingCard";
    [self.navigationController pushViewController:previewController animated:YES];
    
}

- (void)deleteGreetingCard:(GreetingInfo *)greeting {
    [_database deleteGreetingCard:_greeting];
    [self deleteGreetingCardFromServer];
}

- (void)deleteGreetingCardFromServer {
    NSString *deleteGreetingCardService = @"/services/greetingCard/delete/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST,deleteGreetingCardService,_greeting.uuid];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            
        } else {
            //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"邮箱或密码不正确" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            //[alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)createGreetingCardOnServer {
    NSString *createGreetingCardService = @"/services/greetingCard";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,createGreetingCardService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *hostIdString = [[NSString alloc] initWithFormat:@"publisherId=%@",_user.ID];
    NSString *templateIdString = [[NSString alloc] initWithFormat:@"templateId=%@",_greeting.templateID];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@",hostIdString,templateIdString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            _greeting.uuid = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            [_database insertGreetingCard:_greeting :_user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器创建活动失败" message:@"请重新尝试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)updateGreetingCardOnserver {
    //TODO
    NSString *updateGreetingCardService = @"/services/greetingCard/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateGreetingCardService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",_greeting.uuid];
    NSString *contentString = [[NSString alloc] initWithFormat:@"content=%@",_greeting.content];
    NSString *templateString = [[NSString alloc] initWithFormat:@"templateId=%@",_greeting.templateID];
    
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",IDString,contentString,templateString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma FastInputViewDelegate
- (void)done:(NSString *)content {
    _greeting.content = content;
    [self nextBtnClicked];
}

#pragma AlertViewDelegate
//AlertView Action
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            //when user did cancel creating this new event
            if (_isCreate) {
                [self deleteGreetingCard:_greeting];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    if ([textView.text isEqualToString:contentPlaceholderString]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
        textView.text = contentPlaceholderString;
        _greeting.content = @"";
    } else {
        _greeting.content = textView.text;
    }
    [textView resignFirstResponder];
}

- (void)resignKeyBoard
{
    [contentTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

@end

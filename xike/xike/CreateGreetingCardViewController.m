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
#import <CommonCrypto/CommonDigest.h>

#define viewWidth self.view.bounds.size.width
#define viewHeight self.view.bounds.size.height

@interface CreateGreetingCardViewController ()

@end

@implementation CreateGreetingCardViewController {
    UITextView *contentTextView;
    UIGestureRecognizer *tapGestureRecognizer;
    NSString *contentPlaceholderString;
    UIView *navigationBar;
    ImageControl *returnBtn;
    ImageControl *doneBtn;
    UITextField *receieverTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];//[ColorHandler colorWithHexString:@"#f3f3f3"];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    /*
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
    */
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    contentPlaceholderString = @"输入祝福语(内页展示,100字以内)";
    
    //Create greeting card if new
    if (!_greeting) {
        [self createGreetingCard];
    }
    [self buildView];
//    [self buildView_v2];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [self buildNavigationBar];
    
}


- (void)buildNavigationBar {
    if (navigationBar) {
        [navigationBar removeFromSuperview];
    } else {
        navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 64)];
        navigationBar.backgroundColor= [ColorHandler colorWithHexString:@"#1de9b6"];
        [self.view addSubview:navigationBar];
        
        returnBtn = [[ImageControl alloc] initWithFrame:CGRectMake(10, 23, 43, 38)];
        returnBtn.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 43, 18)];
        returnBtn.imageView.image = [UIImage imageNamed:@"return_icon"];
        [returnBtn addSubview:returnBtn.imageView];
        [returnBtn addTarget:self action:@selector(returnToPreviousView) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:returnBtn];
        
        doneBtn = [[ImageControl alloc] initWithFrame:CGRectMake(viewWidth-53, 23, 43, 38)];
        doneBtn.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 43, 18)];
        doneBtn.imageView.image = [UIImage imageNamed:@"go_to_preview"];
        [doneBtn addSubview:doneBtn.imageView];
        [doneBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:doneBtn];
                
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-39)/2, 33, 39, 18)];
        titleView.image = [UIImage imageNamed:@"produce_title"];
        [navigationBar addSubview:titleView];
    }
    [self.view addSubview:navigationBar];
}

- (void)returnToPreviousView {
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

- (void)createGreetingCard {
    _greeting = [GreetingInfo new];
    _greeting.senderID = _user.ID;
    _greeting.templateID = _template.ID;
    _greeting.template = [_database getTemplateWithName:_template.name];
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

- (void)buildView_v2 {
    UIImageView *receieveLabelView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 14+64, 45, 13)];
    receieveLabelView.image = [UIImage imageNamed:@"receiever_label"];
    [self.view addSubview:receieveLabelView];
    
    receieverTextField = [[UITextField alloc] initWithFrame:CGRectMake(7, 40+64, 306, 45)];
    receieverTextField.font = [UIFont systemFontOfSize:15];
    receieverTextField.textColor = [ColorHandler colorWithHexString:@"#413445"];
    if (_receiever && [_receiever length] != 0) {
        receieverTextField.text = _receiever;
    } else {
        receieverTextField.text = @"亲爱的 ";
    }
    CAShapeLayer *receieverTextFieldBorder = [self drawDashBorderWith:receieverTextField.bounds :0 :1.5 :[UIColor blackColor]];
    [receieverTextField.layer addSublayer:receieverTextFieldBorder];
    [self.view addSubview:receieverTextField];
    
    UIImageView *greetingWordLableView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 114+64, 45, 13)];
    greetingWordLableView.image = [UIImage imageNamed:@"greeting_word_label"];
    [self.view addSubview:greetingWordLableView];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(7, 140+64, 306, 95)];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.textColor = [ColorHandler colorWithHexString:@"#413445"];
    if (_greeting.content.length == 0) {
        contentTextView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
        contentTextView.text = contentPlaceholderString;
    } else {
        contentTextView.textColor = [ColorHandler colorWithHexString:@"#413445"];
        contentTextView.text = _greeting.content;
    }
    contentTextView.delegate = self;
    CAShapeLayer *contentTextViewBorder = [self drawDashBorderWith:contentTextView.bounds :0 :1.5 :[UIColor blackColor]];
    [contentTextView.layer addSublayer:contentTextViewBorder];
    [self.view addSubview:contentTextView];
    
    //Fast Input View
    UIControl *fastInputCtl = [[UIControl alloc] initWithFrame:CGRectMake(7, 250+64, viewWidth-14, 47)];
    fastInputCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    CAShapeLayer *fastInputViewBorder =  [self drawDashBorderWith:fastInputCtl.bounds :0 :1.5 :[UIColor blackColor]];
    [fastInputCtl.layer addSublayer:fastInputViewBorder];
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
    [self setGreetingCardContent:contentTextView];
    FastInpuGreetingWordsViewController *fastInputViewController = [FastInpuGreetingWordsViewController new];
    fastInputViewController.greeting = _greeting;
    fastInputViewController.delegate = self;
    [self.navigationController pushViewController:fastInputViewController animated:YES];
}

- (void)nextBtnClicked {
    [self setGreetingCardContent:contentTextView];
    [self updateGreetingCardOnserver];
    PreViewController *previewController = [PreViewController new];
    previewController.greeting = _greeting;
    previewController.database = _database;
    previewController.user = _user;
    previewController.createItem = @"GreetingCard";
    [self.navigationController pushViewController:previewController animated:YES];
    
}

- (void)setGreetingCardContent:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = contentPlaceholderString;
        _greeting.content = @"";
    } else if ([textView.text isEqualToString:contentPlaceholderString]) {
        _greeting.content = @"";
    } else {
        _greeting.content = textView.text;
    }
}

- (void)deleteGreetingCard:(GreetingInfo *)greeting {
    [_database deleteGreetingCard:_greeting];
    [self deleteGreetingCardFromServer];
}

- (NSString *)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (void)deleteGreetingCardFromServer {
    
    NSString *deleteGreetingCardService = @"/services/entity/";
    NSString *IDString = [[NSString alloc] initWithFormat:@"%@?",_greeting.uuid];
    NSString *authString = [[NSString alloc] initWithFormat:@"_username=%@&_password=%@",_user.userID,[self md5HexDigest:[_database getUserPassword:_user]]];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@%@",HOST_2,deleteGreetingCardService,IDString,authString];
    //    NSString *authString = [[NSString alloc] initWithFormat:@"_username=%@&_password=%@",@"admin",[self md5HexDigest:@"admin"]];
    //    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@%@",tmpHost,deleteGreetingCardService,IDString,authString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"DELETE"];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //[dic setValue:@"delete" forKey:@"_method"];
    
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
//    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            _greeting.uuid = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            //[_database insertGreetingCard:_greeting :_user];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)createGreetingCardOnServer {
    NSString *createGreetingCardService = @"/services/entity?";
    NSString *authString = [[NSString alloc] initWithFormat:@"_username=%@&_password=%@",_user.userID,[self md5HexDigest:[_database getUserPassword:_user]]];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST_2,createGreetingCardService,authString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];

    NSString *typeString = [[NSString alloc] initWithFormat:@"type=%@",@"greeting-card"];
    NSString *templateIdString = [[NSString alloc] initWithFormat:@"category=%@",_greeting.template.name];
    NSString *titleString = [[NSString alloc] initWithFormat:@"title=%@",[_greeting.theme isEqualToString:@"Valentine"]?@"情人节快乐!":@"新春快乐!"];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",typeString,templateIdString,titleString];
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
//            NSString *code = [dataDic valueForKey:@"code"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器创建活动失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)updateGreetingCardOnserver {
    //TODO
    NSString *updateGreetingCardService = @"/services/entity/";
    NSString *IDString = [[NSString alloc] initWithFormat:@"%@?",_greeting.uuid];
//    NSString *authString = [[NSString alloc] initWithFormat:@"_username=%@&_password=%@",@"admin",[self md5HexDigest:@"admin"]];
//    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@%@",tmpHost,updateGreetingCardService,IDString,authString];
    
    NSString *authString = [[NSString alloc] initWithFormat:@"_username=%@&_password=%@",_user.userID,[self md5HexDigest:[_database getUserPassword:_user]]];
//    NSString *templateIdString = [[NSString alloc] initWithFormat:@"category=%@",_greeting.template.name];
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@%@",HOST_2,updateGreetingCardService,IDString,authString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    NSMutableDictionary *dic = [NSMutableDictionary new];

    [dic setValue:@"greeting-card" forKey:@"type"];
    [dic setValue:_greeting.template.name forKey:@"category"];
//    NSString *a = [_greeting.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [dic setValue:_greeting.content forKey:@"content"];
    
    NSError *err;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    //    NSString *bodyString = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            _greeting.uuid = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
//            [_database insertGreetingCard:_greeting :_user];
            [_database updateGreetingCard:_greeting];
        }
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
    if ([content length] != 0) {
        contentTextView.text = content;
    }
    [self nextBtnClicked];
}

- (void)returnWithWord:(NSString *)word {
    if ([word length] != 0) {
        contentTextView.text = word;
    }
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


- (CAShapeLayer *)drawDashBorderWith:(CGRect)frame :(CGFloat)cornerRadius :(CGFloat)borderWidth :(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    //creating a path
    CGMutablePathRef path = CGPathCreateMutable();
    
    //drawing a border around a view
    CGPathMoveToPoint(path, NULL, 0, frame.size.height - cornerRadius);
    CGPathAddLineToPoint(path, NULL, 0, cornerRadius);
    CGPathAddArc(path, NULL, cornerRadius, cornerRadius, cornerRadius, M_PI, -M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width - cornerRadius, 0);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, cornerRadius, cornerRadius, -M_PI_2, 0, NO);
    CGPathAddLineToPoint(path, NULL, frame.size.width, frame.size.height - cornerRadius);
    CGPathAddArc(path, NULL, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, M_PI_2, NO);
    CGPathAddLineToPoint(path, NULL, cornerRadius, frame.size.height);
    CGPathAddArc(path, NULL, cornerRadius, frame.size.height - cornerRadius, cornerRadius, M_PI_2, M_PI, NO);
    
    //path is set as the shapeLayer object's path
    shapeLayer.path = path;
    CGPathRelease(path);
    
    shapeLayer.backgroundColor = [[UIColor clearColor] CGColor];
    shapeLayer.frame = frame;
    shapeLayer.masksToBounds = NO;
    [shapeLayer setValue:[NSNumber numberWithBool:NO] forKey:@"isCircle"];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.strokeColor = [lineColor CGColor];
    shapeLayer.lineWidth = borderWidth;
    shapeLayer.lineDashPattern = [NSArray arrayWithObjects: [NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil];
    shapeLayer.lineCap = kCALineCapButt;
    
    return shapeLayer;
}

@end

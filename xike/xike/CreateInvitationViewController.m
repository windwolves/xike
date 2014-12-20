//
//  CreateInvitationViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CreateInvitationViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "SetInvitationLocationViewController.h"
#import "SetInvitationDateViewController.h"
#import "PreViewController.h"


@interface CreateInvitationViewController ()

@end

@implementation CreateInvitationViewController {
    UIView *contentView;
    UIControl *locationView;
    UIControl *timeView;
    UIView *participateView;
    UITextView *contentTextView;
    UILabel *locationlabel;
    UILabel *timeLabel;
    UILabel *participateLabel;
    UIGestureRecognizer *tapGestureRecognizer;
    NSString *placeHolderString;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [self setEventInView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationItem setTitle:@"制作"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    doneBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    placeHolderString = @"输入你的活动内容(限100字)";
    
    //default setting
    if (!_event) {
        [self createEvent];
    }
    
    [self buildView];
}

- (void)buildView {
    //content
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(4, 4+64, self.view.bounds.size.width-8, 110)];
    contentTextView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    contentTextView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    contentTextView.layer.borderWidth = 0.5f;
    contentTextView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.text = placeHolderString;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
    
    //time
    timeView = [[UIControl alloc] initWithFrame:CGRectMake(4, 118+64, self.view.bounds.size.width-8, 47)];
    timeView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    timeView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    timeView.layer.borderWidth = 0.5f;
    [timeView addTarget:self action:@selector(editTime) forControlEvents:UIControlEventTouchUpInside];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 16, 200, 15)];
    timeLabel.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.text = @"输入活动时间";
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(26, 15, 22, 23)];
    [timeIcon setImage:[UIImage imageNamed:@"create_invitation_time_icon"]];
    UIImageView *arrowTimeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(294, 16, 7, 13)];
    [arrowTimeIcon setImage:[UIImage imageNamed:@"arrow_right"]];
    
    [timeView addSubview:timeLabel];
    [timeView addSubview:timeIcon];
    [timeView addSubview:arrowTimeIcon];
    [self.view addSubview:timeView];
    
    //location
    locationView = [[UIControl alloc] initWithFrame:CGRectMake(4, 164.5+64, self.view.bounds.size.width-8, 47)];
    locationView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    locationView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    locationView.layer.borderWidth = 0.5f;
    [locationView addTarget:self action:@selector(editLocation) forControlEvents:UIControlEventTouchUpInside];
    locationlabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 16, 200, 15)];
    locationlabel.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
    locationlabel.font = [UIFont systemFontOfSize:15];
    locationlabel.text = @"输入活动地点";
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(26, 15, 22, 22)];
    [locationIcon setImage:[UIImage imageNamed:@"create_invitation_location_icon"]];
    UIImageView *arrowLocationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(294, 16, 7, 13)];
    [arrowLocationIcon setImage:[UIImage imageNamed:@"arrow_right"]];
    
    [locationView addSubview:locationlabel];
    [locationView addSubview:locationIcon];
    [locationView addSubview:arrowLocationIcon];
    [self.view addSubview:locationView];
    
    //participate
    participateView = [[UIView alloc] initWithFrame:CGRectMake(4, 217+64, self.view.bounds.size.width-8, 47)];
    participateView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    participateView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    participateView.layer.borderWidth = 0.5f;
    participateLabel = [[UILabel alloc] initWithFrame:CGRectMake(57, 16, 60, 15)];
    participateLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    participateLabel.font = [UIFont systemFontOfSize:15];
    participateLabel.text = @"显示成员";
    UIImageView *participateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(26, 15, 22, 23)];
    [participateIcon setImage:[UIImage imageNamed:@"create_invitation_participate_icon"]];
    UISwitch *participateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(253, 10, 50, 35)];
    [participateSwitch setOnTintColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
    [participateSwitch setOn:YES];
    [participateView addSubview:participateSwitch];
    
    [participateView addSubview:participateLabel];
    [participateView addSubview:participateIcon];
    [self.view addSubview:participateView];
    
}

- (void)setEventInView {
    if (_event.content.length != 0) {
        contentTextView.text = _event.content;
    }
    if (_event.date.length !=0) {
        NSString *dateString = [self getFormatDateStringWith:_event.date];
        NSString *timeString = [self getFormatTimeStringWith:_event.time];
        timeLabel.text = [[NSString alloc] initWithFormat:@"%@   %@",dateString,timeString];
    }
    if (_event.location.length != 0) {
        locationlabel.text = _event.location;
    }
}

- (void)createEvent {
    _event = [EventInfo new];
    _event.user = _user;
    _event.template = [_database getTemplate:_template.ID];
    _event.templateID = _event.template.ID;
    [self createEventOnServer];//fetch and set the uuid
}

- (void)editTime {
    SetInvitationDateViewController *setDateViewController = [SetInvitationDateViewController new];
    setDateViewController.delegate = self;
    setDateViewController.event = _event;
    [self.navigationController pushViewController:setDateViewController animated:YES];
}

- (void)editLocation {
    SetInvitationLocationViewController *setLocationViewController = [SetInvitationLocationViewController new];
    setLocationViewController.delegate = self;
    setLocationViewController.location = _event.location;
    [self.navigationController pushViewController:setLocationViewController animated:YES];
}

- (void)done {
    //save event
    PreViewController *previewController = [PreViewController new];
    previewController.event = _event;
    previewController.database = _database;
    previewController.createItem = @"Invitation";
    [self updateEventOnserver];
    [self.navigationController pushViewController:previewController animated:YES];
}

- (void)returnToPreviousView {
    if (_event.content.length == 0 && _event.location.length == 0 && _event.date.length == 0) {
        if (_isCreate) {
            [self deleteEvent:_event];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消创建" message:@"活动尚未保存，真的要离开么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 2;
        [alertView show];
    }
    
}

- (void)deleteEvent:(EventInfo *)event {
    [_database deleteEvent:_event];
    [self deleteEventFromServer:_event];
}

- (void)deleteEventFromServer:(EventInfo *)event {
    NSString *deleteEventService = @"/services/activity/delete/";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@%@",HOST,deleteEventService,_event.uuid];
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

- (void)createEventOnServer {
    NSString *createEventService = @"/services/activity";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,createEventService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *hostIdString = [[NSString alloc] initWithFormat:@"hostId=%@",_user.ID];
    NSString *templateIdString = [[NSString alloc] initWithFormat:@"templateId=%@",_event.templateID];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@",hostIdString,templateIdString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login //need response
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            _event.uuid = [[dataDic valueForKey:@"data"] valueForKey:@"id"];
            _event.templateID = [[dataDic valueForKey:@"data"] valueForKey:@"templateId"];
            [_database createEvent:_event :_user];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"服务器创建活动失败" message:@"请重新尝试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
    }];
    
    [sessionDataTask resume];
}

- (void)updateEventOnserver {
    //TODO
    NSString *updateEventService = @"/services/activity/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateEventService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",_event.uuid];
    NSString *contentString = [[NSString alloc] initWithFormat:@"content=%@",_event.content];
    NSString *timeString = [[NSString alloc] initWithFormat:@"time=%@",[self generateTimeStringWithEvent:_event]];
    NSString *locationString = [[NSString alloc] initWithFormat:@"place=%@",_event.location];
    NSString *templateString = [[NSString alloc] initWithFormat:@"templateId=%@",_event.templateID];
    
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@&%@&%@",IDString,contentString,timeString,locationString,templateString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [sessionDataTask resume];
}

- (NSString *)generateTimeStringWithEvent:(EventInfo *)event {
    NSString *timeString;
    if (event.date.length == 8) {
        NSString *YYYY = [event.date substringWithRange:NSMakeRange(0, 4)];
        NSString *MM = [_event.date substringWithRange:NSMakeRange(4, 2)];
        NSString *DD = [_event.date substringWithRange:NSMakeRange(6, 2)];
        timeString = [[NSString alloc] initWithFormat:@"%@/%@/%@ %@",YYYY,MM,DD,event.time];
    } else {
        timeString = @"";
    }
    return timeString;
}

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
                [self deleteEvent:_event];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    if ([textView.text isEqualToString:placeHolderString]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _event.content = textView.text;
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
        textView.text = placeHolderString;
        _event.content = @"";
        [textView resignFirstResponder];
    }
}

- (void)resignKeyBoard
{
    [contentTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

#pragma mark SetLocationViewControllerDelegate
- (void)didFinishSetLocation:(NSString *)location {
    if (location.length != 0) {
        locationlabel.text = location;
    }
    _event.location = location;
}

#pragma mark SetLocationViewControllerDelegate
- (void)didFinishSetDate:(EventInfo *)event {
    NSString *dateString = [self getFormatDateStringWith:_event.date];
    NSString *timeString = [self getFormatTimeStringWith:_event.time];
    timeLabel.text = [[NSString alloc] initWithFormat:@"%@   %@",dateString,timeString];
}

- (NSString *)getFormatTimeStringWith:(NSString *)HHMMSS {
    NSString *HH = [HHMMSS substringWithRange:NSMakeRange(0, 2)];
    NSString *MM = [HHMMSS substringWithRange:NSMakeRange(3, 2)];
    NSString *formateTimeString = [[NSString alloc] initWithFormat:@"%@:%@",HH,MM];
    return formateTimeString;
}

- (NSString *)getFormatDateStringWith:(NSString *)YYYYMMDD {
    NSString *YYYY = [YYYYMMDD substringWithRange:NSMakeRange(0, 4)];
    NSString *MM = [YYYYMMDD substringWithRange:NSMakeRange(4, 2)];
    NSString *DD = [YYYYMMDD substringWithRange:NSMakeRange(6, 2)];
    NSString *formatDateString = [[NSString alloc] initWithFormat:@"%@年%@月%@日",YYYY,MM,DD];
    return formatDateString;
}

@end

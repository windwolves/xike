//
//  CreateNewEventViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "CreateNewEventViewController.h"
#import "ColorHandler.h"
#import "ImageControl.h"
#import "CanlendarView.h"
#import "ChooseTemplateViewController.h"
#import "Contants.h"

@interface CreateNewEventViewController ()

@end

@implementation CreateNewEventViewController {
    NSInteger flag;
    BOOL isInitial;
    BOOL isInitialRemove;
    UIGestureRecognizer *tapGestureRecognizer;
    UIView *contentView;
    UIView *themeView;
    UIView *timeView;
    UIView *locationView;
    UIView *datePickerView;
    UIView *timePickerView;
    UITextView *themeContentTextView;
    UITextView *locationTextView;
    NSString *themePlaceholderString;
    NSString *locationPlaceholderString;
    NSString *yearString;
    NSString *hourString;
    NSString *minuteString;
    UIImageView *themeContentImageView;
    UIImageView *locationContentImageView;
    UILabel *yearLabel;
    UILabel *limitationLable1;
    UILabel *limitationLable3;
    NSDateComponents *month;
    NSDateComponents *currentDate;
    UIPickerView *timePicker;
    NSMutableArray *hoursArray;
    NSMutableArray *minutesArray;
    NSIndexPath *previousIndexPath;
    NSIndexPath *currentIndexPath;
    ImageControl *themeCtl;
    ImageControl *timeCtl;
    ImageControl *locationCtl;
    ImageControl *dateLabelCtl;
    ImageControl *timeLabelCtl;
    CanlendarView *daysView;
    MonthHeaderView *monthHeaderView;
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
    [self.navigationItem setTitle:@"编辑文本"];
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    doneBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    
    //default setting
    if (!_event) {
        [self createEvent];
    }
    flag = 1;
    isInitial = YES;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    currentDate = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
    yearString = [[self getDateDictionary:[NSDate date]] objectForKey:@"year"];
    
    //Controller
    themeCtl = [[ImageControl alloc] initWithFrame:CGRectMake(36, 12, 74, 43)];
    themeCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theme_off"] highlightedImage:[UIImage imageNamed:@"theme_on"]];
    [themeCtl.imageView setFrame:CGRectMake(1, 0, 23, 23)];
    themeCtl.imageView.highlighted = YES;
    UILabel *themeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 24, 12)];
    themeLabel.font = [UIFont systemFontOfSize:12];
    themeLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    themeLabel.text = @"主题";
    [themeCtl addSubview:themeCtl.imageView];
    [themeCtl addSubview:themeLabel];
    themeCtl.tag = 1;
    [themeCtl addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:themeCtl];
    
    timeCtl = [[ImageControl alloc] initWithFrame:CGRectMake(148, 12, 74, 43)];
    timeCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"time_off"] highlightedImage:[UIImage imageNamed:@"time_on"]];
    timeCtl.imageView.frame = CGRectMake(1, 0, 23, 23);
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 24, 12)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    timeLabel.text = @"时间";
    [timeCtl addSubview:timeCtl.imageView];
    [timeCtl addSubview:timeLabel];
    timeCtl.tag = 2;
    [timeCtl addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:timeCtl];
    
    locationCtl = [[ImageControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-56, 12, 74, 43)];
    locationCtl.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_off"] highlightedImage:[UIImage imageNamed:@"location_on"]];
    locationCtl.imageView.frame = CGRectMake(1, 0, 23, 23);
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 24, 12)];
    locationLabel.font = [UIFont systemFontOfSize:12];
    locationLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    locationLabel.text = @"地点";
    [locationCtl addSubview:locationCtl.imageView];
    [locationCtl addSubview:locationLabel];
    locationCtl.tag = 3;
    [locationCtl addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationCtl];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 58, self.view.bounds.size.width, self.view.bounds.size.height-58)];
    
    [self buildContentView];
    
    [self.view addSubview:contentView];
}

- (void)buildContentView {
    //flag = 1
    themeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    [self buildThemeView];
    // flag = 2
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    [self buildTimeView];
    //flag = 3
    locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    [self buildLocationView];
    //default flag is 1
    [contentView addSubview:themeView];
}

- (void)buildThemeView {
    themeContentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 115)];
    themeContentImageView.image = [UIImage imageNamed:@"themeContent"];
    [themeView addSubview:themeContentImageView];
    themeContentTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 23, themeContentImageView.bounds.size.width-16, 72)];
    themeContentTextView.font = [UIFont systemFontOfSize:15];
    themeContentTextView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    themePlaceholderString = @"请输入主题信息";
    if (_event.content.length == 0) {
        themeContentTextView.text = themePlaceholderString;
    } else {
        themeContentTextView.text = _event.content;
    }
    themeContentTextView.tag = 1;
    themeContentTextView.delegate = self;
    [themeView addSubview:themeContentTextView];
    limitationLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, themeContentImageView.bounds.size.width-8, 12)];
    limitationLable1.font = [UIFont systemFontOfSize:11];
    limitationLable1.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    limitationLable1.textAlignment = NSTextAlignmentRight;
    limitationLable1.text = @"字数不超过100";
    [themeView addSubview:limitationLable1];
}

- (void)createEvent {
    _event = [EventInfo new];
    _event.user = _user;
    [self createEventOnServer];//fetch and set the uuid
    _event.template = [_database getTemplate:@"544331a9-e6e5-41c1-9212-6fcf6f3b3ebc"];
    _event.templateID = _event.template.ID;
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
    NSString *templateIdString = [[NSString alloc] initWithFormat:@"templateId=%@",@"544331a9-e6e5-41c1-9212-6fcf6f3b3ebc"];
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
- (void)buildTimeView {
    //canlendar View
    //DatePicker
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    UIView *canlendarContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 330)];
    canlendarContentView.layer.contents = (__bridge id)([UIImage imageNamed:@"canlendarContent"].CGImage);
    //Year
    yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, 50, 12)];
    yearLabel.font = [UIFont systemFontOfSize:12];
    yearLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    yearLabel.text = [[NSString alloc] initWithFormat:@"%@年",yearString];
    [canlendarContentView addSubview:yearLabel];
    //Month
    monthHeaderView = [[MonthHeaderView alloc] initWithFrame:CGRectMake(0, 60, 300, 30)];
    monthHeaderView.dataSource = self;
    monthHeaderView.delegate = self;
    //monthHeaderView.backgroundColor = [UIColor redColor];
    [canlendarContentView addSubview:monthHeaderView];
    //Day
    float const labelWidth = canlendarContentView.bounds.size.width/7;
    float const labelHeight = 12;
    UILabel *sundayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 113, labelWidth, labelHeight)];
    sundayLabel.font = [UIFont systemFontOfSize:10];
    sundayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    sundayLabel.textAlignment = NSTextAlignmentCenter;
    sundayLabel.text = @"日";
    [canlendarContentView addSubview:sundayLabel];
    UILabel *mondayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 113, labelWidth, labelHeight)];
    mondayLabel.font = [UIFont systemFontOfSize:10];
    mondayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    mondayLabel.textAlignment = NSTextAlignmentCenter;
    mondayLabel.text = @"一";
    [canlendarContentView addSubview:mondayLabel];
    UILabel *tuesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*2, 113, labelWidth, labelHeight)];
    tuesdayLabel.font = [UIFont systemFontOfSize:10];
    tuesdayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    tuesdayLabel.textAlignment = NSTextAlignmentCenter;
    tuesdayLabel.text = @"二";
    [canlendarContentView addSubview:tuesdayLabel];
    UILabel *wednesdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*3, 113, labelWidth, labelHeight)];
    wednesdayLabel.font = [UIFont systemFontOfSize:10];
    wednesdayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    wednesdayLabel.textAlignment = NSTextAlignmentCenter;
    wednesdayLabel.text = @"三";
    [canlendarContentView addSubview:wednesdayLabel];
    UILabel *thursdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*4, 113, labelWidth, labelHeight)];
    thursdayLabel.font = [UIFont systemFontOfSize:10];
    thursdayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    thursdayLabel.textAlignment = NSTextAlignmentCenter;
    thursdayLabel.text = @"四";
    [canlendarContentView addSubview:thursdayLabel];
    UILabel *fridayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*5, 113, labelWidth, labelHeight)];
    fridayLabel.font = [UIFont systemFontOfSize:10];
    fridayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    fridayLabel.textAlignment = NSTextAlignmentCenter;
    fridayLabel.text = @"五";
    [canlendarContentView addSubview:fridayLabel];
    UILabel *saturdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth*6, 113, labelWidth, labelHeight)];
    saturdayLabel.font = [UIFont systemFontOfSize:10];
    saturdayLabel.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    saturdayLabel.textAlignment = NSTextAlignmentCenter;
    saturdayLabel.text = @"六";
    [canlendarContentView addSubview:saturdayLabel];

    month = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
    daysView = [[CanlendarView alloc] initWithFrame:CGRectMake(0, 127, canlendarContentView.bounds.size.width, canlendarContentView.bounds.size.height-127) withMonth:month];
    daysView.backgroundColor = [UIColor clearColor];
    daysView.delegate = self;
    [canlendarContentView addSubview:daysView];
    [datePickerView addSubview:canlendarContentView];
    
    timeLabelCtl = [[ImageControl alloc] initWithFrame:CGRectMake(10, 338, 300, 50)];
    timeLabelCtl.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, timeLabelCtl.bounds.size.width, timeLabelCtl.bounds.size.height)];
    timeLabelCtl.imageView.image = [UIImage imageNamed:@"timeLabel"];
    timeLabelCtl.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, timeLabelCtl.bounds.size.width, timeLabelCtl.bounds.size.height)];
    timeLabelCtl.label.font = [UIFont systemFontOfSize:36];
    timeLabelCtl.label.textAlignment = NSTextAlignmentCenter;
    timeLabelCtl.label.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"HH:mm"];
    timeLabelCtl.label.text = [dateFormatter stringFromDate:[NSDate date]];
    [timeLabelCtl addSubview:timeLabelCtl.imageView];
    [timeLabelCtl addSubview:timeLabelCtl.label];
    [timeLabelCtl addTarget:self action:@selector(refineDateView) forControlEvents:UIControlEventTouchUpInside];
    [datePickerView addSubview:timeLabelCtl];
    
    //TimePicker
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, contentView.bounds.size.height)];
    dateLabelCtl = [[ImageControl alloc] initWithFrame:CGRectMake(10, 0, 300, 57)];
    dateLabelCtl.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dateLabelCtl.bounds.size.width, dateLabelCtl.bounds.size.height)];
    dateLabelCtl.imageView.image = [UIImage imageNamed:@"dateLabel"];
    dateLabelCtl.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dateLabelCtl.bounds.size.width, dateLabelCtl.bounds.size.height)];
    dateLabelCtl.label.font = [UIFont systemFontOfSize:18];
    dateLabelCtl.label.textAlignment = NSTextAlignmentCenter;
    dateLabelCtl.label.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    dateLabelCtl.label.text = _event.date;
    [dateLabelCtl addSubview:dateLabelCtl.imageView];
    [dateLabelCtl addSubview:dateLabelCtl.label];
    [dateLabelCtl addTarget:self action:@selector(goToDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *timeContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 65, 300, 160)];
    timeContentView.layer.contents = (__bridge id)([UIImage imageNamed:@"timeContent"].CGImage);

    //timePicker = [[CustomTimePickerView alloc] initWithFrame:CGRectMake(0, 0, 148, 120)];
    
    //[timeContentView addSubview:timePicker];
   
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    timePicker.delegate = self;
    timePicker.dataSource = self;

    [timeContentView addSubview:timePicker];
    
    [timePickerView addSubview:timeContentView];
    [timePickerView addSubview:dateLabelCtl];
    
    
    
    
    //default
    [timeView addSubview:datePickerView];
}

- (void)buildLocationView {
    locationContentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 300, 115)];
    locationContentImageView.image = [UIImage imageNamed:@"locationContent"];
    [locationView addSubview:locationContentImageView];
    locationTextView = [[UITextView alloc] initWithFrame:CGRectMake(18, 23, locationContentImageView.bounds.size.width-16, 72)];
    locationTextView.font = [UIFont systemFontOfSize:15];
    locationTextView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    locationPlaceholderString = @"请输入地址";
    if (_event.location.length == 0) {
        locationTextView.text = locationPlaceholderString;
    } else {
        locationTextView.text = _event.location;
    }
    locationTextView.tag = 3;
    locationTextView.delegate = self;
    [locationView addSubview:locationTextView];
    limitationLable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, locationContentImageView.bounds.size.width-8, 12)];
    limitationLable3.font = [UIFont systemFontOfSize:11];
    limitationLable3.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    limitationLable3.textAlignment = NSTextAlignmentRight;
    limitationLable3.text = @"字数不超过100";
    [locationView addSubview:limitationLable3];
}

- (void)showWordsLimitation {
    //TODO
}

- (NSDictionary *)getDateDictionary:(NSDate *)date {
    NSMutableDictionary *dateDic = [NSMutableDictionary new];
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *dc = [currentCalendar components:unitFlags fromDate:date];
    NSInteger year = [dc year];
    NSInteger mon = [dc month];
    NSInteger day = [dc day];
    
    [dateDic setValue:[[NSString alloc] initWithFormat:@"%d",year] forKey:@"year"];
    if (mon < 10) {
        [dateDic setValue:[[NSString alloc] initWithFormat:@"0%d",mon] forKey:@"month"];
    } else {
        [dateDic setValue:[[NSString alloc] initWithFormat:@"%d",mon] forKey:@"month"];
    }
    if (day < 10) {
        [dateDic setValue:[[NSString alloc] initWithFormat:@"0%d",day] forKey:@"day"];
    } else {
        [dateDic setValue:[[NSString alloc] initWithFormat:@"%d",day] forKey:@"day"];
    }
    return dateDic;
}

- (void)goToDatePicker:(ImageControl *)sender {
    [self restoreDateView];
}

- (void)goToTimePicker:(ImageControl *)sender {
    [self refineDateView];
}

- (void)changeContent:(UIControl *)sender {
    if (sender.tag == 1) {
        if (flag == 1) {
            return;
        } else {
            [locationView removeFromSuperview];
            [timeView removeFromSuperview];
            [contentView addSubview:themeView];
            
            themeCtl.imageView.highlighted = YES;
            timeCtl.imageView.highlighted = NO;
            locationCtl.imageView.highlighted = NO;
            flag = 1;
            
        }
    } else if (sender.tag == 2) {
        if (flag == 2) {
            return;
        } else {
            [themeView removeFromSuperview];
            [locationView removeFromSuperview];
            [contentView addSubview:timeView];
            
            themeCtl.imageView.highlighted = NO;
            timeCtl.imageView.highlighted = YES;
            locationCtl.imageView.highlighted = NO;
            
            flag = 2;
        }
    } else if (sender.tag ==3) {
        if (flag == 3) {
            return;
        } else {
            [themeView removeFromSuperview];
            [timeView removeFromSuperview];
            [contentView addSubview:locationView];
            
            themeCtl.imageView.highlighted = NO;
            timeCtl.imageView.highlighted = NO;
            locationCtl.imageView.highlighted = YES;
            
            flag = 3;
        }
    }
}

- (void)done {
    if (daysView.dateSelected.length > 0) {
        _event.date = daysView.dateSelected;
    } else {
        NSString *YYYY = [[self getDateDictionary:[NSDate date]] objectForKey:@"year"];
        NSString *MM = [[self getDateDictionary:[NSDate date]] objectForKey:@"month"];
        NSString *DD = [[self getDateDictionary:[NSDate date]] objectForKey:@"day"];
        
        
        _event.date = [[NSString alloc] initWithFormat:@"%@%@%@",YYYY,MM,DD];
    }
    if (hourString&&minuteString) {
        _event.time = [[NSString alloc] initWithFormat:@"%@:%@:00",hourString,minuteString];
    } else {
        _event.time = @"00:00:00";
    }
    
    ChooseTemplateViewController *chooseTemplateViewController = [ChooseTemplateViewController new];
    chooseTemplateViewController.database = _database;
    chooseTemplateViewController.event = _event;
    [self.navigationController pushViewController:chooseTemplateViewController animated:YES];
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

- (void)resignKeyBoard
{
    [themeContentTextView resignFirstResponder];
    [locationTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getFormatDateStringWith:(NSString *)YYYYMMDD {
    NSString *YYYY = [YYYYMMDD substringWithRange:NSMakeRange(0, 4)];
    NSString *MM = [YYYYMMDD substringWithRange:NSMakeRange(4, 2)];
    NSString *DD = [YYYYMMDD substringWithRange:NSMakeRange(6, 2)];
    NSString *formatDateString = [[NSString alloc] initWithFormat:@"%@年%@月%@日",YYYY,MM,DD];
    return formatDateString;
}

#pragma mark - MonthHeaderViewDelegate
- (void)selector:(MonthHeaderView *)valueSelector didSelectRowAtIndex:(NSIndexPath *)indexPath {
    NSInteger currentMonth = (indexPath.row+[currentDate month])%12;
    if (currentMonth == 0) {
        currentMonth = 12;
    }
    NSLog(@"Selected month %d",currentMonth);
    if (!isInitialRemove) {
        //remove initial highlight
        NSIndexPath *initialIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *initialCell = [monthHeaderView.table cellForRowAtIndexPath:initialIndexPath];
        
        [[initialCell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *initialCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, monthHeaderView.bounds.size.width/7, monthHeaderView.frame.size.height)];
        initialCellLabel.text = [NSString stringWithFormat:@"%d",[currentDate month]];
        initialCellLabel.font = [UIFont systemFontOfSize:12];
        initialCellLabel.textAlignment =  NSTextAlignmentCenter;
        initialCellLabel.backgroundColor = [UIColor clearColor];
        initialCellLabel.textColor = [UIColor blackColor];
        [initialCell.contentView addSubview:initialCellLabel];
        initialCell.contentView.backgroundColor = [UIColor whiteColor];
        isInitialRemove = YES;
    }
    
    
    if (previousIndexPath) {
        //remove previous highlight
        NSInteger previousMonth = (previousIndexPath.row+[currentDate month])%12;
        if (previousMonth == 0) {
            previousMonth = 12;
        }
        UITableViewCell *previousCell = [monthHeaderView.table cellForRowAtIndexPath:previousIndexPath];
        [[previousCell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UILabel *previousCellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, monthHeaderView.bounds.size.width/7, monthHeaderView.frame.size.height)];
        previousCellLabel.text = [NSString stringWithFormat:@"%d",previousMonth];
        previousCellLabel.font = [UIFont systemFontOfSize:12];
        previousCellLabel.textAlignment =  NSTextAlignmentCenter;
        previousCellLabel.backgroundColor = [UIColor clearColor];
        previousCellLabel.textColor = [UIColor blackColor];
        [previousCell.contentView addSubview:previousCellLabel];
        previousCell.contentView.backgroundColor = [UIColor whiteColor];
    }
    //highlight
    UITableViewCell *selectedCell = [monthHeaderView.table cellForRowAtIndexPath:indexPath];
    //remove the current lable and replace with the new one.
    [[selectedCell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    selectedCell.contentView.backgroundColor = [UIColor whiteColor];

    UILabel *selectedCellLabel = [[UILabel alloc] initWithFrame:CGRectMake((monthHeaderView.bounds.size.width/7 - 30)/2, 0, 30, monthHeaderView.frame.size.height)];
    selectedCellLabel.text = [NSString stringWithFormat:@"%d月",currentMonth];
    selectedCellLabel.font = [UIFont systemFontOfSize:12];
    selectedCellLabel.textAlignment =  NSTextAlignmentCenter;
    selectedCellLabel.textColor = [UIColor whiteColor];
    selectedCellLabel.layer.cornerRadius = selectedCellLabel.bounds.size.height/2;
    selectedCellLabel.layer.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"].CGColor;

    [selectedCell.contentView addSubview:selectedCellLabel];
    
    previousIndexPath = indexPath;
    //reset the year label
    NSInteger additionYear = (indexPath.row + [currentDate month]-1)/12;
    yearLabel.text = [[NSString alloc] initWithFormat:@"%d年",([currentDate year]+additionYear)];
    //reset the daysView
    month = [currentDate copy];
    [month setMonth:currentMonth];
    [month setYear:[currentDate year]+additionYear];
    daysView.month = month;
    [daysView createDaysButton];
    
}


#pragma mark - MonthHeaderViewDataSource
- (NSInteger)numberOfRowsInSelector:(MonthHeaderView *)valueSelector {
    return 12*100;//return 50 years to make user regard this scroll view as a loop.
}

- (CGFloat)rowWidthInSelector:(MonthHeaderView *)valueSelector {
    return 300*1000/7; //To keep 3 decimal digits (0.001)
}

- (UIView *)selector:(MonthHeaderView *)valueSelector viewForRowAtIndex:(NSInteger)index {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, monthHeaderView.bounds.size.width/7, monthHeaderView.frame.size.height)];
    NSInteger indexMonth = (index+[currentDate month])%12;
    if (indexMonth == 0) {
        indexMonth = 12;
    }
    if (index == 0 && isInitial) {
        label.frame = CGRectMake((monthHeaderView.bounds.size.width/7 - 30)/2, 0, 30, 30);
        label.text = [NSString stringWithFormat:@"%d月",indexMonth];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment =  NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = label.bounds.size.height/2;
        label.layer.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"].CGColor;
        isInitial = NO;
        isInitialRemove = NO;
        return label;
    }
    label.text = [NSString stringWithFormat:@"%d",indexMonth];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment =  NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    return label;
}

- (CGRect)rectForSelectionInSelector:(MonthHeaderView *)valueSelector {
    //Just return a rect in which you want the selector image to appear
    //Use the IZValueSelector coordinates
    //Basically the x will be 0
    //y will be the origin of your image
    //width and height will be the same as in your selector image
    float const a = 300*1000/7;
    return CGRectMake(0, 0, a/1000, 30.0);
}

#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        hourString = [hoursArray objectAtIndex:row%24];
    } else {
        minuteString = [minutesArray objectAtIndex:row%60];
    }
}

#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 100, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[ColorHandler colorWithHexString:@"#1de9b6"]];
        [pickerLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
    hoursArray = [NSMutableArray new];
    for (int i = 0; i < 24; i++) {
        [hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    
    minutesArray = [NSMutableArray new];
    for (int i = 0; i < 60; i++) {
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    if (component == 0) {
        pickerLabel.text =  [hoursArray objectAtIndex:row%24];
    } else if (component == 1) {
        pickerLabel.text =  [minutesArray objectAtIndex:row%60];
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) { // hour
        return 2400;
    }
    else { // min
        return 6000;
    }
}


#pragma CanlendarViewDelegate
- (void)refineDateView {
    NSDateFormatter *formatter = [NSDateFormatter new];
    //set date label
    if (daysView.dateSelected) {
        dateLabelCtl.label.text = [self getFormatDateStringWith:daysView.dateSelected];
    } else {
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        dateLabelCtl.label.text = [formatter stringFromDate:[NSDate date]];
    }
    _event.date = daysView.dateSelected;//set event date
    [datePickerView removeFromSuperview];
    
    //set default time before the time picker view shows
    if (_event.time.length != 0) {
        hourString = [_event.time substringWithRange:NSMakeRange(0, 2)];
        minuteString = [_event.time substringWithRange:NSMakeRange(3, 2)];
        [timePicker selectRow:[hourString integerValue]+24*50 inComponent:0 animated:YES];
        [timePicker selectRow:[minuteString integerValue]+60*50 inComponent:1 animated:YES];
    } else {
        [formatter setDateFormat:@"HH"];
        [timePicker selectRow:[[formatter stringFromDate:[NSDate date]] integerValue]+24*50 inComponent:0 animated:YES];
        hourString = [formatter stringFromDate:[NSDate date]];
        [formatter setDateFormat:@"mm"];
        [timePicker selectRow:[[formatter stringFromDate:[NSDate date]] integerValue]+60*50 inComponent:1 animated:YES];
        minuteString = [formatter stringFromDate:[NSDate date]];
    }
    
    [timeView addSubview:timePickerView];
}


- (void)restoreDateView {
    [timePickerView removeFromSuperview];
    timeLabelCtl.label.text = [[NSString alloc] initWithFormat:@"%@:%@",hourString,minuteString];
    _event.time = [[NSString alloc] initWithFormat:@"%@:%@:00",hourString,minuteString];//set event time
    [timeView addSubview:datePickerView];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    if (textView.tag == 1) {
        if ([textView.text isEqualToString:themePlaceholderString]) {
            textView.textColor = [UIColor blackColor];
            textView.text = @"";
        }
        [textView becomeFirstResponder];
    } else if (textView.tag == 3) {
        if ([textView.text isEqualToString:locationPlaceholderString]) {
            textView.textColor = [UIColor blackColor];
            textView.text = @"";
        }
        [textView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 1) {
        if ([textView.text isEqualToString:@""]) {
            textView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
            textView.text = themePlaceholderString;
            _event.content = @"";
        } else {
            _event.content = textView.text;
        }
        
        [textView resignFirstResponder];
    } else if (textView.tag == 3) {
        if ([textView.text isEqualToString:@""]) {
            textView.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
            textView.text = locationPlaceholderString;
            _event.location = @"";
        } else {
            _event.location = textView.text;
        }
        [textView resignFirstResponder];
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

@end

//
//  SetInvitationDateViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "SetInvitationDateViewController.h"
#import "ColorHandler.h"
#import "ImageControl.h"

@interface SetInvitationDateViewController ()

@end

@implementation SetInvitationDateViewController {
    BOOL isInitial;
    BOOL isInitialRemove;
    UIView *timeView;
    UIView *datePickerView;
    UIView *timePickerView;
    NSString *yearString;
    NSString *hourString;
    NSString *minuteString;
    UILabel *yearLabel;
    UILabel *limitationLable1;
    UILabel *limitationLable3;
    NSDateComponents *month;
    NSDateComponents *currentDate;
    UIPickerView *timePicker;
    NSMutableArray *hoursArray;
    NSMutableArray *minutesArray;
    ImageControl *dateLabelCtl;
    ImageControl *timeLabelCtl;
    NSIndexPath *previousIndexPath;
    NSIndexPath *currentIndexPath;
    CanlendarView *daysView;
    MonthHeaderView *monthHeaderView;
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"地点标注"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    returnBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    doneBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    
    currentDate = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSCalendarCalendarUnit fromDate:[NSDate date]];
    yearString = [[self getDateDictionary:[NSDate date]] objectForKey:@"year"];
    [self buildView];
}

- (void)buildView {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 47)];
    titleView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    titleView.layer.borderWidth = 0.5f;
    titleView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 15, 60, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
    titleLabel.text = @"选择时间";
    [titleView addSubview:titleLabel];
    [self.view addSubview:titleView];
    
    
    timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 51+64, self.view.bounds.size.width, self.view.bounds.size.height-51)];
    //canlendar View
    //DatePicker
    datePickerView = [[UIView alloc] initWithFrame:timeView.bounds];
    UIView *canlendarContentView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, timeView.bounds.size.width-8, 320)];
    canlendarContentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    canlendarContentView.layer.borderWidth = 0.5f;
    canlendarContentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
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
    timeLabelCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    timeLabelCtl.layer.borderWidth = 0.5f;
    timeLabelCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    timeLabelCtl.label = [[UILabel alloc] initWithFrame:timeLabelCtl.bounds];
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
    timePickerView = [[UIView alloc] initWithFrame:timeView.bounds];
    dateLabelCtl = [[ImageControl alloc] initWithFrame:CGRectMake(4, 0, self.view.bounds.size.width-8, 50)];
    dateLabelCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    dateLabelCtl.layer.borderWidth = 0.5f;
    dateLabelCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    dateLabelCtl.label = [[UILabel alloc] initWithFrame:dateLabelCtl.bounds];
    dateLabelCtl.label.font = [UIFont systemFontOfSize:20];
    dateLabelCtl.label.textAlignment = NSTextAlignmentCenter;
    dateLabelCtl.label.textColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    dateLabelCtl.label.text = _event.date;
    [dateLabelCtl addSubview:dateLabelCtl.imageView];
    [dateLabelCtl addSubview:dateLabelCtl.label];
    [dateLabelCtl addTarget:self action:@selector(goToDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *timeContentView = [[UIView alloc] initWithFrame:CGRectMake(4, 65, self.view.bounds.size.width-8, 160)];
    timeContentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    timeContentView.layer.borderWidth = 0.5f;
    timeContentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 160)];
    timePicker.delegate = self;
    timePicker.dataSource = self;
    
    [timeContentView addSubview:timePicker];
    
    [timePickerView addSubview:timeContentView];
    [timePickerView addSubview:dateLabelCtl];
    
    //default
    [timeView addSubview:datePickerView];
    [self.view addSubview:timeView];
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

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
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
    [self.delegate didFinishSetDate:_event];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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


@end

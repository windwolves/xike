//
//  FastInpuGreetingWordsViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/11.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "FastInpuGreetingWordsViewController.h"
#import "ColorHandler.h"
#import "ImageControl.h"

@interface FastInpuGreetingWordsViewController ()

@end

@implementation FastInpuGreetingWordsViewController{
    UITextView *contentTextView;
    UIGestureRecognizer *tapGestureRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    [self.navigationItem setTitle:@"快速添加"];
    
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    returnBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextBtnClicked)];
    nextBtn.tintColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    [self.navigationItem setRightBarButtonItem:nextBtn];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBarHidden = NO;
}

- (void)returnBtnClicked {
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClicked {
    [self.delegate done:contentTextView.text];
}

- (void)buildView {
    //Content View
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 110)];
    contentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    contentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    contentView.layer.borderWidth = 0.5f;
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(26, 10, 250, 90)];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.textColor = [ColorHandler colorWithHexString:@"#413445"];
    if (_greeting.content.length != 0) {
        contentTextView.text = _greeting.content;
    }
    contentTextView.delegate = self;
    [contentView addSubview:contentTextView];
    
    UIControl *deleteGreetingWordsCtl = [[UIControl alloc] initWithFrame:CGRectMake(284, 10, 15, 15)];
    [deleteGreetingWordsCtl addTarget:self action:@selector(deleteGreetingWords) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *deleteGreetingWordsImageView = [[UIImageView alloc] initWithFrame:deleteGreetingWordsCtl.bounds];
    deleteGreetingWordsImageView.image = [UIImage imageNamed:@"delete_icon"];
    [deleteGreetingWordsCtl addSubview:deleteGreetingWordsImageView];
    [contentView addSubview:deleteGreetingWordsCtl];
    [self.view addSubview:contentView];
    
    //Words View
    if ([_greeting.theme isEqualToString:@"Christmas"]) {
        [self buildChristmasWords];
    } else if ([_greeting.theme isEqualToString:@"NewYearDay"]) {
        [self buildNewYearDayWords];
    } else {
        [self buildNewYearDayWords];
    }
}

- (void)buildChristmasWords {
    
    NSString *CHRISTMAS_WORD_1 = @"圣诞节到了，快点任性起来吧！";
    NSString *CHRISTMAS_WORD_2 = @"圣诞节到了耶，要在床头挂起臭袜子哦！";
    NSString *CHRISTMAS_WORD_3 = @"圣诞不送礼，只送稀客君。";
    NSString *CHRISTMAS_WORD_4 = @"希望你每天都快乐得像炉子上的茶壶一样，虽然小屁屁被烧得滚烫，但依然吹着开心的口哨，冒着幸福的小泡泡！圣诞快乐！";
    NSString *CHRISTMAS_WORD_5 = @"圣诞节，因为有了你，才让我浪费了1MB的流量费！感动吧！流泪吧！圣诞快乐！";
    NSString *CHRISTMAS_WORD_6 = @"小巫婆，圣诞节又要到了，我有祝福给你，希望你不要再笨了呆了，要可可爱爱的！";
    NSString *CHRISTMAS_WORD_7 = @"在这24号的晚上，煮两个鸡蛋，我吃一个，送给你的就是一个圣诞，祝你节日快乐！";
    NSString *CHRISTMAS_WORD_8 = @"在这个特殊的日子里，我要光明正大地骚扰你！生蛋快乐！";
    NSString *CHRISTMAS_WORD_9 = @"圣诞老人叫我对你说：圣诞快乐！另外他还叫我问你要回一份礼物，他说他多给了你一份。谢谢！";
    
    ImageControl *words_1 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_1"] :CHRISTMAS_WORD_1 :CGRectMake(21, 165+20, 131, 45)];
    ImageControl *words_2 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_2"] :CHRISTMAS_WORD_2 :CGRectMake(21, 220+20, 131, 46)];
    ImageControl *words_3 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_3"] :CHRISTMAS_WORD_3 :CGRectMake(21, 275+20, 131, 46)];
    ImageControl *words_4 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_4"] :CHRISTMAS_WORD_4 :CGRectMake(21, 331+20, 131, 121)];
    ImageControl *words_5 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_5"] :CHRISTMAS_WORD_5 :CGRectMake(21, 463+20, 131, 75)];
    ImageControl *words_6 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_6"] :CHRISTMAS_WORD_6 :CGRectMake(168, 165+20, 131, 79)];
    ImageControl *words_7 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_7"] :CHRISTMAS_WORD_7 :CGRectMake(168, 254+20, 131, 76)];
    ImageControl *words_8 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_8"] :CHRISTMAS_WORD_8 :CGRectMake(168, 340+20, 131, 61)];
    ImageControl *words_9 = [self buildWordsImageControlWith:[UIImage imageNamed:@"christmas_word_9"] :CHRISTMAS_WORD_9 :CGRectMake(168, 411+20, 131, 90)];
    
    [self.view addSubview:words_1];
    [self.view addSubview:words_2];
    [self.view addSubview:words_3];
    [self.view addSubview:words_4];
    [self.view addSubview:words_5];
    [self.view addSubview:words_6];
    [self.view addSubview:words_7];
    [self.view addSubview:words_8];
    [self.view addSubview:words_9];
}

- (void)buildNewYearDayWords {
    UIScrollView *wordsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height-185)];
    wordsScrollView.contentSize = CGSizeMake(wordsScrollView.bounds.size.width, 420);
    wordsScrollView.showsHorizontalScrollIndicator = NO;
    wordsScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:wordsScrollView];
    NSString *NEW_YEAR_DAY_WORD_1 = @"郑重声明：此信息不曾转发、不曾见过、包装质朴、情真意浓、原装正版、翻版必究、如有雷同、实属巧合。元旦快乐！";
    NSString *NEW_YEAR_DAY_WORD_2 = @"在这新的一年里，我借着元旦佳节，想深情地对你说三个字---快还钱！！";
    NSString *NEW_YEAR_DAY_WORD_3 = @"心情还舒畅？工作还舒心？身体还舒服？家人还。。。啰嗦了那么多，最后问候一声：元旦快乐！";
    NSString *NEW_YEAR_DAY_WORD_4 = @"为答谢多年来关心支持，特在元旦期间大酬宾！凡在我心中有一定地位的人都将获得由我提供的价值1MB流量的元旦贺卡一封！";
    NSString *NEW_YEAR_DAY_WORD_5 = @"领导偏袒你，警察让着你，法院向着你，媳妇由着你，吃喝随便你，财运罩着你，中奖只有你！元旦快乐！";
    NSString *NEW_YEAR_DAY_WORD_6 = @"这是我主的新年福音：要对人好，对发消息的人尤其好，多多请吃饭，经常买礼物，把身上善良的或罪恶的钱全给她，永远爱你！阿门！";
    NSString *NEW_YEAR_DAY_WORD_7 = @"如果有钱也是一种错，祝你一错再错！元旦快乐！";
    NSString *NEW_YEAR_DAY_WORD_8 = @"新的一年里，我给自己定下计划：想你是我的习惯，看你是我的职责，抱你是我的念头，吻你是我的希望，爱你是我的荣幸，娶你是我的目的";
    
    ImageControl *words_1 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_1"] :NEW_YEAR_DAY_WORD_1 :CGRectMake(21, 165+20-185, 131, 100)];
    ImageControl *words_2 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_2"] :NEW_YEAR_DAY_WORD_2 :CGRectMake(21, 273+20-185, 131, 74)];
    ImageControl *words_3 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_3"] :NEW_YEAR_DAY_WORD_3 :CGRectMake(21, 353+20-185, 131, 88)];
    ImageControl *words_4 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_4"] :NEW_YEAR_DAY_WORD_4 :CGRectMake(21, 448+20-185, 131, 115)];
    ImageControl *words_5 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_5"] :NEW_YEAR_DAY_WORD_5 :CGRectMake(168, 165+20-185, 131, 100)];
    ImageControl *words_6 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_6"] :NEW_YEAR_DAY_WORD_6 :CGRectMake(168, 273+20-185, 131, 102)];
    ImageControl *words_7 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_7"] :NEW_YEAR_DAY_WORD_7 :CGRectMake(168, 382+20-185, 131, 58)];
    ImageControl *words_8 = [self buildWordsImageControlWith:[UIImage imageNamed:@"new_year_day_word_8"] :NEW_YEAR_DAY_WORD_8 :CGRectMake(168, 448+20-185, 131, 115)];
    
    
    [wordsScrollView addSubview:words_1];
    [wordsScrollView addSubview:words_2];
    [wordsScrollView addSubview:words_3];
    [wordsScrollView addSubview:words_4];
    [wordsScrollView addSubview:words_5];
    [wordsScrollView addSubview:words_6];
    [wordsScrollView addSubview:words_7];
    [wordsScrollView addSubview:words_8];
}


- (void)deleteGreetingWords {
    contentTextView.text = @"";
}

- (void)addGreetingWords:(ImageControl *)ctl {
    contentTextView.text = ctl.controlID;
}

- (ImageControl *)buildWordsImageControlWith:(UIImage *)image :(NSString *)words :(CGRect)frame {
    ImageControl *ctl = [[ImageControl alloc] initWithFrame:frame];
    ctl.imageView = [[UIImageView alloc] initWithFrame:ctl.bounds];
    ctl.imageView.image = image;
    [ctl addSubview:ctl.imageView];
    ctl.controlID = words;
    [ctl addTarget:self action:@selector(addGreetingWords:) forControlEvents:UIControlEventTouchUpInside];
    
    return ctl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

- (void)resignKeyBoard
{
    [contentTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

@end

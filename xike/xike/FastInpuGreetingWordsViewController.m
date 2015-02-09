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

#define viewWidth self.view.bounds.size.width
#define viewHeight self.view.bounds.size.height

@interface FastInpuGreetingWordsViewController ()

@end

@implementation FastInpuGreetingWordsViewController{
    UITextView *contentTextView;
    UIGestureRecognizer *tapGestureRecognizer;
    UIView *navigationBar;
    ImageControl *returnBtn;
    ImageControl *doneBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*
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
    */
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    [self buildView];
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
        
        doneBtn = [[ImageControl alloc] initWithFrame:CGRectMake(viewWidth-53, 23, 44, 38)];
        doneBtn.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 44, 18)];
        doneBtn.imageView.image = [UIImage imageNamed:@"go_to_preview"];
        [doneBtn addSubview:doneBtn.imageView];
        [doneBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:doneBtn];
        
        UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth-71)/2, 33, 71, 16)];
        titleView.image = [UIImage imageNamed:@"fast_input_title"];
        [navigationBar addSubview:titleView];
    }
    [self.view addSubview:navigationBar];
}

- (void)returnToPreviousView {
    [self.delegate returnWithWord:contentTextView.text];
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
    if ([_greeting.theme isEqualToString:@"Spring"]) {
        [self buildWords2];
    } else if ([_greeting.theme isEqualToString:@"Valentine"]) {
        [self buildWords1];
    } else {
        [self buildWords2];
    }
}

- (void)buildWords1 {
    UIScrollView *wordsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height-185)];
    wordsScrollView.contentSize = CGSizeMake(wordsScrollView.bounds.size.width, 700);
    wordsScrollView.showsHorizontalScrollIndicator = NO;
    wordsScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:wordsScrollView];
    
    NSString *VALENTINE_WORD_1 = @"今天一起床就特别的想你，翻看了一下才知道，原来今天是我们共同的生日，节日快乐！";
    NSString *VALENTINE_WORD_2 = @"不是每一个人都可以幸运的过自己理想中的生活，有楼有车当然好了，没有难道哭吗？所以呢，我们一定要享受我们所过的生活。爱你！！";
    NSString *VALENTINE_WORD_3 = @"工资全部上交，包括计划外的;剩饭全部承包，包括馊了的;家务活全干，包括岳母家的;思想天天汇报，包括一闪念的";
    NSString *VALENTINE_WORD_4 = @"情人节，我愿做一条鱼，任你红烧、白煮、清蒸，然后躺在你温柔的胃里。";
    NSString *VALENTINE_WORD_5 = @"新的一年里，我给自己定下计划:想你是我的习惯,看你是我的职责,抱你是我的念头,吻你是我的希望,爱你是我的荣幸,娶你是我的目的!";
    NSString *VALENTINE_WORD_6 = @"我没有醇香的费列罗，也没有准备清香的怡口莲，更没有准备丝滑的德芙，但我的爱却如一杯白开水般清淡而又暖你心扉。情人节快乐";
    NSString *VALENTINE_WORD_7 = @"据可靠消息，如果情人节这天你没给你老婆买花，她将会在花瓶插上一颗菜花，并拿着鸡毛掸子等你回家跪键盘！所以一定记得买花回家哟！";
    NSString *VALENTINE_WORD_8 = @"情人节了，没有千金，没有钻戒，没有烛光，没有玫瑰，没有甜言，没有蜜语；只有一条短信，一句问候，一线相牵，一份思念，一心相恋，一份爱慕，一生相守，一世呵护。祝亲爱的情人节快乐！";
    NSString *VALENTINE_WORD_9 = @"在一起的日子很平淡，似乎波澜不惊，只是，这种平凡的日子是最浪漫的，对吗?亲爱的，情人节快乐!";
    NSString *VALENTINE_WORD_10 = @"2.14.我把爱写在贺卡里，把希望写在字里行间。亲爱的，情人节快乐!";
    
    ImageControl *words_1 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_1"] :VALENTINE_WORD_1 :CGRectMake(21, 165+20-185, 131, 86)];
    ImageControl *words_2 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_2"] :VALENTINE_WORD_2 :CGRectMake(21, 261+20-185, 131, 118)];
    ImageControl *words_3 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_3"] :VALENTINE_WORD_3 :CGRectMake(21, 389+20-185, 131, 106)];
    ImageControl *words_4 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_4"] :VALENTINE_WORD_4 :CGRectMake(21, 505+20-185, 131, 74)];
    ImageControl *words_9 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_9"] :VALENTINE_WORD_9 :CGRectMake(21, 589+20-185, 131, 88)];
    ImageControl *words_10 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_10"] :VALENTINE_WORD_10 :CGRectMake(21, 687+20-185, 131, 76)];
    ImageControl *words_5 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_5"] :VALENTINE_WORD_5 :CGRectMake(168, 165+20-185, 131, 120)];
    ImageControl *words_6 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_6"] :VALENTINE_WORD_6 :CGRectMake(168, 295+20-185, 131, 121)];
    ImageControl *words_7 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_7"] :VALENTINE_WORD_7 :CGRectMake(168, 426+20-185, 131, 118)];
    ImageControl *words_8 = [self buildWordsImageControlWith:[UIImage imageNamed:@"VALENTINE_WORD_8"] :VALENTINE_WORD_8 :CGRectMake(168, 554+20-185, 131, 149)];
    
    
    
    [wordsScrollView addSubview:words_1];
    [wordsScrollView addSubview:words_2];
    [wordsScrollView addSubview:words_3];
    [wordsScrollView addSubview:words_4];
    [wordsScrollView addSubview:words_5];
    [wordsScrollView addSubview:words_6];
    [wordsScrollView addSubview:words_7];
    [wordsScrollView addSubview:words_8];
    [wordsScrollView addSubview:words_9];
    [wordsScrollView addSubview:words_10];
}

- (void)buildWords2 {
    UIScrollView *wordsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 185, self.view.bounds.size.width, self.view.bounds.size.height-185)];
    wordsScrollView.contentSize = CGSizeMake(wordsScrollView.bounds.size.width, 700);
    wordsScrollView.showsHorizontalScrollIndicator = NO;
    wordsScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:wordsScrollView];
    NSString *SPRING_WORD_1 = @"郑重声名:此条短信不曾转发、不曾见过、包装质朴、情真意浓、原装正版、翻版必究、如有雷同、实属巧合。新年快乐";
    NSString *SPRING_WORD_2 = @"在这新的一年里，我借着新春佳节，想深情地对你说三个字——“快还钱！！”";
    NSString *SPRING_WORD_3 = @"心情还舒畅？工作还舒心？身体还舒服？家人还····啰嗦了那么多，最后问候一声：新年快乐！";
    NSString *SPRING_WORD_4 = @"为答谢多年来关心支持特在新年期间大酬宾!凡在我心中有一定地位的人都将获得由我提供的价值1MB流量的新年贺卡一封。";
    NSString *SPRING_WORD_5 = @"领导偏袒你，警察让着你，法院向着你，官运伴着你，媳妇由着你，吃喝随便你，财运罩着你，中奖只有你!";
    NSString *SPRING_WORD_6 = @"这是我主耶稣的新年福音:要对人好,要对发信息的人尤其好,多多请她吃饭,经常买礼物给她,把你身上善良的或罪恶的钱全给她,耶稣永远爱你! 阿门!";
    NSString *SPRING_WORD_7 = @"如果有钱也是一种错，祝你一错再错!新年快乐!";
    NSString *SPRING_WORD_8 = @"新的一年里，我给自己定下计划:想你是我的习惯,看你是我的职责,抱你是我的念头,吻你是我的希望,爱你是我的荣幸,娶你是我的目的!";
    NSString *SPRING_WORD_9 = @"我决定，毕生全部财产，全部送你! 如果愿意笑纳，亲只需要给我支付宝账号随意打点定金就好，请叫我土豪，不用谢！2015年，愿你有钱，任性！";
    NSString *SPRING_WORD_10 = @"活着真累:上车得排队,爱你又受罪,吃饭没香味,喝酒容易醉,挣钱得交税!就连给亲爱的你发个短信还得收费!祝你新年快乐。";
    

    ImageControl *words_1 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_1"] :SPRING_WORD_1 :CGRectMake(21, 165+20-185, 131, 100)];
    ImageControl *words_2 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_2"] :SPRING_WORD_2 :CGRectMake(21, 275+20-185, 131, 74)];
    ImageControl *words_3 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_3"] :SPRING_WORD_3 :CGRectMake(21, 359+20-185, 131, 88)];
    ImageControl *words_4 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_4"] :SPRING_WORD_4 :CGRectMake(21, 457+20-185, 131, 115)];
    ImageControl *words_9 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_9"] :SPRING_WORD_9 :CGRectMake(21, 582+20-185, 131, 133)];
    ImageControl *words_5 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_5"] :SPRING_WORD_5 :CGRectMake(168, 165+20-185, 131, 100)];
    ImageControl *words_6 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_6"] :SPRING_WORD_6 :CGRectMake(168, 275+20-185, 131, 102)];
    ImageControl *words_7 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_7"] :SPRING_WORD_7 :CGRectMake(168, 387+20-185, 131, 58)];
    ImageControl *words_8 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_8"] :SPRING_WORD_8 :CGRectMake(168, 457+20-185, 131, 115)];
    
    ImageControl *words_10 = [self buildWordsImageControlWith:[UIImage imageNamed:@"SPRING_WORD_10"] :SPRING_WORD_10 :CGRectMake(168, 582+20-185, 131, 133)];
    
    
    [wordsScrollView addSubview:words_1];
    [wordsScrollView addSubview:words_2];
    [wordsScrollView addSubview:words_3];
    [wordsScrollView addSubview:words_4];
    [wordsScrollView addSubview:words_5];
    [wordsScrollView addSubview:words_6];
    [wordsScrollView addSubview:words_7];
    [wordsScrollView addSubview:words_8];
    [wordsScrollView addSubview:words_9];
    [wordsScrollView addSubview:words_10];
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

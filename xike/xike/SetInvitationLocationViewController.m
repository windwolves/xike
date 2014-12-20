//
//  SetInvitationLocationViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/12.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "SetInvitationLocationViewController.h"
#import "ColorHandler.h"

@interface SetInvitationLocationViewController ()

@end

@implementation SetInvitationLocationViewController {
    NSString *placeHolderString;
    UITapGestureRecognizer *tapGestureRecognizer;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    placeHolderString = @"输入场所或地址(限100字)";
    
    [self buildView];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)done {
    _location = _locationTextView.text;
    if ([_locationTextView.text isEqualToString:placeHolderString]) {
        _location = @"";
    }
    [self.delegate didFinishSetLocation:_location];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildView {
    _locationTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    _locationTextView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    _locationTextView.layer.borderWidth = 0.5f;
    _locationTextView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
    _locationTextView.font = [UIFont systemFontOfSize:15];
    _locationTextView.text = placeHolderString;
    if (_location && _location.length != 0) {
        _locationTextView.text = _location;
    }
    _locationTextView.delegate = self;
    [self.view addSubview:_locationTextView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:placeHolderString]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    _location = _locationTextView.text;
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [ColorHandler colorWithHexString:@"#9a9a9a"];
        textView.text = placeHolderString;
        _location = @"";
    }
    [textView resignFirstResponder];
}

- (void)resignKeyBoard
{
    [_locationTextView resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

@end

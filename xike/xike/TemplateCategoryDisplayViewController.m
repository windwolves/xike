//
//  TemplateCategoryDisplayViewController.m
//  xike
//
//  Created by Leading Chen on 14/10/30.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "TemplateCategoryDisplayViewController.h"
#import "ColorHandler.h"
#import "CreateNewEventViewController.h"

@interface TemplateCategoryDisplayViewController ()

@end

@implementation TemplateCategoryDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBtnClicked)];
    returnBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 504)];
    switch (_category) {
        case 1:
            imageView.image = [UIImage imageNamed:@"category_d_1"];
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"category_d_2"];
            break;
        case 3:
            imageView.image = [UIImage imageNamed:@"category_d_3"];
            break;
        case 4:
            imageView.image = [UIImage imageNamed:@"category_d_4"];
            break;
        default:
            imageView.image = [UIImage imageNamed:@"category_d_1"];
            break;
    }
    
    [self.view addSubview:imageView];
    
    //Set Button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80, 460, 160, 40)];
    [button setTitle:@"创建" forState:UIControlStateNormal];
    button.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    [button addTarget:self action:@selector(createNewEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)returnBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createNewEvent {
    CreateNewEventViewController *createNewEventViewController = [CreateNewEventViewController new];
    createNewEventViewController.database = _database;
    createNewEventViewController.user = _user;
    createNewEventViewController.isCreate = YES;
    [self.navigationController pushViewController:createNewEventViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

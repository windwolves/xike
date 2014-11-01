//
//  TemplateDisplayViewController.m
//  xike
//
//  Created by Leading Chen on 14/10/29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "TemplateDisplayViewController.h"
#import "ExploreDetailsViewController.h"
#import "TemplateCategoryDisplayViewController.h"
#import "ColorHandler.h"

@interface TemplateDisplayViewController ()

@end

@implementation TemplateDisplayViewController {
    UIScrollView *myScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    // Do any additional setup after loading the view.
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    myScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 40);
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.tag = 1;
    myScrollView.contentInset = UIEdgeInsetsZero;
    //Banner
    ImageScrollView *imageScrollView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 159)];
    //set image might be done in another way later
    UIImage *image1 = [UIImage imageNamed:@"banner1"];
    UIImage *image2 = [UIImage imageNamed:@"banner2"];
    UIImage *image3 = [UIImage imageNamed:@"banner3"];
    UIImage *image4 = [UIImage imageNamed:@"banner4"];
    
    
    [imageScrollView initializeWith:@[image1,image2,image3,image4]];
    [imageScrollView setScrollInterval:3];
    imageScrollView.delegate = self;
    
    [myScrollView addSubview:imageScrollView];
    
    //Templates
    UIImageView *title1 = [[UIImageView alloc] initWithFrame:CGRectMake(8, 168, 58, 14)];
    title1.image = [UIImage imageNamed:@"template_category_title"];
    [myScrollView addSubview:title1];
    
    //UIScrollView *templatesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 191, self.view.bounds.size.width, self.view.bounds.size.height-191-49)];
    //templatesScrollView.contentSize = CGSizeMake(templatesScrollView.frame.size.width, 350);
    //templatesScrollView.showsHorizontalScrollIndicator = NO;
    //templatesScrollView.showsVerticalScrollIndicator = NO;
    
    //category 1
    UIControl *category_ctl_1 = [[UIControl alloc] initWithFrame:CGRectMake(8, 191, 147, 147)];
    category_ctl_1.tag = 1;
    UIImageView *category_imageView_1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 147)];
    category_imageView_1.image = [UIImage imageNamed:@"category_1"];
    [category_ctl_1 addSubview:category_imageView_1];
    [category_ctl_1 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:category_ctl_1];
    
    //category 2
    UIControl *category_ctl_2 = [[UIControl alloc] initWithFrame:CGRectMake(8+147+9, 191, 147, 147)];
    category_ctl_2.tag = 2;
    UIImageView *category_imageView_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 147)];
    category_imageView_2.image = [UIImage imageNamed:@"category_2"];
    [category_ctl_2 addSubview:category_imageView_2];
    [category_ctl_2 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:category_ctl_2];
    
    //category 3
    UIControl *category_ctl_3 = [[UIControl alloc] initWithFrame:CGRectMake(8, 147+9+191, 147, 147)];
    category_ctl_3.tag = 3;
    UIImageView *category_imageView_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 147)];
    category_imageView_3.image = [UIImage imageNamed:@"category_3"];
    [category_ctl_3 addSubview:category_imageView_3];
    [category_ctl_3 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:category_ctl_3];
    
    //category 4
    UIControl *category_ctl_4 = [[UIControl alloc] initWithFrame:CGRectMake(8+147+9, 147+9+191, 147, 147)];
    category_ctl_4.tag = 4;
    UIImageView *category_imageView_4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 147, 147)];
    category_imageView_4.image = [UIImage imageNamed:@"category_4"];
    [category_ctl_4 addSubview:category_imageView_4];
    [category_ctl_4 addTarget:self action:@selector(chooseCategory:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:category_ctl_4];
    
    
    [self.view addSubview:myScrollView];
    
}

- (void)chooseCategory:(UIControl *)sender {
    TemplateCategoryDisplayViewController *templateCategoryDisplayViewController = [TemplateCategoryDisplayViewController new];
    templateCategoryDisplayViewController.database = _database;
    templateCategoryDisplayViewController.user = _user;
    templateCategoryDisplayViewController.category = sender.tag;
    
    [self.navigationController pushViewController:templateCategoryDisplayViewController animated:YES];
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

#pragma mark ImageScrollViewDelegate
- (void)didChooseImageView:(UIImageView *)imageView {
    ExploreDetailsViewController *exploreDetailsViewController = [ExploreDetailsViewController new];
    if (imageView.tag == 0) {
        exploreDetailsViewController.url =[NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/5c925d95-855e-4624-b7aa-9898376aa998?channel=app"];
    } else if (imageView.tag == 1) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/25d26450-573f-4563-b1fb-8b9a59648401?channel=app"];
    } else if (imageView.tag == 2) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/b39f6ee4-ba68-4a5d-ad56-1ae1b46b82b3?channel=app"];
    } else if (imageView.tag == 3) {
        exploreDetailsViewController.url = [NSURL URLWithString:@"http://121.40.139.180:8081/#/discover/e141bac0-ce18-4336-802d-e0075c96f0be?channel=app"];
    }
    
    
    [self.navigationController pushViewController:exploreDetailsViewController animated:YES];
}

@end

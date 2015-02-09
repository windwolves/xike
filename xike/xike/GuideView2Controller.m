//
//  GuideView2Controller.m
//  xike
//
//  Created by Leading Chen on 15/1/28.
//  Copyright (c) 2015年 Leading. All rights reserved.
//

#import "GuideView2Controller.h"
#import "Contants.h"

#define viewWidth self.view.bounds.size.width
#define viewHeight self.view.bounds.size.height

@interface GuideView2Controller ()

@end

@implementation GuideView2Controller {
    CGSize windowSize;
    NSInteger currentPageIndex;
    UIButton *enterBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    windowSize = [[UIScreen mainScreen] bounds].size;
    //Pages
    UIImage *guide_1 = [UIImage imageNamed:@"guide_1"];
    UIImage *guide_2 = [UIImage imageNamed:@"guide_2"];
    UIImage *guide_3 = [UIImage imageNamed:@"guide_3"];
    UIImage *guide_4 = [UIImage imageNamed:@"guide_4"];
    _pages = [[NSMutableArray alloc] initWithObjects:guide_1,guide_2,guide_3,guide_4, nil];
    //Scroll View
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake([self numberOfPages]*windowSize.width, windowSize.height);
    [_scrollView setPagingEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    
    
    
    _backLayerView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _frontLayerView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_backLayerView];
    [self.view addSubview:_frontLayerView];
    
    // Preset the origin state.
    [self setOriginLayersState];
    
    //Enter Button
    enterBtn = [[UIButton alloc] initWithFrame:CGRectMake((viewWidth-128)/2, 497, 128, 39)];
    [enterBtn setImage:[UIImage imageNamed:@"entry_btn"] forState:UIControlStateNormal];
    [enterBtn addTarget:self action:@selector(guideDidFinish) forControlEvents:UIControlEventTouchUpInside];

    //PageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((windowSize.width-100)/2, windowSize.height-100, 100, 10)];
//    _pageControl.backgroundColor = [UIColor redColor];
    [_pageControl setNumberOfPages:[self numberOfPages]];
    [_pageControl setCurrentPage:0];
    [_pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];

}

- (void)showPanelAtPageControl {
    
}

- (NSUInteger)numberOfPages{
    if (_pages)
        return [_pages count];
    
    return 0;
}

- (void)setOriginLayersState{
    //_currentState = ScrollingStateAuto;
    [self setLayersPicturesWithIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Layer setting
// Setup layer's alpha.
- (void)setLayersPrimaryAlphaWithPageIndex:(NSInteger)index{
    [_frontLayerView setAlpha:1];
    [_backLayerView setAlpha:0];
}

// Handle the background layer image switch.
- (void)setBackLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_backLayerView withIndex:index + 1];
}

// Handle the front layer image switch.
- (void)setFrontLayerPictureWithPageIndex:(NSInteger)index{
    [self setBackgroundImage:_frontLayerView withIndex:index];
}

// Handle page image's loading
- (void)setBackgroundImage:(UIImageView *)imageView withIndex:(NSInteger)index{
    if (index >= [_pages count]){
        [imageView setImage:nil];
        return;
    }
    
    UIImage *image = [_pages objectAtIndex:index];
    [imageView setImage:image];
}

// Setup the layers with the page index.
- (void)setLayersPicturesWithIndex:(NSInteger)index{
    currentPageIndex = index;
    [self setLayersPrimaryAlphaWithPageIndex:index];
    [self setFrontLayerPictureWithPageIndex:index];
    [self setBackLayerPictureWithPageIndex:index];
}

// Animate the fade-in/out (Cross-disolve) with the scrollView translation.
- (void)disolveBackgroundWithContentOffset:(float)offset{
    /* Looping is not needed this time may be used later
     if (_currentState & ScrollingStateLooping){
     // Jump from the last page to the first.
     [self scrollingToFirstPageWithOffset:offset];
     } else {
     // Or just scroll to the next/previous page.
     [self scrollingToNextPageWithOffset:offset];
     }
     */
    // Just scroll to the next/previous page.
    [self scrollingToNextPageWithOffset:offset];
}

// Handle alpha on layers when the auto-scrolling is looping to the first page.
- (void)scrollingToFirstPageWithOffset:(float)offset{
    // Compute the scrolling percentage on all the page.
    offset = (offset * windowSize.width) / (windowSize.width * [self numberOfPages]);
    
    // Scrolling finished...
    if (offset == 0){
        // ...reset to the origin state.
        [self setOriginLayersState];
        return;
    }
    
    // Invert alpha for the back picture.
    float backLayerAlpha = (1 - offset);
    float frontLayerAlpha = offset;
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

// Handle alpha on layers when we are scrolling to the next/previous page.
- (void)scrollingToNextPageWithOffset:(float)offset{
    // Current page index in scrolling.
    NSInteger page = (int)(offset);
    
    // Keep only the float value.
    float alphaValue = offset - (int)offset;
    
    // This is only when you scroll to the right on the first page.
    // That will fade-in black the first picture.
    if (alphaValue < 0 && currentPageIndex == 0){
        [_backLayerView setImage:nil];
        [_frontLayerView setAlpha:(1 + alphaValue)];
        return;
    }
    
    // Switch pictures, and imageView alpha.
    if (page != currentPageIndex) {
        [self setLayersPicturesWithIndex:page];
    }
    // Go to logon view if it's last page
    if (page == [_pages count]-1) {
        [self.view addSubview:enterBtn];
    } else {
        [enterBtn removeFromSuperview];
    }
    // Invert alpha for the front picture.
    float backLayerAlpha = alphaValue;
    float frontLayerAlpha = (1 - alphaValue);
    
    // Set alpha.
    [_backLayerView setAlpha:backLayerAlpha];
    [_frontLayerView setAlpha:frontLayerAlpha];
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Get scrolling position, and send the alpha values.
    float scrollingPosition = scrollView.contentOffset.x / windowSize.width;
    [self disolveBackgroundWithContentOffset:scrollingPosition];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // Update the page index.
    [_pageControl setCurrentPage:currentPageIndex];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)guideDidFinish {
    if (_destination == Destination_logon) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_logonViewController];
        [self presentViewController:navigation animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setFloat:app_version forKey:@"version"];
        }];
    } else if (_destination == Destination_main) {
        
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:_mainView2Controller];
        [self presentViewController:navigation animated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setFloat:app_version forKey:@"version"];
        }];
    }
}
@end

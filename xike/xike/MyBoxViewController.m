//
//  MyBoxViewController.m
//  xike
//
//  Created by Leading Chen on 14/12/7.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MyBoxViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "PreViewController.h"
#import "SettingView2Controller.h"
#import "EventsTableViewCell.h"
#import "GreetingCardTableViewCell.h"


#define ORIGINAL_MAX_WIDTH 640.0f
@interface MyBoxViewController ()

@end

@implementation MyBoxViewController {
    NSMutableArray *eventsArray;
    NSMutableArray *greetingsArray;
    UITapGestureRecognizer *tapGestureRecognizer;
    UISwipeGestureRecognizer *swipeGestureLeft;
    UISwipeGestureRecognizer *swipeGestureRight;
    UIActionSheet *myActionSheet;
    UIView *sectionIndicator;
    UIControl *invitationCtl;
    UIControl *greetingCardCtl;
    UILabel *invitationLabel;
    UILabel *greetingCardLabel;
    UIImageView *invitationTipsImageView;
    UIImageView *greetingTipsImageView;
    UIView *invitationsView;
    UIView *greetingsView;
    SettingView2Controller *settingViewController;
    int SectionFlag;
}

enum ControlFlag {
    InvitationTag = 1,
    GreetingCardTag = 2,
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    
    [self buildInvitationsView];
    [self buildGreetingsView];
    [self.view addSubview:invitationsView];
    [self.view addSubview:greetingsView];
    
    eventsArray = [_database getAllEvents:_user];
    greetingsArray = [_database getAllGreetingCards:_user];
}

- (void)viewWillAppear:(BOOL)animated {
    //Hide the navigationBar
    self.navigationController.navigationBarHidden = YES;
    [self buildTipsView];
    [self buildBackImageView];
}

- (void)buildBackImageView {
    //background Image View
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    if (_user.backgroundPic) {
        _backImageView.image = [UIImage imageWithData:_user.backgroundPic];
    } else {
        _backImageView.image = [UIImage imageNamed:@"box_bg_pic"];
    }
    [_backImageView setUserInteractionEnabled:YES];
    
    //User nickname
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.view.bounds.size.width, 18)];
    _nicknameLabel.font = [UIFont systemFontOfSize:18];
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    _nicknameLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    if (_user.name) {
        _nicknameLabel.text = _user.name;
    } else {
        _nicknameLabel.text = @"";
    }
    [_backImageView addSubview:_nicknameLabel];
    
    //Setting Button
    UIControl *settingCtl = [[UIControl alloc] initWithFrame:CGRectMake(270, 25, 40, 40)];
    UIImageView *settingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    [settingImageView setImage:[UIImage imageNamed:@"setting_icon"]];
    [settingCtl addSubview:settingImageView];
    [settingCtl addTarget:self action:@selector(popSettingView) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:settingCtl];
    
    //user_pic_imageView
    UIImageView *userPicBorderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(124, 74, 78, 78)];
    userPicBorderImageView.layer.cornerRadius = CGRectGetHeight(userPicBorderImageView.bounds) / 2;
    userPicBorderImageView.clipsToBounds = YES;
    userPicBorderImageView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    [_backImageView addSubview:userPicBorderImageView];
    
    UIControl *pictureCtl = [[UIControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-72+4)/2 , 76, 74, 74)];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 74, 74)];
    _pictureView.layer.cornerRadius = CGRectGetHeight(_pictureView.bounds) / 2;
    _pictureView.clipsToBounds = YES;
    if (_user.photo) {
        _pictureView.image = [UIImage imageWithData:_user.photo];
    } else {
        _pictureView.image = [UIImage imageNamed:@"user_pic_default"];
    }
    [pictureCtl addSubview:_pictureView];
    [pictureCtl addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    [_backImageView addSubview:pictureCtl];

    
    
    //Invitation Control
    invitationCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, 158, self.view.bounds.size.width/2, 15)];
    invitationCtl.tag = InvitationTag;
    [invitationCtl addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    invitationLabel = [[UILabel alloc] initWithFrame:invitationCtl.bounds];
    invitationLabel.textAlignment = NSTextAlignmentCenter;
    invitationLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    invitationLabel.font = [UIFont systemFontOfSize:15];
    invitationLabel.text = @"邀请函";
    [invitationCtl addSubview:invitationLabel];
    [_backImageView addSubview:invitationCtl];
    
    //Greeting Control
    greetingCardCtl = [[UIControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 158, self.view.bounds.size.width/2, 15)];
    greetingCardCtl.tag = GreetingCardTag;
    [greetingCardCtl addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchUpInside];
    greetingCardLabel = [[UILabel alloc] initWithFrame:greetingCardCtl.bounds];
    greetingCardLabel.textAlignment = NSTextAlignmentCenter;
    greetingCardLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    greetingCardLabel.font = [UIFont systemFontOfSize:14];
    greetingCardLabel.text = @"贺卡";
    [greetingCardCtl addSubview:greetingCardLabel];
    [_backImageView addSubview:greetingCardCtl];
    
    //Inidicator
    sectionIndicator = [[UIView alloc] initWithFrame:CGRectMake(0+45, 178, 70, 2)];
    sectionIndicator.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    [_backImageView addSubview:sectionIndicator];
    SectionFlag = InvitationTag;
    
    [self.view addSubview:_backImageView];
}

- (void)buildInvitationsView {
    invitationsView = [[UIView alloc] initWithFrame:CGRectMake(4, 184, self.view.bounds.size.width-8, self.view.bounds.size.height)];
    invitationsView.backgroundColor = [UIColor clearColor];
    _eventsTable = [[UITableView alloc] initWithFrame:invitationsView.bounds];
    _eventsTable.dataSource = self;
    _eventsTable.delegate = self;
    _eventsTable.rowHeight = 85;
    _eventsTable.tag = InvitationTag;
    _eventsTable.showsVerticalScrollIndicator = NO;
    [_eventsTable registerClass:[EventsTableViewCell class] forCellReuseIdentifier:@"EventCell"];
}

- (void)buildGreetingsView {
    greetingsView = [[UIView alloc] initWithFrame:CGRectMake(4+320, 184, self.view.bounds.size.width-8, self.view.bounds.size.height-184)];
    greetingsView.backgroundColor = [UIColor clearColor];
    _greetingsTables = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, greetingsView.bounds.size.width, greetingsView.bounds.size.height)];
    _greetingsTables.dataSource = self;
    _greetingsTables.delegate = self;
    _greetingsTables.rowHeight = 85;
    _greetingsTables.tag = GreetingCardTag;
    _greetingsTables.showsVerticalScrollIndicator = NO;
    [_greetingsTables registerClass:[GreetingCardTableViewCell class] forCellReuseIdentifier:@"GreetingCardCell"];
}

- (void)buildTipsView {
    //Invitation Tips
    eventsArray = [_database getAllEvents :_user];
    [_eventsTable removeFromSuperview];
    [invitationTipsImageView removeFromSuperview];
    if (eventsArray.count == 0) {
        invitationTipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(89, 246, 134, 79)];
        invitationTipsImageView.image = [UIImage imageNamed:@"tips_invitation"];
        [invitationsView addSubview:invitationTipsImageView];
    } else {
        [invitationsView addSubview:_eventsTable];
        [_eventsTable reloadData];
    }
    
    //Greetings Tips
    greetingsArray = [_database getAllGreetingCards:_user];
    [_greetingsTables removeFromSuperview];
    [greetingTipsImageView removeFromSuperview];
    if (greetingsArray.count == 0) {
        greetingTipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(96, 246, 126, 78)];
        greetingTipsImageView.image = [UIImage imageNamed:@"tips_greeting"];
        [greetingsView addSubview:greetingTipsImageView];
    } else {
        [greetingsView addSubview:_greetingsTables];
        [_greetingsTables reloadData];
    }
    
}

- (void)uploadProfileOnServer {
    NSData *imgData = UIImageJPEGRepresentation(_pictureView.image, 0.5);
    
    NSString *uploadProfileService = @"/services/user/upload";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,uploadProfileService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831464368775746641449"];
    NSMutableData *body = [NSMutableData new];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_user.ID dataUsingEncoding:NSUTF8StringEncoding]];
    if (imgData) {
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", @"profile",_user.name] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imgData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // set request HTTPHeader
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            NSLog(@"%@",[dataDic valueForKey:@"status"]);
            NSLog(@"%@",[[dataDic valueForKey:@"data"] valueForKey:@"nickname"]);
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    
}

- (void)changeSection:(UIControl *)section {
    if (section.tag == InvitationTag) {
        [self showInvitationView];
    } else if (section.tag == GreetingCardTag) {
        [self showGreetingCardView];
    }
}

- (void)showInvitationView {
    if (SectionFlag == InvitationTag) {
        return;
    }
    invitationLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    greetingCardLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    [sectionIndicator setFrame:CGRectMake(0+45, 178, 70, 2)];
    
    [greetingsView setFrame:CGRectMake(4+self.view.bounds.size.width, 184, self.view.bounds.size.width-8, self.view.bounds.size.height-184)];
    [invitationsView setFrame:CGRectMake(4, 184, self.view.bounds.size.width-8, self.view.bounds.size.height-184)];
    
    [sectionIndicator setTransform:CGAffineTransformMakeTranslation(160,0)];
    [greetingsView setTransform:CGAffineTransformMakeTranslation(-320,0)];
    [invitationsView setTransform:CGAffineTransformMakeTranslation(-320, 0)];
    [UIView animateWithDuration:0.4f animations:^{
        [sectionIndicator setTransform:CGAffineTransformIdentity];
        [greetingsView setTransform:CGAffineTransformIdentity];
        [invitationsView setTransform:CGAffineTransformIdentity];
        SectionFlag = InvitationTag;
    }];
}

- (void)showGreetingCardView {
    if (SectionFlag == GreetingCardTag) {
        return;
    }
    invitationLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    greetingCardLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    [sectionIndicator setFrame:CGRectMake(160+45, 178, 70, 2)];
    
    [greetingsView setFrame:CGRectMake(4, 184, self.view.bounds.size.width-8, self.view.bounds.size.height-184)];
    [invitationsView setFrame:CGRectMake(-1*self.view.bounds.size.width+4, 184, self.view.bounds.size.width-8, self.view.bounds.size.height-184)];
    
    [sectionIndicator setTransform:CGAffineTransformMakeTranslation(-160,0)];
    [greetingsView setTransform:CGAffineTransformMakeTranslation(320,0)];
    [invitationsView setTransform:CGAffineTransformMakeTranslation(320, 0)];
    
    [UIView animateWithDuration:0.4f animations:^{
        [sectionIndicator setTransform:CGAffineTransformIdentity];
        [greetingsView setTransform:CGAffineTransformIdentity];
        [invitationsView setTransform:CGAffineTransformIdentity];
        SectionFlag = GreetingCardTag;
    }];
}

- (void)popSettingView {
    settingViewController = [[SettingView2Controller alloc] init];
    settingViewController.delegate = self;
    settingViewController.database = _database;
    settingViewController.user = _user;
    
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == InvitationTag) {
        return [eventsArray count];
    } else {
        return [greetingsArray count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == InvitationTag) {
        EventsTableViewCell *cell_1 = [EventsTableViewCell new];
        cell_1 = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
        [cell_1 setEvent:[eventsArray objectAtIndex:indexPath.row]];
        return cell_1;
    } else {
        GreetingCardTableViewCell *cell_2 = [GreetingCardTableViewCell new];
        cell_2 = [tableView dequeueReusableCellWithIdentifier:@"GreetingCardCell" forIndexPath:indexPath];
        [cell_2 setGreeting:[greetingsArray objectAtIndex:indexPath.row]];
        return cell_2;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView.tag == InvitationTag) {
            //Delete the event
            EventInfo *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
            [_database deleteEvent:eventToDelete];
            eventsArray = [_database getAllEvents :_user];
        } else if (tableView.tag == GreetingCardTag) {
            //Delete the greeting card
            GreetingInfo *greetingCardToDelete = [greetingsArray objectAtIndex:indexPath.row];
            [_database deleteGreetingCard:greetingCardToDelete];
            greetingsArray = [_database getAllGreetingCards:_user];
        }
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self buildTipsView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PreViewController *preViewController = [PreViewController new];
    preViewController.database = _database;
    if (tableView.tag == InvitationTag) {
        preViewController.event = [eventsArray objectAtIndex:indexPath.row];
        preViewController.fromController = @"eventsTable";
    } else if (tableView.tag == GreetingCardTag) {
        preViewController.greeting = [greetingsArray objectAtIndex:indexPath.row];
        preViewController.fromController = @"greetingsTable";
        preViewController.createItem = @"greetingCard";
    }
    
    [self.navigationController pushViewController:preViewController animated:YES];
}

#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [_pictureView setImage:editedImage];
    _user.photo = UIImagePNGRepresentation(_pictureView.image);
    [_database updateUser:_user];
    [self uploadProfileOnServer];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self locolPhoto];
                break;
            default:
                break;
        }
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        NSLog(@"You don't have a camera!");
    }
}

- (void)locolPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^(void){}];
    // [self presentModalViewController:picker animated:YES];
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //[_pictureView setImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:^(){
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [self imageByScalingToMaxSize:image];
        // 裁剪
        ImageCropperViewController *imgEditorVC = [[ImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}


- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma SettingView2ControllerDelegate
- (void)didFinishAccountSettingwith:(UserInfo *)user {
    _pictureView.image = [UIImage imageWithData:user.photo];
    _nicknameLabel.text = user.name;
}






@end

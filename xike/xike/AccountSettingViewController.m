//
//  AccountSettingViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-29.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "ColorHandler.h"
#import "ChangePasswordViewController.h"
#import "UserLogonViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface AccountSettingViewController () {
    UIActionSheet *myActionSheet;
    UIActionSheet *genderSheet;
    UIGestureRecognizer *tapGestureRecognizer;
    UITextField *nicknameField;
    UILabel *genderLabel2;
}

@end

@implementation AccountSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    //Save the changes!
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"设置"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAccountSetting)];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f6f6f6"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    UIView *accountInfoView = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 314, 224)];
    accountInfoView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    
    UILabel *picLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 33, 30, 15)];
    picLabel.font = [UIFont systemFontOfSize:15];
    picLabel.text = @"头像";
    [accountInfoView addSubview:picLabel];
    UIImageView *picBorderView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-80, 4, 72, 72)];
    picBorderView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    picBorderView.layer.cornerRadius = CGRectGetHeight(picBorderView.bounds) / 2;
    picBorderView.clipsToBounds = YES;
    [accountInfoView addSubview:picBorderView];
    UIControl *pictureCtl = [[UIControl alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-80+2 , 4+2, 68, 68)];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    _pictureView.layer.cornerRadius = CGRectGetHeight(_pictureView.bounds) / 2;
    _pictureView.clipsToBounds = YES;
    if (_user.photo) {
        _pictureView.image = [UIImage imageWithData:_user.photo];
    } else {
        _pictureView.image = [UIImage imageNamed:@"user_pic_default.png"];
    }
    [pictureCtl addSubview:_pictureView];
    [pictureCtl addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    [accountInfoView addSubview:pictureCtl];
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, accountInfoView.bounds.size.width, 0.5)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#cccccc"];
    [accountInfoView addSubview:line1];
    
    UILabel *accountLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 101, 30, 15)];
    accountLabel1.font = [UIFont systemFontOfSize:15];
    accountLabel1.text = @"账号";
    [accountInfoView addSubview:accountLabel1];
    UILabel *accountLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 101, accountInfoView.bounds.size.width-40-9, 15)];
    accountLabel2.font = [UIFont systemFontOfSize:14];
    accountLabel2.textAlignment = NSTextAlignmentRight;
    accountLabel2.text = _user.userID;
    [accountInfoView addSubview:accountLabel2];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128, accountInfoView.bounds.size.width, 0.5)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#cccccc"];
    [accountInfoView addSubview:line2];
    
    UILabel *nicknameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 143, 30, 15)];
    nicknameLabel1.font = [UIFont systemFontOfSize:15];
    nicknameLabel1.text = @"昵称";
    [accountInfoView addSubview:nicknameLabel1];
    
    nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 143, accountInfoView.bounds.size.width-40-9, 15)];
    nicknameField.font = [UIFont systemFontOfSize:14];
    nicknameField.textAlignment = NSTextAlignmentRight;
    nicknameField.delegate = self;
    if (_user.name) {
        nicknameField.text = _user.name;
    } else {
        nicknameField.text = @"";
    }
    
    [accountInfoView addSubview:nicknameField];

    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 176, accountInfoView.bounds.size.width, 0.5)];
    line3.backgroundColor = [ColorHandler colorWithHexString:@"#cccccc"];
    [accountInfoView addSubview:line3];
    
    UILabel *genderLable1 = [[UILabel alloc] initWithFrame:CGRectMake(7, 190, 30, 15)];
    genderLable1.font = [UIFont systemFontOfSize:15];
    genderLable1.text = @"性别";
    [accountInfoView addSubview:genderLable1];
    
    UIControl *genderCtl = [[UIControl alloc] initWithFrame:CGRectMake(40, 190, accountInfoView.bounds.size.width-40-9, 15)];
    genderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, accountInfoView.bounds.size.width-40-9, 15)];
    genderLabel2.font = [UIFont systemFontOfSize:14];
    genderLabel2.textAlignment = NSTextAlignmentRight;
    if (_user.gender) {
        genderLabel2.text = _user.gender;
    } else {
        genderLabel2.text = @"男";
    }
    [genderCtl addSubview:genderLabel2];
    [genderCtl addTarget:self action:@selector(changeGender) forControlEvents:UIControlEventTouchUpInside];
    [accountInfoView addSubview:genderCtl];

    [self.view addSubview:accountInfoView];
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(2, 242, 314, 47)];
    passwordView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 16, 80, 15)];
    passwordLabel.font = [UIFont systemFontOfSize:15];
    passwordLabel.text = @"更改密码";
    [passwordView addSubview:passwordLabel];
    UIControl *changePwdCtl = [[UIControl alloc] initWithFrame:CGRectMake(254, 1, 60, 45)];
    changePwdCtl.backgroundColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    UIImageView *buttonView = [[UIImageView alloc] initWithFrame:CGRectMake(21, 14, 18, 17)];
    buttonView.image = [UIImage imageNamed:@"forward_icon"];
    [changePwdCtl addSubview:buttonView];
    [changePwdCtl addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
    [passwordView addSubview:changePwdCtl];
    [self.view addSubview:passwordView];

    UIControl *logoutCtl = [[UIControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-96-64, self.view.bounds.size.width, 47)];
    logoutCtl.backgroundColor = [ColorHandler colorWithHexString:@"#00bfa5"];
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 47)];
    logoutLabel.font = [UIFont systemFontOfSize:15];
    logoutLabel.textAlignment = NSTextAlignmentCenter;
    logoutLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    logoutLabel.text = @"退出登录";
    [logoutCtl addSubview:logoutLabel];
    [logoutCtl addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutCtl];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)changeGender {
    genderSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    genderSheet.tag = 2;
    [genderSheet showInView:self.view];
}

- (void)changePassword {
    ChangePasswordViewController *changePasswordViewController = [ChangePasswordViewController new];
    changePasswordViewController.database = _database;
    changePasswordViewController.user = _user;
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (void)saveAccountSetting {
    _user.photo = UIImageJPEGRepresentation(_pictureView.image,1.0);
    _user.name = nicknameField.text;
    _user.gender = genderLabel2.text;
    if ([_database updateUser:_user]) {
        [self updateAccountOnServer];
        [self.delegate didFinishAccountSettingwith:_user];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)updateAccountOnServer {
    /*
    NSString *updateAccountService = @"/services/user/login";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,loginService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *emailString = [[NSString alloc] initWithFormat:@"username=%@",emailTextField.text];
    NSString *passwordString = [[NSString alloc] initWithFormat:@"password=%@",passwordTextField.text];
    NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@",emailString,passwordString];
    [request setHTTPBody:[loginDataString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //if success then login
        [self loginApp];
    }];
    
    [sessionDataTask resume];
    
    UIImage *a = [UIImage imageNamed:@"x001.jpg"];
    NSData *b = UIImageJPEGRepresentation(a, 1.0);
    NSString *c = [b base64EncodedStringWithOptions:0];
    */
}

- (void)resignKeyBoard {
    [nicknameField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)logout {
    //TODO
    //Save the changes! logout will be done later!
    UserLogonViewController *logonViewController = [UserLogonViewController new];
    logonViewController.database = _database;
    //[self.navigationController pushViewController:logonViewController animated:YES];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
    [self.navigationController presentViewController:navigation animated:YES completion:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"isLogin"];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [_pictureView setImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark UITextViewDelegate
- (void)textFieldDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    NSInteger offset = 65;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextView *)textView {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 64.0f, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
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
    if (actionSheet.tag == 2) {
        switch (buttonIndex) {
            case 0:
                genderLabel2.text = @"男";
                break;
            case 1:
                genderLabel2.text = @"女";
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
        picker.allowsEditing = YES;
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


@end

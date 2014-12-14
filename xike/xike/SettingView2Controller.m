//
//  SettingView2Controller.m
//  xike
//
//  Created by Leading Chen on 14/12/5.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "SettingView2Controller.h"
#import "ColorHandler.h"
#import "Contants.h"
#import "AboutUSViewController.h"
#import "SuggestionViewController.h"
#import "ChangePasswordViewController.h"
#import "UserLogonViewController.h"

@interface SettingView2Controller ()

@end

@implementation SettingView2Controller {
    UIActionSheet *myActionSheet;
    UIActionSheet *genderSheet;
    UITextField *nicknameField;
    UIGestureRecognizer *tapGestureRecognizer;
    UILabel *genderLabel2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitle:@"个人设置"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *returnBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnToPreviousView)];
    [self.navigationItem setLeftBarButtonItem:returnBtn];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveSetting)];
    [self.navigationItem setRightBarButtonItem:saveButtonItem];

    [self buildView];
}

- (void)buildView {
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    //User Picture
    UIControl *pictureContentView = [[UIControl alloc] initWithFrame:CGRectMake(4, 4+64, self.view.bounds.size.width-8, 90)];
    pictureContentView.layer.borderWidth = 0.5f;
    pictureContentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    pictureContentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    [pictureContentView addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *picLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 30, 90)];
    picLabel.text = @"头像";
    picLabel.font = [UIFont systemFontOfSize:15];
    picLabel.textAlignment = NSTextAlignmentCenter;
    [pictureContentView addSubview:picLabel];
    
    UIImageView *picBorderView = [[UIImageView alloc] initWithFrame:CGRectMake(pictureContentView.bounds.size.width-9-70, 10, 70, 70)];
    picBorderView.backgroundColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    picBorderView.layer.cornerRadius = CGRectGetHeight(picBorderView.bounds) / 2;
    picBorderView.clipsToBounds = YES;
    [pictureContentView addSubview:picBorderView];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 64, 64)];
    _pictureView.layer.cornerRadius = CGRectGetHeight(_pictureView.bounds) / 2;
    _pictureView.clipsToBounds = YES;
    if (_user.photo) {
        _pictureView.image = [UIImage imageWithData:_user.photo];
    } else {
        _pictureView.image = [UIImage imageNamed:@"user_pic_default.png"];
    }
    [picBorderView addSubview:_pictureView];
    
    [self.view addSubview:pictureContentView];
    
    //User nickname
    UIView *nicknameContentView = [[UIView alloc] initWithFrame:CGRectMake(4, 4+64+90+4, self.view.bounds.size.width-8, 48)];
    nicknameContentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    nicknameContentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    nicknameContentView.layer.borderWidth = 0.5f;
    
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 30, 48)];
    nicknameLabel.textAlignment = NSTextAlignmentCenter;
    nicknameLabel.font = [UIFont systemFontOfSize:15];
    nicknameLabel.text = @"昵称";
    [nicknameContentView addSubview:nicknameLabel];
    
    nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, nicknameContentView.bounds.size.width-45-15, 48)];
    nicknameField.textAlignment = NSTextAlignmentRight;
    nicknameField.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    nicknameField.font = [UIFont systemFontOfSize:15];
    nicknameField.delegate = self;
    if (_user.name) {
        nicknameField.text = _user.name;
    } else {
        nicknameField.text = @"";
    }
    
    [nicknameContentView addSubview:nicknameField];
    [self.view addSubview:nicknameContentView];
    
    //User's gender
    UIControl *genderContentView = [[UIControl alloc] initWithFrame:CGRectMake(4, 4+64+90+4+47.5, self.view.bounds.size.width-8, 48)];
    genderContentView.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    genderContentView.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    genderContentView.layer.borderWidth = 0.5f;
    [genderContentView addTarget:self action:@selector(changeGender) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 30, 48)];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.font = [UIFont systemFontOfSize:15];
    genderLabel.text = @"性别";
    [genderContentView addSubview:genderLabel];
    
    genderLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, genderContentView.bounds.size.width-45-15, 48)];
    genderLabel2.textAlignment = NSTextAlignmentRight;
    genderLabel2.font = [UIFont systemFontOfSize:15];
    genderLabel2.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    if (_user.gender) {
        genderLabel2.text = _user.gender;
    } else {
        genderLabel2.text = @"男";
    }
    [genderContentView addSubview:genderLabel2];
    [self.view addSubview:genderContentView];
    
    //About US
    UIControl *aboutUSCtl = [[UIControl alloc] initWithFrame:CGRectMake(4, 4+64+90+4+47.5+48+4, self.view.bounds.size.width-8, 48)];
    aboutUSCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    aboutUSCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    aboutUSCtl.layer.borderWidth = 0.5f;
    [aboutUSCtl addTarget:self action:@selector(popAboutUS) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *aboutUSLable = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 60, 48)];
    aboutUSLable.textAlignment = NSTextAlignmentCenter;
    aboutUSLable.font = [UIFont systemFontOfSize:15];
    aboutUSLable.text = @"关于我们";
    [aboutUSCtl addSubview:aboutUSLable];
    
    UIImageView *aboutUSImageView = [[UIImageView alloc] initWithFrame:CGRectMake(aboutUSCtl.bounds.size.width-22, 17, 7, 13)];
    aboutUSImageView.image = [UIImage imageNamed:@"arrow_right"];
    [aboutUSCtl addSubview:aboutUSImageView];
    [self.view addSubview:aboutUSCtl];
    
    //Suggestion & Feedback
    UIControl *suggestionCtl = [[UIControl alloc] initWithFrame:CGRectMake(4, 4+64+90+4+47.5+48+4+47.5, self.view.bounds.size.width-8, 48)];
    suggestionCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    suggestionCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    suggestionCtl.layer.borderWidth = 0.5f;
    [suggestionCtl addTarget:self action:@selector(popSuggestion) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *suggestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 60, 48)];
    suggestionLabel.textAlignment = NSTextAlignmentCenter;
    suggestionLabel.font = [UIFont systemFontOfSize:15];
    suggestionLabel.text = @"意见反馈";
    [suggestionCtl addSubview:suggestionLabel];
    
    UIImageView *suggestionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(suggestionCtl.bounds.size.width-22, 17, 7, 13)];
    suggestionImageView.image = [UIImage imageNamed:@"arrow_right"];
    [suggestionCtl addSubview:suggestionImageView];
    [self.view addSubview:suggestionCtl];
    
    //change password
    UIControl *passwordCtl = [[UIControl alloc] initWithFrame:CGRectMake(4, 4+64+90+4+47.5+48+4+47.5+48+4, self.view.bounds.size.width-8, 48)];
    passwordCtl.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    passwordCtl.layer.borderColor = [ColorHandler colorWithHexString:@"#c7c7c7"].CGColor;
    passwordCtl.layer.borderWidth = 0.5f;
    [passwordCtl addTarget:self action:@selector(popPassword) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 60, 48)];
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.font = [UIFont systemFontOfSize:15];
    passwordLabel.text = @"修改密码";
    [passwordCtl addSubview:passwordLabel];
    
    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(passwordCtl.bounds.size.width-22, 17, 7, 13)];
    passwordImageView.image = [UIImage imageNamed:@"arrow_right"];
    [passwordCtl addSubview:passwordImageView];
    [self.view addSubview:passwordCtl];
    
    //logout
    UIControl *logoutCtl = [[UIControl alloc] initWithFrame:CGRectMake(4, self.view.bounds.size.height-61, self.view.bounds.size.width-8, 48)];
    logoutCtl.backgroundColor = [ColorHandler colorWithHexString:@"1de9b6"];
    [logoutCtl addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, logoutCtl.bounds.size.width, logoutCtl.bounds.size.height)];
    logoutLabel.textAlignment = NSTextAlignmentCenter;
    logoutLabel.font = [UIFont systemFontOfSize:15];
    logoutLabel.textColor = [ColorHandler colorWithHexString:@"#ffffff"];
    logoutLabel.text = @"退出登录";
    [logoutCtl addSubview:logoutLabel];
    [self.view addSubview:logoutCtl];
}

- (void)returnToPreviousView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignKeyBoard {
    [nicknameField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)saveSetting {
    _user.photo = UIImagePNGRepresentation(_pictureView.image);
    _user.name = nicknameField.text;
    _user.gender = genderLabel2.text;
    if ([_database updateUser:_user]) {
        [self updateAccountOnServer];
        [self uploadProfileOnServer];
        [self.delegate didFinishAccountSettingwith:_user];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (void)popAboutUS {
    AboutUSViewController *aboutUSViewController = [AboutUSViewController new];
    [self.navigationController pushViewController:aboutUSViewController animated:YES];
}

- (void)popSuggestion {
    SuggestionViewController *suggestionViewController = [SuggestionViewController new];
    suggestionViewController.user = _user;
    [self.navigationController pushViewController:suggestionViewController animated:YES];
}

- (void)popPassword {
    ChangePasswordViewController *changePasswordViewController = [ChangePasswordViewController new];
    changePasswordViewController.database = _database;
    changePasswordViewController.user = _user;
    [self.navigationController pushViewController:changePasswordViewController animated:YES];
}

- (void)logout {
    UserLogonViewController *logonViewController = [UserLogonViewController new];
    logonViewController.database = _database;
    //[self.navigationController pushViewController:logonViewController animated:YES];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:logonViewController];
    [self.navigationController presentViewController:navigation animated:YES completion:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:NO forKey:@"isLogin"];
    }];
}


- (void)updateAccountOnServer {
    
    NSString *updateAccountService = @"/services/user/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateAccountService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",_user.ID];
    NSString *nicknameString = [[NSString alloc] initWithFormat:@"nickname=%@",nicknameField.text];
    //NSString *profileString = [[NSString alloc] initWithFormat:@"profile=%@",[_user.photo base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    //NSString *parameterString = [[NSString alloc] initWithFormat:@"%@&%@&%@",IDString,nicknameString,profileString];
    NSString *parameterString = [[NSString alloc] initWithFormat:@"%@&%@",IDString,nicknameString];
    [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *err;
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([[dataDic valueForKey:@"status"] isEqualToString:@"success"]) {
            // NSLog(@"aaa");
            //What to do?
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"同步失败" message:@"请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定！", nil];
            [alertView show];
        }
        
    }];
    
    [sessionDataTask resume];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    NSInteger offset = 65;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
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
   float ORIGINAL_MAX_WIDTH = self.view.bounds.size.width;
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

//
//  UserInfoViewController.m
//  xike
//
//  Created by Leading Chen on 14-9-19.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ColorHandler.h"
#import "MainView2Controller.h"
#import "Contants.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController {
    UIImageView *picImageView;
    UITextField *nicknameTextField;
    UIGestureRecognizer *tapGestureRecognizer;
    UIActionSheet *myActionSheet;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"个人信息"];
    self.navigationController.navigationBar.barTintColor = [ColorHandler colorWithHexString:@"#1de9b6"];
    self.navigationController.navigationBar.translucent = NO;
    NSMutableDictionary *titleFont= [NSMutableDictionary new];
    [titleFont setValue:[UIColor whiteColor] forKeyPath:NSForegroundColorAttributeName];
    [titleFont setValue:[UIFont fontWithName:@"HelveticaNeue-Light" size:20] forKeyPath:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleFont;
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    doneBtn.tintColor = [UIColor whiteColor];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#ffffff"];
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    
    UIImageView *picBorderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(106, 97, 107, 107)];
    picBorderImageView.image = [UIImage imageNamed:@"pic_border"];
    [self.view addSubview:picBorderImageView];
    
    UIControl *picImageCtl = [[UIControl alloc] initWithFrame:CGRectMake(107, 98, 106, 105)];
    picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 105, 105)];
    picImageView.layer.cornerRadius = CGRectGetHeight(picImageView.bounds) / 2;
    picImageView.image = [self getDefaultUserPic];
    picImageView.clipsToBounds = YES;
    [picImageCtl addSubview:picImageView];
    [picImageCtl addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picImageCtl];
    
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 224, 150, 1)];
    line1.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 224, 1, 40)];
    line2.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(85, 264, 150, 1)];
    line3.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(235, 224, 1, 40)];
    line4.backgroundColor = [ColorHandler colorWithHexString:@"#01bfa5"];
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
    nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 238, 140, 15)];
    //nicknameTextField.textColor = [UIColor blackColor];
    nicknameTextField.textAlignment = NSTextAlignmentCenter;
    nicknameTextField.font = [UIFont systemFontOfSize:15];
    nicknameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的昵称" attributes:@{NSForegroundColorAttributeName:[ColorHandler colorWithHexString:@"#c7c7c7"]}];
    nicknameTextField.delegate = self;
    [self.view addSubview:nicknameTextField];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 405, self.view.bounds.size.width, 12)];
    tipsLabel.textColor = [ColorHandler colorWithHexString:@"#c7c7c7"];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.text = @"稀客提醒~ 上传美照可以让邀请函更加别致哦~";
    [self.view addSubview:tipsLabel];
}

- (void)resignKeyBoard {
    [nicknameTextField resignFirstResponder];
    [self.view removeGestureRecognizer:tapGestureRecognizer];
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
}

- (void)done {
    
    _user.photo = UIImagePNGRepresentation(picImageView.image);
    _user.name = nicknameTextField.text;
    if ([_database updateUser:_user]) {//update by user_id?uuid?
        [self updateAccountOnServer];
        [self uploadProfileOnServer];
    }
    MainView2Controller *mainView2Controller = [MainView2Controller new];
    mainView2Controller.database = _database;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainView2Controller];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (UIImage *)getDefaultUserPic {
    UIImage *image;
    NSString *imageName;
    int x = arc4random()%100;
    if (x >= 0 && x <= 10) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"1"];
    } else if (x >= 11 && x <= 20) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"2"];
    } else if (x >= 21 && x <= 30) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"3"];
    } else if (x >= 31 && x <= 40) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"4"];
    } else if (x >= 41 && x <= 50) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"5"];
    } else if (x >= 51 && x <= 60) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"6"];
    } else if (x >= 61 && x <= 70) {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"7"];
    } else {
        imageName = [[NSString alloc] initWithFormat:@"user_default_pic_%@",@"8"];
    }
    
    image = [UIImage imageNamed:imageName];
    return image;
}

- (void)updateAccountOnServer {
    //TODO
    NSString *updateAccountService = @"/services/user/update";
    NSString *URLString = [[NSString alloc]initWithFormat:@"%@%@",HOST,updateAccountService];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSString *IDString = [[NSString alloc] initWithFormat:@"id=%@",_user.ID];
    NSString *nicknameString = [[NSString alloc] initWithFormat:@"nickname=%@",nicknameTextField.text];
    //NSString *profileString = [[NSString alloc] initWithFormat:@"profile=%@",[self get64BasedPhoto]];
    //NSString *loginDataString = [[NSString alloc] initWithFormat:@"%@&%@&%@",IDString,nicknameString,profileString];
    NSString *parameterString = [[NSString alloc] initWithFormat:@"%@&%@",IDString,nicknameString];
    [request setHTTPBody:[parameterString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       
    }];
    
    [sessionDataTask resume];
}

- (void)uploadProfileOnServer {
    NSData *imgData = UIImageJPEGRepresentation(picImageView.image, 0.5);
    
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

- (NSString *)get64BasedPhoto {
    NSString *photo64BasedString = [_user.photo base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    //NSString *photo64BasedString = [_user.photo base64Encoding];
    return photo64BasedString;
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

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tapGestureRecognizer];
    NSInteger offset = 30;
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
    [self presentViewController:picker animated:YES completion:nil];
    // [self presentModalViewController:picker animated:YES];
}


-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
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


#pragma mark ImageCropperDelegate
- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [picImageView setImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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

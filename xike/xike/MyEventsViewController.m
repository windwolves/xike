//
//  MyEventsViewController.m
//  xike
//
//  Created by Leading Chen on 14-8-31.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MyEventsViewController.h"
#import "Contants.h"
#import "ColorHandler.h"
#import "PreViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f
@interface MyEventsViewController ()


@end

@implementation MyEventsViewController {
    NSMutableArray *eventsArray;
    UITapGestureRecognizer *tapGestureRecognizer;
    UIActionSheet *myActionSheet;
    UIImageView *tipsImageView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self buildTipsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorHandler colorWithHexString:@"#f3f3f3"];
    //self.navigationController.navigationBarHidden = YES;
    
    _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 135)];
    //user_background_imageView
    if (_user.backgroundPic) {
        _backImageView.image = [UIImage imageWithData:_user.backgroundPic];
    } else {
        _backImageView.image = [UIImage imageNamed:@"user_bg_default"];
    }

    [self.view addSubview:_backImageView];
    
    //user_pic_imageView
    UIImageView *userPicBorderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160-36, 22, 72, 72)];
    userPicBorderImageView.image = [UIImage imageNamed:@"user_pic_border"];
    
    UIControl *pictureCtl = [[UIControl alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-72+4)/2 , (44+4)/2+64, 68, 68)];
    _pictureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
    _pictureView.layer.cornerRadius = CGRectGetHeight(_pictureView.bounds) / 2;
    _pictureView.clipsToBounds = YES;
    if (_user.photo) {
        _pictureView.image = [UIImage imageWithData:_user.photo];
    } else {
        _pictureView.image = [UIImage imageNamed:@"user_pic_default"];
    }
    [pictureCtl addSubview:_pictureView];
    [pictureCtl addTarget:self action:@selector(changePic) forControlEvents:UIControlEventTouchUpInside];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 12)];
    if (_user.name) {
        _nicknameLabel.text = _user.name;
    } else {
        _nicknameLabel.text = _user.userID;
    }
    _nicknameLabel.textAlignment = NSTextAlignmentCenter;
    _nicknameLabel.textColor = [ColorHandler colorWithHexString:@"#413445"];
    _nicknameLabel.font = [UIFont systemFontOfSize:12];
    
    [_backImageView addSubview:_nicknameLabel];
    [_backImageView addSubview:userPicBorderImageView];
    //[_backImageView addSubview:pictureCtl];

    [self.view addSubview:_backImageView];
    [self.view addSubview:pictureCtl]; //TO ENABLE THE TOUCH EVENT
    
    //Events table
    _eventsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 135+64, self.view.bounds.size.width, self.view.bounds.size.height - 135 - 49-64)];
    _eventsTable.dataSource = self;
    _eventsTable.delegate = self;
    _eventsTable.backgroundColor = [UIColor whiteColor];
    _eventsTable.rowHeight = 85;
    [_eventsTable registerClass:[EventsTableViewCell class] forCellReuseIdentifier:@"EventCell"];
    
    
    //[self.view addSubview:_eventsTable];
    
}

- (void)buildTipsView {
    eventsArray = [_database getAllEvents :_user];
    [_eventsTable removeFromSuperview];
    [tipsImageView removeFromSuperview];
    if (eventsArray.count == 0) {
        tipsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-125)/2, 350+64, 125, 86)];
        tipsImageView.image = [UIImage imageNamed:@"event_tips"];
        [self.view addSubview:tipsImageView];
    } else {
        [self.view addSubview:_eventsTable];
        [_eventsTable reloadData];
    }
}

- (void)changePic {
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从手机相册获取", nil];
    myActionSheet.tag = 1;
    [myActionSheet showInView:self.view];
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
#pragma mark UITableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    [cell setEvent:[eventsArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       //Delete the event
        EventInfo *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
        [_database deleteEvent:eventToDelete];
        eventsArray = [_database getAllEvents :_user];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self buildTipsView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PreViewController *preViewController = [PreViewController new];
    preViewController.database = _database;
    preViewController.event = [eventsArray objectAtIndex:indexPath.row];
    preViewController.fromController = @"eventsTable";
    [self.navigationController pushViewController:preViewController animated:YES];
}

#pragma mark EventsTableViewCellDelegate
- (TemplateInfo *)getTemplateByID:(NSString *)templateID {
    TemplateInfo *template = [_database getTemplate:templateID];
    return template;
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


@end

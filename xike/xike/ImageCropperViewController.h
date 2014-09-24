//
//  ImageCropperViewController.h
//  xike
//
//  Created by Leading Chen on 14-9-23.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCropperViewController;

@protocol ImageCropperDelegate <NSObject>

- (void)imageCropper:(ImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(ImageCropperViewController *)cropperViewController;

@end

@interface ImageCropperViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<ImageCropperDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;


@end

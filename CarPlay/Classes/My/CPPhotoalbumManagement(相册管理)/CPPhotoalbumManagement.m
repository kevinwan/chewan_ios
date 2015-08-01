//
//  CPPhotoalbumManagement.m
//  CarPlay
//
//  Created by 公平价 on 15/7/29.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPPhotoalbumManagement.h"
#import <UzysAssetsPickerController/UzysWrapperPickerController.h>
#import "UzysAssetsPickerController.h"
#import "CPEditImageView.h"

@interface CPPhotoalbumManagement ()< UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate>
@property (nonatomic, assign) CGFloat photoWH;
@property (nonatomic, strong) NSMutableArray *editPhotoViews;
@property (nonatomic, assign) NSUInteger picIndex;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, assign) CGFloat photoViewHeight;
@end

@implementation CPPhotoalbumManagement

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPhotos:_albumPhotos];
    self.photoWH = (kScreenWidth - 50) / 4;
    self.picIndex = 10;
    self.photoViewHeight = self.photoWH + 20;
    UIButton *addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.tag = 9;
    addPhotoBtn.frame = CGRectMake(10, 76, self.photoWH, self.photoWH);
    [addPhotoBtn setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [addPhotoBtn setImage:[UIImage imageNamed:@"大相机"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:addPhotoBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [self layoutPhotoView];
}

- (NSMutableArray *)editPhotoViews
{
    if (_editPhotoViews == nil) {
        _editPhotoViews = [NSMutableArray array];
    }
    return _editPhotoViews;
}

- (UIBarButtonItem *)rightItem
{
    if (_rightItem == nil) {
        _rightItem = [UIBarButtonItem itemWithNorImage:@"删除" higImage:nil title:nil target:self action:@selector(showAlertIfDelete)];
    }
    return _rightItem;
}

#pragma mark - 添加相片的相关方法
- (void)addPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            pick.delegate = self;
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:pick animated:YES completion:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:@"相机不可用"];
        }
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.maximumNumberOfSelectionPhoto = 10 - self.photoView.subviews.count;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}
/**
 *  照片选择完毕
 *
 *  @param picker picker description
 *  @param info   info description
 */

#pragma mark - <UZYImagePickerController>

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSMutableArray *arr = [NSMutableArray array];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        [arr addObject:img];
    }];
    [self addPhoto:arr];
    [SVProgressHUD showWithStatus:@"加载中"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    [self showAlert];
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"您最多只能上传9张图片"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  系统的拍照完毕方法
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self addPhoto:@[portraitImg]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    DLog(@"系统的....");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  添加图片
 */
- (void)addPhoto:(NSArray *)arr
{
    if (self.photoView.subviews.count + arr.count > 10){
        [self showAlert];
        return;
    }
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/album/upload?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    for (int i = 0; i < arr.count; i++) {
        CPHttpFile *imageFile = [CPHttpFile fileWithName:@"a1.jpg" data:UIImageJPEGRepresentation(arr[i], 0.4) mimeType:@"image/jpeg" filename:@"a1.jpg"];
        
        [CPNetWorkTool postFileWithUrl:path params:nil files:@[imageFile] success:^(id responseObject) {
            if (CPSuccess) {
                CPEditImageView *imageView = [[CPEditImageView alloc] init];
                imageView.image = arr[i];
                imageView.tag = self.picIndex++;
                UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                [imageView addGestureRecognizer:longPressGes];
                [self.photoView insertSubview:imageView atIndex:0];
            }
        } failure:^(NSError *error) {
            [self showError:@"照片上传失败"];
        }];
    }
    [self layoutPhotoView];
}

/**
 *  长按的选中效果
 *
 *  @param recognizer
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CPEditImageView *editImageView = (CPEditImageView *)recognizer.view;
        if (editImageView.select) {
            [self.editPhotoViews removeObject:editImageView];
        }else{
            [self.editPhotoViews addObject:editImageView];
        }
        editImageView.showSelectImage = !editImageView.select;
        
        if (self.editPhotoViews.count > 0){
            self.navigationItem.rightBarButtonItem = self.rightItem;
        }else{
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

#pragma mark - 处理图片的编辑
/**
 *  取消所有照片的选中
 */
- (void)cancleEditPhotoSelect
{
    for (int i = 0; i < self.photoView.subviews.count; i++) {
        UIView *subView = self.photoView.subviews[i];
        if ([subView isKindOfClass:[CPEditImageView class]]) {
            CPEditImageView *editView = (CPEditImageView *)subView;
            editView.showSelectImage = NO;
        }
    }
    self.navigationItem.rightBarButtonItem = nil;
}

/**
 *  提示是否删除
 */
- (void)showAlertIfDelete
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除选中的图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    [self deleteSelectPhoto];
}

/**
 *  删除选中的图片
 */
- (void)deleteSelectPhoto
{
    [self.editPhotoViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.editPhotoViews removeAllObjects];
    [self layoutPhotoView];
    self.navigationItem.rightBarButtonItem = nil;
}
/**
 *  重新布局photoView
 */
- (void)layoutPhotoView
{
    
    CGFloat imgW = self.photoWH;
    CGFloat imgH = imgW;
    NSUInteger count = self.photoView.subviews.count;
    for (int i = 0; i < count; i++) {
        UIView *subView = self.photoView.subviews[i];
        subView.x = 10 + (i % 4) * (10 + imgW);
        subView.y = 76 + (i / 4) * (10 + imgH);
        subView.width = imgW;
        subView.height = imgH;
    }
    NSUInteger column = (count % 4 == 0) ? count / 4 : (count / 4 + 1);
    self.photoViewHeight = column * (imgH + 10) + 10;
//    self.photoView.height = self.photoViewHeight;
}

-(void)loadPhotos:(NSArray *)photos{
    if (self.photoView.subviews.count + photos.count > 10){
        [self showAlert];
        return;
    }
    
    for (int i = 0; i < photos.count; i++) {
        CPEditImageView *imageView = [[CPEditImageView alloc] init];
        NSURL *url=[[NSURL alloc]initWithString:photos[i]];
        [imageView sd_setImageWithURL:url];
      
        imageView.tag = self.picIndex++;
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [imageView addGestureRecognizer:longPressGes];
        [self.photoView insertSubview:imageView atIndex:0];
    }
    [self layoutPhotoView];
}

@end

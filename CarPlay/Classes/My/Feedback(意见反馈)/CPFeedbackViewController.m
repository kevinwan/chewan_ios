//
//  CPFeedbackViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/8/1.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPFeedbackViewController.h"
#import <UzysAssetsPickerController/UzysWrapperPickerController.h>
#import "UzysAssetsPickerController.h"
#import "CPEditImageView.h"
#import "CPCreatActivityCell.h"

@interface CPFeedbackViewController ()< UIActionSheetDelegate,UIImagePickerControllerDelegate, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate,UITextViewDelegate>{
    NSMutableArray *photoIds;
    
}
@property (nonatomic, assign) CGFloat photoWH;
@property (nonatomic, strong) NSMutableArray *editPhotoViews;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, assign) NSUInteger picIndex;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) UIBarButtonItem *rightItem1;
@property (nonatomic, strong) UIBarButtonItem *leftItem;
@property (nonatomic, strong) UIBarButtonItem *leftItem1;
@property (nonatomic, assign) CGFloat photoViewHeight;
@property (nonatomic, strong) UIView *photoView;
@property (nonatomic, assign) BOOL imageEditing;
@end

@implementation CPFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgs=[[NSMutableArray alloc]init];
    photoIds=[[NSMutableArray alloc]init];
    self.navigationItem.title=@"意见反馈";
    self.tableView.tableFooterView=[UIView new];
    self.tableView.bounces=NO;
    self.photoWH = (kScreenWidth - 50) / 4;
    self.photoViewHeight = self.photoWH + 20;
    self.navigationItem.rightBarButtonItem=self.rightItem1;
    //    点击其他地方隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self setUpCellOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)imgs{
    if (_imgs==nil) {
        _imgs=[[NSMutableArray alloc]init];
    }
    return _imgs;
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

- (UIBarButtonItem *)rightItem1
{
    if (_rightItem1 == nil) {
        _rightItem1 = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"提交" target:self action:@selector(submit)];
    }
    return _rightItem1;
}

- (UIBarButtonItem *)leftItem
{
    if (_leftItem == nil) {
        _leftItem = [UIBarButtonItem itemWithNorImage:@"返回" higImage:nil title:nil target:self action:@selector(goBack)];
    }
    return _leftItem;
}

- (UIBarButtonItem *)leftItem1
{
    if (_leftItem1 == nil) {
        _leftItem1 = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"取消" target:self action:@selector(cancleEditPhotoSelect)];
    }
    return _leftItem1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return self.photoViewHeight;
    }else
        return 92.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            picker.maximumNumberOfSelectionPhoto = 5 - self.photoView.subviews.count;
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
    [_imgs addObjectsFromArray:arr];
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
                                                    message:@"您最多只能上传3张图片"
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
    [_imgs addObject:@[portraitImg]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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

    for (int i = 0; i < arr.count; i++) {
                CPEditImageView *imageView = [[CPEditImageView alloc] init];
                imageView.image = arr[i];
                imageView.tag = self.picIndex++;
                UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                [imageView addGestureRecognizer:longPressGes];
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
                [imageView addGestureRecognizer:tapGes];
                [self.photoView insertSubview:imageView atIndex:0];
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
        self.imageEditing = YES;
        [self dealImageViewTapWithRecognizer:recognizer];
    }
}

- (void)tapPress:(UITapGestureRecognizer *)recognizer
{
    if (self.imageEditing) {
        [self dealImageViewTapWithRecognizer:recognizer];
    }
}

/**
 *  处理图片手势的触发
 *
 *  @param recognizer recognizer description
 */
- (void)dealImageViewTapWithRecognizer:(UIGestureRecognizer *)recognizer
{
    CPEditImageView *editImageView = (CPEditImageView *)recognizer.view;
    
    if (editImageView.select) {
        [self.editPhotoViews removeObject:editImageView];
    }else{
        [self.editPhotoViews addObject:editImageView];
    }
    editImageView.showSelectImage = !editImageView.select;
    
    if (self.editPhotoViews.count > 0){
        self.navigationItem.rightBarButtonItem = self.rightItem;
        self.navigationItem.leftBarButtonItem = self.leftItem1;
    }else{
        self.imageEditing = NO;
        self.navigationItem.rightBarButtonItem = self.rightItem1;
        self.navigationItem.rightBarButtonItem = self.leftItem;
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
    self.navigationItem.rightBarButtonItem = self.rightItem1;
    self.navigationItem.leftBarButtonItem = self.leftItem;
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
    self.navigationItem.rightBarButtonItem = self.rightItem1;
    self.navigationItem.leftBarButtonItem = self.leftItem;
}
/**
 *  重新布局photoView
 */
- (void)layoutPhotoView
{

    CGFloat imgW = self.photoWH;
    CGFloat imgH = imgW;
    NSUInteger count = self.photoView.subviews.count;
    NSUInteger column = ((count-2) % 4 == 0) ? (count-2) / 4 : ((count-2) / 4 + 1);
    for (int i = 0; i < count; i++) {
        UIView *subView = self.photoView.subviews[i];
        if (i==count-2) {
            subView.x=10;
            subView.y=10 + column * (10 + imgH);
            subView.width = imgW;
            subView.height = imgH;
        }else if (i==count-1){
            subView.x=20+imgW;
            subView.y=10 + column * (10 + imgH);
            subView.width = 180.0f;
            subView.height = imgH;
        }else{
            subView.x = 10 + (i % 4) * (10 + imgW);
            subView.y = 10 + (i / 4) * (10 + imgH);
            subView.width = imgW;
            subView.height = imgH;
        }
    }
    
    self.photoViewHeight = (column+1) * (imgH + 10) + 10;
    self.photoView.height = self.photoViewHeight;
    [self.tableView reloadData];
}

#pragma mark - 添加相片的相关方法#pragma mark - 添加相片的相关方法
- (IBAction)addImg:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请简要描述你的问题和意见"]) {
        textView.text=@"";
        [textView setTextColor:[UIColor blackColor]];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text=@"请简要描述你的问题和意见";
        [textView setTextColor:[Tools getColor:@"aab2bd"]];
    }
}


/**
 *  进行cell操作的封装
 */
- (void)setUpCellOperation
{
    CPCreatActivityCell *activityPhotoCell = [self cellWithRow:0];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.photoViewHeight)];
    [activityPhotoCell.contentView addSubview:photoView];
    self.photoView = photoView;
    
    UIButton *addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoBtn.tag = 9;
    addPhotoBtn.frame = CGRectMake(10, 10, self.photoWH, self.photoWH);
    [addPhotoBtn setBackgroundColor:[Tools getColor:@"ccd1d9"]];
    [addPhotoBtn setImage:[UIImage imageNamed:@"大相机"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(addPhotoBtn.right+10, addPhotoBtn.centerY-10, 180, 20)];
    lable.text=@"上传问题图片（选填）";
    lable.textColor=[Tools getColor:@"aab2bd"];
    lable.font=[UIFont systemFontOfSize:16.0f];
    
    [photoView addSubview:addPhotoBtn];
    
    [photoView addSubview:lable];
}

/**
 *  返货获取到得cell
 *
 *  @param row 行号
 */
- (CPCreatActivityCell *)cellWithRow:(NSUInteger)row
{
    return  (CPCreatActivityCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
}

#pragma mark - 添加相片的相关方法
- (void)addPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
}

-(void)submit{
        if (![Tools isEmptyOrNull:self.contentTextView.text] && ![self.contentTextView.text isEqualToString:@"请简要描述你的问题和意见"]) {
            if (_imgs.count) {
                for (int i = 0; i < _imgs.count; i++) {
                    ZYHttpFile *imageFile = [ZYHttpFile fileWithName:@"a1.jpg" data:UIImageJPEGRepresentation(_imgs[i], 0.4) mimeType:@"image/jpeg" filename:@"a1.jpg"];
                    [ZYNetWorkTool postFileWithUrl:@"v1/feedback/upload" params:nil files:@[imageFile] success:^(id responseObject) {
                        if (CPSuccess) {
                            NSDictionary *data=[responseObject objectForKey:@"data"];
                            [photoIds insertObject:[data objectForKey:@"photoId"] atIndex:0];
                            if (i == _imgs.count-1) {
                                NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:photoIds,@"photos",self.contentTextView.text,@"content",[Tools getValueFromKey:@"userId"],@"userId",[Tools getValueFromKey:@"token"],@"token", nil];
                                [ZYNetWorkTool postJsonWithUrl:@"v1/feedback/submit" params:params success:^(id responseObject) {
                                    if (CPSuccess) {
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的反馈" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                                        [alertView show];
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        [self showError:responseObject[@"errmsg"]];
                                    }
                                } failed:^(NSError *error) {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的反馈提交失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                                    [alertView show];
                                }];
                            }
                        }else{
                            [self showError:responseObject[@"errmsg"]];
                        }
                    } failure:^(NSError *error) {
                        [self showError:@"照片上传失败"];
                    }];
                }
            }else{
                NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"photos",self.contentTextView.text,@"content",[Tools getValueFromKey:@"userId"],@"userId",[Tools getValueFromKey:@"token"],@"token", nil];
                NSLog(@"%@",params);
                [ZYNetWorkTool postJsonWithUrl:@"v1/feedback/submit" params:params success:^(id responseObject) {
                    if (CPSuccess) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"感谢您的反馈" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alertView show];
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [self showError:responseObject[@"errmsg"]];
                    }
                } failed:^(NSError *error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的反馈提交失败，请稍后再试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alertView show];
                }];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请简要描述你的问题和意见" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alertView show];
        }
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

//    点击其他地方隐藏键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}
@end

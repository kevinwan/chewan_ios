//
//  CPAvatarAuthenticationController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPAvatarAuthenticationController.h"

@interface CPAvatarAuthenticationController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIImage *editedImage;
    NSString *photoId;
}
@end

@implementation CPAvatarAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.submitBtn.layer setMasksToBounds:YES];
    [self.submitBtn.layer setCornerRadius:20.0];
    [self.navigationItem setTitle:@"头像认证"];
    [self.headImg.layer setMasksToBounds:YES];
    [self.headImg.layer setCornerRadius:3.0];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPhoto:)];
    [self.headImg addGestureRecognizer:tapGesture];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    if ([_user.photoAuthStatus isEqualToString:@"认证中"]) {
        [self.submitBtn setEnabled:NO];
        [self.submitBtn setBackgroundColor:GrayColor];
    }
    if (_user.photo) {
        [_headImg zySetImageWithUrl:_user.photo placeholderImage:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)selectPhoto:(UITapGestureRecognizer *)tapGes{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    [sheet showInView:self.view];
}

#pragma actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else if (buttonIndex == 0){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            DLog(@"相机不可用");
            return;
        }
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else
        return;
}

#pragma PickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
        [self upLoadImageWithBase64Encodeing:data];
        
    }];
}

-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"attach";
    file.data=encodedImageData;
    file.filename=@"photo.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    NSString *path=[NSString stringWithFormat:@"user/%@/photo/upload?token=%@",CPUserId,CPToken];
    [ZYNetWorkTool postFileWithUrl:path params:nil files:files success:^(id responseObject){
        if (CPSuccess) {
            photoId=responseObject[@"data"][@"photoId"];
            [self.headImg setImage:editedImage];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }failure:^(NSError *erro){
        [self showInfo:@"请检查您的手机网络!"];
    }];
}

- (IBAction)submit:(id)sender {
    if (photoId) {
        NSString *path=[NSString stringWithFormat:@"user/%@/photo/authentication?token=%@",CPUserId,CPToken];
        NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:photoId,@"photoId", nil];
        [ZYNetWorkTool postJsonWithUrl:path params:params success:^(id responseObject) {
            if (CPSuccess) {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"认证提交成功，请等待审核" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSString *msg=[NSString stringWithFormat:@"%@",responseObject[@"errmsg"]];
                 [[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        } failed:^(NSError *error) {
            [self showInfo:@"请检查您的手机网络!"];
        }];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的头像!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}


@end

//
//  CPCarOwnersCertificationController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/15.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPCarOwnersCertificationController.h"
#import "CPBrandModelViewController.h"
#import "CPUser.h"

@interface CPCarOwnersCertificationController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    CPUser *user;
    NSString *path;
    NSInteger selectRow;
}
@end

@implementation CPCarOwnersCertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    path=[NSString stringWithFormat:@"%@.info",CPUserId];
    selectRow=1;
    [self.submitBtn.layer setMasksToBounds:YES];
    [self.submitBtn.layer setCornerRadius:20.0];
    [self.navigationItem setTitle:@"车主认证"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    user=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CPBrandModelViewController *CPBrandModelVC=[[CPBrandModelViewController alloc]init];
        CPBrandModelVC.title=@"车型选择";
        [self.navigationController pushViewController:CPBrandModelVC animated:YES];
    }else{
        if (indexPath.row==2) {
            selectRow=2;
        }else{
            selectRow=1;
        }
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
        [sheet showInView:self.view];
    }
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
    UIImage *editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
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
    NSString *urlPath=[NSString stringWithFormat:@"user/%@/drivingLicense/upload?token=%@",CPUserId,CPToken];
    if (selectRow==2) {
        urlPath=[NSString stringWithFormat:@"user/%@/driverLicense/upload?token=%@",CPUserId,CPToken];
    }
    [self showLoading];
    [ZYNetWorkTool postFileWithUrl:urlPath params:nil files:files success:^(id responseObject){
        if (CPSuccess) {
            if (selectRow==2) {
                user.driverLicenseId=responseObject[@"data"][@"photoId"];
            }else{
                user.drivingLicenseId=responseObject[@"data"][@"photoId"];
            }
            [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
        [self disMiss];
    }failure:^(NSError *erro){
        [self disMiss];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}
- (IBAction)submit:(id)sender {
    CPUser *lastDataUser=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
    
    if (lastDataUser.car) {
        if (lastDataUser.drivingLicenseId) {
            if (lastDataUser.driverLicenseId) {
                NSString *urlPath=[NSString stringWithFormat:@"user/%@/license/authentication?token=%@",CPUserId,CPToken];
                NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:lastDataUser.car.brand,@"brand",lastDataUser.car.model,@"model",lastDataUser.car.logo,@"logo",lastDataUser.drivingLicenseId,@"drivingLicense",lastDataUser.driverLicenseId,@"driverLicense", nil];
                [self showLoading];
                [ZYNetWorkTool postJsonWithUrl:urlPath params:params success:^(id responseObject) {
                    if (CPSuccess) {
                        NSLog(@"成功了");
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"errmsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                    [self disMiss];
                } failed:^(NSError *error) {
                    [self disMiss];
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请您的检查手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }];
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的驾驶证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的行驶证" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择车型" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}
@end

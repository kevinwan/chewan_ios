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

@interface CPCarOwnersCertificationController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
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
    if (user.car.brand) {
        self.bandName.text=user.car.model;
        CGSize labelsize = [user.car.model sizeWithFont:ZYFont12];
        self.bandNameWidth.constant=labelsize.width+2;
    }
    if (user.car.logo) {
        [self.logo zySetImageWithUrl:user.car.logo placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    [self reloadCarOwnersInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        picker.allowsEditing=NO;
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
        picker.allowsEditing=NO;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }else
        return;
}

#pragma PickerController
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
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
                user.driverLicense=responseObject[@"data"][@"photoUrl"];
            }else{
                user.drivingLicenseId=responseObject[@"data"][@"photoId"];
                user.drivingLicense=responseObject[@"data"][@"photoUrl"];
            }
            [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
            [self reloadCarOwnersInfo];
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
                NSArray *array = [lastDataUser.car.logo componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
                
                NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:lastDataUser.car.brand,@"brand",lastDataUser.car.model,@"model",[array lastObject],@"logo",lastDataUser.drivingLicenseId,@"drivingLicense",lastDataUser.driverLicenseId,@"driverLicense", nil];
                [self showLoading];
                [ZYNetWorkTool postJsonWithUrl:urlPath params:params success:^(id responseObject) {
                    if (CPSuccess) {
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"认证提交成功，请等待审核！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                        [self.navigationController popViewControllerAnimated:YES];
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

-(void)reloadCarOwnersInfo{
    if (user.drivingLicense) {
        [self.uploadDrivingLicense zySetImageWithUrl:user.drivingLicense placeholderImage:nil forState:UIControlStateNormal];
//        self.uploadDriverLicense
    }
    if (user.driverLicense) {
//        [self.driverLicenseImageView zySetImageWithUrl:user.driverLicense placeholderImage:nil];
        [self.uploadDriverLicense zySetImageWithUrl:user.driverLicense placeholderImage:nil forState:UIControlStateNormal];
    }
}
- (IBAction)upload:(UIButton *)sender {
    selectRow=sender.tag;
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    [sheet showInView:self.view];
}
@end

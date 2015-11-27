//
//  CPEditInfoViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/20.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPEditInfoViewController.h"
#import "CPAvatarAuthenticationController.h"
#import "CPCarOwnersCertificationController.h"
#import "CPUser.h"
#import "CPEditUsername.h"
#import "ZHPickView.h"

@interface CPEditInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,ZHPickViewDelegate>
{
    UIImage *editedImage;
    CPUser *user;
    NSString *path;
}
@end

@implementation CPEditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"编辑资料"];
//    [self setRightNavigationBarItemWithTitle:@"保存" Image:nil highImage:nil target:self action:@selector(rightClick)];
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius:20.0];
    [self.tableView setBackgroundColor:[Tools getColor:@"efefef"]];
    path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
}

-(void)viewWillAppear:(BOOL)animated{
    user=[NSKeyedUnarchiver unarchiveObjectWithFile:path.documentPath];
    [self.avatar zySetImageWithUrl:user.avatar placeholderImage:nil];
    [self.nickName setText:user.nickname];
    [self.sex setText:user.gender];
    [self.age setText:[NSString stringWithFormat:@"%zd",user.age]];
    [self.photoAuthStatus setText:user.photoAuthStatus];
    [self.licenseAuthStatus setText:user.licenseAuthStatus];
    if ([user.photoAuthStatus isEqualToString:@"认证通过"]) {
        self.right1.constant=-8.0;
        [self.rightArrow1 setHidden:YES];
    }
    
    if ([user.licenseAuthStatus isEqualToString:@"认证通过"]) {
        self.right2.constant=-8.0;
        [self.rightArrow2 setHidden:YES];
    }
    
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView setFrame:CGRectMake(0, 10, ZYScreenWidth, ZYScreenHeight-10)];
}
#pragma tableViewDeleget
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            actionSheet.tag=1;
            [actionSheet showInView:self.view];
        }
            break;
        case 2:
        {
            CPEditUsername *editNickName=[UIStoryboard storyboardWithName:@"CPEditUsername" bundle:nil].instantiateInitialViewController;
            editNickName.user=user;
            [self.navigationController pushViewController:editNickName animated:YES];
        }
            break;
        case 4:
//        {
//            NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//            NSString *str = @"1990年01月01号";
//            fmt.dateFormat = @"yyyy年MM月dd号";
//            NSDate *defualtDate = [fmt dateFromString:str];
//            _pickview=[[ZHPickView alloc] initDatePickWithDate:defualtDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
//            _pickview.delegate=self;
//            [_pickview show];
//        }
            break;
        case 5:
        {
            if (![user.photoAuthStatus isEqualToString:@"认证通过"]) {
                CPAvatarAuthenticationController *CPAvatarAuthenticationController = [UIStoryboard storyboardWithName:@"CPAvatarAuthenticationController" bundle:nil].instantiateInitialViewController;
                CPAvatarAuthenticationController.user = user;
                [self.navigationController pushViewController:CPAvatarAuthenticationController animated:YES];
            }
            break;
        }
        case 6:
        {
            if (![user.licenseAuthStatus isEqualToString:@"认证通过"]) {
                CPCarOwnersCertificationController *CPCarOwnersCertification = [UIStoryboard storyboardWithName:@"CPCarOwnersCertification" bundle:nil].instantiateInitialViewController;
                CPCarOwnersCertification.user = user;
                [self.navigationController pushViewController:CPCarOwnersCertification animated:YES];
            }
            break;
        }
            
        default:
            break;
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
    editedImage=[info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
//        [[SDImageCache sharedImageCache] removeImageForKey:user.avatar];
        [self upLoadImageWithBase64Encodeing:data];
    }];
}

//上传头像
-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"attach";
    file.data=encodedImageData;
    file.filename=@"avatar.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    NSString *urlPath=[NSString stringWithFormat:@"user/%@/avatar?token=%@",[Tools getUserId],[Tools getToken]];
    [self showLoading];
    [ZYNetWorkTool postFileWithUrl:urlPath params:nil files:files success:^(id responseObject){
        if (CPSuccess) {
            user.avatar=responseObject[@"data"][@"photoUrl"];
            user.avatarId=responseObject[@"data"][@"photoId"];
            [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
            [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
            [self.avatar zySetReloadImageWithUrl:user.avatar placeholderImage:editedImage completion:nil];
            
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
        [self disMiss];
    }failure:^(NSError *erro){
        [self showInfo:@"请检查您的手机网络!"];
        [self disMiss];
    }];
}

#pragma mark ZhpickVIewDelegate
//
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormtter dateFromString:resultString];
    user.brithDay=date.timeIntervalSince1970 * 1000;
    NSString *urlPath=[NSString stringWithFormat:@"user/%@/info?token=%@",CPUserId,CPToken];
    NSString *savePath=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
    NSDictionary *params=[[NSDictionary alloc]initWithObjectsAndKeys:@(user.brithDay),@"birthday", nil];
    [self showLoading];
    [ZYNetWorkTool postJsonWithUrl:urlPath params:params success:^(id responseObject) {
        [self disMiss];
        if (CPSuccess) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *cmps = [calendar components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
            user.age=[cmps year];
            [NSKeyedArchiver archiveRootObject:user toFile:savePath.documentPath];
            [self.age setText:[NSString stringWithFormat:@"%ld",user.age]];
        }else{
            [self showInfo:@"年龄修改失败，请稍候再试"];
        }
        
    } failed:^(NSError *error) {
        [self disMiss];
        [self showInfo:@"请检查您的手机网络!"];
    }];
}

@end

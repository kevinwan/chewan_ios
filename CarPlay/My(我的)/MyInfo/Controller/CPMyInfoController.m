//
//  CPMyInfoController.m
//  CarPlay
//
//  Created by 公平价 on 15/10/12.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMyInfoController.h"
#import "CPUser.h"

@interface CPMyInfoController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIImage *editedImage;
}

@end

@implementation CPMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"个人信息";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:nil higImage:nil title:@"完成" target:self action:@selector(finish)];
    self.tableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    
    self.view.backgroundColor=[Tools getColor:@"efefef"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_user) {
        [self.userHeadIcon zySetImageWithUrl:_user.avatar placeholderImage:nil];
        [self.nick setText:_user.nickname];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSString *str = @"1990年01月01号";
        fmt.dateFormat = @"yyyy年MM月dd号";
        NSDate *defualtDate = [fmt dateFromString:str];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:defualtDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
//    NSDate *brithDay=[[NSDate alloc]initWithTimeIntervalSinceNow:[resultString doubleValue]];
    
//    long brith=[resultString longLongValue]*1000;
//    _user.brithDay=brith;
    
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormtter dateFromString:resultString];
    _user.brithDay=date.timeIntervalSince1970 * 1000;
    NSString * dateToString = [fmt stringFromDate:date];
    self.brithDay.text=dateToString;
}

- (void)finish{
    if (_user.avatar && ![_user.avatar isEqualToString:@""]) {
        if (self.nick.text && ![self.nick.text isEqualToString:@""]) {
            if (_user.gender && ![_user.gender isEqualToString:@""]) {
                if (_user.brithDay) {
                    NSLog(@"ZYLongitude%f,-------ZYLatitude%f",ZYLongitude,ZYLatitude);
                    NSDictionary *landmark=[[NSDictionary alloc]initWithObjectsAndKeys:@(ZYLongitude),@"longitude",@(ZYLatitude),@"latitude", nil];
                    NSDictionary *paras=[[NSDictionary alloc]initWithObjectsAndKeys:_user.phone,@"phone",_code,@"code",_password,@"password",self.nick.text,@"nickname",_user.gender,@"gender",@(_user.brithDay),@"birthday",_user.avatarId,@"avatar",landmark,@"landmark",nil];
                    
                    [ZYNetWorkTool postJsonWithUrl:@"user/register" params:paras success:^(id responseObject) {
                        if (CPSuccess) {
                            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[Tools md5EncryptWithString:responseObject[@"data"][@"userId"]] password:_password completion:^(NSDictionary *loginInfo, EMError *error) {
                                if (!error) {
                                    //存储个人信息
                                    CPUser * user = [CPUser objectWithKeyValues:responseObject[@"data"]];
                                    NSString *path=[[NSString alloc]initWithFormat:@"%@.info",[Tools getUserId]];
                                    [NSKeyedArchiver archiveRootObject:user toFile:path.documentPath];
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"nickname"] forKey:kUserNickName];
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"avatar"] forKey:kUserHeadUrl];
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"age"] forKey:kUserAge];
                                    [ZYUserDefaults setObject:responseObject[@"data"][@"gender"] forKey:KUserSex];
                                    // 设置自动登录
                                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                                    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                                    
                                    if (responseObject[@"data"][@"userId"]) {
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"userId"] forKey:UserId];
                                    }
                                    if (responseObject[@"data"][@"token"]) {
                                        [ZYUserDefaults setObject:responseObject[@"data"][@"token"] forKey:Token];
                                    }
                                    [ZYUserDefaults setObject:_user.phone forKey:@"phone"];
                                    [ZYUserDefaults setObject:[Tools md5EncryptWithString:_password] forKey:@"password"];
                                    [ZYNotificationCenter postNotificationName:NOTIFICATION_HASLOGIN object:nil];
                                    [self.navigationController popToRootViewControllerAnimated:NO];
                                    if (user.album.count > 0) {
                                        [ZYUserDefaults setBool:YES forKey:CPHasAlbum];
                                    }else{
                                        [ZYUserDefaults setBool:NO forKey:CPHasAlbum];
                                    }
                                }
                                [self disMiss];
                            } onQueue:nil];
                            
                        }else{
                            NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                        }
                    } failed:^(NSError *error) {
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的生日" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的头像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (IBAction)headIconBtnClick:(id)sender {
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
    file.filename=@"avatar.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    [ZYNetWorkTool postFileWithUrl:@"avatar/upload" params:nil files:files success:^(id responseObject){
        if (CPSuccess) {
            _user.avatar=responseObject[@"data"][@"photoUrl"];
            _user.avatarId=responseObject[@"data"][@"photoId"];
            [_truePortraitLabel setHidden:YES];
            [_promptLabel setHidden:YES];
            [self.userHeadIcon setImage:editedImage];
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }failure:^(NSError *erro){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}
- (IBAction)manBtnClick:(id)sender {
    _user.gender=@"男";
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"btn_man_1"] forState:UIControlStateNormal];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"btn_woman_2"] forState:UIControlStateNormal];
}
- (IBAction)womanBtnClick:(id)sender {
    _user.gender=@"女";
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"btn_man_2"] forState:UIControlStateNormal];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"btn_woman_1"] forState:UIControlStateNormal];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *name=[self.nick.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([name length]>7) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"昵称最多包含7个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
    }
}
@end

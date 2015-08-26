//
//  CarOwnersCertificationViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/13.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CarOwnersCertificationViewController.h"
#import "CPBrandModelViewController.h"
#import "ZHPickView.h"
#import "CPRegisterCellsTableViewCell3.h"

@interface CarOwnersCertificationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate,UIAlertViewDelegate>
{
    BOOL uploaded;
    NSInteger drivingExperience;
}
@end

@implementation CarOwnersCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    uploaded=NO;
    drivingExperience=1;
    self.tableView.tableHeaderView=self.headView;
    self.tableView.tableFooterView=self.footView;
    self.nextBtn.layer.cornerRadius=3.0;
    self.nextBtn.layer.masksToBounds=YES;
    if (_fromMy && [_fromMy isEqualToString:@"1"]) {
        [self setRightBarWithText:@"跳过"];
    }
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [self.imageBtn addGestureRecognizer:singleTap1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickview) name:@"remove" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([Tools getValueFromKey:@"userId"]) {
        [self.tableView reloadData];
        _organizer = [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(_fileName)];
        if (_organizer && ![Tools isEmptyOrNull:_organizer.drivingLicensePhoto]) {
            NSURL *url=[[NSURL alloc]initWithString:_organizer.drivingLicensePhoto];
            [self.imageBtn sd_setImageWithURL:url];
        }
    }else{
        [self.tableView removeFromSuperview];
        [CPNotificationCenter postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pickview removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma UITableViewDataSource   UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Tools getValueFromKey:@"userId"]) {
        return 1;
    }else
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    CPRegisterCellsTableViewCell3 *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell3" owner:nil options:nil] lastObject];
    }

    if (indexPath.row==0) {
        UILabel *cellTopSeparator=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, .5)];
        cellTopSeparator.backgroundColor=[Tools getColor:@"e6e9ed"];
        [cell addSubview:cellTopSeparator];
        cell.cellTitle.text=@"驾龄";
        cell.textLabel.textColor=[Tools getColor:@"aab2bd"];
        if (_organizer.drivingExperience) {
            cell.cellContent.text=[[NSString alloc]initWithFormat:@"%ld年",(long)_organizer.drivingExperience];
        }
    }else{
        cell.cellTitle.text=@"车型品牌";
        cell.textLabel.textColor=[Tools getColor:@"aab2bd"];
        if (_organizer.carModel) {
            NSString *detailText=[[NSString alloc]initWithFormat:@"%@",_organizer.carModel];
            cell.cellContent.text=detailText;
        }
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_pickview remove];
    if (indexPath.row==1) {
        CPBrandModelViewController *CPBrandModelVC=[[CPBrandModelViewController alloc]init];
//        if (![Tools getValueFromKey:@"userId"]) {
            CPBrandModelVC.fromMy=_fromMy;
//        }
        CPBrandModelVC.title=@"车型选择";
        CPBrandModelVC.fileName=_fileName;
        [self.navigationController pushViewController:CPBrandModelVC animated:YES];
    }
    
    if (indexPath.row==0) {
        CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[tableView cellForRowAtIndexPath:indexPath];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //动画结束
        [UIView commitAnimations];
        NSArray *array=@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
        _pickview=[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
    }else{
        NSIndexPath *index= [NSIndexPath indexPathForRow:0 inSection:0];
        CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[self.tableView cellForRowAtIndexPath:index];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
        //动画结束
        [UIView commitAnimations];
    }
}

-(void)removePickview{
    NSIndexPath *index= [NSIndexPath indexPathForRow:0 inSection:0];
    CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[self.tableView cellForRowAtIndexPath:index];
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:.3];
    //动画的内容
    cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
    //动画结束
    [UIView commitAnimations];
}

- (IBAction)nextBtnClick:(id)sender {
    if (uploaded) {
        if (drivingExperience) {
            if ([Tools getValueFromKey:@"brandName"]) {
                if ([Tools getValueFromKey:@"modelName"]) {
                    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/authentication?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
                    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:[Tools getValueFromKey:@"brandName"],@"carBrand",[Tools getValueFromKey:@"brandUrl"],@"carBrandLogo",[Tools getValueFromKey:@"modelName"],@"carModel",@(drivingExperience),@"drivingExperience",[Tools getValueFromKey:@"slug"],@"slug",nil];
                   [self showLoading];
                    [ZYNetWorkTool postJsonWithUrl:path params:para success:^(id responseObject) {
                        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
                        [self disMiss];
                        if (CPSuccess) {
                             [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的认证提交成功，我们会尽快审核!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                            if (_fromMy && [_fromMy isEqualToString:@"1"]) {
                                EMError *error = nil;
                                NSString *EMuser=[Tools md5EncryptWithString:[Tools getValueFromKey:@"userId"]];
                                NSString *password=[Tools getValueFromKey:@"password"];
                                if ([Tools getValueFromKey:@"LoginFrom3Party"]) {
                                    NSDictionary *dict=[Tools getValueFromKey:THIRDPARTYLOGINACCOUNT];
                                    password =dict[@"sign"];
                                }
                                
                                NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:password error:&error];
                                if (!error && loginInfo) {
                                    [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
                                    [Tools setValueForKey:password key:@"password"];
                                    
                                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
                                }else{
                                    [self showError:error.description];
                                }
                            }
                        }else{
                            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                        }
                    } failed:^(NSError *error) {
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                        [self disMiss];
                    }];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的爱车型号!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的爱车品牌!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的驾龄!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的行驶证!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

-(void)imageClick{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    [sheet showInView:self.view];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    CPRegisterCellsTableViewCell3 * cell=(CPRegisterCellsTableViewCell3 *)[self.tableView cellForRowAtIndexPath:index];
    cell.cellContent.text=[[NSString alloc]initWithFormat:@"%@年",resultString];
    [Tools setValueForKey:resultString key:@"drivingExperience"];
    drivingExperience=[resultString intValue];
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
    [self.imageBtn setImage:editedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
        [self upLoadImageWithBase64Encodeing:data];
    }];
}

-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"photo";
    file.data=encodedImageData;
    file.filename=@"license.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText=@"加载中…";
    hud.dimBackground=YES;
    NSString *path=[[NSString alloc]initWithFormat:@"v1/user/%@/license/upload?token=%@",[Tools getValueFromKey:@"userId"],[Tools getValueFromKey:@"token"]];
    [ZYNetWorkTool postFileWithUrl:path params:nil files:files success:^(id responseObject){
        [hud hide:YES];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
        if (![state isEqualToString:@"0"]) {
           [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else{
            uploaded=YES;
        }
    }failure:^(NSError *erro){
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

- (void)rightBarClick:(id)sender {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您将跳过车主认证!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"跳过", nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        EMError *error = nil;
        NSString *EMuser=[Tools md5EncryptWithString:[Tools getValueFromKey:@"userId"]];
        NSString *password = [Tools getValueFromKey:@"password"];
        if ([Tools getValueFromKey:@"LoginFrom3Party"]) {
            NSDictionary *dict=[Tools getValueFromKey:THIRDPARTYLOGINACCOUNT];
            password =dict[@"sign"];
        }
        NSDictionary *loginInfo = [[EaseMob sharedInstance].chatManager loginWithUsername:EMuser password:password error:&error];
        if (!error && loginInfo) {
            [Tools setValueForKey:@(YES) key:NOTIFICATION_HASLOGIN];
            [Tools setValueForKey:[Tools getValueFromKey:@"password"] key:@"password"];
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_LOGINCHANGE object:nil];
        }else{
            [self showError:error.description];
        }
    }
}

@end

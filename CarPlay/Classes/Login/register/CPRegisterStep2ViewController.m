//
//  CPRegisterStep2ViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/7/14.
//  Copyright (c) 2015年 gongpingjia. All rights reserved.
//

#import "CPRegisterStep2ViewController.h"
#import "CPRegisterCellsTableViewCell1.h"
#import "CPRegisterCellsTableViewCell2.h"
#import "CPRegisterCellsTableViewCell3.h"
#import "CPEditUsernameViewController.h"
#import "ZHPickView.h"
#import "CarOwnersCertificationViewController.h"
#import "CPMySubscribeModel.h"
#import "UIButton+WebCache.h"

@interface CPRegisterStep2ViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate,UIAlertViewDelegate>
{
    NSString *photoId;
    int brithYear;
    int birthMonth;
    int birthDay;
    NSString *fileName;
    CPOrganizer *organizer;
    NSDictionary *thirdPartyLoginDic;
}
@end

@implementation CPRegisterStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    fileName=[[NSString alloc]initWithFormat:@"%@.data",[Tools getValueFromKey:@"phone"]];
    if (_snsUid) {
        thirdPartyLoginDic = [Tools getValueFromKey:THIRDPARTYLOGINACCOUNT];
        fileName=[[NSString alloc]initWithFormat:@"%@.data",_snsUid];
    }
    photoId=[[NSString alloc]init];
    self.nextStepBtn.layer.cornerRadius=3.0;
    self.nextStepBtn.layer.masksToBounds=YES;
    brithYear=0;
    birthMonth=0;
    birthDay=0;
    self.tableView.tableHeaderView=self.headView;
    self.tableView.tableFooterView=self.footView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.nextStep.layer.cornerRadius=3.0;
    self.nextStep.layer.masksToBounds=YES;
    self.userIconBtn.layer.cornerRadius=38.5;
    self.userIconBtn.layer.masksToBounds=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickview) name:@"remove" object:nil];
    [Tools setValueForKey:@"男" key:@"gender"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    organizer = [NSKeyedUnarchiver unarchiveObjectWithFile:CPDocmentPath(fileName)];
    if (organizer && organizer.headImgUrl) {
        NSURL *url=[[NSURL alloc]initWithString:organizer.headImgUrl];
        [self.userIconBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    }else{
        organizer = [[CPOrganizer alloc]init];
        organizer.gender=@"男";
    }
//    if (thirdPartyLoginDic) {
//        NSURL *url=[[NSURL alloc]initWithString:thirdPartyLoginDic[@"url"]];
//        [self.userIconBtn sd_setImageWithURL:url forState:UIControlStateNormal];
//    }
    
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.pickview removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
# pragma UITableViewDataSource   UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CPRegisterCellsTableViewCell1Identifier=@"CPRegisterCellsTableViewCell1";
    static NSString *CPRegisterCellsTableViewCell2Identifier=@"CPRegisterCellsTableViewCell2";
    static NSString *CPRegisterCellsTableViewCell3Identifier=@"CPRegisterCellsTableViewCell3";
    UITableViewCell *cell;
    if (indexPath.row==0) {
        CPRegisterCellsTableViewCell2 *cell0=[tableView dequeueReusableCellWithIdentifier:CPRegisterCellsTableViewCell2Identifier];
        if (cell0 == nil) {
            cell0 = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell2" owner:nil options:nil] lastObject];
        }
        [cell0.checkManBtn addTarget:nil action:@selector(checkSex:) forControlEvents:UIControlEventTouchUpInside];
        [cell0.checkWomanBtn addTarget:nil action:@selector(checkSex:) forControlEvents:UIControlEventTouchUpInside];
        if (organizer && [organizer.gender isEqualToString:@"女"]) {
            [cell0.checkManBtn setImage:[UIImage imageNamed:@"sexUnchecked"] forState:UIControlStateNormal];
            [cell0.checkManBtn setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
            [cell0.checkWomanBtn setImage:[UIImage imageNamed:@"sexChecked"] forState:UIControlStateNormal];
            [cell0.checkWomanBtn setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        }
        
        cell=cell0;
    }else if (indexPath.row==1) {
        CPRegisterCellsTableViewCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:CPRegisterCellsTableViewCell1Identifier];
        if (cell1 == nil) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell1" owner:nil options:nil] lastObject];
        }
        if (organizer) {
            cell1.cellContent.text=organizer.nickname;
        }
        if (thirdPartyLoginDic) {
            cell1.cellContent.text=thirdPartyLoginDic[@"username"];
        }
        cell=cell1;
    }else{
        CPRegisterCellsTableViewCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:CPRegisterCellsTableViewCell3Identifier];
        if (cell3 == nil) {
            cell3 = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell3" owner:nil options:nil] lastObject];
        }
        
        if (indexPath.row==3) {
            cell3.cellTitle.text=@"城市";
            if (organizer.cityAndDistrict) {
                 cell3.cellContent.text=organizer.cityAndDistrict;
            }
           
        }else{
            if (organizer.age) {
                cell3.cellContent.text=[[NSString alloc]initWithFormat:@"%ld岁",(long)organizer.age];
            }
        }
        cell=cell3;
    }
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_pickview remove];
    
    if (indexPath.row==2 || indexPath.row==3) {
        if ((_indexPath.row==2 || _indexPath.row==3) && ![indexPath compare:_indexPath] == NSOrderedSame) {
            CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[tableView cellForRowAtIndexPath:_indexPath];
            //开始动画
            [UIView beginAnimations:nil context:nil];
            //设定动画持续时间
            [UIView setAnimationDuration:.3];
            //动画的内容
            cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
            //动画结束
            [UIView commitAnimations];
        }
        _indexPath=indexPath;
        CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[tableView cellForRowAtIndexPath:indexPath];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //动画结束
        [UIView commitAnimations];
        
    }else if(_indexPath.row==2 || _indexPath.row==3){
        CPRegisterCellsTableViewCell3 *cell=(CPRegisterCellsTableViewCell3 *)[tableView cellForRowAtIndexPath:_indexPath];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
        //动画结束
        [UIView commitAnimations];
    }
    _indexPath=indexPath;
    if (indexPath.row==3) {
        _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"city" isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
        CGRect frame=self.tableView.frame;
        frame.size.height=SCREEN_HEIGHT-_pickview.height-66;
        [self.tableView setFrame:frame];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    }
    
    if (indexPath.row==2) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSString *str = @"1990年01月01号";
        fmt.dateFormat = @"yyyy年MM月dd号";
        NSDate *now = [fmt dateFromString:str];
        _pickview=[[ZHPickView alloc] initDatePickWithDate:now datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
        _pickview.delegate=self;
        [_pickview show];
        CGRect frame=self.tableView.frame;
        frame.size.height=SCREEN_HEIGHT-_pickview.height-66;
        [self.tableView setFrame:frame];
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
    }
    
    if (indexPath.row==1) {
        CPEditUsernameViewController *CPEditUsernameVC=[[CPEditUsernameViewController alloc]init];
        CPEditUsernameVC.title=@"昵称";
        [self.navigationController pushViewController:CPEditUsernameVC animated:YES];
    }
}

-(void)removePickview{
    CGRect frame=self.tableView.frame;
    frame.size.height=SCREEN_HEIGHT-66;
    [self.tableView setFrame:frame];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    CPRegisterCellsTableViewCell3 * cell=(CPRegisterCellsTableViewCell3 *)[self.tableView cellForRowAtIndexPath:_indexPath];
    if (_indexPath.row==2) {
        double age=[resultString doubleValue]/31536000;
        cell.cellContent.text=[[NSString alloc]initWithFormat:@"%.0f岁",0-age];
        NSDate *brithDay=[[NSDate alloc]initWithTimeIntervalSinceNow:[resultString doubleValue]];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:brithDay]; // Get necessary date components

        [Tools setValueForKey:[[NSString alloc]initWithFormat:@"%.0f岁",0-age] key:@"age"];
        if (organizer) {
            organizer.age=0-age;
            organizer.brithYear=[components year];
            organizer.birthMonth=[components month];
            organizer.birthDay=[components day];
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
            organizer.brithYear=[components year];
            organizer.birthMonth=[components month];
            organizer.birthDay=[components day];
        }else{
            CPOrganizer *organizer1=[[CPOrganizer alloc]init];
            organizer1.age=0-age;
            organizer1.brithYear=[components year];
            organizer1.birthMonth=[components month];
            organizer1.birthDay=[components day];
            [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
        }
    }else{
        NSArray *array = [resultString componentsSeparatedByString:@","];
        NSString *cellContentLableText=[[NSString alloc]initWithFormat:@"%@ %@",[array objectAtIndex:1],[array objectAtIndex:2]];

        cell.cellContent.text=cellContentLableText;
        [Tools setValueForKey:cellContentLableText key:@"cityAndDistrict"];
        if (organizer) {
            organizer.cityAndDistrict=cellContentLableText;
            organizer.province = [array objectAtIndex:0];
            organizer.city = [array objectAtIndex:1];
            organizer.district = [array objectAtIndex:2];
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
        }else{
            CPOrganizer *organizer1 = [[CPOrganizer alloc]init];
            organizer1.cityAndDistrict = cellContentLableText;
            organizer1.province = [array objectAtIndex:0];
            organizer1.city = [array objectAtIndex:1];
            organizer1.district = [array objectAtIndex:2];
            [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
        }
    }
//    [self.tableView reloadData];
    //开始动画
    [UIView beginAnimations:nil context:nil];
    //设定动画持续时间
    [UIView setAnimationDuration:.3];
    //动画的内容
    cell.arrowImgView.transform = CGAffineTransformMakeRotation(0);
    //动画结束
    [UIView commitAnimations];
}

- (IBAction)userIconBtnClick:(id)sender {
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
    [self.userIconBtn setImage:editedImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSData *data=UIImageJPEGRepresentation(editedImage, 0.4);
        [self upLoadImageWithBase64Encodeing:data];
        
    }];
}

-(void)upLoadImageWithBase64Encodeing:(NSData *)encodedImageData{
    ZYHttpFile *file=[[ZYHttpFile alloc]init];
    file.name=@"photo";
    file.data=encodedImageData;
    file.filename=@"avatar.jpg";
    file.mimeType=@"image/jpeg";
    NSArray *files=[[NSArray alloc]initWithObjects:file, nil];
    [ZYNetWorkTool postFileWithUrl:@"v1/avatar/upload" params:nil files:files success:^(id responseObject){
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    [Tools setValueForKey:[data objectForKey:@"photoId"] key:@"photoId"];
                    [Tools setValueForKey:[data objectForKey:@"photoUrl"] key:@"photoUrl"];
                    if (organizer) {
                        organizer.headImgUrl=[data objectForKey:@"photoUrl"];
                        organizer.headImgId =[data objectForKey:@"photoId"];
                        [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
                    }else{
                        CPOrganizer *organizer1=[[CPOrganizer alloc]init];
                        organizer1.headImgUrl=[data objectForKey:@"photoUrl"];
                        organizer1.headImgId = [data objectForKey:@"photoId"];
                        [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
    }failure:^(NSError *erro){
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}

#pragma private methods
-(void)checkSex:(UIButton *)btn{
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];
    CPRegisterCellsTableViewCell2 *cell=[self.tableView cellForRowAtIndexPath:index];
    if (btn.tag==1) {
        [cell.checkManBtn setImage:[UIImage imageNamed:@"sexChecked"] forState:UIControlStateNormal];
        [cell.checkManBtn setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setImage:[UIImage imageNamed:@"sexUnchecked"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
        if (organizer) {
            organizer.gender=@"男";
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
        }else{
            CPOrganizer *organizer1=[[CPOrganizer alloc]init];
            organizer1.gender=@"男";
            [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
        }
    }else{
        [cell.checkManBtn setImage:[UIImage imageNamed:@"sexUnchecked"] forState:UIControlStateNormal];
        [cell.checkManBtn setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setImage:[UIImage imageNamed:@"sexChecked"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        if (organizer) {
            organizer.gender=@"女";
            [NSKeyedArchiver archiveRootObject:organizer toFile:CPDocmentPath(fileName)];
        }else{
            CPOrganizer *organizer1=[[CPOrganizer alloc]init];
            organizer.gender=@"女";
            [NSKeyedArchiver archiveRootObject:organizer1 toFile:CPDocmentPath(fileName)];
        }
    }
}

- (IBAction)nextStepBtnClick:(id)sender {
    if (organizer) {
        if (organizer.headImgId) {
            if(organizer.nickname){
                if(organizer.age){
                    if(organizer.cityAndDistrict){
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"性别一经选定无法修改，请确认" delegate:self cancelButtonTitle:@"重新选择" otherButtonTitles:@"不改了", nil];
                        [alert show];
                    }else{
                        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的地区" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    }
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择您的生日" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
            }else{
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的昵称" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请上传您的头像" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else{
         [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的个人信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1) {
        NSString *phone=[Tools getValueFromKey:@"phone"];
        NSString *password=[Tools getValueFromKey:@"password"];
        NSString *code=[Tools getValueFromKey:@"code"];
        NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"password",code,@"code",organizer.nickname,@"nickname",organizer.gender,@"gender",organizer.province,@"province",organizer.city,@"city",organizer.district,@"district",organizer.headImgId,@"photo",@(organizer.brithYear),@"birthYear",@(organizer.birthMonth),@"birthMonth",@(organizer.birthDay),@"birthDay",nil];
        
        if (_snsChannel && _snsUid && _snsUserName) {
            para=[NSDictionary dictionaryWithObjectsAndKeys:_snsUid,@"snsUid",_snsUserName,@"snsUserName",_snsChannel,@"snsChannel",organizer.nickname ? organizer.nickname:@"",@"nickname",organizer.gender,@"gender",organizer.province,@"province",organizer.city,@"city",organizer.district,@"district",organizer.headImgId,@"photo",@(organizer.brithYear),@"birthYear",@(organizer.birthMonth),@"birthMonth",@(organizer.birthDay),@"birthDay",nil];
        }
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor clearColor];
        hud.labelText=@"加载中…";
        hud.dimBackground=NO;
        [ZYNetWorkTool postJsonWithUrl:@"v1/user/register" params:para success:^(id responseObject) {
            [hud hide:YES];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
            if (![state isEqualToString:@"0"]) {
                NSString *errmsg =[responseObject objectForKey:@"errmsg"];
                [[[UIAlertView alloc]initWithTitle:@"提示" message:errmsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            }else{
                NSDictionary *data=[responseObject objectForKey:@"data"];
                [Tools setValueForKey:[data objectForKey:@"userId"] key:@"userId"];
                [Tools setValueForKey:[data objectForKey:@"token"] key:@"token"];
                
                CarOwnersCertificationViewController *CarOwnersCertificationVC=[[CarOwnersCertificationViewController alloc]init];
                CarOwnersCertificationVC.fromMy=@"1";
                CarOwnersCertificationVC.title=@"车主认证";
                [self.navigationController pushViewController:CarOwnersCertificationVC animated:YES];
            }
        } failed:^(NSError *error) {
            [hud hide:YES];
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }];
    }
}

@end

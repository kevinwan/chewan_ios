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

@interface CPRegisterStep2ViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ZHPickViewDelegate>
{
    NSString *photoId;
    NSInteger brithYear;
    NSInteger birthMonth;
    NSInteger birthDay;
}
@end

@implementation CPRegisterStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    photoId=[[NSString alloc]init];
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
        cell=cell0;
    }else if (indexPath.row==1) {
        CPRegisterCellsTableViewCell1 *cell1=[tableView dequeueReusableCellWithIdentifier:CPRegisterCellsTableViewCell2Identifier];
        if (cell1 == nil) {
            cell1 = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell1" owner:nil options:nil] lastObject];
        }
        if ([Tools getValueFromKey:@"nickname"]) {
            cell1.cellContent.text=[Tools getValueFromKey:@"nickname"];
        }
        cell=cell1;
    }else{
        CPRegisterCellsTableViewCell3 *cell3=[tableView dequeueReusableCellWithIdentifier:CPRegisterCellsTableViewCell3Identifier];
        if (cell3 == nil) {
            cell3 = [[[NSBundle mainBundle] loadNibNamed:@"CPRegisterCellsTableViewCell3" owner:nil options:nil] lastObject];
        }
        if (indexPath.row==3) {
            cell3.cellTitle.text=@"城市";
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
            CPRegisterCellsTableViewCell3 *cell=[tableView cellForRowAtIndexPath:_indexPath];
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
        CPRegisterCellsTableViewCell3 *cell=[tableView cellForRowAtIndexPath:indexPath];
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:.3];
        //动画的内容
        cell.arrowImgView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //动画结束
        [UIView commitAnimations];
        
    }else if(_indexPath.row==2 || _indexPath.row==3){
        CPRegisterCellsTableViewCell3 *cell=[tableView cellForRowAtIndexPath:_indexPath];
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
        NSDate *now = [NSDate date];
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
//        [self presentViewController:CPEditUsernameVC animated:YES completion:nil];
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
        brithYear=[components year];
        birthMonth=[components month];
        birthDay=[components day];
    }else{
        NSArray *array = [resultString componentsSeparatedByString:@","];
        NSString *cellContentLableText=[[NSString alloc]initWithFormat:@"%@%@",[array objectAtIndex:1],[array objectAtIndex:2]];
        [Tools setValueForKey:[array objectAtIndex:0] key:@"province"];
        [Tools setValueForKey:[array objectAtIndex:1] key:@"city"];
        [Tools setValueForKey:[array objectAtIndex:2] key:@"district"];
        cell.cellContent.text=cellContentLableText;
    }
    
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
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor clearColor];
    hud.labelText=@"加载中…";
    hud.dimBackground=YES;
    [ZYNetWorkTool postFileWithUrl:@"v1/avatar/upload" params:nil files:files success:^(id responseObject){
                [hud hide:YES];
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *state=[numberFormatter stringFromNumber:[responseObject objectForKey:@"result"]];
                if ([state isEqualToString:@"0"]) {
                    NSDictionary *data=[responseObject objectForKey:@"data"];
                    [Tools setValueForKey:[data objectForKey:@"photoId"] key:@"photoId"];
                    [Tools setValueForKey:[data objectForKey:@"photoUrl"] key:@"photoUrl"];
                }else{
                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                }
    }failure:^(NSError *erro){
        [hud hide:YES];
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
        [Tools setValueForKey:@"男" key:@"gender"];
    }else{
        [cell.checkManBtn setImage:[UIImage imageNamed:@"sexUnchecked"] forState:UIControlStateNormal];
        [cell.checkManBtn setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setImage:[UIImage imageNamed:@"sexChecked"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
        [Tools setValueForKey:@"女" key:@"gender"];
    }
}

- (IBAction)nextStepBtnClick:(id)sender {
    NSString *phone=[Tools getValueFromKey:@"phone"];
    NSString *password=[Tools getValueFromKey:@"password"];
    NSString *code=[Tools getValueFromKey:@"code"];
    NSString *nickname=[Tools getValueFromKey:@"nickname"];
    NSString *gender=[Tools getValueFromKey:@"gender"];
    NSString *province=[Tools getValueFromKey:@"province"];
    NSString *city=[Tools getValueFromKey:@"city"];
    NSString *district=[Tools getValueFromKey:@"district"];
    NSString *photo=[Tools getValueFromKey:@"photoId"];
    NSDictionary *para=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"password",code,@"code",nickname,@"nickname",gender,@"gender",province,@"province",city,@"city",district,@"district",photo,@"photo",@(brithYear),@"birthYear",@(birthMonth),@"birthMonth",@(birthDay),@"birthDay",nil];
    
//    NSMutableDictionary *para=[NSMutableDictionary dictionary];
//    para[@"phone"] =phone ;
//    para[@"password"] =password ;
//    para[@"code"] =code ;
//    para[@"nickname"] =nickname ;
//    para[@"gender"] =gender ;
//    para[@"province"] =province ;
//    para[@"city"] =city ;
//    para[@"district"] =district ;
//    para[@"photo"] =photo ;
//    para[@"brithYear"] =@(brithYear);
//     para[@"birthMonth"] =@(birthMonth);
//     para[@"birthDay"] =@(birthDay);
    
    
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
        }
    } failed:^(NSError *error) {
        [hud hide:YES];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的手机网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }];
}
@end

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
}
@end

@implementation CPRegisterStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    photoId=[[NSString alloc]init];
    self.tableView.tableHeaderView=self.headView;
    self.tableView.tableFooterView=self.footView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.nextStep.layer.cornerRadius=3.0;
    self.nextStep.layer.masksToBounds=YES;
    self.userIconBtn.layer.cornerRadius=38.5;
    self.userIconBtn.layer.masksToBounds=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickview) name:@"remove" object:nil];
    
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
        NSLog(@"%ld",(long)[components year]);// gives you year
        NSLog(@"%ld",(long)[components month]); //gives you month
        NSLog(@"%ld",(long)[components day]); //gives you day
        
    }else{
        cell.cellContent.text=resultString;
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
//    
//    NSString *url=[NSString stringWithFormat:@"%@/v1/avatar/upload",BASE_URL];
//    
//    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:url]];
//    NSMutableURLRequest *request=[httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock:^(id formData) {
//        [formData appendPartWithFileData:encodedImageData name:@"photo" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
//    }];
//    AFHTTPRequestOperation *oper=[[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [oper setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSDictionary *dicData=[NSJSONSerialization  JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        
//        NSString *resStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData *data_utf8 = [resStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//        NSError *error = nil;
//        id json = [NSJSONSerialization JSONObjectWithData:data_utf8 options:kNilOptions error:&error];
//        
//        if (json) {
//            if ([json isKindOfClass:[NSDictionary class]]) {
//                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//                NSString *state=[numberFormatter stringFromNumber:[json objectForKey:@"result"]];
//                if (![state isEqualToString:@"0"]) {
//                    photoId=[json objectForKey:@"photoId"];
//                    [Tools setValueForKey:[json objectForKey:@"photoUrl"] key:@"photoUrl"];
//                }else{
//                    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//                }
//            }else{
//                DLog(@"返回数据不是JSON数据:%@", [json class]);
//            }
//        }else
//        {
//            DLog(@"解析数据失败:%@", json);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"上传失败，请稍后再试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//    }];
//    [oper start];
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
    }else{
        [cell.checkManBtn setImage:[UIImage imageNamed:@"sexUnchecked"] forState:UIControlStateNormal];
        [cell.checkManBtn setTitleColor:[Tools getColor:@"aab2bd"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setImage:[UIImage imageNamed:@"sexChecked"] forState:UIControlStateNormal];
        [cell.checkWomanBtn setTitleColor:[Tools getColor:@"fd6d53"] forState:UIControlStateNormal];
    }
}

@end

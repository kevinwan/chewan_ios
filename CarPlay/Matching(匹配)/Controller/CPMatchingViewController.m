//
//  CPMatchingViewController.m
//  CarPlay
//
//  Created by 公平价 on 15/9/29.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import "CPMatchingViewController.h"
#import "CPTakeALookViewController.h"
#import "UIView+Shake.h"
#import "MatchingSelectView.h"
#import "ExerciseMatchingSelectView.h"
#import "OtherMatchingSelectView.h"
#import "MatchingSelectView.h"
#import "ExerciseMatchingSelectView.h"
#import "CPActivityModel.h"
#import "CPTabBarController.h"


@interface CPMatchingViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *timer;
    NSTimer *timer1;
    NSTimer *takeALookViewTimer;
    NSUInteger takeALookAnimationIndex;
    CPTakeALookViewController *takeALook;
    OtherMatchingSelectView *otherMatchingSelectView;
    MatchingSelectView *signMatchingSelectView;
    ExerciseMatchingSelectView *exerciseMatchingSelectView;
    NSInteger index;
}

@end

@implementation CPMatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 1;
    takeALook=[UIStoryboard storyboardWithName:@"CPTakeALook" bundle:nil].instantiateInitialViewController;
    [self.scrollView setFrame:CGRectMake(0, 0, ZYScreenWidth, ZYScreenHeight)];
    [self.scrollView setContentSize:CGSizeMake(545.0/320.0*ZYScreenWidth, ZYScreenHeight-60)];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]]];
    
    [self.nowYouWantImg setCenter:CGPointMake(ZYScreenWidth/2.0, 45.0f)];
    [self.eatBtn setCenter:CGPointMake(95.5/320.0*ZYScreenWidth, 131/568.0*ZYScreenHeight)];
    [self.eatBtn setSize:CGSizeMake(81.0/320.0*ZYScreenWidth, 81.0/320.0*ZYScreenWidth)];
    [self.eatBtnBgView setCenter:CGPointMake(95.5/320.0*ZYScreenWidth, 131/568.0*ZYScreenHeight)];
    [self.eatBtnBgView setSize:CGSizeMake(81.0/320.0*ZYScreenWidth, 81.0/320.0*ZYScreenWidth)];
    [self.eatBtnBgView.layer setMasksToBounds:YES];
    [self.eatBtnBgView.layer setCornerRadius:40.5/320.0*ZYScreenWidth];
    [self.eatBtnBgView setBackgroundColor:[Tools getColor:@"44A8F2"]];
    
    [self.singBtn setCenter:CGPointMake(232.0/320.0*ZYScreenWidth, 175.0/568.0*ZYScreenHeight)];
    [self.singBtn setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.singBtnBgView setCenter:CGPointMake(232.0/320.0*ZYScreenWidth, 175.0/568.0*ZYScreenHeight)];
    [self.singBtnBgView setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.singBtnBgView.layer setMasksToBounds:YES];
    [self.singBtnBgView.layer setCornerRadius:35.0/320.0*ZYScreenWidth];
    [self.singBtnBgView setBackgroundColor:[Tools getColor:@"FDCC22"]];
    
    [self.movieBtn setCenter:CGPointMake(130.0/320.0*ZYScreenWidth, 245.0/568.0*ZYScreenHeight)];
    [self.movieBtn setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.movieBtnBgView setCenter:CGPointMake(130.0/320.0*ZYScreenWidth, 245.0/568.0*ZYScreenHeight)];
    [self.movieBtnBgView setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.movieBtnBgView.layer setMasksToBounds:YES];
    [self.movieBtnBgView.layer setCornerRadius:35.0/320.0*ZYScreenWidth];
    [self.movieBtnBgView setBackgroundColor:[Tools getColor:@"BE77D2"]];
    
    [self.takeExerciseBtn setCenter:CGPointMake(62.5/320.0*ZYScreenWidth, 325.5/568.0*ZYScreenHeight)];
    [self.takeExerciseBtn setSize:CGSizeMake(65.0/320.0*ZYScreenWidth, 65.0/320.0*ZYScreenWidth)];
    [self.takeExerciseBtnBgView setCenter:CGPointMake(62.5/320.0*ZYScreenWidth, 325.5/568.0*ZYScreenHeight)];
    [self.takeExerciseBtnBgView setSize:CGSizeMake(65.0/320.0*ZYScreenWidth, 65.0/320.0*ZYScreenWidth)];
    [self.takeExerciseBtnBgView.layer setMasksToBounds:YES];
    [self.takeExerciseBtnBgView.layer setCornerRadius:32.5/320.0*ZYScreenWidth];
    [self.takeExerciseBtnBgView setBackgroundColor:[Tools getColor:@"7BCC4A"]];
    
    [self.walkDogBtn setCenter:CGPointMake(256.0/320.0*ZYScreenWidth, 294.0/568.0*ZYScreenHeight)];
    [self.walkDogBtn setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.walkDogBtnBgView setCenter:CGPointMake(256.0/320.0*ZYScreenWidth, 294.0/568.0*ZYScreenHeight)];
    [self.walkDogBtnBgView setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.walkDogBtnBgView.layer setMasksToBounds:YES];
    [self.walkDogBtnBgView.layer setCornerRadius:30.0/320.0*ZYScreenWidth];
    [self.walkDogBtnBgView setBackgroundColor:[Tools getColor:@"F17945"]];
    
    [self.supperBtn setCenter:CGPointMake(182.0/320.0*ZYScreenWidth, 378.0/568.0*ZYScreenHeight)];
    [self.supperBtn setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.supperBtnBgView setCenter:CGPointMake(182.0/320.0*ZYScreenWidth, 378.0/568.0*ZYScreenHeight)];
    [self.supperBtnBgView setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.supperBtnBgView.layer setMasksToBounds:YES];
    [self.supperBtnBgView.layer setCornerRadius:35.0/320.0*ZYScreenWidth];
    [self.supperBtnBgView setBackgroundColor:[Tools getColor:@"498BB8"]];
    
    [self.beerBtn setCenter:CGPointMake(339.0/320.0*ZYScreenWidth, 400.0/568.0*ZYScreenHeight)];
    [self.beerBtn setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.beerBtnBgView setCenter:CGPointMake(339.0/320.0*ZYScreenWidth, 400.0/568.0*ZYScreenHeight)];
    [self.beerBtnBgView setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.beerBtnBgView.layer setMasksToBounds:YES];
    [self.beerBtnBgView.layer setCornerRadius:35.0/320.0*ZYScreenWidth];
    [self.beerBtnBgView setBackgroundColor:[Tools getColor:@"1AAC8E"]];
    
    [self.nightclubBtn setCenter:CGPointMake(476.0/320.0*ZYScreenWidth, 131.0/568.0*ZYScreenHeight)];
    [self.nightclubBtn setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.nightclubBtnBgView setCenter:CGPointMake(476.0/320.0*ZYScreenWidth, 131.0/568.0*ZYScreenHeight)];
    [self.nightclubBtnBgView setSize:CGSizeMake(70.0/320.0*ZYScreenWidth, 70.0/320.0*ZYScreenWidth)];
    [self.nightclubBtnBgView.layer setMasksToBounds:YES];
    [self.nightclubBtnBgView.layer setCornerRadius:35.0/320.0*ZYScreenWidth];
    [self.nightclubBtnBgView setBackgroundColor:[Tools getColor:@"2DC6BA"]];
    
    [self.shoppingBtn setCenter:CGPointMake(380.0/320.0*ZYScreenWidth, 196.0/568.0*ZYScreenHeight)];
     [self.shoppingBtn setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.shoppingBtnBgView setCenter:CGPointMake(380.0/320.0*ZYScreenWidth, 196.0/568.0*ZYScreenHeight)];
    [self.shoppingBtnBgView setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.shoppingBtnBgView.layer setMasksToBounds:YES];
    [self.shoppingBtnBgView.layer setCornerRadius:30.0/320.0*ZYScreenWidth];
    [self.shoppingBtnBgView setBackgroundColor:[Tools getColor:@"FB6087"]];
    
    [self.coffeBtn setCenter:CGPointMake(423.0/320.0*ZYScreenWidth, 315.0/568.0*ZYScreenHeight)];
    [self.coffeBtn setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.coffeBtnBgView setCenter:CGPointMake(423.0/320.0*ZYScreenWidth, 315.0/568.0*ZYScreenHeight)];
    [self.coffeBtnBgView setSize:CGSizeMake(60.0/320.0*ZYScreenWidth, 60.0/320.0*ZYScreenWidth)];
    [self.coffeBtnBgView.layer setMasksToBounds:YES];
    [self.coffeBtnBgView.layer setCornerRadius:30.0/320.0*ZYScreenWidth];
    [self.coffeBtnBgView setBackgroundColor:[Tools getColor:@"E85959"]];
    
    [self.takeALookBtn setCenter:CGPointMake(ZYScreenWidth/2.0, 505.0/568.0*ZYScreenHeight)];
   
    timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(biginAni) userInfo:nil repeats:YES];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenScrollView)];
    [self.scrollView addGestureRecognizer:tapGesture];
    otherMatchingSelectView=[UIStoryboard storyboardWithName:@"OtherMatchingSelectView" bundle:nil].instantiateInitialViewController;
    signMatchingSelectView=[UIStoryboard storyboardWithName:@"MatchingSelectView" bundle:nil].instantiateInitialViewController;
    exerciseMatchingSelectView=[UIStoryboard storyboardWithName:@"ExerciseMatchingSelectView" bundle:nil].instantiateInitialViewController;
}

-(void)animationContent{
    
    UIView *btnView=[self.scrollView viewWithTag:index];
    UIView *bgView=[self.scrollView viewWithTag:index+20];
    
        [UIView animateWithDuration:0.0 animations:^{
//            btnView.transform=CGAffineTransformMakeScale(.7, .7);
//            bgView.transform=CGAffineTransformMakeScale(.7, .7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                btnView.transform=CGAffineTransformMakeScale(1, 1);
                bgView.transform=CGAffineTransformMakeScale(.9, .9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 animations:^{
                    btnView.transform=CGAffineTransformMakeScale(0.9, 0.9);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3 animations:^{
                        bgView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:.4 animations:^{
                            bgView.transform=CGAffineTransformMakeScale(0.9, 0.9);
                        } completion:^(BOOL finished) {
                            [timer1 setFireDate:[NSDate distantFuture]];
                        }];
                    }];
                }];
            }];
        }];
    index++;
    if (index>10) {
        index=1;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [timer setFireDate:[NSDate distantPast]];
}

-(void)biginAni{
    timer1 =  [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(animationContent) userInfo:nil repeats:YES];
    [timer1 setFireDate:[NSDate distantPast]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    [timer setFireDate:[NSDate distantFuture]];
    [_eatBtn endShake];
    [_singBtn endShake];
    [_movieBtn endShake];
    [_takeExerciseBtn endShake];
    [_walkDogBtn endShake];
    [_supperBtn endShake];
    [_beerBtn endShake];
    [_nightclubBtn endShake];
    [_shoppingBtn endShake];
    [_coffeBtn endShake];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MultiplePulsingHaloLayer *)dateAnim
{

    _dateAnim = [self multiLayer];
    switch (arc4random() % 10) {
        case 1:
        {
            _dateAnim.position = _eatBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"77c0f7"].CGColor];
            _dateAnim.radius = _eatBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_eatBtn.layer];
        }
            break;
        case 2:
        {
            _dateAnim.position = _singBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"fddb64"].CGColor];
            _dateAnim.radius = _singBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_singBtn.layer];
        }
            break;
        case 3:
        {
            _dateAnim.position = _movieBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"cd97dd"].CGColor];
            _dateAnim.radius = _movieBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_movieBtn.layer];
        }
            break;
        case 4:
        {
            _dateAnim.position = _takeExerciseBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"E0F3D4"].CGColor];
            _dateAnim.radius = _takeExerciseBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_takeExerciseBtn.layer];
        }
            break;
        case 5:
        {
            _dateAnim.position = _walkDogBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"f48c60"].CGColor];
            _dateAnim.radius = _walkDogBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_walkDogBtn.layer];
            
        }
            break;
        case 6:
        {
            _dateAnim.position = _supperBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"5f99c0"].CGColor];
            _dateAnim.radius = _supperBtn.bounds.size.width/2.0+15.0;
           [self.scrollView.layer insertSublayer:_dateAnim below:_supperBtn.layer];
        }
            break;
        case 7:
        {
            _dateAnim.position = _beerBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"1cc1a0"].CGColor];
            _dateAnim.radius = _beerBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_beerBtn.layer];
        }
            break;
        case 8:
        {
            _dateAnim.position = _nightclubBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"5adad0"].CGColor];
            _dateAnim.radius = _nightclubBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_nightclubBtn.layer];
        }
            break;
        case 9:
        {
            _dateAnim.position = _shoppingBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"fb7b9b"].CGColor];
            _dateAnim.radius = _shoppingBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_shoppingBtn.layer];
        }
            break;
        case 0:
        {
            _dateAnim.position = _coffeBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"ea6f6f"].CGColor];
            _dateAnim.radius = _coffeBtn.bounds.size.width/2.0+15.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_coffeBtn.layer];
        }
            break;
        default:
            break;
    }
    return _dateAnim;
}

- (MultiplePulsingHaloLayer *)multiLayer
{
    MultiplePulsingHaloLayer *multiLayer = [[MultiplePulsingHaloLayer alloc] initWithHaloLayerNum:1 andStartInterval:0];
    multiLayer.fromValueForRadius = 0.5;
    multiLayer.useTimingFunction = NO;
    multiLayer.fromValueForAlpha = 1.0;
    multiLayer.animationRepeatCount=1;
    [multiLayer buildSublayers];
    return multiLayer;
}

- (IBAction)btnClick:(UIButton *)sender {
    NSString *colorRGB=@"77c0f7";
    NSString *type=@"吃饭";
    if (sender.tag!=100) {
        switch (sender.tag) {
            case 1:
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 2:
                colorRGB=@"5f99c0";
                type=@"夜宵";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 3:
                colorRGB=@"fddb64";
                type=@"唱歌";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 4:
                colorRGB=@"5adad0";
                type=@"夜店";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 5:
                colorRGB=@"cd97dd";
                type=@"看电影";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 6:
                colorRGB=@"ea6f6f";
                type=@"喝咖啡";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 7:
                colorRGB=@"f48c60";
                type=@"遛狗";
                signMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                signMatchingSelectView.view.alpha=1.0;
                signMatchingSelectView.selectView.alpha=1.0;
                signMatchingSelectView.locationAddressView.alpha=0.0;
                signMatchingSelectView.addressSelection.alpha=0.0;
                signMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:signMatchingSelectView.view];
                [self addChildViewController:signMatchingSelectView];
                break;
            case 8:
                colorRGB=@"1cc1a0";
                type=@"喝酒";
                otherMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                otherMatchingSelectView.view.alpha=1.0;
                otherMatchingSelectView.selectView.alpha=1.0;
                otherMatchingSelectView.locationAddressView.alpha=0.0;
                otherMatchingSelectView.addressSelection.alpha=0.0;
                otherMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:otherMatchingSelectView.view];
                [self addChildViewController:otherMatchingSelectView];
                break;
            case 9:
                colorRGB=@"98d872";
                type=@"运动";
                exerciseMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                exerciseMatchingSelectView.view.alpha=1.0;
                exerciseMatchingSelectView.selectView.alpha=1.0;
                exerciseMatchingSelectView.locationAddressView.alpha=0.0;
                exerciseMatchingSelectView.addressSelection.alpha=0.0;
                exerciseMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:exerciseMatchingSelectView.view];
                [self addChildViewController:exerciseMatchingSelectView];
                break;
            case 10:
                colorRGB=@"fb7b9b";
                type=@"购物";
                signMatchingSelectView.view.backgroundColor=[Tools getColor:colorRGB];
                signMatchingSelectView.view.alpha=1.0;
                signMatchingSelectView.selectView.alpha=1.0;
                signMatchingSelectView.locationAddressView.alpha=0.0;
                signMatchingSelectView.addressSelection.alpha=0.0;
                signMatchingSelectView.indexView.alpha=0.0;
                [self.view addSubview:signMatchingSelectView.view];
                [self addChildViewController:signMatchingSelectView];
                break;
                
            default:
                break;
        }
        
        [ZYUserDefaults setObject:type forKey:LastType];
    }else{
        //加载随便看看页面
        [self.view addSubview:takeALook.view];
        [self addChildViewController:takeALook];
        takeALook.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        [UIView animateWithDuration:0.5 animations:^{
            takeALook.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }
}

-(void)hidenScrollView{
    CPTabBarController *tab = (CPTabBarController *)self.view.window.rootViewController;
    [tab setSelectedIndex:[ZYUserDefaults integerForKey:TabLastSelectIndex]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

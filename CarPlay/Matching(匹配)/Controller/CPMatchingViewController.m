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

@interface CPMatchingViewController ()<UIGestureRecognizerDelegate>
{
    NSTimer *timer;
    NSTimer *takeALookViewTimer;
    NSUInteger takeALookAnimationIndex;
    CPTakeALookViewController *takeALook;
}

@end

@implementation CPMatchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    takeALook=[UIStoryboard storyboardWithName:@"CPTakeALook" bundle:nil].instantiateInitialViewController;
    [self.scrollView setFrame:CGRectMake(0, 0, ZYScreenWidth, ZYScreenHeight)];
    [self.scrollView setContentSize:CGSizeMake(545.0/320.0*ZYScreenWidth, ZYScreenHeight-60)];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]]];
    [self.nowYouWantImg setCenter:CGPointMake(ZYScreenWidth/2.0, 45.0f)];
    [self.eatBtn setCenter:CGPointMake(95.5/320.0*ZYScreenWidth, 131/568.0*ZYScreenHeight)];
    [self.singBtn setCenter:CGPointMake(232.0/320.0*ZYScreenWidth, 175.0/568.0*ZYScreenHeight)];
    [self.movieBtn setCenter:CGPointMake(130.0/320.0*ZYScreenWidth, 245.0/568.0*ZYScreenHeight)];
    [self.takeExerciseBtn setCenter:CGPointMake(62.5/320.0*ZYScreenWidth, 293.0/568.0*ZYScreenHeight)];
    [self.walkDogBtn setCenter:CGPointMake(256.0/320.0*ZYScreenWidth, 294.0/568.0*ZYScreenHeight)];
    [self.supperBtn setCenter:CGPointMake(182.0/320.0*ZYScreenWidth, 378.0/568.0*ZYScreenHeight)];
    [self.beerBtn setCenter:CGPointMake(339.0/320.0*ZYScreenWidth, 400.0/568.0*ZYScreenHeight)];
    [self.nightclubBtn setCenter:CGPointMake(476.0/320.0*ZYScreenWidth, 131.0/568.0*ZYScreenHeight)];
    [self.shoppingBtn setCenter:CGPointMake(380.0/320.0*ZYScreenWidth, 196.0/568.0*ZYScreenHeight)];
    [self.coffeBtn setCenter:CGPointMake(423.0/320.0*ZYScreenWidth, 315.0/568.0*ZYScreenHeight)];
    [self.takeALookBtn setCenter:CGPointMake(ZYScreenWidth/2.0, 505.0/568.0*ZYScreenHeight)];
   
//    for (int i=1; i<11; i++) {
//        UIButton *btn=(UIButton *)[self.scrollView viewWithTag:i];
//        [btn shakeWithOptions:SCShakeOptionsDirectionHorizontalAndVertical | SCShakeOptionsForceInterpolationRandom | SCShakeOptionsAtEndContinue force:0.05 duration:2 iterationDuration:1 completionHandler:nil];
//    }
   
}

-(void)aaa{
    [UIView animateWithDuration:0.35 animations:^{
        self.eatBtn.transform=CGAffineTransformMakeScale(.7, .7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            self.eatBtn.transform=CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            _dateAnim = [self multiLayer];
            _dateAnim.position = _eatBtn.center;
            [_dateAnim setHaloLayerColor:[Tools getColor:@"44A8F2"].CGColor];
            _dateAnim.radius = 81.0/2.0+6.0;
            [self.scrollView.layer insertSublayer:_dateAnim below:_eatBtn.layer];
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
     timer =  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(aaa) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantPast]];
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
    if (sender.tag!=100) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.view addSubview:takeALook.view];
        [UIView animateWithDuration:0.1
                         animations:^{
                             takeALook.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
                         }completion:^(BOOL finish){
                             [UIView animateWithDuration:0.7
                                              animations:^{
                                                  takeALook.view.transform = CGAffineTransformMakeScale(1, 1);
                                              }completion:^(BOOL finish){
                                                  [takeALook.person1 setFrame:CGRectMake(53.0/320.0*ZYScreenWidth, 35.0/568.0*ZYScreenHeight, 59.0, 59.0)];
                                                  takeALookAnimationIndex=1;
                                                  takeALookViewTimer =  [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(takeALookAnimation) userInfo:nil repeats:YES];
                                              }];
                         }];
        [self addChildViewController:takeALook];
    }
}

//随便看看页面动画
-(void)takeALookAnimation{
//    [UIView beginAnimations:@"takeALookAnimation" context:nil];
//    //动画持续时间
//    [UIView setAnimationDuration:.2];
//    //设置动画的回调函数，设置后可以使用回调方法
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDelay:0];
//    [self takeALookAnimationDetail];
    
    [UIView animateWithDuration:0.2 animations:^{
//        [takeALook.person1 setFrame:CGRectMake(53.0/320.0*ZYScreenWidth, 35.0/568.0*ZYScreenHeight, 59.0, 59.0)];
//        takeALook.person1.height=59.0;
//        takeALook.person1.width=59.0;
        [takeALook.person1 setBackgroundColor:[UIColor yellowColor]];
    }];
    
    //提交UIView动画
//    [UIView commitAnimations];
}
//随便看看页面逐步动画
-(void)takeALookAnimationDetail{
    switch (takeALookAnimationIndex % 10) {
        case 1:
            [takeALook.person1 setFrame:CGRectMake(53.0/320.0*ZYScreenWidth, 35.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 2:
           [takeALook.person2 setFrame:CGRectMake(182.0/320.0*ZYScreenWidth, 59.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 3:
            [takeALook.person3 setFrame:CGRectMake(80.0/320.0*ZYScreenWidth, 115.0/568.0*ZYScreenHeight, 62.0, 62.0)];
            break;
        case 4:
          [takeALook.person4 setFrame:CGRectMake(233.0/320.0*ZYScreenWidth, 148.0/568.0*ZYScreenHeight, 69.0, 69.0)];
            break;
        case 5:
           [takeALook.person5 setFrame:CGRectMake(130.0/320.0*ZYScreenWidth, 196.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 6:
           [takeALook.person6 setFrame:CGRectMake(27.0/320.0*ZYScreenWidth, 206.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 7:
            [takeALook.person7 setFrame:CGRectMake(214.0/320.0*ZYScreenWidth, 261.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 8:
            [takeALook.person8 setFrame:CGRectMake(32.0/320.0*ZYScreenWidth, 313.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        case 9:
           [takeALook.person9 setFrame:CGRectMake(125.0/320.0*ZYScreenWidth, 326.0/568.0*ZYScreenHeight, 69.0, 69.0)];
            break;
        case 0:
            [takeALook.person10 setFrame:CGRectMake(232.0/320.0*ZYScreenWidth, 349.0/568.0*ZYScreenHeight, 59.0, 59.0)];
            break;
        default:
            break;
    }
    takeALookAnimationIndex++;
    if (takeALookAnimationIndex>10) {
        takeALookAnimationIndex=1;
    }
}
@end

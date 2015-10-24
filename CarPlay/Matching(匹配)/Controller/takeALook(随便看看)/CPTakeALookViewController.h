//
//  CPTakeALookViewController.h
//  CarPlay
//
//  Created by 公平价 on 15/10/8.
//  Copyright © 2015年 chewan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPTakeALookViewController : UIViewController
@property (weak, nonatomic) IBOutlet CPNPSButton *person1;
@property (weak, nonatomic) IBOutlet CPNPSButton *person2;
@property (weak, nonatomic) IBOutlet CPNPSButton *person3;
@property (weak, nonatomic) IBOutlet CPNPSButton *person4;
@property (weak, nonatomic) IBOutlet CPNPSButton *person5;
@property (weak, nonatomic) IBOutlet CPNPSButton *person6;
@property (weak, nonatomic) IBOutlet CPNPSButton *person7;
@property (weak, nonatomic) IBOutlet CPNPSButton *person8;
@property (weak, nonatomic) IBOutlet CPNPSButton *person9;
@property (weak, nonatomic) IBOutlet CPNPSButton *person10;
- (IBAction)personBtnClick:(CPNPSButton *)sender;
- (IBAction)close:(id)sender;
@end

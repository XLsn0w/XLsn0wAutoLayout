//
//  ViewController.m
//  XLsn0wAutoLayout
//
//  Created by XLsn0w on 2018/5/26.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "ViewController.h"
#import "XLsn0wConstraintLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.redColor;
//    view.make.centerX_equalTo(self.view).centerY_equalTo(self.view).widthValue(200).heightValue(200);
    
    view.make.leftValue(self.view, 10).topValue(self.view, 200).widthValue(200).heightValue(200);
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

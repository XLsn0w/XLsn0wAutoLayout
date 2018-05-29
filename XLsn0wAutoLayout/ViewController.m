//
//  ViewController.m
//  XLsn0wAutoLayout
//
//  Created by XLsn0w on 2018/5/26.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "ViewController.h"
#import "XLsn0wMakeConstraints.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    view.backgroundColor = UIColor.redColor;
    view.makeConstraints.centerXEqualToView(self.view).centerYEqualToView(self.view).widthIs(200).heightIs(200);
    
    UIView *view1 = [UIView new];
    [self.view addSubview:view1];
    view1.backgroundColor = UIColor.blueColor;
    view1.makeConstraints.leftSpaceToView(self.view, 50).bottomSpaceToView(self.view, 50).widthIs(50).heightIs(50);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

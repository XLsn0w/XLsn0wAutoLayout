//
//  ViewController.m
//  XLsn0wAutoLayout
//
//  Created by XLsn0w on 2018/5/26.
//  Copyright © 2018年 XLsn0w. All rights reserved.
//

#import "ViewController.h"
#import "XLsn0wConstraintLayout.h"
#import "ConstraintCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
}

- (void)addTableView {
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[ConstraintCell class] forCellReuseIdentifier:@"ConstraintCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConstraintCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstraintCell"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

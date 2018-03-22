//
//  ViewController.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/1/8.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import "ViewController.h"
#import "JYJPublishView.h"
@interface ViewController ()<JYJPublishViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ShareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    


}

- (void)ShareBtnClick {
    JYJPublishView *publishView = [[JYJPublishView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    publishView.delegate = self;
    [publishView show];
}


-(void) didSelecteBtnWithBtntag:(NSInteger)tag buttonTitle:(NSString *)title{
    if (tag == 1) {
        NSLog(@"1");
    }else if (tag == 2) {
        NSLog(@"2");
    }else {
        NSLog(@"CLOSE");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

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
    if ([title isEqualToString:@"微信登录"]) {
        NSLog(@"微信登录");
    }if ([title isEqualToString:@"QQ登录"]) {
        NSLog(@"QQ登录");

    }if ([title isEqualToString:@"微博登录"]) {
        NSLog(@"微博登录");

    }if ([title isEqualToString:@"微信分享"]) {
        NSLog(@"微信分享");

    }if ([title isEqualToString:@"朋友圈分享"]) {
        NSLog(@"朋友圈分享");

    }if ([title isEqualToString:@"微博分享"]) {
        NSLog(@"微博分享");

    }if ([title isEqualToString:@"QQ分享"]) {
        NSLog(@"QQ分享");

    }if ([title isEqualToString:@"QQ空间分享"]) {
        NSLog(@"QQ空间分享");
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

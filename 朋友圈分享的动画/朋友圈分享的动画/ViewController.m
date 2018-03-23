//
//  ViewController.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/1/8.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import "ViewController.h"
#import "JYJPublishView.h"
#import "WTQQShareManger.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "WTWXShareManger.h"
#import "WTWBShareManger.h"

@interface ViewController ()<JYJPublishViewDelegate>

{
    AppDelegate *appdelegate;
}

@property (nonatomic,strong) UIImageView *third_image;

@property (nonatomic,strong) UILabel *third_name;

@property (nonatomic,strong) UILabel *access_token;

@property (nonatomic,strong) UILabel *third_id;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.third_image = [[UIImageView alloc]init];
    self.third_image.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:self.third_image];
    
    
    
    
    
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
        
        [WTWXShareManger WT_LoginUserInfoWithWTQQType:WTLoginTypeWeiXin result:^(NSDictionary *LoginResult, NSString *error) {
            
            NSLog(@"微信登录 === %@",LoginResult);

            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
            [alertView show];
            
              [self.third_image sd_setImageWithURL:[NSURL URLWithString:LoginResult[@"third_image"]]];
            
        }];
        
    }if ([title isEqualToString:@"QQ登录"]) {
        NSLog(@"QQ登录");
        
       [ WTQQShareManger WT_LoginUserInfoWithWTQQType:WTLoginTypeTencent result:^(NSDictionary *LoginResult, NSString *error) {
           
           if (LoginResult) {
               
               NSLog(@"🐒🐒🐒🐒🐒🐒🐒🐒-----%@", LoginResult);
               
               [self.third_image sd_setImageWithURL:[NSURL URLWithString:LoginResult[@"third_image"]]];

           }else{
               NSLog(@"%@",error);
           }
            
        }];
        

    }if ([title isEqualToString:@"微博登录"]) {
        NSLog(@"微博登录");

    }if ([title isEqualToString:@"微信分享"]) {
        
        [WTWXShareManger WT_shareWithContent:nil shareType:WTShareTypeWeiXinSession shareResult:^(NSDictionary *LoginResult, NSString *error) {
           NSLog(@"微信分享 == %@",LoginResult);
            
            
            
        }];

    }if ([title isEqualToString:@"朋友圈分享"]) {
        NSLog(@"朋友圈分享");
        
        [WTWXShareManger WT_shareWithContent:nil shareType:WTShareTypeWeiXinTimeline shareResult:^(NSDictionary *LoginResult, NSString *error) {
            
            NSLog(@"微信分享 == %@",LoginResult);
        }];
        

    }if ([title isEqualToString:@"微博分享"]) {
        NSLog(@"微博分享");

    }if ([title isEqualToString:@"QQ分享"]) {
        NSLog(@"QQ分享");
        
        
        [WTQQShareManger WT_shareWithContent:[WTShareContentItem shareWTShareContentItem] shareType:WTShareTypeQQ shareResult:^(NSDictionary *LoginResult, NSString *error) {
            
            
            NSLog(@"error === %@",error);

        }];
        

    }if ([title isEqualToString:@"QQ空间分享"]) {
        NSLog(@"QQ空间分享");
        
        [WTQQShareManger WT_shareWithContent:nil shareType:WTShareTypeQQZone shareResult:^(NSDictionary *LoginResult, NSString *error) {
           
            NSLog(@"error === %@",error);

            
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end

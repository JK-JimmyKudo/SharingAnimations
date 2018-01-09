//
//  JYJPublishView.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/1/8.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import "JYJPublishView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define ShareH 150

@interface JYJPublishView ()


@end


@implementation JYJPublishView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - ShareH, WIDTH, ShareH)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    NSArray *imageArray = @[@"weixinShar",@"weixinFrindShar",@"weiboShar"];
    NSArray *titleArray = @[@"微信",@"朋友圈",@"微博"];
    
    for (NSInteger i = 0;  i < imageArray.count;i++) {
        NSString *imageStr = imageArray[i];
        NSString *titleStr = titleArray[i];
        CGFloat maigin = (WIDTH - 3*60)/4;
        UIButton *btn1 = [self btnAnimationWithFrame:CGRectMake(maigin + i * (60 + maigin), HEIGHT - 80, 60, 60) imageName:imageStr animationFrame:CGRectMake(maigin + i * (60 + maigin), HEIGHT - 130, 60, 60) delay:0.0];
        btn1.tag = i;
        [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [self LabelAnimationWithFrame:CGRectMake(maigin + i * (60 + maigin), CGRectGetMinY(btn1.frame) + 10, 60, 60) imageName:titleStr animationFrame:CGRectMake(maigin + i * (60 + maigin), HEIGHT - 130 + 55, 60, 20) delay:0.0];
        label.tag = i;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
//    UIButton *btn1 = [self btnAnimationWithFrame:CGRectMake(WIDTH / 4 - 30, HEIGHT - 80, 60, 60) imageName:@"weixinShar" animationFrame:CGRectMake(WIDTH / 4 - 30, HEIGHT - 130, 60, 60) delay:0.0];
//    btn1.backgroundColor = [UIColor redColor];
//    btn1.tag = 1;
//    [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *btn2 = [self btnAnimationWithFrame:CGRectMake((WIDTH / 4) * 3 - 30, HEIGHT - 80, 60, 60) imageName:@"weixinFrindShar" animationFrame:CGRectMake((WIDTH / 4) * 3 - 30, HEIGHT - 130, 60, 60) delay:0.1];
//    btn2.tag = 2;
//    btn2.backgroundColor = [UIColor orangeColor];
//    [btn2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.backgroundColor = [UIColor orangeColor];
    plus.frame = CGRectMake((WIDTH - 25) / 2, HEIGHT - 35, 25, 25);
    [plus setBackgroundImage:[UIImage imageNamed:@"close_share_icon"] forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
    plus.tag = 3;
    [self addSubview:plus];
    [UIView animateWithDuration:0.2 animations:^{
        plus.transform = CGAffineTransformMakeRotation(M_PI_2);
    }];
}

- (void)show {
    UIWindow *keyWindown = [UIApplication sharedApplication].keyWindow;
    [keyWindown addSubview:self];
}
// 定义一个方法，减去一些重复的步骤，高内聚低耦合嘛！
- (UIButton *)btnAnimationWithFrame:(CGRect)frame imageName:(NSString *)imageName animationFrame:(CGRect)aniFrame delay:(CGFloat)delay {
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [btn setTitle:@"wei'xin" forState:UIControlStateNormal];
    [self addSubview:btn];
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        btn.frame = aniFrame;
    } completion:^(BOOL finished) {
        
    }];
    return btn;
    // usingSpringWithDamping:弹簧动画的阻尼值，也就是相当于摩擦力的大小 ,该属性的值0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大到一定程度，会出现不动的情况。
    // initialSpringVelocity:弹簧画的速率，或者说是动力。值越小的弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
    
}

// 定义一个方法，减去一些重复的步骤，高内聚低耦合嘛！
- (UILabel *)LabelAnimationWithFrame:(CGRect)frame imageName:(NSString *)imageName animationFrame:(CGRect)aniFrame delay:(CGFloat)delay {
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.text = [NSString stringWithFormat:@"%@",imageName];
    [self addSubview:label];
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        label.frame = aniFrame;
    } completion:^(BOOL finished) {
        
    }];
    return label;
}






- (void)BtnClick:(UIButton *)btn {
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 *i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    for (NSInteger i = 0; i< self.subviews.count; i++ ) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UILabel class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
    
    [self performSelector:@selector(removeView:) withObject:btn afterDelay:0.5];
}

- (void)removeView:(UIButton *)btn {
    [self removeFromSuperview];
    [self.delegate didSelecteBtnWithBtntag:btn.tag];
}
// 点击白色View范围之外的执行的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    CGFloat deltaY  = currentPosition.y;
    if (deltaY < HEIGHT - ShareH) {
        [self cancelAnimation];
    }
    
}
- (void)cancelAnimation {
    UIButton *cancelButton = (UIButton *)[self viewWithTag:3];
    [UIView animateWithDuration:0.2 animations:^{
        cancelButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }];
    
    for (NSInteger i = 0; i< self.subviews.count; i++ ) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
    
    for (NSInteger i = 0; i< self.subviews.count; i++ ) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UILabel class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
    
    
    
}



@end

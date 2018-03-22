//
//  JYJPublishView.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/1/8.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import "JYJPublishView.h"
#import "ShareSDKMethod.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define ShareH 150

@interface JYJPublishView ()

@property (nonatomic,strong) ShareSDKMethod *SDKMethod;

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
    
    NSArray *imageArray = @[@"weixinShar",@"weixinFrindShar",@"weiboShar",@"share_qq",@"share_zone"];
    NSArray *titleArray = @[@"微信",@"朋友圈",@"微博",@"QQ",@"qq"];
    CGFloat itemWidth = 60;
    CGFloat itemHeight = 90;
    CGFloat maigin = (WIDTH - 3*itemWidth)/4;
    NSInteger rowCount = 3;
    CGFloat whiteViewHeight = (2)*(itemHeight + 10) + 45;
    CGFloat whiteViewY = HEIGHT - whiteViewHeight;
    
    
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, whiteViewY, WIDTH, whiteViewHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    

    for (NSInteger i = 0;  i < imageArray.count;i++) {
        NSString *imageStr = imageArray[i];
        NSString *titleStr = titleArray[i];
        self.SDKMethod = [self btnAnimationWithFrame:CGRectMake(maigin + (i%rowCount) * (60 + maigin),whiteViewY +  24 + (i/rowCount)*(itemHeight+10), itemWidth, itemHeight) imageName:imageStr animationFrame:CGRectMake(maigin + (i%rowCount) * (60 + maigin),whiteViewY + 10 + (i/rowCount)*(itemHeight+10), itemWidth, itemHeight) delay:0.0];
        self.SDKMethod.shareBtn.tag = i;
        self.SDKMethod.shareLabel.tag = i;
        self.SDKMethod.shareLabel.text = titleStr;
        [self.SDKMethod.shareBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
    plus.frame = CGRectMake((WIDTH - 25) / 2, HEIGHT - 35, 25, 25);
    [plus setBackgroundImage:[UIImage imageNamed:@"SearchOff"] forState:UIControlStateNormal];
    [plus addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
    plus.tag = 100;
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
- (ShareSDKMethod *)btnAnimationWithFrame:(CGRect)frame imageName:(NSString *)imageName animationFrame:(CGRect)aniFrame delay:(CGFloat)delay {
    
    ShareSDKMethod *btn = [[ShareSDKMethod alloc]init];
    btn.frame = frame;
    [btn creatView];
    [btn.shareBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self addSubview:btn];
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        btn.frame = aniFrame;
    } completion:^(BOOL finished) {
        
    }];
    return btn;
    // usingSpringWithDamping:弹簧动画的阻尼值，也就是相当于摩擦力的大小 ,该属性的值0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大到一定程度，会出现不动的情况。
    // initialSpringVelocity:弹簧画的速率，或者说是动力。值越小的弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
    
}
- (void)BtnClick:(UIButton *)btn {
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[ShareSDKMethod class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 *i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    [self performSelector:@selector(removeView:) withObject:btn afterDelay:0.2];
}

- (void)removeView:(UIButton *)btn {
    [self removeFromSuperview];
    [self.delegate didSelecteBtnWithBtntag:btn.tag buttonTitle:[NSString stringWithFormat:@"%@",btn.titleLabel.text]];
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
    UIButton *cancelButton = (UIButton *)[self viewWithTag:100];
    [UIView animateWithDuration:0.2 animations:^{
        cancelButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }];
    
    for (NSInteger i = 0; i< self.subviews.count; i++ ) {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[ShareSDKMethod class]]) {
            [UIView animateWithDuration:0.3 delay:0.1 * i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, HEIGHT, 60, 60);
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    }
}



@end

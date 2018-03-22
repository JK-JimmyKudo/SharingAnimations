//
//  ShareSDKMethod.m
//  3Dov
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 3Dov. All rights reserved.
//

#import "ShareSDKMethod.h"
#import "UIView+LLAdd.h"
@implementation ShareSDKMethod

-(instancetype) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) creatView{

    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 30)];
    self.shareBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:self.shareBtn];
    
    self.shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 30 + 10, self.width, 20)];
    self.shareLabel.textColor = [UIColor grayColor];
    self.shareLabel.font = [UIFont systemFontOfSize:12];
    self.shareLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.shareLabel];
    
    
}

@end

//
//  JYJPublishView.h
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/1/8.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import <UIKit/UIKit.h>

// 代理方法  判断点击了那个button
@protocol JYJPublishViewDelegate <NSObject>

- (void)didSelecteBtnWithBtntag:(NSInteger)tag;

@end

@interface JYJPublishView : UIView

@property (nonatomic, weak) id <JYJPublishViewDelegate> delegate;

- (void)show;
@end

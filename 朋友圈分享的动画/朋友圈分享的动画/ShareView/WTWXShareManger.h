//
//  WTWXShareManger.h
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WTShareContentItem.h"

typedef NS_ENUM(NSInteger, WTWXType) {
    WTLoginTypeWeiXin,         //微信登录
    WTShareTypeWeiXinTimeline,// 朋友圈
    WTShareTypeWeiXinSession,// 微信朋友
    WTShareTypeWeiXinFavorite,// 微信收藏
};


typedef NS_ENUM(NSInteger, WTWeiXinErrCode) {
    WTShareWeiXinErrCodeSuccess = 0,   // 分享成功
    WTShareWeiXinErrCodeCancel = -1,   // 分享失败
    
};

typedef void(^WTQQResultBlock)(NSDictionary * LoginResult, NSString * error);




@interface WTWXShareManger : NSObject<WXApiDelegate>

@property (nonatomic, copy)WTQQResultBlock resultBlock;
@property (nonatomic, assign)WTWXType wtLoginType;

+ (instancetype)WXShareManger;

+ (void)WT_LoginUserInfoWithWTQQType:(WTWXType)type result:(WTQQResultBlock)result;

+ (void)WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTWXType)shareType shareResult:(WTQQResultBlock)shareResult;


@end

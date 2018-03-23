//
//  WTWBShareManger.h
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "WTShareContentItem.h"

typedef NS_ENUM(NSInteger, WTWBType) {
    WTWBLoginType,         //微博登录
    WTShareWBType,//         微博分享
};


typedef NS_ENUM(NSInteger, WTWBErrCode) {
    WTShareWBErrCodeSuccess = 0,   // 分享成功
    WTShareWBErrCodeCancel = -1,   // 分享失败
    
};

typedef void(^WTWBResultBlock)(NSDictionary * SuccessResult, NSString * error);

@interface WTWBShareManger : NSObject<WBHttpRequestDelegate,WeiboSDKDelegate>



@property (nonatomic, copy)WTWBResultBlock resultBlock;
@property (nonatomic, assign)WTWBType wtLoginType;

+ (instancetype)WeiBoShareManger;

+ (void)WT_LoginUserInfoWithWTQQType:(WTWBType)type result:(WTWBResultBlock)result;

+ (void)WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTWBType)shareType shareResult:(WTWBResultBlock)shareResult;

@end

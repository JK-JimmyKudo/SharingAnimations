//
//  WTQQShareManger.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//







#define  kTencentAppId       @"1105491932"
#define  KTencentAPPKEY      @"WOuYpZMQ0psi3xIA"



#import "WTQQShareManger.h"


@interface WTQQShareManger ()
@property (nonatomic, strong)TencentOAuth * tencentOAuth;
@property (nonatomic, strong)NSMutableArray * tencentPermissions;
@end

static WTQQShareManger * _instance;

@implementation WTQQShareManger


+ (void)initialize
{
    
    NSLog(@" ==== WTThirdPartyLoginManager");
    
    [WTQQShareManger QQShareManger];
}

+(instancetype) QQShareManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WTQQShareManger alloc]init];
         [_instance setRegisterApps];
    });
    
    return _instance;
}
// 注册app
// 注册appid
- (void)setRegisterApps
{
    // 注册QQ
    _tencentOAuth = [[TencentOAuth alloc]initWithAppId:kTencentAppId andDelegate:self];
    // 这个是说到时候你去qq那拿什么信息
    _tencentPermissions = [NSMutableArray arrayWithArray:@[/** 获取用户信息 */
                                                           kOPEN_PERMISSION_GET_USER_INFO,
                                                           /** 移动端获取用户信息 */
                                                           kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                                           /** 获取登录用户自己的详细信息 */
                                                           kOPEN_PERMISSION_GET_INFO]];
}


+(void) GetUserInfoWithWTQQType:(WTQQType)type result:(WTQQResultBlock)result{
    
   
    _instance.resultBlock = result;
    _instance.wtLoginType = type;
    
    [_instance.tencentOAuth authorize:_instance.tencentPermissions];
    
    
    
    
    
    
    
}

#pragma mark - TencentLoginDelegate
//委托
- (void)tencentDidLogin
{
    [_tencentOAuth getUserInfo];
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        NSLog(@"%@", response.jsonResponse);
        NSLog(@"openID %@", [_tencentOAuth openId]);
        NSDictionary *paramter = @{@"third_id" : [_tencentOAuth openId],
                                   @"third_name" : [response.jsonResponse valueForKeyPath:@"nickname"],
                                   @"third_image":[response.jsonResponse valueForKeyPath:@"figureurl_qq_2"],
                                   @"access_token":[_tencentOAuth accessToken]};
        
        if (self.resultBlock)
        {
            self.resultBlock(paramter, nil);
        }
    }
    else
    {
        NSLog(@"登录失败!");
    }
}

- (void)tencentDidLogout
{
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    
}

- (void)tencentDidNotNetWork
{
    
}

@end

//
//  WTQQShareManger.m
//  朋友圈分享的动画
//
//  Created by 彭围 on 2018/3/22.
//  Copyright © 2018年 dfsj. All rights reserved.
//







#define  kTencentAppId       @"1105491932"
#define  KTencentAPPKEY      @"WOuYpZMQ0psi3xIA"
#define kWTShareQQSuccess @"0"
#define kWTShareQQFail      @"-4"


#import "WTQQShareManger.h"
#import "AppDelegate.h"

@interface WTQQShareManger ()

@property (nonatomic, strong)TencentOAuth * tencentOAuth;
@property (nonatomic, strong)NSMutableArray * tencentPermissions;
@end

static WTQQShareManger * _instance;

@implementation WTQQShareManger


+ (void)initialize
{
    
//    NSLog(@" ==== WTThirdPartyLoginManager");
    
    [WTQQShareManger QQShareManger];
    
}

+(instancetype) QQShareManger{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
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

//登录
+(void) WT_LoginUserInfoWithWTQQType:(WTQQType)type result:(WTQQResultBlock)result{
    _instance.resultBlock = result;
    _instance.wtLoginType = type;
    [_instance.tencentOAuth authorize:_instance.tencentPermissions];
}

//分享

+(void) WT_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTQQType)shareType shareResult:(WTQQResultBlock)shareResult{
    
    WTQQShareManger * shareManager = [WTQQShareManger QQShareManger];

    shareManager.resultBlock = shareResult;
    
    [self wt_shareWithContent:contentObj shareType:shareType];
}

+ (void)wt_shareWithContent:(WTShareContentItem *)contentObj shareType:(WTQQType)shareType
{
 
    [WTQQShareManger QQShareManger];
    
    /*分享 新闻URL对象 。
     获取一个autorelease的<code>QQApiAudioObject</code>
     @param url 音频内容的目标URL
     @param title 分享内容的标题
     @param description 分享内容的描述
     @param previewURL 分享内容的预览图像URL
     @note 如果url为空，调用<code>QQApi#sendMessage:</code>时将返回FALSE
     */

    switch (shareType) {
        case WTShareTypeQQ:
        {
            NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
            NSURL *preimageUrl = [NSURL URLWithString:@"http://www.sizzee.com/index.php/catalog/product/view/id/55730/s/10196171/?SID=au0lhpg54f11nenmrjvhsh0rq6?uk=Y3VzdG9tZXJfaWQ9Mjc0fHByb2R1Y3RfaWQ9NTU3MzA"];
            QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:@"测试分享" description:[NSString stringWithFormat:@"分享内容------新闻URL对象分享 ------test"] previewImageURL:preimageUrl];
            //请求帮助类,分享的所有基础对象，都要封装成这种请求对象。
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
//            [[WTQQShareManger QQShareManger] handleSendResult:sent];
             NSLog(@"QQApiSendResultCode %d",sent);
        }
            break;
            case WTShareTypeQQZone:
            {
            NSString *utf8String = @"http://www.163.com";
            NSString *title = @"新闻标题";
            NSString *description = @"新闻描述";
            NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
            QQApiNewsObject *newsObj = [QQApiNewsObject
                                        objectWithURL:[NSURL URLWithString:utf8String]
                                        title:title
                                        description:description
                                        previewImageURL:[NSURL URLWithString:previewImageUrl]];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
            //分享到QZone
             QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
            NSLog(@"QQApiSendResultCode %d",sent);
        }
            break;
        default:
            break;
    }
}



- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


















#pragma mark - TencentLoginDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    NSLog(@" 登录成功后的回调  ");
    
    [_tencentOAuth getUserInfo];
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED){
        NSLog(@"%@", response.jsonResponse);
        
        NSLog(@"openID %@", [_tencentOAuth openId]);
        
        NSDictionary *paramter = @{@"third_id" : [_tencentOAuth openId],
                                   @"third_name" : [response.jsonResponse valueForKeyPath:@"nickname"],
                                   @"third_image":[response.jsonResponse valueForKeyPath:@"figureurl_qq_2"],
                                   @"access_token":[_tencentOAuth accessToken]};
        
        if (self.resultBlock){
            self.resultBlock(paramter, nil);}
        
    }else{
        NSLog(@"登录失败!");
    }
}


/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    NSLog(@" ----req %@",req);
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    
    NSLog(@" ----resp %@",resp.class);

    // SendMessageToQQResp应答帮助类
    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
        
    }
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    
} 

/**
 * 退出登录的回调
 */
- (void)tencentDidLogout
{
    /** Access Token凭证，用于后续访问各开放接口 */
    if (_tencentOAuth.accessToken) {
        
        
        
    }else{
        
        NSLog(@"accessToken 没有获取成功");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        NSLog(@" 用户点击取消按键,主动退出登录");
    }else{
        NSLog(@"其他原因， 导致登录失败");
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
     NSLog(@"没有网络了， 怎么登录成功呢");
}

/**
 * 因用户未授予相应权限而需要执行增量授权。在用户调用某个api接口时，如果服务器返回操作未被授权，则触发该回调协议接口，由第三方决定是否跳转到增量授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \param permissions 需增量授权的权限列表。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启增量授权流程。若需要增量授权请调用\ref TencentOAuth#incrAuthWithPermissions: \n注意：增量授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

/**
 * [该逻辑未实现]因token失效而需要执行重新登录授权。在用户调用某个api接口时，如果服务器返回token失效，则触发该回调协议接口，由第三方决定是否跳转到登录授权页面，让用户重新授权。
 * \param tencentOAuth 登录授权对象。
 * \return 是否仍然回调返回原始的api请求结果。
 * \note 不实现该协议接口则默认为不开启重新登录授权流程。若需要重新登录授权请调用\ref TencentOAuth#reauthorizeWithPermissions: \n注意：重新登录授权时用户可能会修改登录的帐号
 */
- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

/**
 * 用户通过增量授权流程重新授权登录，token及有效期限等信息已被更新。
 * \param tencentOAuth token及有效期限等信息更新后的授权实例对象
 * \note 第三方应用需更新已保存的token及有效期限等信息。
 */
- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;
    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}


/**
 * 用户增量授权过程中因取消或网络问题导致授权失败
 * \param reason 授权失败原因，具体失败原因参见sdkdef.h文件中\ref UpdateFailType
 */
- (void)tencentFailedUpdate:(UpdateFailType)reason{
    
    switch (reason)
    {
        case kUpdateFailNetwork:
        {
            //            _labelTitle.text=@"增量授权失败，无网络连接，请设置网络";
            NSLog(@"增量授权失败，无网络连接，请设置网络");
            break;
        }
        case kUpdateFailUserCancel:
        {
            //            _labelTitle.text=@"增量授权失败，用户取消授权";
            NSLog(@"增量授权失败，用户取消授权");
            break;
        }
        case kUpdateFailUnknown:
        default:
        {
            NSLog(@"增量授权失败，未知错误");
            break;
        }
    }
}

#pragma mark - 判断qq是否分享成功
+ (void)didReceiveTencentUrl:(NSURL *)url
{
    NSString * urlStr = url.absoluteString;
    NSArray * array = [urlStr componentsSeparatedByString:@"error="];
    if (array.count > 1) {
        NSString * lastStr = [array lastObject];
        NSArray * lastStrArray = [lastStr componentsSeparatedByString:@"&"];
        
        NSString * resultStr = [lastStrArray firstObject];
        if ([resultStr isEqualToString:kWTShareQQSuccess]) {
                        NSLog(@"QQ------分享成功!");
            [WTQQShareManger QQShareManger].resultBlock(nil,@"QQ------分享成功!" );
        }else if ([resultStr isEqualToString:kWTShareQQFail]){
                        NSLog(@"QQ------分享失败!");
            [WTQQShareManger QQShareManger].resultBlock(nil,@"QQ------分享失败!");
        }
    }
}

@end

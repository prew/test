require 'rest-client'

# ECS API 的服务接入地址为：ecs.aliyuncs.com

# 支持通过 HTTP 或 HTTPS 通道进行请求通信。为了获得更高的安全性，推荐您使用 HTTPS 通道发送请求。

# 每个请求都需要指定要执行的操作，即 Action 参数（例如 StartInstance），以及每个操作都需要包含的公共请求参数和指定操作所特有的请求参数。

# 支持 HTTP GET 方法发送请求，这种方式下请求参数需要包含在请求的 URL 中。

# 请求及返回结果都使用 UTF-8 字符集进行编码。


# 公共请求参数

# 名称	类型	是否必须	描述
# Format	String	否	返回值的类型，支持 JSON 与 XML。默认为 XML。
# Version	String	是	API 版本号，为日期形式：YYYY-MM-DD，本版本对应为 2014-05-26。
# AccessKeyId	String	是	阿里云颁发给用户的访问服务所用的密钥 ID。
# Signature	String	是	签名结果串，关于签名的计算方法，请参见<签名机制>。
# SignatureMethod	String	是	签名方式，目前支持 HMAC-SHA1。
# Timestamp	String	是	请求的时间戳。日期格式按照 ISO8601 标准表示，并需要使用 UTC 时间。格式为：
# YYYY-MM-DDThh:mm:ssZ
# 例如，2014-05-26T12:00:00Z（为北京时间 2014 年 5 月 26 日 12 点 0 分 0 秒）。
# SignatureVersion	String	是	签名算法版本，目前版本是 1.0。
# SignatureNonce	String	是	唯一随机数，用于防止网络重放攻击。用户在不同请求间要使用不同的随机数值
# ResourceOwnerAccount	String	否	本次 API 请求访问到的资源拥有者账户，即登录用户名。
# 此参数的使用方法，详见< 借助 RAM 实现子账号对主账号的 ECS 资源访问 >，（只能在 RAM 中可对 ECS 资源进行授权的 Action 中才能使用此参数，否则访问会被拒绝）


# 用户发送的每次接口调用请求，无论成功与否，系统都会返回一个唯一识别码 RequestId 给用户。


url = "https://ecs.aliyuncs.com"

params = {:Format => 'JSON',  :Version => '2014-05-26', :AccessKeyId => '', :Signature => '', :SignatureMethod => 'HMAC-SHA1',
          :Timestamp => '', :SignatureVersion => '1.0', :SignatureNonce => ''
          #, :ResourceOwnerAccount => ''
          }

# (a) 按照参数名称的字典顺序对请求中所有的请求参数（包括文档中描述的“公共请求参数”和给定了的请求接口的自定义参数，但不能包括“公共请求参数”中提到 Signature 参数本身）进行排序。


# b) 对每个请求参数的名称和值进行编码。名称和值要使用 UTF-8 字符集进行 URL 编码，URL 编码的编码规则是

# (c) 对编码后的参数名称和值使用英文等号（\=）进行连接。

# (d) 再把英文等号连接得到的字符串按参数名称的字典顺序依次使用 &符号连接，即得到规范化请求字符串。

# 以 DescribeRegions 为例，签名前的请求 URL 为：

# http://ecs.aliyuncs.com/?TimeStamp=2012-12-26T10:33:56Z&Format=XML&AccessKeyId=testid&Action=DescribeRegions&SignatureMethod=HMAC-SHA1&RegionId=region1&SignatureNonce=NwDAxvLU6tFE0DVb&Version=2014-05-26&SignatureVersion=1.0


 # StringToSign=
 # HTTPMethod + “&” +
 # percentEncode(“/”) + ”&” +
 # percentEncode(CanonicalizedQueryString)

# GET&%2F&AccessKeyId%3Dtestid%26Action%3DDescribeRegions%26Format%3DXML%26RegionId%3Dregion1%26SignatureMethod%3DHMAC-SHA1%26SignatureNonce%3DNwDAxvLU6tFE0DVb%26SignatureVersion%3D1.0%26TimeStamp%3D2012-12-26T10%253A33%253A56Z%26Version%3D2014-05-26


# 假如使用的 Access Key Id 是 “testid”，Access Key Secret 是 “testsecret”，用于计算 HMAC 的 Key 就是 “testsecret&”，则计算得到的签名值是：



#  SDFQNvyH5rtkc9T5Fwo8DOjw5hc=

# 签名后的请求 URL 为（注意增加了 Signature 参数）：



# http://ecs.aliyuncs.com/?TimeStamp=2012-12-26T10%3A33%3A56Z&Format=XML&AccessKeyId=testid&Action=DescribeRegions&SignatureMethod=HMAC-SHA1&RegionId=region1&SignatureNonce=NwDAxvLU6tFE0DVb&Version=2012-09-13&SignatureVersion=1.0&Signature=SDFQNvyH5rtkc9T5Fwo8DOjw5hc%3d

# {
#     "RequestId": "8906582E-6722-409A-A6C4-0E7863B733A5",
#     "HostId": "ecs.aliyuncs.com",
#     "Code": "UnsupportedOperation",
#     "Message": "The specified action is not supported."
# }



# 公共错误码

# 错误代码	描述	Http 状态码	语义
# MissingParameter	The input parameter "Action" that is mandatory for processing this request is not supplied	400	缺少 Action 字段
# MissingParameter	The input parameter "AccessKeyId" that is mandatory for processing this request is not supplied	400	缺少 AccessKeyId 字段
# MissingParameter	An input parameter "Signature" that is mandatory for processing the request is not supplied.	400	缺少 Signature 字段
# MissingParameter	The input parameter "TimeStamp" that is mandatory for processing this request is not supplied	400	缺少 Timestamp 字段
# MissingParameter	The input parameter "Version" that is mandatory for processing this request is not supplied	400	缺少 Version 字段
# InvalidParameter	The specified parameter "Action or Version" is not valid.	400	无效的 Action 值（该 API 不存在）
# InvalidAccessKeyId.NotFound	The Access Key ID provided does not exist in our records.	400	无效的 AccessKeyId 值（该 key 不存在）
# Forbidden.AccessKeyDisabled	The Access Key is disabled.	403	该 AccessKey 处于禁用状态
# IncompleteSignature	The request signature does not conform to Aliyun standards.	400	无效的 Signature 取值（签名结果错误）
# InvalidParamater	The specified parameter "SignatureMethod" is not valid.	400	无效的 SignatureMethod 取值
# InvalidParamater	The specified parameter "SignatureVersion" is not valid.	400	无效的 SignatureVersion 取值
# IllegalTimestamp	The input parameter "Timestamp" that is mandatory for processing this request is not supplied.	400	无效的 Timestamp 取值（Timestamp 与服务器时间相差超过了 1 个小时）
# SignatureNonceUsed	The request signature nonce has been used.	400	无效的 SignatureNonce（该 SignatureNonce 值已被使用过）
# InvalidParameter	The specified parameter "Action or Version" is not valid.	400	无效的 Version 取值
# InvalidOwnerId	The specified OwnerId is not valid.	400	无效的 OwnerId 取值
# InvalidOwnerAccount	The specified OwnerAccount is not valid.	400	无效的 OwnerAccount 取值
# InvalidOwner	OwnerId and OwnerAccount can't be used at one API access.	400	同时使用了 OwnerId 和 OwnerAccount
# Throttling	Request was denied due to request throttling.	400	因系统流控拒绝访问
# Throttling	Request was denied due to request throttling.	400	该 key 的调用 quota 已用完
# InvalidAction	Specified action is not valid.	403	该 key 无权调用该 API
# UnsupportedHTTPMethod	This http method is not supported.	403	用户使用了不支持的 Http Method（当前 TOP 只支持 post 和 get）
# ServiceUnavailable	The request has failed due to a temporary failure of the server.	500	服务不可用
# UnsupportedParameter	The parameter ”<parameter name>” is not supported.	400	使用了无效的参数
# InternalError	The request processing has failed due to some unknown error, exception or failure.	500	其他情况
# MissingParameter	The input parameter OwnerId,OwnerAccount that is mandatory for processing this request is not supplied.	403	调用该接口没有指定 OwnerId
# Forbidden.SubUser	The specified action is not available for you。	403	无权调用订单类接口
# UnsupportedParameter	The parameter ”<parameter name>” is not supported.	400	该参数无权使用
# Forbidden.InstanceNotFound	The specified Instance is not found, so we cann't get enough information to check permission in RAM.	404	使用了 RAM 授权子账号进行资源访问，但是本次访问涉及到的 Instance 不存在
# Forbidden.DiskNotFound	The specified Disk is not found, so we cann't get enough information to check permission in RAM.	404	使用了 RAM 授权子账号进行资源访问,但是本次访问涉及到的 Disk 不存在
# Forbidden.SecurityGroupNotFound	The specified SecurityGroup is not found, so we cann't get enough information to check permission in RAM.	404	使用了 RAM 授权子账号进行资源访问,但是本次访问涉及到的 SecurityGroup 不存在
# Forbidden.SnapshotNotFound	The specified Snapshot is not found, so we cann't get enough information to check permission in RAM.	404	使用了 RAM 授权子账号进行资源访问,但是本次访问涉及到的 Snapshot 不存在
# Forbidden.ImageNotFound	The specified Image is not found, so we cann't get enough information to check permission in RAM.	404	使用了 RAM 授权子账号进行资源访问,但是本次访问涉及到的 Image 不存在
# Forbidden.RAM	User not authorized to operate the specified resource, or this API doesn't support RAM.	403	使用了 RAM 授权子账号进行资源访问,但是本次操作没有被正确的授权
# Forbidden.NotSupportRAM	This action does not support accessed by RAM mode.	403	该接口不允许使用 RAM 方式进行访问
# Forbidden.RiskControl	This operation is forbidden by Aliyun Risk Control system.	403	阿里云风控系统拒绝了此次访问
# InsufficientBalance	Your account does not have enough balance.	400	余额不足
# IdempotentParameterMismatch	Request uses a client token in a previous request but is not identical to that request.	400	使用了一个已经使用过的 ClientToken，但此次请求内容却又与上一次使用该 Token 的 request 不一样.
# RealNameAuthenticationError	Your account has not passed the real-name authentication yet.	403	用户未进行实名认证
# InvalidIdempotenceParameter.Mismatch	The specified parameters are different from before	403	幂等参数不匹配
# LastTokenProcessing	The last token request is processing	403	上一次请求还在处理中
# InvalidParameter	The specified parameter is not valid	400	参数校验失败
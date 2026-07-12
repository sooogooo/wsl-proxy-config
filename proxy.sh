#!/bin/bash
# ~/.proxy.sh — WSL 代理配置
# 通过 127.0.0.1:10808 访问 GFW 屏蔽内容，本地/内网/国内直连

_PROXY_URL="http://127.0.0.1:10808"

# 不走代理的地址：本地 + 私有网段 + 国内主要域名
_NO_PROXY="\
localhost,127.0.0.1,127.0.0.0/8,::1,0.0.0.0,\
10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,\
.local,\
.cn,.com.cn,.net.cn,.org.cn,.gov.cn,.edu.cn,\
.baidu.com,.baidu.cn,.baidubce.com,\
.qq.com,.weixin.qq.com,.wechat.com,.tencent.com,\
.163.com,.126.com,.netease.com,\
.taobao.com,.tmall.com,.alipay.com,.aliyun.com,.alibaba.com,.alicdn.com,\
.jd.com,.360buy.com,.jdcloud.com,\
.weibo.com,.sina.com,.sina.com.cn,.sinaimg.cn,\
.zhihu.com,.zhimg.com,\
.bilibili.com,.hdslb.com,.bilivideo.com,\
.douyin.com,.toutiao.com,.bytedance.com,.byteimg.com,.byted.org,\
.kuaishou.com,.kwai.com,\
.iqiyi.com,.qiyi.com,.youku.com,.sohu.com,\
.meituan.com,.dianping.com,.waimai.meituan.com,\
.xiaomi.com,.mi.com,.miui.com,\
.huawei.com,.hicloud.com,\
.xinhuanet.com,.people.com.cn,.chinadaily.com.cn,\
.csdn.net,.cnblogs.com,.oschina.net,.gitee.com,\
.douban.com,.doubanio.com,\
.pinduoduo.com,.yangkeduo.com,\
.jiguang.cn,.umeng.com,.umengcloud.com"

proxy_on() {
    export http_proxy="${_PROXY_URL}"
    export https_proxy="${_PROXY_URL}"
    export HTTP_PROXY="${_PROXY_URL}"
    export HTTPS_PROXY="${_PROXY_URL}"
    export no_proxy="${_NO_PROXY}"
    export NO_PROXY="${_NO_PROXY}"
    echo "代理已开启: ${_PROXY_URL}"
}

proxy_off() {
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
    echo "代理已关闭"
}

proxy_status() {
    if [ -n "${http_proxy}" ]; then
        echo "代理状态: 开启 (${http_proxy})"
    else
        echo "代理状态: 关闭"
    fi
}

# 默认开启代理
proxy_on

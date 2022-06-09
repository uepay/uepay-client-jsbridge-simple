package com.uepay.webview.simple;

/**
 * Created by zsg on 2022/6/7.
 * Desc:
 * <p>
 * Copyright (c) 2022 UePay.mo All rights reserved.
 */
public class Response {

    public String ret_code; // 狀態碼，00：成功、01：失敗
    public String ret_msg;  // 狀態描述

    //--------請求定位字段---------
    public double longitude; // 纬度，浮点数，范围为90 ~ -90
    public double latitude;  // 经度，浮点数，范围为180 ~ -180。
    public float accuracy;   // 位置精度
    public float speed;      // 速度，以米/每秒计
}

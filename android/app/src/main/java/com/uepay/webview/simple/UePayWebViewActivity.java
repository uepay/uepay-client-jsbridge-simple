package com.uepay.webview.simple;

import android.net.Uri;
import android.net.http.SslError;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.webkit.SslErrorHandler;
import android.webkit.URLUtil;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import com.google.gson.Gson;
import com.uepay.web.BridgeHandler;
import com.uepay.web.BridgeWebViewClient;
import com.uepay.web.CallbackFunction;
import com.uepay.web.UePayWebView;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by zsg on 2022/6/7.
 * Desc: UePay客戶端WebView組件SDK使用示例（demo代碼僅做參考）
 * <p>
 * Copyright (c) 2022 UePay.mo All rights reserved.
 */
public class UePayWebViewActivity extends AppCompatActivity {

    private final String TAG = "UePayWebViewActivity";

    private String requestUrl = "file:///android_asset/index.html";

    UePayWebView webView;
    EditText editText;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setTitle(R.string.app_title);
        setContentView(R.layout.activity_uepay_webview);
        editText = findViewById(R.id.edt_request_url);
        webView = findViewById(R.id.web_view);

        setupWebView();

        registerHandler();

        loadUrl();
    }


    /**
     * 打開html頁面
     */
    private void loadUrl() {
        webView.loadUrl(requestUrl);
        editText.setText(requestUrl);
    }

    /**
     * 根據需要設置WebView屬性
     */
    private void setupWebView() {
        WebSettings settings = webView.getSettings();
        String originUA = settings.getUserAgentString();
        // 添加瀏覽器自定義的 userAgent 信息；"Customer/Text" 可替換成任意字符串
        String newUA = new StringBuilder(originUA).append("; Customer/Text").toString();
        Log.i(TAG,"originUA: " + originUA);
        Log.i(TAG,"newUA: " + newUA);
        settings.setUserAgentString(newUA);
        webView.setWebChromeClient(new UePayWebChromeClient());
        webView.setWebViewClient(new UePayWebViewClient(webView));
    }

    /**
     * 註冊native原生方法，提供給JS側調用
     */
    private void registerHandler() {
        // 獲取定位信息
        webView.registerHandler("getLocation", (data, function) -> {
            Log.i(TAG, "getLocation: " + data);
            if (TextUtils.isEmpty(data)) {
                showToast("參數不能為空");
                return;
            }

            /**
             * 模擬獲取位置信息，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Response res = new Response();
            res.ret_code = "00"; // 00：成功，01：失敗
            res.ret_msg = "獲取定位成功";
            res.latitude = 20.146551;
            res.longitude = 112.346848;
            res.speed = 0;
            res.accuracy = 100;
            function.onCallback(g.toJson(res));
        });
        // 喚醒支付
        webView.registerHandler("sendPayReq", (data, function) -> {
            Log.i(TAG, "sendPayReq: " + data);
            showMsgDialog(data, function);
        });
    }

    private void showMsgDialog(String data, final CallbackFunction function) {
        AlertDialog.Builder dialog = new AlertDialog.Builder(this);
        dialog.setTitle("发起支付");
        dialog.setMessage("订单信息：" + data);
        dialog.setPositiveButton("支付完成", (dialog3, which) -> {

            /**
             * 模擬 用戶支付成功，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","00");
            resp.put("ret_msg","success");
            function.onCallback(g.toJson(resp));
        });
        dialog.setNeutralButton("支付失敗",(dialog1, which) -> {

            /**
             * 模擬 支付失敗，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","01");
            resp.put("ret_msg","failed");
            function.onCallback(g.toJson(resp));
        });
        dialog.setNegativeButton("取消支付", (dialog2, which) -> {
            /**
             * 模擬 用戶取消支付，通過回調函數返回給『調用者』結果
             * PS: 返回給js的報文必須是json格式
             */
            Gson g = new Gson();
            Map<String,String> resp = new HashMap<>();
            resp.put("ret_code","02");
            resp.put("ret_msg","cancel");
            function.onCallback(g.toJson(resp));
        });
        dialog.show();
    }


    public void onSearch(View view) {
        String text = editText.getText().toString().trim();
        if (URLUtil.isHttpUrl(text) || URLUtil.isHttpsUrl(text) || URLUtil.isAssetUrl(text)) {
            webView.loadUrl(text);
        } else {
            Toast.makeText(this, "請輸入正確的網址", Toast.LENGTH_SHORT).show();
        }
    }

    private void showToast(String msg) {
        Toast.makeText(UePayWebViewActivity.this, msg, Toast.LENGTH_SHORT).show();
    }


    /**
     * WebChromeClient 默認實現類（根據需要選擇是否實現）
     */
    private class UePayWebChromeClient extends WebChromeClient {

        @Override
        public void onReceivedTitle(WebView view, String title) {
            super.onReceivedTitle(view, title);
        }

        public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback,
                                         WebChromeClient.FileChooserParams fileChooserParams) {
            Log.i("test", "openFileChooser 4:" + filePathCallback.toString());
            return true;
        }
    }

    /**
     * WebViewClient 默認實現類（根據需要選擇是否實現）
     */
    private class UePayWebViewClient extends BridgeWebViewClient {

        UePayWebView webView;

        public UePayWebViewClient(UePayWebView webView) {
            this.webView = webView;
        }

        @Override
        public void onReceivedSslError(WebView webView, SslErrorHandler sslErrorHandler,
                                       SslError sslError) {
            sslErrorHandler.proceed();
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            Log.i("OverrideUrlLoading =>>", url);
            return super.shouldOverrideUrlLoading(view, url);

        }
    }
}

package com.example.counsellingapp.utils;

import com.midtrans.Config;
import com.midtrans.httpclient.SnapApi;
import com.midtrans.httpclient.error.MidtransError;
import com.example.counsellingapp.model.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class MidtransPaymentUtil {

    private static Config snapConfig;

    @Value("${midtrans.server.key}")
    private String serverKey;

    @Value("${midtrans.client-key}")
    private String clientKey;

    @Value("${midtrans.is-production}")
    private boolean isProduction;

    @PostConstruct
    public void init() {
        snapConfig = Config.builder()
                .setServerKey(serverKey)
                .setClientKey(clientKey)
                .setIsProduction(isProduction)
                .build();

        System.out.println("Midtrans initialized. Production mode: " + isProduction);
    }

    public static Map<String, String> createSnapTransaction(
        String orderId, int amount, String itemName, User user,
        String finishUrl, String errorUrl, String pendingUrl) throws MidtransError {

        if (snapConfig == null) {
            throw new IllegalStateException("MidtransPaymentUtil belum di-inisialisasi!");
        }

        Map<String, Object> transactionDetails = new HashMap<>();
        transactionDetails.put("order_id", orderId);
        transactionDetails.put("gross_amount", amount);

        Map<String, Object> item = new HashMap<>();
        item.put("id", "1");
        item.put("name", itemName);
        item.put("price", amount);
        item.put("quantity", 1);

        List<Map<String, Object>> itemDetails = new ArrayList<>();
        itemDetails.add(item);

        Map<String, Object> customerDetails = new HashMap<>();
        customerDetails.put("first_name", user.getName());
        customerDetails.put("email", user.getEmail());

        Map<String, Object> callbacks = new HashMap<>();
        callbacks.put("finish", finishUrl);
        callbacks.put("unfinish", pendingUrl);
        callbacks.put("error", errorUrl);

        Map<String, Object> param = new HashMap<>();
        param.put("transaction_details", transactionDetails);
        param.put("item_details", itemDetails);
        param.put("customer_details", customerDetails);
        param.put("callbacks", callbacks);

        Map<String, Object> result = SnapApi.createTransaction(param, snapConfig).toMap();

        Map<String, String> snapResult = new HashMap<>();
        snapResult.put("token", (String) result.get("token"));
        snapResult.put("redirect_url", (String) result.get("redirect_url"));

        return snapResult;
    }
}
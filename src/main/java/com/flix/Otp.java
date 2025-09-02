package com.flix;

import java.util.Random;

public class Otp {
    public static String GenrateOtp(){
        String otp;
        Random random = new Random();
        StringBuilder stringBuilder = new StringBuilder();
        for (int i = 0; i < 6 ; i++) {
            int num = random.nextInt(10);
            stringBuilder.append(num);
        }
        otp = stringBuilder.toString();
        return otp;
    }
}

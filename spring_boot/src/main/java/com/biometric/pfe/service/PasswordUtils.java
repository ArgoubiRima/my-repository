package com.biometric.pfe.service;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    // Method to encrypt a password
    public static String encryptPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    // Method to verify a password against its encrypted version
    public static boolean verifyPassword(String plainPassword, String encryptedPassword) {
        return BCrypt.checkpw(plainPassword, encryptedPassword);
    }
}

package com.example.cakeshop.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import java.util.regex.Pattern;

/**
 * 口令散列：PBKDF2-HMAC-SHA256 加盐；历史库中的裸 MD5 仍可校验，登录后由业务层升级为散列格式。
 */
public final class PasswordUtil {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String PREFIX = "pbkdf2";
    private static final int ITERATIONS = 12000;
    private static final int KEY_LENGTH_BITS = 256;
    private static final int SALT_BYTES = 16;
    private static final Pattern LEGACY_MD5 = Pattern.compile("^[0-9a-fA-F]{32}$");
    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordUtil() {
    }

    public static String encode(String rawPassword) {
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] hash = pbkdf2(rawPassword, salt, ITERATIONS);
        Base64.Encoder encoder = Base64.getEncoder();
        return PREFIX + ":" + ITERATIONS + ":" + encoder.encodeToString(salt) + ":" + encoder.encodeToString(hash);
    }

    public static boolean matches(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        if (isLegacyMd5(storedPassword)) {
            String legacy = MD5Util.md5(rawPassword);
            return legacy != null && legacy.equalsIgnoreCase(storedPassword);
        }
        String[] parts = storedPassword.split(":");
        if (parts.length != 4 || !PREFIX.equals(parts[0])) {
            return false;
        }
        try {
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            return MessageDigest.isEqual(expected, pbkdf2(rawPassword, salt, iterations));
        } catch (RuntimeException e) {
            return false;
        }
    }

    public static boolean needsUpgrade(String storedPassword) {
        return isLegacyMd5(storedPassword);
    }

    private static boolean isLegacyMd5(String storedPassword) {
        return LEGACY_MD5.matcher(storedPassword).matches();
    }

    private static byte[] pbkdf2(String rawPassword, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(rawPassword.toCharArray(), salt, iterations, KEY_LENGTH_BITS);
            return SecretKeyFactory.getInstance(ALGORITHM).generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("口令散列计算失败", e);
        }
    }
}

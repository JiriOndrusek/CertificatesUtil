package me.JiriOndrusek;

import static org.junit.Assert.assertTrue;

import org.junit.Assert;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;

/**
 * Unit test for simple App.
 */
public class AppTest 
{
    /**
     * Rigorous Test :-)
     */
    @Test
    public void shouldAnswerWithTrue() throws CertificateException, KeyStoreException, IOException, NoSuchAlgorithmException {
//        KeyStore ks = KeyStore.getInstance(new File(AppTest.class.getResource("/test-keystore.p12").getFile()), "tests3cret".toCharArray());
        KeyStore ks = KeyStore.getInstance("PKCS12");
        ks.load(AppTest.class.getResourceAsStream("/test-keystore.p12"), "tests3cret".toCharArray());



        Assert.assertNotNull(ks);
        Assert.assertEquals("localhost", ks.aliases().nextElement());
    }
}

package com.biometric.pfe.service;

import com.biometric.pfe.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;

@Service
public class PersonService {

    @Autowired
    private PersonRepository personRepository;

    public String processFingerprint(byte[] fingerprintImage) {
        String base64Image = null;
        try {
            // Convert the byte array back to a BufferedImage
            ByteArrayInputStream bais = new ByteArrayInputStream(fingerprintImage);
            BufferedImage bufferedImage = ImageIO.read(bais);

            // Convert the BufferedImage to a byte array
            byte[] imageData = convertBufferedImageToArrayBytes(bufferedImage);

            // Encode the byte array to a Base64 string
            base64Image = encodeToBase64(imageData);

        } catch (IOException e) {
            e.printStackTrace();
        }
        return base64Image;
    }

    private byte[] convertBufferedImageToArrayBytes(BufferedImage bufferedImage) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            ImageIO.write(bufferedImage, "jpg", baos);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return baos.toByteArray();
    }

    private String encodeToBase64(byte[] data) {
        return Base64.getEncoder().encodeToString(data);
    }
}

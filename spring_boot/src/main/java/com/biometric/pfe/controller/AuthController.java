package com.biometric.pfe.controller;

import com.biometric.pfe.data.ProfileDTO;
import com.biometric.pfe.data.UserDTO;
import com.biometric.pfe.data.UserLoginDTO;
import com.biometric.pfe.model.Person;
import com.biometric.pfe.model.User;
import com.biometric.pfe.repository.PersonRepository;
import com.biometric.pfe.repository.UserRepository;
import com.biometric.pfe.service.PasswordUtils;
import com.biometric.pfe.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Base64;
import java.util.Optional;

@CrossOrigin(origins = "http://localhost:4200/")
@RestController
@RequestMapping(path = "/auth")
public class AuthController {

    @Autowired
    private  UserRepository userRepository;
    @Autowired
    private PersonService personService;


    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserLoginDTO loginUser) {
        User user = userRepository.findByUsername(loginUser.getUsername());
        if (user != null && PasswordUtils.verifyPassword(loginUser.getPassword(), user.getPassword())) {
            UserDTO userDTO = new UserDTO(user.getUsername(), new ProfileDTO(user.getPerson().getFirstname(), user.getPerson().getLastname(),user.getPerson().getEmail(),user.getPerson().getAddress(),user.getPerson().getPhoneNumber(),user.getPerson().getDob()));
            return ResponseEntity.ok(userDTO);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"error\": \"Invalid username or password\"}");
        }
    }
    @PostMapping("/change_pw")
    public ResponseEntity<?> changePW(@RequestBody UserLoginDTO userChangePW) {
        User user = userRepository.findByUsername(userChangePW.getUsername());
        if (user != null) {
            String hashedPassword = PasswordUtils.encryptPassword(userChangePW.getPassword());
            user.setPassword(hashedPassword);
            userRepository.save(user);
            return ResponseEntity.ok("{\"success\": \"Password Updated Successfully\"}");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("{\"error\": \"Error Occurred\"}");
        }
    }

    @PostMapping("/login_fingerprint")
    public ResponseEntity<?> loginWithFingerprint(@RequestPart("fingerprintImage") MultipartFile fingerprintImage) {
        byte[] fingerprintBytes;
        try {
            fingerprintBytes = fingerprintImage.getBytes();
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("{\"error\": \"Failed to read fingerprint image\"}");
        }

        // Process the fingerprint bytes to get the Base64 encoded string
        String base64Fingerprint = personService.processFingerprint(fingerprintBytes);

        // Fetch the person by fingerprint code
        Optional<User> userOpt = userRepository.findByFingerprintCode(base64Fingerprint);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            UserDTO userDTO = new UserDTO(user.getUsername(), new ProfileDTO(user.getPerson().getFirstname(), user.getPerson().getLastname(),user.getPerson().getEmail(),user.getPerson().getAddress(),user.getPerson().getPhoneNumber(),user.getPerson().getDob()));
            return ResponseEntity.ok(userDTO);

        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("{\"error\": \"Fingerprint does not match\"}");
        }
    }
}

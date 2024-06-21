package com.biometric.pfe.model;

import jakarta.persistence.*;

import java.io.Serializable;


@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    @Lob
    @Column(name = "fingerprint_image", columnDefinition = "LONGBLOB",unique = true)
    private byte[] fingerprintImage;

    @Lob
    @Column(name = "fingerprint_code", columnDefinition = "LONGTEXT",unique = true)
    private String fingerprintCode;
    @OneToOne(optional = true)
    @JoinColumn(name = "person_id", referencedColumnName = "id")
    private Person person;

    public User() {
    }

    public User(String username, String password, byte[] fingerprintImage, String fingerprintCode, Person person) {
        this.username = username;
        this.password = password;
        this.fingerprintImage = fingerprintImage;
        this.fingerprintCode = fingerprintCode;
        this.person = person;
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public byte[] getFingerprintImage() {
        return fingerprintImage;
    }

    public void setFingerprintImage(byte[] fingerprintImage) {
        this.fingerprintImage = fingerprintImage;
    }

    public String getFingerprintCode() {
        return fingerprintCode;
    }

    public void setFingerprintCode(String fingerprintCode) {
        this.fingerprintCode = fingerprintCode;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }
}
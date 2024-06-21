package com.biometric.pfe.data;

public class UserDTO {
    private String username;
    private ProfileDTO profile;

    public UserDTO() {
    }

    public UserDTO(String username, ProfileDTO profile) {
        this.username = username;
        this.profile = profile;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public ProfileDTO getProfile() {
        return profile;
    }

    public void setProfile(ProfileDTO profile) {
        this.profile = profile;
    }
}

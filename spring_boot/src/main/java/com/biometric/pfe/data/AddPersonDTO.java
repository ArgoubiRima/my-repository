package com.biometric.pfe.data;

import com.biometric.pfe.model.Person;

public class AddPersonDTO {
    private Person profile;

    private String password;


    public AddPersonDTO() {
    }

    public AddPersonDTO(Person profile,String password) {
        this.profile = profile;
        this.password = password;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Person getProfile() {
        return profile;
    }

    public void setProfile(Person profile) {
        this.profile = profile;
    }
}

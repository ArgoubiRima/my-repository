package com.biometric.pfe.controller;

import com.biometric.pfe.data.AddPersonDTO;
import com.biometric.pfe.exception.ResourceNotFoundException;
import com.biometric.pfe.model.Person;
import com.biometric.pfe.model.User;
import com.biometric.pfe.repository.PersonRepository;
import com.biometric.pfe.repository.UserRepository;
import com.biometric.pfe.service.PasswordUtils;
import com.biometric.pfe.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "http://localhost:4200/")
@RestController
@RequestMapping(path = "/persons")
public class PersonController {

    @Autowired
    private PersonRepository personRepository;
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PersonService personService;


    @GetMapping
    public List<Person> getAllPersons() {
        return personRepository.findAll();
    }

    @PostMapping
    public Person createPerson(@RequestBody AddPersonDTO personDTO) {
        Person newPerson = personRepository.save(personDTO.getProfile());
        String hashedPassword = PasswordUtils.encryptPassword(personDTO.getPassword());
        User newUser = new User(personDTO.getProfile().getEmail(), hashedPassword, null, null, newPerson);
        userRepository.save(newUser);
        return newPerson;
    }



    @PostMapping("/{id_person}/fingerprint")
    public ResponseEntity< ? > updateFingerprint(@PathVariable Long id_person, @RequestPart("fingerprintImage") MultipartFile fingerprintImage) throws IOException {
        try{
            Optional<Person> personOpt = personRepository.findById(id_person);
            if (personOpt.isPresent()) {
                Person person = personOpt.get();
                Optional<User> userOpt = userRepository.findByPerson(person);
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    user.setFingerprintImage(fingerprintImage.getBytes());
                    String fingerprintCode = personService.processFingerprint(fingerprintImage.getBytes());
                    user.setFingerprintCode(fingerprintCode);
                    userRepository.save(user);
                }
            }
            return ResponseEntity.ok("{\"success\": \"Person Deleted Successfully\"}");
        }catch (Exception e){
            Person person = personRepository.getById(id_person);
            Optional<User> userOptional = userRepository.findByPerson(person);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                // Delete the user
                userRepository.delete(user);
            }
            personRepository.delete(person);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("{\"error\": \"Fingerprint already exists !\"}");
        }

    }

    @GetMapping("/{id}")
    public ResponseEntity< Person >getPersonById(@PathVariable Long id){

        Person person = personRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Person not exist with id :"+id));
        return ResponseEntity.ok(person);
    }
    @PutMapping("/{id}")
    public ResponseEntity<Person> updatePerson(@PathVariable long id, @RequestBody  Person personDetails){

        Person person  = personRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Person not exist with id :"+id));
        person.setFirstname(personDetails.getFirstname());
        person.setLastname(personDetails.getLastname());
        person.setEmail(personDetails.getEmail());
        person.setAddress(personDetails.getAddress());
        person.setPhoneNumber(personDetails.getPhoneNumber());
        person.setDob(personDetails.getDob());
        person.setGender(personDetails.getGender());

        Person updatePerson = personRepository.save(person);
        return ResponseEntity.ok(updatePerson);


    }
    @DeleteMapping("/{id}")
    public ResponseEntity< ? >deletePersonById(@PathVariable Long id){

        Person person = personRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Person not exist with id :"+id));
        Optional<User> userOptional = userRepository.findByPerson(person);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            // Delete the user
            userRepository.delete(user);
        }
        personRepository.delete(person);
        return ResponseEntity.ok("{\"success\": \"Person Deleted Successfully\"}");
    }
}
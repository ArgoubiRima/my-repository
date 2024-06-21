package com.biometric.pfe.repository;

import com.biometric.pfe.model.Person;
import com.biometric.pfe.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    User findByUsername(String username);

    Optional<User> findByPerson(Person person);

    Optional<User> findByFingerprintCode(String fingerprintCode);
}

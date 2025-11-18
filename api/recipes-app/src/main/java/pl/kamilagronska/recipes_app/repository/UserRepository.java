package pl.kamilagronska.recipes_app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pl.kamilagronska.recipes_app.entity.User;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User,Long> {
    boolean existsByUserName(String userName);
    Optional<User> findUserByUserName(String userName);
//    Optional<User> findUserByUserId(Long id);
}

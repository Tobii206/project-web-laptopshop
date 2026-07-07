package datt.nguyenthanhlong.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import datt.nguyenthanhlong.laptopshop.domain.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User save(User hothai);

    List<User> findOneByEmail(String email);

    User findOneById(long id);

    Boolean existsByEmail(String email);

    User findByEmail(String email);

    List<User> findByRole_Name(String roleName);
}

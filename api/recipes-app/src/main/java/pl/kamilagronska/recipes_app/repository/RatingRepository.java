package pl.kamilagronska.recipes_app.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pl.kamilagronska.recipes_app.entity.Rating;
import pl.kamilagronska.recipes_app.entity.Recipe;

import java.util.Optional;

@Repository
public interface RatingRepository extends JpaRepository<Rating,Long> {

}

package pl.kamilagronska.recipes_app.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pl.kamilagronska.recipes_app.entity.Recipe;
import pl.kamilagronska.recipes_app.entity.User;

import java.util.List;
import java.util.Optional;

@Repository
public interface RecipeRepository extends JpaRepository<Recipe,Long> {
    Page<Recipe> findAllByTitleContainingOrIngredientsContaining(String titlePhrase,String ingredientsPhrase,Pageable pageable);
    Page<Recipe> findAllByUser(User user, Pageable pageable);

    List<Recipe> findAllByUser(User user);

}

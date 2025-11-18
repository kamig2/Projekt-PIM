package pl.kamilagronska.recipes_app.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity(name = "Recipe")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Recipe {
    @Id
    @Column(name = "recipe_id",updatable = false,nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long recipeId;
    @Column(name ="title"/*, nullable = false*/)
    private String title;

    @Column(name = "preparation_time", nullable = false)
    private int preparationTime;

    @Column(name = "portion", nullable = false)
    private int portion;

    @Column(name = "ingredients")
    private String ingredients;
    @Column(name="description"/*, nullable = false*/)
    private String description;
    @ManyToOne
    @JoinColumn(name = "user_id",nullable = false)
    private User user;
    @Column(name = "rating")
    private float rating;
    @Column(name = "date")
    private LocalDate date;

    @OneToMany(mappedBy = "recipe", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Rating> ratingList = new ArrayList<>();

    @ElementCollection
    @CollectionTable(name = "recipe_images", joinColumns = @JoinColumn(name = "recipe_id"))
    @Column(name = "image_url")
    private List<String> imageUrls;

}

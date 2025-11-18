package pl.kamilagronska.recipes_app.dto;

import jakarta.persistence.Column;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
public class RecipeDto {
    Long recipeId;
    String title;
    private int preparationTime;

    private int portion;
    String ingredients;
    String description;
    String username;
    float rating;
    LocalDate date;
    private List<String> imageUrls;
}

package pl.kamilagronska.recipes_app.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RatingResponse {
    Long id;

    Long recipeId;
    int rate;
    String opinion;

    String username;
}

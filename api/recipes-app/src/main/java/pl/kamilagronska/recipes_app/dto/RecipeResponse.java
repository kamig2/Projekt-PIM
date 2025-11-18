package pl.kamilagronska.recipes_app.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RecipeResponse {
    List<RecipeDto> content;
    int pageNumber;
    int pageSize;
    long totalElements;
    int totalPages;
}

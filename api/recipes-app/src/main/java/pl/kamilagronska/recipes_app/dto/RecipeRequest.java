package pl.kamilagronska.recipes_app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RecipeRequest {
    String title;
    Integer preparationTime;

    Integer portion;
    String ingredients;
    String description;
    List<MultipartFile> files;
}


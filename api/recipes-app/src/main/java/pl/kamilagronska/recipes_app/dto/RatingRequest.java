package pl.kamilagronska.recipes_app.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RatingRequest {
    @Min(0)
    @Max(10)
    int rate;
    String opininion;
}

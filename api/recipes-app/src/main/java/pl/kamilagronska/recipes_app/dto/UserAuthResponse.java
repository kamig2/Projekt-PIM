package pl.kamilagronska.recipes_app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class UserAuthResponse {
    String token;
}

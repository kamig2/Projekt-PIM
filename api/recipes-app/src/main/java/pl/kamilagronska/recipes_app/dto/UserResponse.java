package pl.kamilagronska.recipes_app.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@AllArgsConstructor
@Data
@Builder
public class UserResponse{
    Long userID;
    String firstName;
    String lastName;
    String username;
}

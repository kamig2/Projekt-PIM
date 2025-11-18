package pl.kamilagronska.recipes_app.dto;

import lombok.Getter;

@Getter
public class UserRegisterRequest {
    String firstName;
    String lastName;
    String username;
    String password;
}

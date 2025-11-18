package pl.kamilagronska.recipes_app.dto;

import lombok.Getter;

@Getter
public class UserLoginRequest {
    String username;
    String password;
}

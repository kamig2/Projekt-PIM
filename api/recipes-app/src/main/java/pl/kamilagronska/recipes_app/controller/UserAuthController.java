package pl.kamilagronska.recipes_app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.kamilagronska.recipes_app.dto.UserRegisterRequest;
import pl.kamilagronska.recipes_app.dto.UserAuthResponse;
import pl.kamilagronska.recipes_app.entity.User;
import pl.kamilagronska.recipes_app.dto.UserLoginRequest;
import pl.kamilagronska.recipes_app.service.UserAuthService;

@RestController
@RequestMapping
@RequiredArgsConstructor
public class UserAuthController {
    private final UserAuthService service;


    @PostMapping(  "/register")
    public ResponseEntity<UserAuthResponse> registerNewUser(@RequestBody UserRegisterRequest request){
        return ResponseEntity.ok(service.addUser(request));
    }

    @PostMapping("/login")
    public ResponseEntity<UserAuthResponse> login(@RequestBody UserLoginRequest request){

        return ResponseEntity.ok(service.login(request));
    }

}

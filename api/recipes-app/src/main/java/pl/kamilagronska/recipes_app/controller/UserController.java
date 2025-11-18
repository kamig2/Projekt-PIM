package pl.kamilagronska.recipes_app.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.kamilagronska.recipes_app.dto.UserResponse;
import pl.kamilagronska.recipes_app.entity.User;
import pl.kamilagronska.recipes_app.service.UserService;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/users")
public class UserController {
    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers(){
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{userId}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long userId){
        return ResponseEntity.ok(userService.getUserById(userId));
    }

    @GetMapping("/logged/user")
    public ResponseEntity<UserResponse> getLoggedUser(){
        return ResponseEntity.ok(userService.getLoggedUser());
    }



}

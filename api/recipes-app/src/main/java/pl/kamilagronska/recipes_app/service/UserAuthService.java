package pl.kamilagronska.recipes_app.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import pl.kamilagronska.recipes_app.dto.UserAuthResponse;
import pl.kamilagronska.recipes_app.dto.UserRegisterRequest;
import pl.kamilagronska.recipes_app.entity.Role;
import pl.kamilagronska.recipes_app.entity.User;
import pl.kamilagronska.recipes_app.exception.ResourceNotFoundException;
import pl.kamilagronska.recipes_app.exception.UsernameAlreadyExistsException;
import pl.kamilagronska.recipes_app.repository.UserRepository;
import pl.kamilagronska.recipes_app.dto.UserLoginRequest;
import pl.kamilagronska.recipes_app.security.JwtService;



@Service
@RequiredArgsConstructor
public class UserAuthService {
    private final UserRepository repository;
    private final PasswordEncoder encoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public UserAuthResponse addUser(UserRegisterRequest request){
        //warunki rejstracji
        //nie ma użytkownika o tej samej nazwie uzytkownika
        if(repository.existsByUserName(request.getUsername())){
            throw new UsernameAlreadyExistsException("This username: "+request.getUsername() + " already exists ");
        }
        var user = User.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .userName(request.getUsername())
                .password(encoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();

        repository.save(user);
        String token = jwtService.generateToken(user);
        return UserAuthResponse.builder()
                .token(token)
                .build();
    }


    public UserAuthResponse login(UserLoginRequest request) {
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getUsername(),request.getPassword()));
        }catch (AuthenticationException e){
            throw new BadCredentialsException("Wrong username or password");
        }
        User user = repository.findUserByUserName(request.getUsername()).orElseThrow(()->new ResourceNotFoundException("Username not found "));
        String token = jwtService.generateToken(user);
        return UserAuthResponse.builder()
                .token(token)
                .build();
    }
}

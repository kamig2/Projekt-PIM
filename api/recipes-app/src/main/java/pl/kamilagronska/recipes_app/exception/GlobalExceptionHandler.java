package pl.kamilagronska.recipes_app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = {ResourceNotFoundException.class})
    public ResponseEntity<Object> handleResourceNotFoundException(ResourceNotFoundException e){
        ExceptionResponse exceptionResponse = new ExceptionResponse(
                e.getMessage(),
                e.getCause(),
                HttpStatus.NOT_FOUND
        );

        return new ResponseEntity<>(exceptionResponse,HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(value = {UsernameAlreadyExistsException.class})
    public ResponseEntity<Object> handleUsernameAlreadyExistsException(UsernameAlreadyExistsException e){
        ExceptionResponse exceptionResponse = new ExceptionResponse(
                e.getMessage(),
                e.getCause(),
                HttpStatus.CONFLICT
        );

        return new ResponseEntity<>(exceptionResponse,HttpStatus.CONFLICT);
    }

    @ExceptionHandler(value = {BadCredentialsException.class})
    public ResponseEntity<Object> handleBadCredentialsException(BadCredentialsException e){
        ExceptionResponse exceptionResponse = new ExceptionResponse(
                e.getMessage(),
                e.getCause(),
                HttpStatus.UNAUTHORIZED
        );

        return new ResponseEntity<>(exceptionResponse,HttpStatus.UNAUTHORIZED);

    }

    @ExceptionHandler(value = {UnsupportedOperationException.class})
    public ResponseEntity<Object> handleUnsupportedOperationException(UnsupportedOperationException e){

        ExceptionResponse exceptionResponse = new ExceptionResponse(
                e.getMessage(),
                e.getCause(),
                HttpStatus.FORBIDDEN
        );

        return new ResponseEntity<>(exceptionResponse,HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(value = {IllegalArgumentException.class})
    public ResponseEntity<Object> handleIllegalArgumentException(IllegalArgumentException e){
        ExceptionResponse exceptionResponse = new ExceptionResponse(
                e.getMessage(),
                e.getCause(),
                HttpStatus.BAD_REQUEST
        );

        return new ResponseEntity<>(exceptionResponse,HttpStatus.BAD_REQUEST);
    }

}

package pl.kamilagronska.recipes_app.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@AllArgsConstructor
@Getter
public class ExceptionResponse {
    private final String message;
    private final Throwable throwable;
    private final HttpStatus httpStatus;

}

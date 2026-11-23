package com.miser.moneyTracker.common.exception;

import com.miser.moneyTracker.parser.StatementParseException;
import com.miser.moneyTracker.parser.StatementPasswordException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorBody(ex.getMessage(), 404));
    }

    @ExceptionHandler(BadCredentialsException.class)
    public ResponseEntity<Map<String, Object>> handleBadCredentials(BadCredentialsException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorBody(ex.getMessage(), 401));
    }

    /** 422 with a machine-readable code so clients can prompt for the PDF password. */
    @ExceptionHandler(StatementPasswordException.class)
    public ResponseEntity<Map<String, Object>> handlePassword(StatementPasswordException ex) {
        Map<String, Object> body = new HashMap<>(errorBody(ex.getMessage(), 422));
        body.put("code", ex.getReason().name());
        return ResponseEntity.unprocessableEntity().body(body);
    }

    @ExceptionHandler(StatementParseException.class)
    public ResponseEntity<Map<String, Object>> handleParseFailure(StatementParseException ex) {
        return ResponseEntity.unprocessableEntity().body(errorBody(ex.getMessage(), 422));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<Map<String, Object>> handleBadRequest(IllegalArgumentException ex) {
        return ResponseEntity.badRequest().body(errorBody(ex.getMessage(), 400));
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<Map<String, Object>> handleConflict(ConflictException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT).body(errorBody(ex.getMessage(), 409));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .reduce((a, b) -> a + "; " + b)
                .orElse("Validation failed");
        return ResponseEntity.badRequest().body(errorBody(message, 400));
    }

    private Map<String, Object> errorBody(String message, int status) {
        return Map.of("timestamp", LocalDateTime.now(), "status", status, "message", message);
    }
}

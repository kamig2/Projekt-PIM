package pl.kamilagronska.recipes_app.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.function.Function;

@Service
public class JwtService {

    private static final String SECRET_KEY ="L5zQmF4X8LJm8VzqvhVhOvzn5b8/nJ1C+lBie7yFuF4=";
    public String extractUsername(String token){
        return extractClaim(token,Claims::getSubject);
    }

    public String generateToken(UserDetails user){
        return Jwts
                .builder()
                .subject(user.getUsername())
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + 24 * 60 * 60 * 1000))
                .signWith(getKey())
                .compact();
    }

    public boolean isTokenValid(String token, UserDetails user){
        String username  =  extractUsername(token);
        return username.equals(user.getUsername()) && !isExpired(token,user);

    }

    private boolean isExpired(String token,UserDetails user){
        Date date = extractClaim(token,Claims::getExpiration);
        return date.before(new Date());
    }

    //pojedyncze Claims
    public <T> T extractClaim(String token, Function<Claims,T> resolver){
        Claims claims = extractAllClaims(token);
        return resolver.apply(claims);
    }

    //wszytskie claims
    public Claims extractAllClaims(String token){
        return Jwts
                .parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }


    private SecretKey getKey(){
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);

    }


}

package pl.kamilagronska.recipes_app.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity(name = "Rating")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Rating {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "rate_id",updatable = false)
    private Long id;

    @Column(name = "rate",nullable = false)
    @Min(0)
    @Max(10)
    private int rate;

    @Column(name = "opinion")
    private String opinion;

    @ManyToOne
    @JoinColumn(name = "recipe_id", nullable = false)
    private Recipe recipe;

    @ManyToOne
    @JoinColumn(name = "user_id",nullable = false)
    private User user;
}

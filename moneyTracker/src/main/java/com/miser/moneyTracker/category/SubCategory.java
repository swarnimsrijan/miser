package com.miser.moneyTracker.category;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "sub_categories")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class SubCategory {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Lazy proxy is not serializable; the API always lists sub-categories under a category.
    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(nullable = false)
    private String name;
}

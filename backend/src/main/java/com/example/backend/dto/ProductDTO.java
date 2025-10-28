package com.example.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {

    private Long id;

    @NotBlank(message = "Name darf nicht leer sein")
    private String name;

    private String description;

    @NotNull(message = "Preis ist erforderlich")
    @Positive(message = "Preis muss positiv sein")
    private BigDecimal price;

    @NotNull(message = "Lagerbestand ist erforderlich")
    @PositiveOrZero(message = "Lagerbestand muss >= 0 sein")
    private Integer stock;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}


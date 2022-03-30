/* Database schema to keep the structure of entire database. */

CREATE TABLE owners (
    id          INT GENERATED ALWAYS AS IDENTITY,
    full_name   VARCHAR(255) NOT NULL,
    age         INT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE species (
    id     INT GENERATED ALWAYS AS IDENTITY,
    name   VARCHAR(50) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE animals (
    id              INT GENERATED ALWAYS AS IDENTITY,
    name            VARCHAR(100) NOT NULL,
    date_of_birth   DATE NOT NULL,
    escape_attempts INT NOT NULL,
    neutered        BOOLEAN NOT NULL,
    weight_kg       DECIMAL NOT NULL,
    specie_id       INT NOT NULL,
    owner_id        INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_specie
        FOREIGN KEY (specie_id)
        REFERENCES species (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_owner
        FOREIGN KEY (owner_id)
        REFERENCES owners (id)
        ON DELETE CASCADE
);

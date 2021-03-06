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

CREATE TABLE vets (
    id                  INT GENERATED ALWAYS AS IDENTITY,
    name                VARCHAR(100) NOT NULL,
    age                 INT NOT NULL,
    date_of_graduation  DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE spetializations (
    vet_id      INT NOT NULL,
    specie_id   INT NOT NULL,
    CONSTRAINT fk_vet
        FOREIGN KEY (vet_id)
        REFERENCES vets(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_specie
        FOREIGN KEY (specie_id)
        REFERENCES species(id)
        ON DELETE RESTRICT
);

CREATE TABLE visits (
    animal_id       INT NOT NULL,
    vet_id          INT NOT NULL,
    date_of_visit   DATE NOT NULL,
    CONSTRAINT fk_animal
        FOREIGN KEY (animal_id)
        REFERENCES animals(id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_vet
        FOREIGN KEY (vet_id)
        REFERENCES vets(id)
        ON DELETE RESTRICT
);

ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX visits_vetid_asc ON visits(vet_id ASC);
explain analyze SELECT * FROM visits where vet_id = 2;

CREATE INDEX visits_animalid_asc ON visits(animal_id ASC);
explain analyze SELECT COUNT(*) FROM visits where animal_id = 4;

CREATE INDEX owners_email_asc ON owners(email ASC);
explain analyze SELECT * FROM owners where email = 'owner_18327@mail.com';

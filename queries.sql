/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT name FROM animals WHERE date_of_birth >= '2016-01-01' AND date_of_birth <= '2019-12-31';

SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name != 'Gabumon';
SELECT * FROM animals WHERE name NOT IN ('Gabumon');

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;
SELECT * FROM animals WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;

/* QUERY AND UPDATE ANIMALS TABLE */

BEGIN;
UPDATE animals SET species = 'unspecified';
ROLLBACK;

UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;

BEGIN;
DELETE FROM animals;
ROLLBACK;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

SELECT COUNT(*) FROM animals;
 count
-------
    10
(1 row)

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;
 count
-------
     2
(1 row)

SELECT AVG(weight_kg) AS average FROM animals;
       average
---------------------
 15.5500000000000000
(1 row)

SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;
 neutered | sum
----------+-----
 f        |   4
 t        |  20
(2 rows)

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;
 species | min | max
---------+-----+-----
 pokemon |  11 |  17
 digimon | 5.7 |  45
(2 rows)

SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BE
TWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
 species |        avg
---------+--------------------
 pokemon | 3.0000000000000000
(1 row)

SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BE
TWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;
 species |        avg
---------+--------------------
 pokemon | 3.0000000000000000
(1 row)


-- QUERY MULTIPLE TABLES --

SELECT full_name as OWNER, name as PET FROM owners INNER JOIN animals ON owners.id =
animals.owner_id WHERE owners.full_name = 'Melody Pond';

SELECT full_name as OWNER, name as PET
FROM (SELECT * FROM owners WHERE full_name = 'Melody Pond') OW
INNER JOIN animals ON OW.id = animals.owner_id;
    owner    |    pet
-------------+------------
 Melody Pond | Charmander
 Melody Pond | Squirtle
 Melody Pond | Blossom
(3 rows)

SELECT species.name as SPECIE, animals.name as PET FROM species INNER JOIN animals ON species.id =
animals.specie_id WHERE species.name = 'Pokemon';

SELECT SPE.name as SPECIE, animals.name as PET
FROM (SELECT * FROM species WHERE name = 'Pokemon') SPE
INNER JOIN animals ON SPE.id = animals.specie_id;
 specie  |    pet
---------+------------
 Pokemon | Pikachu
 Pokemon | Charmander
 Pokemon | Squirtle
 Pokemon | Blossom
(4 rows)

SELECT owners.full_name as OWNER, animals.name as PET
FROM owners LEFT JOIN animals ON owners.id = animals.owner_id ORDER BY owners.id;
      owner      |    pet
-----------------+------------
 Sam Smith       | Agumon
 Jennifer Orwell | Gabumon
 Jennifer Orwell | Pikachu
 Bob             | Plantmon
 Bob             | Devimon
 Melody Pond     | Charmander
 Melody Pond     | Squirtle
 Melody Pond     | Blossom
 Dean Winchester | Angemon
 Dean Winchester | Boarmon
 Jodie Whittaker |
(11 rows)

SELECT species.name as SPECIE, COUNT(species.name) AS NUM
FROM species INNER JOIN animals
ON species.id = animals.specie_id GROUP BY species.name;
 specie  | num
---------+-------
 Pokemon |     4
 Digimon |     6
(2 rows)

SELECT OWNERANIMALS.name as PET, species.name as SPECIE, OWNERANIMALS.full_name as OWNER
FROM species
INNER JOIN (SELECT *
            FROM owners INNER JOIN animals
            ON owners.id = animals.owner_id
            WHERE owners.full_name = 'Jennifer Orwell') OWNERANIMALS
ON species.id = OWNERANIMALS.specie_id
WHERE species.name = 'Digimon';
   pet   | specie  |      owner
---------+---------+-----------------
 Gabumon | Digimon | Jennifer Orwell
(1 row)

SELECT animals.name as PET, animals.escape_attempts as SCAPES, owners.full_name as OWNER
FROM owners INNER JOIN animals
ON owners.id = animals.owner_id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;
 pet | scapes | owner
-----+--------+-------
(0 rows)

SELECT owners.full_name AS OWNER, count(owners.full_name) as PETS
FROM animals INNER JOIN owners ON animals.owner_id = owners.id 
GROUP BY owners.full_name
HAVING COUNT(owners.full_name) = (SELECT MAX(NUMPETS)
                                    FROM (SELECT COUNT(animals.owner_id) as NUMPETS
                                            FROM animals
                                            GROUP BY animals.owner_id) OWNERPETS
                                    );
    owner    | pets
-------------+------
 Melody Pond |    3

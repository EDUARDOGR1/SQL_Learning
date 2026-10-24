INSERT INTO continentes (nombre) VALUES
('africa'), 
('America'),
('Antartida'),
('Asia'),
('Europa'),
('Oceania') 

SELECT * FROM continentes

INSERT INTO paises (nombre, idContinente) VALUES
('Kenia', 1),
('India', 4),
('España', 5),
('México', 2),
('Brasil', 2),
('Australia', 6),
('China', 4),
('Sudáfrica', 1),
('Estados Unidos', 2),
('Alemania', 5);

INSERT INTO ciudades (nombre, idPais) VALUES
('Nairobi', 1),
('Nueva Delhi', 2),
('Madrid', 3),
('Ciudad de México', 4),
('São Paulo', 5),
('Sídney', 6),
('Chengdu', 7),
('Pretoria', 8),
('San Diego', 9),
('Berlín', 10);

INSERT INTO familiasEspecies (nombre) VALUES
('Felidae'), ('Canidae'), ('Ursidae'), ('Elephantidae'), ('Giraffidae'),
('Hominidae'), ('Phascolarctidae'), ('Spheniscidae'), ('Crocodylidae'), ('Rhinocerotidae');

INSERT INTO estatusConservacion (nombre, enPeligro) VALUES
('No evaluada', 'N'),
('Datos insuficientes', 'N'),
('Preocupación menor', 'N'),
('Casi amenazada', 'N'),
('Vulnerable', 'S'),
('En peligro', 'S'),
('En peligro crítico', 'S'),
('Extinta en estado silvestre', 'S'),
('Extinta', 'N');

INSERT INTO especies (nombreCientifico, nombreVulgar, idFamilia, idEstatusConservacion) VALUES
('Panthera leo', 'León', 1, 5),
('Canis lupus', 'Lobo gris', 2, 3),
('Ailuropoda melanoleuca', 'Panda gigante', 3, 5),
('Loxodonta africana', 'Elefante africano', 4, 6),
('Giraffa camelopardalis', 'Jirafa', 5, 5),
('Gorilla gorilla', 'Gorila occidental', 6, 7),
('Phascolarctos cinereus', 'Koala', 7, 5),
('Spheniscus humboldti', 'Pingüino de Humboldt', 8, 5),
('Crocodylus niloticus', 'Cocodrilo del Nilo', 9, 3),
('Diceros bicornis', 'Rinoceronte negro', 10, 7);

INSERT INTO zoologicos (nombre, aream2, presupuestoAnual, idCiudad) VALUES
('Zoo Aquarium de Madrid', 200000, 25000000, 3),
('Zoológico de Chapultepec', 678000, 90000000, 4),
('San Diego Zoo', 400000, 300000000, 9),
('Zoo de Berlín', 340000, 40000000, 10),
('Taronga Zoo', 210000, 60000000, 6),
('Base de Investigación del Panda Gigante de Chengdu', 1000000, 80000000, 7),
('Jardín Zoológico Nacional de Pretoria', 850000, 35000000, 8),
('Zoológico de São Paulo', 824000, 50000000, 5),
('Nairobi Safari Walk', 50000, 5000000, 1),
('Zoológico de Delhi', 800000, 20000000, 2);

INSERT INTO animales (nombre, sexo, anoDeNacimiento, idEspecie, idPais, idZoologico) VALUES
('Simba', 'M', 2015, 1, 1, 1),
('Luna', 'H', 2018, 2, 9, 3),
('Bao Bao', 'M', 2019, 3, 7, 6),
('Dumbo', 'M', 2005, 4, 8, 7),
('Melman', 'M', 2016, 5, 1, 9),
('Koko', 'H', 2012, 6, 3, 1),
('Kiwi', 'H', 2020, 7, 6, 5),
('Pepe', 'M', 2017, 8, 5, 8),
('Sobek', 'M', 2008, 9, 1, 10),
('Rocky', 'M', 2010, 10, 8, 4);
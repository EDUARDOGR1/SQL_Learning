USE Farmacias;
GO

INSERT INTO provincias (nombre) VALUES
('Guanajuato'),
('Jalisco'),
('Querétaro');

INSERT INTO ciudades (nombre, cantidadHabitantes, superficieKM2, idProvincia) VALUES
('Celaya',            500000,  553.20, 1),
('Apaseo el Grande',   95000,  467.50, 1),
('Guadalajara',      1385000,  151.00, 2),
('Querétaro',        1050000,  759.90, 3),
('Zapopan',          1476000, 1163.00, 2);

INSERT INTO colonias (codigoPostal, nombre, idCiudad) VALUES
('38000', 'Centro',           1),
('38160', 'Centro',           2),
('44100', 'Americana',        3),
('76000', 'Centro Histórico', 4),
('44500', 'Chapalita',        3);

INSERT INTO calles (nombre, idColonia) VALUES
('Hidalgo',       1),
('Juárez',        2),
('Chapultepec',   3),
('Morelos',       1),
('Independencia', 4),
('Av. México',    5);

INSERT INTO direcciones (idCalle, numeroInterior, numeroExterior) VALUES
(1, NULL, '10'),
(2, NULL, '25'),
(3, '2B', '150'),
(4, NULL, '8'),
(5, NULL, '33'),
(6, 'A',  '1200'),
(1, NULL, '55'),
(2, NULL, '7'),
(5, NULL, '90');

INSERT INTO farmacias (nombre, idDomicilio) VALUES
('Farmacia Central',          1),
('Farmacia del Pueblo',       2),
('Farmacia Americana',        3),
('Farmacia Morelos',          4),
('Farmacia Centro Histórico', 5),
('Farmacia Chapalita',        6);

INSERT INTO propietarios (nombre, apellidoPaterno, apellidoMaterno, idFarmacia, idDomicilio) VALUES
('Eduardo',  'Gutierrez',     'Rodriguez', 1, 7),
('María', 'Gómez',     'Ruiz',  2, 8),
('Luis',  'Hernández', 'Soto',  5, 9);

INSERT INTO medicamentos (nombreComercial, idMedicamentoComplementario) VALUES
('Paracetamol Plus', NULL),
('Ibuprofeno Max',   1),
('Vitamina C',       NULL),
('Antigripal X',     1),
('Jarabe Tos',       NULL),
('Omeprazol 20',     NULL),
('Loratadina Forte', 3);

INSERT INTO drogas (nombre) VALUES
('Paracetamol'),
('Ibuprofeno'),
('Ácido ascórbico'),
('Cafeína'),
('Dextrometorfano'),
('Omeprazol'),
('Loratadina');

INSERT INTO drogasEnMedicamentos (idMedicamento, idDroga) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(4, 4),
(5, 5),
(6, 6),
(7, 7);

INSERT INTO preciosMedicamentos (idFarmacia, idMedicamento, precio) VALUES
(1, 1,  35.00),
(1, 2,  60.00),
(1, 3,  90.00),
(1, 6,  85.00),
(2, 1,  38.50),
(2, 2,  65.00),
(3, 1,  40.00),
(3, 4, 120.00),
(4, 1,  36.00),
(4, 6,  88.00),
(5, 1,  42.00),
(5, 2,  70.00),
(5, 3,  95.00),
(6, 3,  92.00);
GO
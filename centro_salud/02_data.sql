USE CentroSalud;
GO

INSERT INTO estados (nombre) VALUES
('Guanajuato'),
('Querétaro'),
('Jalisco');

INSERT INTO municipios (nombre, idEstado) VALUES
('Apaseo el Grande', 1),
('Celaya', 1),
('Querétaro', 2),
('Guadalajara', 3),
('León', 1);

INSERT INTO asentamientos (nombre) VALUES
('Colonia'),
('Fraccionamiento'),
('Barrio'),
('Ejido');

INSERT INTO colonias (nombre, codigoPostal, idMunicipio, idAsentamiento) VALUES
('Centro', '38160', 1, 1),
('Jardines del Valle', '38165', 1, 2),
('San Juan', '38170', 1, 3),
('Los Pinos', '38010', 2, 2),
('Centro', '38000', 2, 1),
('Villas del Sol', '76100', 3, 2),
('Providencia', '44630', 4, 1),
('Lomas del Campestre', '37150', 5, 2);

INSERT INTO calles (nombre, idColonia) VALUES
('Calle Hidalgo', 1),
('Calle Morelos', 1),
('Avenida Juárez', 1),
('Calle de las Flores', 2),
('Calle Girasol', 2),
('Calle Allende', 3),
('Avenida Las Torres', 4),
('Calle Reforma', 5),
('Calle Zaragoza', 5),
('Avenida del Sol', 6),
('Calle Libertad', 7),
('Boulevard Campestre', 8);

INSERT INTO direcciones (numeroExterior, numeroInterior, idCalle) VALUES
('12', NULL, 1),
('45-A', NULL, 2),
('7', '2', 3),
('120', NULL, 4),
('33', NULL, 5),
('18', NULL, 6),
('250', NULL, 7),
('9', NULL, 8),
('61', '4', 9),
('S/N', NULL, 10),
('88', NULL, 11),
('14', NULL, 12),
('5', NULL, 1),
('27', NULL, 2),
('101', NULL, 4),
('3-B', NULL, 5),
('72', NULL, 6),
('40', NULL, 7),
('15', NULL, 8),
('66', NULL, 9);
GO

INSERT INTO personas (nombre, apellidoPaterno, apellidoMaterno, telefono, correoElectronico, idDireccion) VALUES
('Laura', 'Ramírez', 'Soto', '4125550101', 'laura.ramirez@example.com', 1),
('Carlos', 'Hernández', 'Vega', '4125550102', 'carlos.hernandez@example.com', 2),
('Mariana', 'López', 'Cruz', '4125550103', 'mariana.lopez@example.com', 3),
('Jorge', 'Martínez', 'Ruiz', '4125550104', 'jorge.martinez@example.com', 4),
('Sofía', 'Torres', 'Navarro', '4125550105', 'sofia.torres@example.com', 5),
('Ricardo', 'Díaz', 'Ortega', '4125550106', 'ricardo.diaz@example.com', 6),
('Patricia', 'Gómez', 'Luna', '4125550107', 'patricia.gomez@example.com', 7),
('Miguel Ángel', 'Flores', 'Rojas', '4125550108', NULL, 8),
('Daniela', 'Castro', 'Mejía', '4125550109', 'daniela.castro@example.com', 9),
('Fernando', 'Salazar', 'Peña', '4125550110', NULL, 10),
('Alejandra', 'Reyes', 'Campos', '4125550111', NULL, 11),
('Héctor', 'Morales', 'Silva', '4125550112', 'hector.morales@example.com', 12),
('Luis Fernando', 'Ortiz', 'Báez', '4125550113', 'luis.ortiz@example.com', 13),
('Ana María', 'Ortiz', 'Núñez', '4125550114', 'ana.ortiz@example.com', 13),
('Roberto', 'Jiménez', 'Paz', '4125550115', 'roberto.jimenez@example.com', 14),
('Elena', 'Vargas', 'Ibarra', '4125550116', 'elena.vargas@example.com', 15),
('Diego', 'Herrera', 'Lara', '4125550117', 'diego.herrera@example.com', 16),
('Valeria', 'Mendoza', 'Ríos', '4125550118', 'valeria.mendoza@example.com', 17),
('José Antonio', 'Cervantes', 'Gil', '4125550119', 'jose.cervantes@example.com', 18),
('Gabriela', 'Aguilar', 'Solís', '4125550120', 'gabriela.aguilar@example.com', 19),
('Pablo', 'Estrada', 'Moreno', '4125550121', 'pablo.estrada@example.com', 20);
GO

INSERT INTO estatusConsultorios (nombre) VALUES
('Disponible'),
('En mantenimiento'),
('Fuera de servicio');

INSERT INTO consultorios (numero, piso, descripcion, idEstatusConsultorio) VALUES
('101', 1, 'Medicina general', 1),
('102', 1, 'Pediatría', 1),
('201', 2, 'Cardiología', 1),
('202', 2, 'Ginecología', 1),
('203', 2, 'Usos múltiples', 2),
('104', 1, 'Dermatología y traumatología', 1);
GO

INSERT INTO especialidades (nombre) VALUES
('Medicina General'),
('Pediatría'),
('Cardiología'),
('Ginecología'),
('Dermatología'),
('Traumatología');

INSERT INTO medicos (cedulaProfesional, idPersona) VALUES
(10234501, 1),
(10345602, 2),
(10456703, 3),
(10567804, 4),
(10678905, 5),
(10789006, 6);

INSERT INTO medico_especialidad (idMedico, idEspecialidad) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(4, 6),
(5, 4),
(6, 5);

INSERT INTO horariosConsultas (diaDeLaSemana, horaInicio, horaFin, idMedico, idConsultorio) VALUES
('Lunes', '08:00', '14:00', 1, 1),
('Martes', '08:00', '14:00', 1, 1),
('Miércoles', '08:00', '14:00', 1, 1),
('Jueves', '08:00', '14:00', 1, 1),
('Viernes', '08:00', '14:00', 1, 1),
('Lunes', '09:00', '15:00', 2, 2),
('Miércoles', '09:00', '15:00', 2, 2),
('Viernes', '09:00', '15:00', 2, 2),
('Martes', '10:00', '16:00', 3, 3),
('Jueves', '10:00', '16:00', 3, 3),
('Lunes', '14:00', '20:00', 4, 1),
('Martes', '14:00', '20:00', 4, 1),
('Miércoles', '14:00', '20:00', 4, 1),
('Jueves', '14:00', '20:00', 4, 1),
('Viernes', '14:00', '20:00', 4, 1),
('Sábado', '09:00', '13:00', 4, 6),
('Lunes', '09:00', '15:00', 5, 4),
('Martes', '09:00', '15:00', 5, 4),
('Miércoles', '09:00', '15:00', 5, 4),
('Jueves', '09:00', '15:00', 5, 4),
('Martes', '08:00', '13:00', 6, 6),
('Jueves', '08:00', '13:00', 6, 6),
('Viernes', '08:00', '13:00', 6, 6);
GO

INSERT INTO tiposContratos (nombre) VALUES
('Titular'),
('Interino'),
('Sustituto');

INSERT INTO contratos (idMedico, idTipoContrato) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 1),
(6, 3);

INSERT INTO movimientosPeriodos (nombre) VALUES
('Alta'),
('Baja');

INSERT INTO periodosAltasBajas (fecha, idMedico, idMovimiento) VALUES
('2018-03-01', 1, 1),
('2019-08-15', 2, 1),
('2016-01-10', 3, 1),
('2022-02-01', 4, 1),
('2022-12-31', 4, 2),
('2024-03-01', 4, 1),
('2020-06-01', 5, 1),
('2025-01-15', 6, 1),
('2025-06-30', 6, 2),
('2026-02-01', 6, 1);
GO

INSERT INTO tiposEmpleos (nombre) VALUES
('Jefe de departamento'),
('Auxiliar administrativo'),
('Auxiliar de enfermería'),
('Vigilante');

INSERT INTO profesiones (nombre) VALUES
('Administración'),
('Enfermería'),
('Contaduría'),
('Seguridad privada'),
('Trabajo social');

INSERT INTO empleados (NSS, cedulaProfesional, idPersona, idTipoEmpleo, idProfesion) VALUES
('41019000011', 9876501, 7, 1, 1),
('41019000022', 9876502, 8, 2, 3),
('41019000033', 8765401, 9, 3, 2),
('41019000044', NULL, 10, 4, 4),
('41019000055', 8765402, 11, 3, 2),
('41019000066', NULL, 12, 2, 1);
GO

INSERT INTO estatusVacaciones (nombre) VALUES
('Planificado'),
('Disfrutado');

INSERT INTO periodosVacacionalesMedicos (idMedico, fechaInicio, fechaFin, idEstatus) VALUES
(1, '2026-07-06', '2026-07-17', 2),
(5, '2026-04-06', '2026-04-17', 2),
(2, '2026-12-21', '2027-01-04', 1),
(4, '2026-12-28', '2027-01-08', 1),
(6, DATEADD(DAY, -2, CAST(GETDATE() AS DATE)), DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), 1);

INSERT INTO periodosVacacionalesEmpleados (idEmpleado, fechaInicio, fechaFin, idEstatus) VALUES
(1, '2026-05-04', '2026-05-15', 2),
(2, '2026-08-03', '2026-08-14', 2),
(4, '2026-09-14', '2026-09-25', 2),
(5, '2026-12-22', '2027-01-05', 1),
(3, DATEADD(DAY, -1, CAST(GETDATE() AS DATE)), DATEADD(DAY, 6, CAST(GETDATE() AS DATE)), 1);
GO

INSERT INTO pacientes (NSS, idPersona) VALUES
('72026000011', 13),
('72026000022', 14),
('72026000033', 15),
('72026000044', 16),
('72026000055', 17),
('72026000066', 18),
('72026000077', 19),
('72026000088', 20),
('72026000099', 21),
('72026000100', 3);

INSERT INTO estatusCitasProgramadas (nombre) VALUES
('Programada'),
('Confirmada'),
('Atendida'),
('Cancelada'),
('No se presentó');

INSERT INTO citasProgramadas (fecha, hora, idPaciente, idConsultorio, idEstatus) VALUES
('2026-10-26', '09:00', 1, 1, 3),
('2026-10-27', '10:30', 2, 3, 3),
('2026-10-28', '09:30', 3, 2, 3),
('2026-10-29', '09:00', 4, 4, 3),
('2026-10-30', '11:00', 5, 1, 3),
('2026-11-02', '10:00', 6, 2, 3),
('2026-11-03', '11:00', 7, 3, 3),
('2026-11-04', '09:00', 10, 4, 3),
('2026-11-05', '12:00', 3, 3, 3),
('2026-11-06', '09:30', 1, 1, 3),
('2026-11-09', '10:00', 6, 1, 3),
('2026-11-10', '12:00', 4, 3, 3),
('2026-11-11', '10:00', 2, 4, 3),
('2026-11-12', '11:00', 5, 3, 3),
('2026-11-09', '12:00', 7, 1, 4),
('2026-11-10', '09:00', 7, 6, 5),
('2026-11-16', '09:00', 3, 1, 2),
('2026-11-16', '10:30', 8, 2, 1),
('2026-11-17', '11:00', 9, 3, 2),
('2026-11-18', '09:30', 6, 4, 1),
('2026-11-19', '10:00', 1, 3, 1),
('2026-11-20', '08:30', 10, 1, 1),
('2026-11-21', '10:00', 5, 6, 1),
('2026-11-23', '14:30', 2, 1, 1);
GO

INSERT INTO tiposMotivos (nombre) VALUES
('Revisión'),
('Seguimiento'),
('Consulta');

INSERT INTO citas (notas, idCitaProgramada, idMotivo, idMedico) VALUES
('Control general. Signos vitales normales.', 1, 1, 1),
('Dolor en el pecho al hacer ejercicio.', 2, 3, 3),
('Fiebre y tos de tres días.', 3, 3, 2),
('Revisión ginecológica anual.', 4, 1, 5),
('Dolor de garganta persistente.', 5, 3, 1),
('Seguimiento de infección respiratoria.', 6, 2, 2),
('Palpitaciones ocasionales.', 7, 3, 3),
('Molestias abdominales.', 8, 3, 5),
('Control de presión arterial.', 9, 2, 3),
('Seguimiento de cuadro de gripa.', 10, 2, 1),
('Dolor de oído desde hace dos días.', 11, 3, 1),
('Presión arterial elevada.', 12, 3, 3),
('Revisión de rutina.', 13, 1, 5),
('Control de hipertensión.', 14, 2, 3);

INSERT INTO diagnosticos (codigoCIE10, nombre) VALUES
('J00', 'Rinofaringitis aguda (resfriado común)'),
('J02.9', 'Faringitis aguda, no especificada'),
('I10', 'Hipertensión esencial (primaria)'),
('R07.4', 'Dolor torácico, no especificado'),
('R00.2', 'Palpitaciones'),
('H66.9', 'Otitis media, no especificada'),
('R10.4', 'Otros dolores abdominales y los no especificados'),
('J06.9', 'Infección aguda de las vías respiratorias superiores, no especificada'),
('E11.9', 'Diabetes mellitus tipo 2 sin complicaciones'),
('K29.7', 'Gastritis, no especificada'),
('L20.9', 'Dermatitis atópica, no especificada'),
('N76.0', 'Vaginitis aguda'),
('M54.5', 'Lumbalgia'),
('Z00.0', 'Examen médico general');

INSERT INTO citasDiagnosticos (observaciones, idCita, idDiagnostico) VALUES
('Se solicita electrocardiograma.', 2, 4),
('Reposo e hidratación.', 3, 8),
('Antiinflamatorio por cinco días.', 5, 2),
('Cuadro viral asociado.', 5, 8),
('Se programa seguimiento.', 7, 5),
('Presión elevada durante la consulta.', 7, 3),
('Se indica dieta blanda.', 8, 7),
('Posible gastritis, se vigila evolución.', 8, 10),
('Se receta tratamiento por diez días.', 11, 6),
('Se inicia tratamiento y control mensual.', 12, 3);
GO
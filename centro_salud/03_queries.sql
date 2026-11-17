
USE CentroSalud;
GO

/* =====================================================
   NIVEL 1: FUNDAMENTOS DE SQL
   ===================================================== */

-- 1. LISTADO DE MÉDICOS
-- Obtener el nombre, apellido paterno, apellido materno
-- y cédula profesional de todos los médicos registrados.

	SELECT * FROM medicos

	SELECT  p.nombre AS nombreMedico, 
			p.apellidoPaterno AS apellidoPaternoMedico, 
			p.apellidoMaterno AS apellidoMaternoMedico, 
			m.cedulaProfesional AS cedulaProfesionalMedico
	FROM personas p
	INNER JOIN medicos m ON p.id = m.idPersona
	


-- 2. CONSULTORIOS DISPONIBLES
-- Mostrar el número, piso y descripción de los consultorios
-- cuyo estatus sea "Disponible".

	SELECT	c.numero AS numeroConsultorio, 
			c.piso AS pisoConsultorio,
			c.descripcion as descripcion,
			ec.nombre as estatus
	FROM consultorios c
	INNER JOIN estatusConsultorios ec ON c.idEstatusConsultorio = ec.id
	WHERE ec.nombre = 'Disponible';

-- 3. PACIENTES POR NSS
-- Obtener todos los pacientes cuyo NSS comience con
-- los números 720260.

	SELECT  pe.nombre AS nombrePaciente,
			pe.apellidoPaterno AS apellidoPaternoPaciente, 
			pe.apellidoMaterno AS apellidoMaternoPaciente, 
			pa.NSS
	FROM pacientes pa
	INNER JOIN personas pe ON pa.idPersona = pe.id
	WHERE pa.NSS LIKE '720260%'

-- 4. ESPECIALIDADES MÉDICAS
-- Mostrar todas las especialidades registradas,
-- sin repetir nombres y ordenadas alfabéticamente.

	SELECT DISTINCT nombre
	FROM especialidades 
	ORDER BY nombre ASC;



-- 5. CITAS DE NOVIEMBRE
-- Obtener todas las citas programadas durante noviembre
-- de 2026, mostrando fecha, hora, paciente y consultorio.

	SELECT	cp.fecha, 
			cp.hora, pe.nombre AS nombrePaciente, 
			pe.apellidoPaterno AS apellidoPaternoPaciente, 
			pe.apellidoMaterno AS apellidoMaternoPaciente, 
			c.numero, 
			c.piso, 
			c.descripcion
	FROM citasProgramadas cp
	INNER JOIN pacientes pa ON cp.idPaciente = pa.id
	INNER JOIN personas pe ON pa.idPersona = pe.id
	INNER JOIN consultorios c ON cp.idConsultorio = c.id
	WHERE cp.fecha BETWEEN '2026-11-01' AND '2026-11-30';

/* =====================================================
   NIVEL 2
   ===================================================== */

-- 6. DIRECTORIO DE MÉDICOS
-- Mostrar el nombre completo de cada médico,
-- su cédula profesional y su especialidad.

	SELECT	p.nombre AS nombreMedico, 
			p.apellidoPaterno AS apellidoPaternoMedico, 
			p.apellidoMaterno AS apellidoMaternoMedico, 
			m.cedulaProfesional AS cedulaProfesionalMedico, 
			e.nombre AS especialidad
	FROM medicos m
	INNER JOIN personas p ON m.idPersona = p.id
	INNER JOIN medico_especialidad me ON m.id = me.idMedico
	INNER JOIN especialidades e ON me.idEspecialidad = e.id

-- 7. DIRECTORIO DE EMPLEADOS
-- Obtener el nombre completo, NSS, tipo de empleo
-- y profesión de todos los empleados.

	SELECT p.nombre, p.apellidoPaterno, p.apellidoMaterno, e.NSS, t.nombre , pr.nombre
	FROM empleados e
	INNER JOIN personas p ON e.idPersona = p.id
	INNER JOIN profesiones pr ON e.idProfesion = pr.id
	INNER JOIN tiposEmpleos t ON e.idTipoEmpleo = t.id 

-- 8. DIRECTORIO DE PACIENTES
-- Mostrar el nombre completo, teléfono, correo electrónico,
-- calle, número exterior, colonia y código postal
-- de cada paciente.

	SELECT pe.nombre, pe.apellidoPaterno, pe.apellidoMaterno, pe.telefono, pe.correoElectronico, c.nombre, d.numeroExterior, co.nombre, co.codigoPostal
	FROM pacientes p 
	INNER JOIN personas pe ON p.idPersona = pe.id
	INNER JOIN direcciones d ON pe.idDireccion = d.id
	INNER JOIN calles c ON d.idCalle = c.id
	INNER JOIN colonias co ON c.idColonia = co.id


-- 9. HISTORIAL DE CITAS
-- Obtener las citas atendidas mostrando:
-- Nombre completo del paciente.
-- Nombre completo del médico.
-- Especialidad del médico.
-- Fecha y hora de la cita.
-- Motivo de la consulta.
-- Consultorio asignado.

SELECT pe.nombre as nombrePaciente,pe.apellidoPaterno as apellidoPaternoPaciente, pe.apellidoMaterno as apellidoMaternoPaciente, 
	   pm.nombre as nombreMedico, pm.apellidoPaterno as apellidoPaternoMedico, pm.apellidoMaterno as apellidoMaternoMedico, e.nombre, t.nombre, cp.fecha, cp.hora, co.numero as numeroConsultorio, co.piso as pisoConsultorio
FROM citas c
INNER JOIN citasProgramadas cp ON c.idCitaProgramada = cp.id 
INNER JOIN pacientes pa ON cp.idPaciente = pa.id
INNER JOIN personas pe ON pa.idPersona = pe.id
INNER JOIN medicos m ON c.idMedico = m.id
INNER JOIN personas pm ON m.idPersona = pm.id
INNER JOIN medico_especialidad me ON m.id = me.idMedico
INNER JOIN especialidades e ON me.idEspecialidad = e.id
INNER JOIN tiposMotivos t ON c.idMotivo = t.id
INNER JOIN consultorios co ON cp.idConsultorio = co.id




-- 10. MÉDICOS Y SUS HORARIOS
-- Mostrar todos los médicos con sus respectivos días
-- de consulta, hora de inicio, hora de finalización
-- y número de consultorio.
-- Incluir también médicos que no tengan horarios registrados.

	SELECT p.nombre, p.apellidoPaterno, p.apellidoMaterno, hc.diaDeLaSemana, hc.horaInicio, hc.horaFin, c.numero, c.piso
	FROM medicos m
	INNER JOIN personas p ON m.idPersona = p.id
	LEFT JOIN horariosConsultas hc ON m.id = hc.idMedico
	LEFT JOIN consultorios c ON hc.idConsultorio = c.id
	ORDER BY p.nombre, p.apellidoPaterno, p.apellidoMaterno,
			CASE  hc.diaDeLaSemana
				WHEN 'Lunes' THEN 1
				WHEN 'Martes' THEN 2
				WHEN 'Miércoles' THEN 3
				WHEN 'Jueves' THEN 4
				WHEN 'Viernes' THEN 5
				WHEN 'Sábado' THEN 6
				WHEN 'Domingo' THEN 7
			END,
			hc.horaInicio;



/* =====================================================
   NIVEL 3: FUNCIONES DE AGREGACIÓN
   ===================================================== */

-- 11. CANTIDAD DE PACIENTES
-- Obtener el número total de pacientes registrados
-- en el centro de salud.

	SELECT COUNT(DISTINCT idPersona) as totalPacientes
	FROM pacientes


-- 12. CITAS POR MÉDICO
-- Mostrar el nombre de cada médico y la cantidad total
-- de citas que ha atendido.
-- Ordenar los resultados de mayor a menor.

	SELECT p.nombre, p.apellidoPaterno, p.apellidoMaterno, COUNT(c.idMedico) as cantidadTotalCitas
	FROM medicos m
	INNER JOIN personas p ON m.idPersona = p.id
	LEFT JOIN citas c ON c.idMedico = m.id
	GROUP BY p.nombre, p.apellidoPaterno, p.apellidoMaterno
	ORDER BY cantidadTotalCitas DESC;

-- 13. PACIENTES POR MUNICIPIO
-- Obtener la cantidad de pacientes registrados
-- en cada municipio.
-- Mostrar el nombre del municipio y el total de pacientes.

	SELECT m.nombre, COUNT(pa.idPersona) as totalPacientes
	FROM pacientes pa
	INNER JOIN personas pe ON pa.idPersona = pe.id
	INNER JOIN direcciones d ON pe.idDireccion = d.id
	INNER JOIN calles ca ON d.idCalle = ca.id
	INNER JOIN colonias co ON ca.idColonia = co.id
	RIGHT JOIN municipios m ON co.idMunicipio = m.id
	GROUP BY m.id, m.nombre

-- 14. ESPECIALIDADES MÁS SOLICITADAS
-- Mostrar cada especialidad y la cantidad de citas atendidas
-- por médicos que cuentan con dicha especialidad.
-- Ordenar de mayor a menor.

	SELECT e.nombre, COUNT(c.id) as cantidadCitasAtendidas
	FROM especialidades e
	LEFT JOIN medico_especialidad me ON e.id = me.idEspecialidad
	LEFT JOIN citas c ON c.idMedico = me.idMedico
	GROUP BY e.nombre
	ORDER BY cantidadCitasAtendidas DESC




-- 15. MÉDICOS CON MÁS DE UNA ESPECIALIDAD
-- Obtener los médicos que tengan dos o más especialidades.
-- Mostrar nombre completo y cantidad de especialidades.

	SELECT m.id AS idMedico, 
		   p.nombre AS nombreMedico, 
		   p.apellidoPaterno AS apellidoPaternoMedico, 
		   p.apellidoMaterno AS apellidoMaternoMedico, 
		   COUNT(me.idMedico) AS especialidades,
		   STRING_AGG(e.nombre, ', ') WITHIN GROUP (ORDER BY e.nombre) as nombreEspecialidades
	FROM medico_especialidad me
	INNER JOIN medicos m ON me.idMedico = m.id
	INNER JOIN personas p ON m.idPersona = p.id
	INNER JOIN especialidades e ON me.idEspecialidad = e.id
	GROUP BY m.id, p.nombre, p.apellidoPaterno, p.apellidoMaterno
	HAVING COUNT(me.idMedico) >= 2


/* =====================================================
   NIVEL 4: SUBCONSULTAS Y LÓGICA SQL
   ===================================================== */

-- 16. MÉDICOS SIN CITAS
-- Encontrar los médicos que no tengan ninguna
-- cita registrada.
	SELECT	m.id, p.nombre, p.apellidoPaterno, p.apellidoMaterno
	FROM medicos m
	INNER JOIN personas p ON m.idPersona = p.id
	WHERE NOT EXISTS (
		SELECT 1
		FROM citas c
		WHERE c.idMedico = m.id
)

-- 17. PACIENTES FRECUENTES
-- Obtener los pacientes que 
-- hayan tenido más citas
-- que el promedio de citas por paciente.
-- Mostrar nombre completo y cantidad de citas.

--Batalle en esta consulta, si alguien lee esto espero que entienda la logica
	WITH citasPorPaciente AS(
	SELECT	pa.id,
			CONCAT_WS(' ', pe.nombre, pe.apellidoPaterno, pe.apellidoMaterno) AS paciente,
			COUNT(c.id) as cantidadCitas
	FROM pacientes pa
	INNER JOIN personas pe ON pa.idPersona = pe.id
	LEFT JOIN citasProgramadas cp ON cp.idPaciente = pa.id
	LEFT JOIN citas c ON c.idCitaProgramada = cp.id
	GROUP BY pa.id, pe.nombre, pe.apellidoPaterno, pe.apellidoMaterno
	)
	SELECT paciente, cantidadCitas
	FROM citasPorPaciente
	WHERE cantidadCitas > (SELECT AVG(cantidadCitas * 1) FROM citasPorPaciente)


-- 18. MÉDICOS SIN VACACIONES PLANIFICADAS
-- Encontrar los médicos que actualmente no tengan
-- ningún periodo vacacional con estatus "Planificado".
	SELECT m.id, p.nombre, p.apellidoPaterno, p.apellidoMaterno
	FROM medicos m
	INNER JOIN personas p ON m.idPersona = p.id
	WHERE NOT EXISTS(
		SELECT 1
		FROM periodosVacacionalesMedicos pv
		INNER JOIN estatusVacaciones ev ON pv.idEstatus = ev.id
		WHERE pv.idMedico = m.id AND ev.nombre = 'Planificado'
	)


-- 19. CITAS SIN DIAGNÓSTICO
-- Obtener las citas atendidas que todavía no tengan
-- ningún diagnóstico asociado.
-- Mostrar paciente, médico, fecha y motivo de consulta.
	SELECT cp.fecha , pe.nombre, pe.apellidoPaterno, pe.apellidoMaterno, m.id, pm.nombre, pm.apellidoPaterno, pm.apellidoMaterno,  t.nombre
	FROM citas c
	INNER JOIN citasProgramadas cp ON c.idCitaProgramada = cp.id
	INNER JOIN tiposMotivos t ON c.idMotivo = t.id
	INNER JOIN medicos m ON c.idMedico = m.id
	INNER JOIN pacientes pa ON cp.idPaciente = pa.id
	INNER JOIN personas pe ON pa.idPersona = pe.id
	INNER JOIN personas pm ON m.idPersona = pm.id
	WHERE NOT EXISTS (
		SELECT 1
		FROM citasDiagnosticos cd
		WHERE cd.idCita = c.id
	)

-- 20. CONSULTORIOS MÁS UTILIZADOS
-- Encontrar los consultorios que hayan sido utilizados
-- en más citas que el promedio de citas por consultorio.
-- Mostrar número de consultorio y cantidad de citas.
-- cantidad de citas por consultorio
	WITH citasPorConsultorioC AS(
		SELECT	co.id as idConsultorio , co.numero as numeroConsultorio, 
			COUNT(cp.id) as citasProgramadasPorConsultorio,
			COUNT(c.id) as citasPorConsultorio
		FROM consultorios co
		LEFT JOIN citasProgramadas cp ON cp.idConsultorio = co.id
		LEFT JOIN citas c ON c.idCitaProgramada = cp.id
		GROUP BY co.id, co.numero
	)
	SELECT idConsultorio, numeroConsultorio, citasPorConsultorio
	FROM citasPorConsultorioC
	WHERE citasPorConsultorio > (SELECT AVG(citasPorConsultorio * 1) FROM citasPorConsultorioC)
	ORDER BY  citasPorConsultorio DESC


/* =====================================================
   NIVEL 5: RETOS DE SQL
   ===================================================== */

-- 21. MÉDICOS ACTUALMENTE ACTIVOS
-- Obtener los médicos cuyo último movimiento registrado
-- sea "Alta".
-- Mostrar nombre completo, cédula profesional
-- y fecha del último movimiento.


-- 22. DISPONIBILIDAD DE MÉDICOS
-- Encontrar los médicos que no tengan vacaciones
-- planificadas que coincidan con el periodo comprendido
-- entre el 15 de noviembre y el 31 de diciembre de 2026.
-- Mostrar nombre completo y especialidad.


-- 23. DIAGNÓSTICOS MÁS FRECUENTES
-- Obtener los cinco diagnósticos que aparecen con
-- mayor frecuencia en las consultas.
-- Mostrar código CIE-10, nombre y cantidad de veces registrado.


-- 24. REPORTE DE PRODUCTIVIDAD MÉDICA
-- Generar un reporte por médico que contenga:
-- Nombre completo.
-- Tipo de contrato.
-- Especialidad o especialidades.
-- Total de citas atendidas.
-- Total de diagnósticos registrados.
-- Incluir médicos que no tengan citas.


-- 25. REPORTE INTEGRAL DEL CENTRO DE SALUD
-- Generar un reporte por municipio que muestre:
-- Nombre del estado.
-- Nombre del municipio.
-- Cantidad de pacientes.
-- Cantidad de médicos.
-- Cantidad de empleados.
-- Incluir municipios aunque no tengan pacientes,
-- médicos o empleados.

GO

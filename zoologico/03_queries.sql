USE zoologico;
GO

/* ============================================================
   25 EJERCICIOS DE CONSULTAS - BASE DE DATOS ZOOLOGICO
   ============================================================ */


-- 1. Listar todos los datos de la tabla animales.
	SELECT * FROM animales;

-- 2. Mostrar el nombre y el año de nacimiento de los animales nacidos después de 2015.
	SELECT nombre, anoDeNacimiento 
	FROM animales
	WHERE anoDeNacimiento > 2015;

-- 3. Mostrar los zoológicos ordenados por presupuesto anual, del mayor al menor.
	SELECT nombre, presupuestoAnual 
	FROM zoologicos
	ORDER BY presupuestoAnual DESC;

-- 4. Mostrar los 3 zoológicos con mayor área en m².
	SELECT TOP 3 nombre, aream2
	FROM zoologicos 
	ORDER BY aream2 DESC;


-- 5. Mostrar las especies cuyo nombre vulgar empieza con la letra "G".
	SELECT nombreVulgar 
	FROM especies
	WHERE nombreVulgar like 'G%';

-- 6. Mostrar los estatus de conservación en los que enPeligro es 'S'.
	SELECT nombre, enPeligro
	FROM estatusConservacion
	WHERE enPeligro = 'S';

-- 7. Mostrar las hembras ('H') nacidas entre 2010 y 2019.
	SELECT nombre, anoDeNacimiento, sexo
	FROM animales
	WHERE anoDeNacimiento BETWEEN 2010 AND 2019 AND sexo = 'H';

-- 8. Mostrar el nombre de cada animal junto con el nombre vulgar de su especie.
	SELECT  animales.nombre, especies.nombreVulgar
	FROM animales 
	INNER JOIN especies ON animales.idEspecie = especies.id;

-- 9. Mostrar cada zoológico con su ciudad y su país.
	SELECT zoologicos.nombre AS nombreZoologico, ciudades.nombre AS nombreCiudad, paises.nombre AS nombrePais
	FROM zoologicos
	INNER JOIN ciudades ON zoologicos.idCiudad = ciudades.id
	INNER JOIN paises ON ciudades.idPais = paises.id;

-- 10. Mostrar cada especie con su familia y su estatus de conservación.
	SELECT especies.nombreCientifico, especies.nombreVulgar, familiasEspecies.nombre AS familia, estatusConservacion.nombre AS estatus, estatusConservacion.enPeligro AS enPeligro
	FROM especies
	INNER JOIN familiasEspecies ON especies.idFamilia = familiasEspecies.id
	INNER JOIN estatusConservacion ON especies.idEstatusConservacion = estatusConservacion.id; 

-- 11. Calcular la edad actual de cada animal (año actual dinámico)
--     y ordénalos del más viejo al más joven.
	SELECT nombre, anoDeNacimiento, ( YEAR(GETDATE()) - anoDeNacimiento) AS edad
	FROM animales
	ORDER BY edad DESC;
	


-- 12. Mostrar los países de Asia y Europa usando una subconsulta con IN.
	SELECT nombre
	FROM paises
	WHERE idContinente IN (	SELECT id FROM continentes WHERE nombre IN ('Asia', 'Europa') )



-- 13. Contar cuántos animales tiene cada zoológico,
--     incluyendo los que tienen cero.
	SELECT z.nombre, COUNT(idZoologico) as totalAnimales
	FROM zoologicos z
	LEFT JOIN animales a ON a.idZoologico = z.id
	GROUP BY z.nombre


-- 14. Mostrar solo los zoológicos que tengan más de un animal (HAVING).
	SELECT z.nombre, COUNT(*) as totalAnimales
	FROM animales a
	INNER JOIN zoologicos z ON a.idZoologico = z.id
	GROUP BY z.nombre
	HAVING COUNT(*) > 1


-- 15. Mostrar los animales que pertenecen a especies en peligro de extinción.
	SElECT a.nombre, e.nombreCientifico, ec.nombre as estatus, ec.enPeligro
	FROM animales a
	INNER JOIN especies e ON a.idEspecie = e.id
	INNER JOIN estatusConservacion ec ON e.idEstatusConservacion = ec.id
	WHERE ec.enPeligro = 'S'


-- 16. Mostrar el presupuesto promedio de los zoológicos por continente.
	SELECT co.nombre as continente, AVG(z.presupuestoAnual) as promedioContinente
	FROM zoologicos z
	INNER JOIN ciudades c ON z.idCiudad = c.id
	INNER JOIN paises p ON c.idPais = p.id
	INNER JOIN continentes co ON p.idContinente = co.id
	GROUP BY co.nombre




-- 17. Mostrar los animales cuyo país de origen es distinto
--     al país donde está su zoológico.

	SELECT a.nombre as animal, po.nombre as paisOrigen, pz.nombre as paisZoologico
	FROM animales a
	INNER JOIN paises po ON a.idPais = po.id
	INNER JOIN zoologicos z ON a.idZoologico = z.id
	INNER JOIN ciudades c ON z.idCiudad = c.id
	INNER JOIN paises pz ON c.idPais = pz.id
	WHERE po.nombre != pz.nombre;





-- 18. Mostrar los zoológicos que no tienen ningún animal registrado.
	SELECT z.nombre
	FROM zoologicos z
	LEFT JOIN animales a ON a.idZoologico = z.id
	WHERE a.id IS NULL


/* ----------------------- AVANZADO (19-23) ----------------------- */

-- 19. Mostar los zoológicos con presupuesto mayor al promedio general (subconsulta).
	SELECT z.nombre, z.presupuestoAnual
	FROM zoologicos z
	WHERE presupuestoAnual > (SELECT AVG(presupuestoAnual) FROM zoologicos)

-- 20. Calcular el presupuesto por m² de cada zoológico
--     y ordénalos de mayor a menor.
	SELECT z.nombre, CAST(z.presupuestoAnual / aream2 AS DECIMAL (10,2)) as presupuestoPorM2
	FROM zoologicos z
	ORDER BY presupuestoPorM2 DESC;

-- 21. Clasificar a los animales por etapa de vida con CASE:
--     cría (menos de 5 años), adulto (5 a 11) y senior (12 o más).

	SELECT nombre, anoDeNacimiento, (YEAR(GETDATE()) - anoDeNacimiento) as edad,
		CASE 
			WHEN YEAR(GETDATE()) - anoDeNacimiento < 5 THEN 'cria'
			WHEN YEAR(GETDATE()) - anoDeNacimiento < 12 THEN 'adulto'
			ELSE 'senior'
		END AS etapaVida
	FROM animales;



-- 22. Mostrar por continente cuántos países, ciudades y zoológicos hay
--     (cuidado con COUNT(DISTINCT ...)).

-- 23. Mostrar cuál es el animal más viejo de cada zoológico
--     (subconsulta correlacionada).



/* ------------------------- TOP (24-25) ------------------------- */

-- 24. Crear una vista vw_resumenAnimales que una animales, especie, familia,
--     estatus, zoológico, ciudad y país de origen, con la edad calculada.
--     Luego haz un SELECT sobre ella filtrando solo los animales en peligro.


-- 25. Crear un procedimiento almacenado sp_animalesPorContinente que reciba
--     el nombre de un continente y devuelva los animales cuyo zoológico esté
--     en ese continente, con su especie y su edad.
--     Ejecútalo con 'Europa'.
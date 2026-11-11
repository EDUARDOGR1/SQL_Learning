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
	


-- 12. Muestra los países de Asia y Europa usando una subconsulta con IN.



-- 13. Cuenta cuántos animales tiene cada zoológico,
--     incluyendo los que tienen cero.


-- 14. Muestra solo los zoológicos que tengan más de un animal (HAVING).


-- 15. Muestra los animales que pertenecen a especies en peligro de extinción.


-- 16. Muestra el presupuesto promedio de los zoológicos por continente.


-- 17. Muestra los animales cuyo país de origen es distinto
--     al país donde está su zoológico.


-- 18. Muestra los zoológicos que no tienen ningún animal registrado.



/* ----------------------- AVANZADO (19-23) ----------------------- */

-- 19. Muestra los zoológicos con presupuesto mayor al promedio general (subconsulta).


-- 20. Calcula el presupuesto por m² de cada zoológico
--     y ordénalos de mayor a menor.


-- 21. Clasifica a los animales por etapa de vida con CASE:
--     cría (menos de 5 años), adulto (5 a 11) y senior (12 o más).


-- 22. Muestra por continente cuántos países, ciudades y zoológicos hay
--     (cuidado con COUNT(DISTINCT ...)).


-- 23. Muestra cuál es el animal más viejo de cada zoológico
--     (subconsulta correlacionada).



/* ------------------------- TOP (24-25) ------------------------- */

-- 24. Crea una vista vw_resumenAnimales que una animales, especie, familia,
--     estatus, zoológico, ciudad y país de origen, con la edad calculada.
--     Luego haz un SELECT sobre ella filtrando solo los animales en peligro.


-- 25. Crea un procedimiento almacenado sp_animalesPorContinente que reciba
--     el nombre de un continente y devuelva los animales cuyo zoológico esté
--     en ese continente, con su especie y su edad.
--     Ejecútalo con 'Europa'.
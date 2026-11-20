USE Farmacias;
GO

-- 1. Mostrar el nombre de cada farmacia junto con la ciudad y la provincia donde se ubica.
	SELECT	f.nombre AS Farmacia, 
			c.nombre AS Ciudad,
			p.nombre AS Provincia 
	FROM farmacias f
	INNER JOIN provincias p ON f.idDomicilio = p.id
	INNER JOIN ciudades c ON p.id = c.idProvincia

-- 2. Mostrar cuántas farmacias hay en cada ciudad, ordenado de mayor a menor.
	SELECT	ci.nombre AS ciudad,
			COUNT(f.id) AS cantidadFarmacias
	FROM ciudades ci
	LEFT JOIN colonias co ON ci.id = co.idCiudad
	LEFT JOIN calles ca ON ca.idColonia = co.id
	LEFT JOIN direcciones d ON d.idCalle = ca.id
	LEFT JOIN farmacias f ON f.idDomicilio = d.id
	GROUP BY ci.nombre
	ORDER BY cantidadFarmacias DESC

-- 3. Mostrar las ciudades que tienen más de una farmacia.
	WITH totalFarmacias AS (
	SELECT	ci.nombre AS ciudad,
			COUNT(f.id) AS cantidadFarmacias
	FROM ciudades ci
	LEFT JOIN colonias co ON ci.id = co.idCiudad
	LEFT JOIN calles ca ON ca.idColonia = co.id
	LEFT JOIN direcciones d ON d.idCalle = ca.id
	LEFT JOIN farmacias f ON f.idDomicilio = d.id
	GROUP BY ci.nombre
	)
	SELECT	ciudad,
			cantidadFarmacias
	FROM totalFarmacias
	WHERE cantidadFarmacias > 1

	SELECT	ci.nombre AS ciudad,
			COUNT(f.id) AS cantidadFarmacias
	FROM ciudades ci
	INNER JOIN colonias co ON ci.id = co.idCiudad
	INNER JOIN calles ca ON ca.idColonia = co.id
	INNER JOIN direcciones d ON d.idCalle = ca.id
	INNER JOIN farmacias f ON f.idDomicilio = d.id
	GROUP BY ci.nombre
	HAVING COUNT(f.id) > 1

-- 4. Mostrar las farmacias que no tienen propietario.
	SELECT f.nombre AS Farmacias
	FROM farmacias f
	WHERE NOT EXISTS (
		SELECT 1
		FROM propietarios p
		WHERE p.idFarmacia = f.id
	)

-- 5. Mostrar el nombre completo de cada propietario junto con el nombre de su farmacia.
	SELECT 
		CONCAT_WS(' ', p.nombre, p.apellidoPaterno, p.apellidoMaterno) AS propietario,
		f.nombre AS farmacia
	FROM propietarios p
	INNER JOIN farmacias f ON p.idFarmacia = f.id

-- 6. Mostrar el precio promedio de cada medicamento, solo de los que se venden en al menos 2 farmacias.




-- 7. Mostrar los medicamentos que no se venden en ninguna farmacia.



-- 8. Mostrar cada medicamento junto con el nombre del medicamento que lo complementa (incluir los que no tienen complemento).



-- 9. Mostrar las farmacias que tienen al menos un medicamento con precio mayor al precio promedio de todos los precios.



-- 10. Mostrar las ciudades con habitantes mayores al promedio, junto con el número de farmacias que tienen.
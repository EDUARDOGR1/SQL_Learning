# Zoológico

Base de datos en **SQL Server** que modela zoológicos de distintas partes del mundo, los animales que viven en ellos, su especie y su estado de conservación.

Proyecto de práctica de modelado relacional y consultas SQL, con 25 ejercicios que van de `SELECT` básicos hasta vistas y procedimientos almacenados.

## Modelo de datos

La base cuenta con **8 tablas**:

| Tabla | Descripción | Campos principales |
|-------|-------------|--------------------|
| `continentes` | Catálogo de continentes | `id`, `nombre` |
| `paises` | Países, cada uno dentro de un continente | `id`, `nombre`, `idContinente` |
| `ciudades` | Ciudades, cada una dentro de un país | `id`, `nombre`, `idPais` |
| `familiasEspecies` | Familias biológicas (Felidae, Canidae...) | `id`, `nombre` |
| `estatusConservacion` | Estados de conservación de una especie | `id`, `nombre`, `enPeligro` |
| `especies` | Especies animales | `id`, `nombreCientifico`, `nombreVulgar`, `idFamilia`, `idEstatusConservacion` |
| `zoologicos` | Zoológicos, ubicados en una ciudad | `id`, `nombre`, `aream2`, `presupuestoAnual`, `idCiudad` |
| `animales` | Animales individuales | `id`, `nombre`, `sexo`, `anoDeNacimiento`, `idEspecie`, `idPais`, `idZoologico` |

### Relaciones

- Un continente tiene muchos países (1:N).
- Un país tiene muchas ciudades (1:N).
- Una ciudad tiene muchos zoológicos (1:N).
- Una familia agrupa muchas especies (1:N).
- Un estatus de conservación se asigna a muchas especies (1:N).
- Una especie tiene muchos animales (1:N).
- Un zoológico alberga muchos animales (1:N).
- Un país es el origen de muchos animales (1:N). Este país puede ser distinto al del zoológico donde vive el animal.

### Restricciones

| Restricción | Dónde |
|-------------|-------|
| Nombres únicos | `continentes.nombre`, `paises.nombre`, `familiasEspecies.nombre`, `estatusConservacion.nombre`, `especies.nombreCientifico`, `zoologicos.nombre` |
| `enPeligro` solo acepta `'S'` o `'N'` | `estatusConservacion` |
| `sexo` solo acepta `'M'` (macho) o `'H'` (hembra) | `animales` |
| Año de nacimiento mayor a 1900 | `animales` |
| Área mayor a 0 | `zoologicos.aream2` |
| Presupuesto mayor o igual a 0 | `zoologicos.presupuestoAnual` |
| Llaves foráneas en todas las relaciones | Todas las tablas hijas |

## Contenido de la carpeta

| Archivo | Descripción |
|---------|-------------|
| `01_schema.sql` | Crea la base de datos `zoologico`, las tablas, llaves y restricciones |
| `02_data.sql` | Inserta los datos de ejemplo |
| `03_queries.sql` | 25 ejercicios de consultas |

## Datos de ejemplo

- 6 continentes y 10 países
- 10 ciudades
- 10 familias y 10 especies (león, lobo gris, panda gigante, elefante africano, jirafa, gorila, koala, pingüino de Humboldt, cocodrilo del Nilo y rinoceronte negro)
- 9 estatus de conservación, desde "No evaluada" hasta "Extinta"
- 10 zoológicos, entre ellos San Diego Zoo, Zoo de Berlín y Taronga Zoo
- 10 animales

## Cómo ejecutar

**Requisitos**: SQL Server 2019 o superior y SQL Server Management Studio (SSMS) o Azure Data Studio.

Ejecuta los scripts en este orden:

1. `01_schema.sql`
2. `02_data.sql`
3. `03_queries.sql`

> `01_schema.sql` ejecuta `CREATE DATABASE zoologico;`. Si ya existe una base con ese nombre, elimínala primero para evitar errores.

## Ejercicios de consultas

`03_queries.sql` contiene 25 ejercicios, organizados por dificultad:

| Ejercicios | Tema |
|------------|------|
| 1 - 7 | `SELECT`, `WHERE`, `ORDER BY`, `TOP`, `LIKE`, `BETWEEN` |
| 8 - 10 | `INNER JOIN` entre dos y tres tablas |
| 11 | Cálculo de edad con `YEAR(GETDATE())` |
| 12 | Subconsulta con `IN` |
| 13 - 14 | `COUNT`, `GROUP BY`, `LEFT JOIN` y `HAVING` |
| 15 - 16 | Joins múltiples con filtros y `AVG` por continente |
| 17 - 18 | Comparación entre dos joins a `paises` y búsqueda de registros sin relación |
| 19 - 21 | Subconsulta con `AVG`, `CAST` y `CASE` |
| 22 - 23 | `COUNT(DISTINCT ...)` y subconsulta correlacionada |
| 24 - 25 | Vista y procedimiento almacenado |

## Temas que practica

`PRIMARY KEY` · `IDENTITY` · `FOREIGN KEY` · `UNIQUE` · `CHECK` · `JOIN` · `GROUP BY` · `HAVING` · subconsultas · `CASE` · `CAST` · funciones de fecha · vistas · procedimientos almacenados

## Estado

- [x] Esquema de la base de datos
- [x] Datos de ejemplo
- [x] Ejercicios 1 al 21
- [ ] Ejercicio 22: conteo por continente con `COUNT(DISTINCT ...)`
- [ ] Ejercicio 23: animal más viejo por zoológico
- [ ] Ejercicio 24: vista `vw_resumenAnimales`
- [ ] Ejercicio 25: procedimiento `sp_animalesPorContinente`

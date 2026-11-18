# Sistema de Registro de Farmacias

Diseño de base de datos para registrar farmacias en distintas ciudades del país, junto con sus propietarios, los medicamentos que venden y los precios de cada uno.

## Descripción

El sistema permite almacenar:

- **Farmacias**, con nombre único en todo el sistema y un domicilio.
- **Ciudades**, con su provincia, cantidad de habitantes y superficie.
- **Propietarios**, con su domicilio. Una farmacia puede no tener propietario.
- **Medicamentos**, con nombre comercial, las drogas que los componen y el medicamento que los complementa.
- **Precios**, ya que cada farmacia vende un medicamento a un precio que puede variar entre farmacias.

## Requerimientos del enunciado

1. Cada farmacia tiene un nombre (único en todo el sistema) y un domicilio.
2. Cada farmacia se ubica en una sola ciudad, y una ciudad tiene varias farmacias.
3. Cada ciudad se identifica por su nombre y su provincia, y guarda cantidad de habitantes y superficie.
4. Cada farmacia puede tener un propietario, y cada propietario tiene solo una farmacia. Puede haber farmacias sin propietario.
5. Un propietario tiene un identificador único, nombre y domicilio (calle, número, código postal y ciudad).
6. Una farmacia vende varios medicamentos y un medicamento se vende en varias farmacias, a un precio que depende de la farmacia.
7. Cada medicamento tiene un id único, un nombre comercial y las drogas de las que se compone.
8. Un medicamento puede complementar a otros, pero cada medicamento es complementado por uno solo.

## Adaptación al contexto de México

Para aprovechar una estructura de direcciones normalizada, el modelo usa estos equivalentes:

| Término del enunciado | Tabla en el modelo |
|---|---|
| Provincia | `Provincias` (equivale a los estados en México) |
| Ciudad | `Ciudades` (equivale a los municipios) |
| Domicilio | `Direcciones`, que enlaza calle, colonia, ciudad y provincia |

La ciudad de una farmacia no se guarda directamente en `Farmacias`. Se obtiene por la cadena **Direcciones → Calles → Colonias → Ciudades**, lo que evita redundancia.

## Modelo de datos

### Tablas

| Tabla | Campos |
|---|---|
| `Provincias` | ID, Nombre |
| `Ciudades` | ID, ID_Provincia, Nombre, Cantidad_Habitantes, Superficie_Km2 |
| `Colonias` | ID, ID_Ciudad, Codigo_Postal, Nombre |
| `Calles` | ID, ID_Colonia, Nombre |
| `Direcciones` | ID, ID_Calle, Numero_Interior, Numero_Exterior |
| `Farmacias` | ID, Nombre, ID_Domicilio |
| `Propietarios` | ID, ID_Farmacia, Nombre, Apellido_Paterno, Apellido_Materno, ID_Domicilio |
| `Medicamentos` | ID, Nombre_Comercial, ID_Medicamento_Complementario |
| `Drogas` | ID, Nombre |
| `Drogas_Medicamentos` | ID, ID_Droga, ID_Medicamento |
| `Precios` | ID, ID_Farmacia, ID_Medicamento, Precio |

### Relaciones

| Relación | Cardinalidad |
|---|---|
| Provincias contienen Ciudades | 1:N |
| Ciudades contienen Colonias | 1:N |
| Colonias contienen Calles | 1:N |
| Calles contienen Direcciones | 1:N |
| Direcciones tienen Farmacias | 1:N |
| Direcciones tienen Propietarios | 1:N |
| Farmacias tienen Propietarios | 1:1 opcional |
| Farmacias tienen Precios | 1:N |
| Medicamentos tienen Precios | 1:N |
| Medicamentos y Drogas (vía `Drogas_Medicamentos`) | N:M |
| Medicamentos complementan a Medicamentos (recursiva) | 1:N |

## Reglas de integridad

Estas restricciones se implementan en la base de datos, no en el diagrama:

- `Farmacias.Nombre`: **UNIQUE**.
- `Ciudades (ID_Provincia, Nombre)`: **UNIQUE**, porque una ciudad se identifica por nombre y provincia.
- `Propietarios.ID_Farmacia`: **UNIQUE**, para que cada propietario tenga una sola farmacia y cada farmacia un solo propietario.
- `Precios (ID_Farmacia, ID_Medicamento)`: **UNIQUE**, para no repetir el precio de un medicamento en la misma farmacia.
- `Drogas_Medicamentos (ID_Medicamento, ID_Droga)`: **UNIQUE**, para no repetir una droga en un mismo medicamento.
- `Medicamentos.ID_Medicamento_Complementario`: permite **NULL**, ya que hay medicamentos sin complemento.
- `Ciudades.Superficie_Km2`: se expresa en kilómetros cuadrados, por ejemplo `DECIMAL(10,2)`.

## Decisiones de diseño

- **Farmacia sin propietario:** `ID_Farmacia` vive en `Propietarios`, así una farmacia sin dueño simplemente no tiene fila en esa tabla.
- **Precio por farmacia:** se guarda en `Precios` porque depende de la combinación farmacia–medicamento.
- **Complementos:** como cada medicamento es complementado por uno solo, basta una clave foránea recursiva en `Medicamentos`.
- **Nombre del propietario:** se divide en nombre, apellido paterno y apellido materno, en lugar del campo único que menciona el enunciado.

## Contenido del repositorio

```
.
├── README.md
├── Farmacias.pdf        # Diagrama entidad-relación
└── (script SQL)         # Pendiente
```

## Pendientes

- Corregir en el diagrama la ortografía de "Pertenencen" a "Pertenecen".
- Unificar el nombre de la tabla puente (`Drogas_Medicamentos`).
- Escribir el script SQL con tablas, claves foráneas y restricciones.

## Autor

- Nombre: _por completar_
- Materia / curso: _por completar_
- Fecha: noviembre de 2026

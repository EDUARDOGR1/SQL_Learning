# Centro de Salud

Base de datos en **SQL Server** para administrar la información de un centro de salud: médicos, empleados, pacientes, citas y atención médica.

Proyecto de práctica de modelado relacional, normalización y consultas SQL.

## Estado del proyecto

Con esta base de datos ya están resueltas todas las consultas de práctica. Los retos de SQL que quedan son opcionales y están pensados para quien quiera hacer un ejercicio extra.

Por ahora doy este proyecto por concluido y continuaré con otras bases de datos. Cuando haya subido más proyectos con sus respectivas consultas, volveré para resolver los retos pendientes.

## Planteamiento

Se necesita guardar información sobre:

- **Médicos**: nombre completo, dirección, teléfono, correo, cédula profesional, consultorio asignado, tipo de contrato (titular, interino o sustituto) y especialidad. Cada médico tiene un horario de consulta que puede cambiar según el día de la semana.
- **Contratos**: los datos de un médico nunca se eliminan al terminar su contrato, solo se registra una fecha de baja. Los interinos y sustitutos pueden tener varios periodos de alta y baja.
- **Empleados**: jefes de departamento, auxiliares administrativos, auxiliares de enfermería y vigilantes, con nombre, dirección, teléfono, NSS, cédula profesional y profesión.
- **Vacaciones**: periodos planificados y ya disfrutados, tanto de médicos como de empleados.
- **Pacientes**: nombre completo, dirección, teléfono, correo y NSS. Para solicitar una cita indican su NSS, consultorio, fecha y hora.
- **Atención médica**: cuando el paciente es atendido por el médico titular se registra el motivo (Revisión, Seguimiento o Consulta) y, si es Consulta, el diagnóstico.

## Diagrama entidad-relación

[Ver diagrama ER (PDF)](./Centro%20de%20salud%20Diagrama%20ER.pdf)

## Estructura de la base de datos

La base cuenta con **30 tablas** agrupadas así. Los nombres siguen la convención camelCase del script.

| Módulo | Tablas |
|--------|--------|
| **Ubicación** | `estados`, `municipios`, `asentamientos`, `colonias`, `calles`, `direcciones` |
| **Personas** | `personas` |
| **Médicos** | `medicos`, `especialidades`, `medico_especialidad`, `horariosConsultas` |
| **Contratos y movimientos** | `contratos`, `tiposContratos`, `periodosAltasBajas`, `movimientosPeriodos` |
| **Consultorios** | `consultorios`, `estatusConsultorios` |
| **Empleados** | `empleados`, `tiposEmpleos`, `profesiones` |
| **Vacaciones** | `periodosVacacionalesMedicos`, `periodosVacacionalesEmpleados`, `estatusVacaciones` |
| **Pacientes y agenda** | `pacientes`, `citasProgramadas`, `estatusCitasProgramadas` |
| **Atención médica** | `citas`, `tiposMotivos`, `diagnosticos`, `citasDiagnosticos` |

### Citas programadas vs. citas

El modelo separa lo **planeado** de lo que **realmente ocurrió**:

| Tabla | Qué representa |
|-------|----------------|
| `citasProgramadas` | La solicitud del paciente: paciente, consultorio, fecha, hora y estatus (programada, cancelada, etc.) |
| `citas` | La atención que se llevó a cabo: médico que atendió, motivo y notas, ligada a la cita programada que la originó |

## Decisiones de diseño

- **Entidad `personas` con subtipos**: los datos comunes (nombre, apellidos, teléfono, correo y dirección) viven una sola vez en `personas`. `medicos`, `empleados` y `pacientes` tienen su propio `id` y un `idPersona` único (FK a `personas`), por lo que la relación es 1:1 con cada rol. Así se evita duplicar datos y una misma persona puede ser, por ejemplo, médico y paciente.
- **Catálogos en lugar de textos repetidos**: tipos de contrato, movimientos, motivos, estatus de citas, consultorios y vacaciones se guardan en tablas aparte. Se pueden agregar valores sin modificar la estructura.
- **El tipo de contrato vive en el contrato, no en el médico**: así un sustituto puede convertirse en interino y el historial se conserva.
- **Historial de altas y bajas separado del contrato**: `contratos` define el tipo, y `periodosAltasBajas` registra cada movimiento (alta o baja) con su fecha, usando el catálogo `movimientosPeriodos`. Un médico puede tener varias altas y bajas a lo largo del tiempo, y sus datos nunca se eliminan. Como `contratos` no tiene fechas, la vigencia se deduce del último movimiento del médico.
- **Diagnósticos con catálogo CIE-10 y tabla intermedia**: una cita puede tener varios diagnósticos (`citasDiagnosticos`), y se pueden hacer reportes por enfermedad sin depender de texto libre. Las notas generales del médico van en `citas.notas` y las observaciones de cada diagnóstico en `citasDiagnosticos.observaciones`.
- **Direcciones normalizadas**: Estado → Municipio → Colonia → Calle → Dirección, para evitar datos repetidos. `asentamientos` clasifica cada colonia (colonia, fraccionamiento, barrio, etc.). La dirección se guarda en `personas`, no en cada subtipo.
- **Separación entre tipo de empleo y profesión**: el puesto (vigilante) es distinto de la formación (enfermero, contador).
- **Horarios por día**: `horariosConsultas` asigna a cada médico un consultorio, día de la semana (texto, de `Lunes` a `Domingo`), hora de inicio y hora de fin, lo que resuelve tanto el consultorio asignado como el horario distinto cada día.
- **Identificadores como texto**: teléfono, NSS y código postal se guardan como texto (`VARCHAR` o `CHAR`) para conservar ceros iniciales y no operar con ellos como números.

## Reglas de negocio

### Implementadas en el esquema

| Regla | Cómo se aplica |
|-------|----------------|
| Una cita programada genera una sola cita | `UNIQUE` en `citas.idCitaProgramada` |
| Un diagnóstico no se repite en la misma cita | `UNIQUE (idCita, idDiagnostico)` |
| Una persona tiene un solo registro por rol, pero puede tener varios roles | `UNIQUE` en `idPersona` de `medicos`, `empleados` y `pacientes` |
| Un médico no repite una especialidad | `UNIQUE (idMedico, idEspecialidad)` |
| Un médico no repite día y hora de inicio en su horario | `UNIQUE (idMedico, diaDeLaSemana, horaInicio)` |
| El día de la semana es válido | `CHECK` en `horariosConsultas` |
| La hora de fin es posterior a la de inicio | `CHECK` en `horariosConsultas` |
| La fecha de fin de vacaciones es posterior a la de inicio | `CHECK` en los dos periodos vacacionales |
| El NSS es único y tiene solo dígitos | `UNIQUE` y `CHECK` en `pacientes` y `empleados` |
| La cédula profesional es única; en empleados puede ser nula (ej. vigilantes) | `UNIQUE` en `medicos`; índice único filtrado (`WHERE cedulaProfesional IS NOT NULL`) en `empleados` |
| Teléfono y código postal solo tienen dígitos | `CHECK` en `personas` y `colonias` |

### Pendientes de implementar

Estas reglas no las cubre el esquema y se podrían resolver con triggers o validaciones:

- Las altas y bajas de un médico se alternan y la baja no es anterior a la alta.
- Solo el médico titular con contrato vigente atiende las citas.
- Si el motivo es Consulta, debe haber al menos un diagnóstico.
- No se agenda dos veces el mismo consultorio, fecha y hora (excepto citas canceladas).

## Cómo ejecutar

**Requisitos**: SQL Server 2019 o superior y SQL Server Management Studio (SSMS) o Azure Data Studio.

Ejecuta los scripts en este orden:

1. `01_schema.sql`: crea la base de datos, tablas, llaves y restricciones.
2. `02_data.sql`: llena los catálogos y carga datos de ejemplo.
3. `03_queries.sql`: consultas de práctica.

**Notas**

- El esquema crea la base `CentroSalud`. Si ya existe y quieres empezar de cero, elimínala antes (`DROP DATABASE CentroSalud`).
- Los datos de ejemplo asumen una base recién creada, porque las llaves foráneas usan los `id` generados en orden.
- Los datos son ficticios: 21 personas (6 médicos, 6 empleados y 10 pacientes; una persona es médica y paciente a la vez), 24 citas programadas y 14 citas atendidas.
- Dos periodos de vacaciones se calculan con la fecha de hoy (`GETDATE()`), para que la consulta de "quién está de vacaciones hoy" devuelva resultados el día que cargues los datos.
- Los scripts incluyen acentos: ábrelos como UTF-8.

## Consultas de práctica

`03_queries.sql` reúne las consultas de práctica, organizadas por nivel de dificultad, cada una con su enunciado. Practican:

- `INNER JOIN` y `LEFT JOIN` sobre varias tablas.
- Filtros con `WHERE`, `LIKE`, `BETWEEN` y ordenamientos con `ORDER BY`.
- Agregaciones con `COUNT`, `GROUP BY` y `HAVING`.
- Subconsultas, incluyendo `EXISTS` y `NOT EXISTS`.
- Expresiones de tabla comunes (`WITH`) para comparar contra promedios.

Algunos ejemplos de lo que se consulta:

- Directorio de médicos, empleados y pacientes, con su especialidad, puesto o dirección.
- Consultorios disponibles y citas programadas por mes.
- Historial de citas atendidas con paciente, médico, especialidad y motivo.
- Horario semanal de cada médico, incluyendo a quien no tiene horarios.
- Pacientes por municipio y citas por consultorio.
- Especialidades más solicitadas y médicos con más de una especialidad.
- Médicos sin citas y médicos sin vacaciones planificadas.
- Pacientes con más citas que el promedio y consultorios más utilizados.
- Citas atendidas sin diagnóstico.

Además, el archivo incluye **retos SQL opcionales** para quien quiera practicar un poco más.

## Estado

- [x] Diagrama entidad-relación
- [x] Script de tablas
- [x] Datos de prueba
- [x] Consultas de práctica
- [ ] Retos SQL (opcionales)
- [ ] Reglas de negocio pendientes (triggers y validaciones)

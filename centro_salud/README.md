# Centro de Salud

Base de datos en **SQL Server** para administrar la información de un centro de salud: médicos, empleados, pacientes, citas y atención médica.

Proyecto de práctica de modelado relacional, normalización y consultas SQL.

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

La base cuenta con **30 tablas** agrupadas así:

| Módulo | Tablas |
|--------|--------|
| **Ubicación** | `Estados`, `Municipios`, `Asentamientos`, `Colonias`, `Calles`, `Direcciones` |
| **Personas** | `Personas` |
| **Médicos** | `Medicos`, `Especialidades`, `Medico_Especialidad`, `Horarios_De_Consultas`, `Cedula_Profesional`|
| **Contratos y movimientos** | `Contratos`, `Tipos_De_Contrato`, `Periodos_Altas_Bajas`, `Movimientos` |
| **Consultorios** | `Consultorios`, `Estatus_Consultorios` |
| **Empleados** | `Empleados`, `Tipos_De_Empleados`, `Profesiones` |
| **Vacaciones** | `Periodos_Vacacionales_Medicos`, `Periodos_Vacacionales_Empleados`, `Estatus_Vacaciones` |
| **Pacientes y agenda** | `Pacientes`, `Citas_Programadas`, `Estatus_De_Las_Citas_Programadas` |
| **Atención médica** | `Citas`, `Tipos_De_Motivos`, `Diagnosticos`, `Citas_Diagnosticos` |

### Citas programadas vs. citas

El modelo separa lo **planeado** de lo que **realmente ocurrió**:

| Tabla | Qué representa |
|-------|----------------|
| `Citas_Programadas` | La solicitud del paciente: paciente, consultorio, fecha, hora y estatus (programada, cancelada, etc.) |
| `Citas` | La atención que se llevó a cabo: médico que atendió, motivo y notas, ligada a la cita programada que la originó |

## Decisiones de diseño

- **Entidad `Personas` con subtipos**: los datos comunes (nombre, apellidos, teléfono, correo y dirección) viven una sola vez en `Personas`. `Medicos`, `Empleados` y `Pacientes` usan como llave primaria el mismo `ID_Persona` (a la vez FK), y solo guardan lo propio de cada rol. Así se evita duplicar datos y una misma persona puede ser, por ejemplo, médico y paciente.
- **Catálogos en lugar de textos repetidos**: tipos de contrato, movimientos, motivos, estatus de citas, consultorios y vacaciones se guardan en tablas aparte. Se pueden agregar valores sin modificar la estructura.
- **El tipo de contrato vive en el contrato, no en el médico**: así un sustituto puede convertirse en interino y el historial se conserva.
- **Historial de altas y bajas separado del contrato**: `Contratos` define el tipo, y `Periodos_Altas_Bajas` registra cada movimiento (alta o baja) con su fecha, usando el catálogo `Movimientos`. Un médico puede tener varias altas y bajas a lo largo del tiempo, y sus datos nunca se eliminan.
- **Diagnósticos con catálogo CIE-10 y tabla intermedia**: una cita puede tener varios diagnósticos (`Citas_Diagnosticos`), y se pueden hacer reportes por enfermedad sin depender de texto libre. Las observaciones del médico van en `Notas`.
- **Direcciones normalizadas**: Estado → Municipio → Colonia → Calle → Dirección, para evitar datos repetidos. `Asentamientos` clasifica cada colonia (colonia, fraccionamiento, barrio, etc.). La dirección se guarda en `Personas`, no en cada subtipo.
- **Separación entre tipo de empleado y profesión**: el puesto (vigilante) es distinto de la formación (enfermero, contador).
- **Horarios por día**: `Horarios_De_Consultas` asigna a cada médico un consultorio, día de la semana, hora de inicio y hora de fin, lo que resuelve tanto el consultorio asignado como el horario distinto cada día.

## Reglas de negocio

| Regla | Cómo se aplica |
|-------|----------------|
| Una cita programada genera una sola cita | `UNIQUE` en `Citas.ID_Cita_Programada` |
| Un diagnóstico no se repite en la misma cita | `UNIQUE (ID_Cita, ID_Diagnostico)` |
| Una persona puede tener varios roles (médico, paciente, empleado) | PK de cada subtipo es FK a `Personas`, sin restricción de exclusividad |
| Las altas y bajas de un médico se alternan y la baja no es anterior a la alta | Trigger en `Periodos_Altas_Bajas` |
| La hora de fin es posterior a la de inicio | `CHECK` en `Horarios_De_Consultas` |
| El NSS no se repite | `UNIQUE` en `Pacientes` y en `Empleados` |
| La cédula profesional es única y puede ser nula en empleados (ej. vigilantes) | `UNIQUE` filtrado (`WHERE Cedula IS NOT NULL`) |
| Solo el médico titular con contrato vigente atiende las citas | Trigger |
| Si el motivo es Consulta, debe haber al menos un diagnóstico | Validación al cerrar la cita |
| No se agenda dos veces el mismo consultorio, fecha y hora (excepto citas canceladas) | Trigger en `Citas_Programadas` |

## Cómo ejecutar

**Requisitos**: SQL Server 2019 o superior y SQL Server Management Studio (SSMS) o Azure Data Studio.

Ejecuta los scripts en este orden:

1. `01_schema.sql`: crea la base de datos, tablas, llaves y restricciones.
2. `02_data.sql`: llena los catálogos y carga datos de ejemplo.
3. `03_queries.sql`: consultas de práctica.

## Consultas de práctica

Ejemplos de lo que se puede consultar con esta base:

- Médicos con contrato vigente y su especialidad.
- Horario semanal de un médico.
- Citas programadas para una fecha, por consultorio.
- Historial de citas y diagnósticos de un paciente (por NSS).
- Diagnósticos más frecuentes del último año.
- Médicos y empleados que están de vacaciones hoy.
- Consultorios disponibles en un día y hora determinados.
- Pacientes sin ninguna cita atendida.
- Historial de altas y bajas de un médico.
- Personas que son médico y paciente a la vez.

## Estado

- [x] Diagrama entidad-relación
- [ ] Script de tablas
- [ ] Datos de prueba
- [ ] Triggers
- [ ] Consultas de práctica

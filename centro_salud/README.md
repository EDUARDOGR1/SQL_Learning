# Centro de Salud

Base de datos en **SQL Server** para administrar la información de un centro de salud: médicos, empleados, pacientes, citas y visitas médicas.

Proyecto de práctica de modelado relacional, normalización y consultas SQL.

## Planteamiento

Se necesita guardar información sobre:

- **Médicos**: nombre completo, dirección, teléfono, correo, cédula profesional, consultorio asignado, tipo de contrato (titular, interino o sustituto) y especialidad. Cada médico tiene un horario de consulta que puede cambiar según el día de la semana.
- **Contratos**: los datos de un médico nunca se eliminan al terminar su contrato, solo se registra una fecha de baja. Los interinos y sustitutos pueden tener varios periodos de alta y baja.
- **Empleados**: jefes de departamento, auxiliares administrativos, auxiliares de enfermería y vigilantes, con nombre, dirección, teléfono, NSS, cédula profesional y profesión.
- **Vacaciones**: periodos planificados y ya disfrutados, tanto de médicos como de empleados.
- **Pacientes**: nombre completo, dirección, teléfono, correo y NSS. Para solicitar una cita indican su NSS, consultorio, fecha y hora.
- **Visitas**: cuando el paciente es atendido por el médico titular se registra el motivo (Revisión, Seguimiento o Consulta) y, si es Consulta, el diagnóstico.

## Diagrama entidad-relación

![Diagrama ER](./diagrama_er.png)

> Agrega aquí la imagen exportada de tu diagrama con el nombre `diagrama_er.png`.

## Estructura de la base de datos

La base cuenta con **27 tablas** agrupadas así:

| Módulo | Tablas |
|--------|--------|
| **Ubicación** | `Estados`, `Municipios`, `Asentamientos`, `Colonias`, `Calles`, `Direcciones` |
| **Médicos** | `Medicos`, `Especialidades`, `Medico_Especialidad`, `Horarios_De_Consultas` |
| **Contratos** | `Contratos`, `Tipos_De_Contrato` |
| **Consultorios** | `Consultorios`, `Estatus_Consultorios` |
| **Empleados** | `Empleados`, `Tipos_De_Empleados`, `Profesiones` |
| **Vacaciones** | `Periodos_Vacacionales_Medicos`, `Periodos_Vacacionales_Empleados`, `Estatus_Vacaciones` |
| **Pacientes y citas** | `Pacientes`, `Citas`, `Estatus_De_Las_Citas` |
| **Atención médica** | `Visitas`, `Tipos_De_Motivos`, `Diagnosticos`, `Visitas_Diagnosticos` |

## Decisiones de diseño

- **Catálogos en lugar de textos repetidos**: tipos de contrato, motivos, estatus de citas, consultorios y vacaciones se guardan en tablas aparte. Se pueden agregar valores sin modificar la estructura.
- **El tipo de contrato vive en el contrato, no en el médico**: así un sustituto puede convertirse en interino y el historial se conserva.
- **Historial de altas y bajas**: cada contrato tiene `Fecha_De_Alta` y `Fecha_De_Baja` (nula si sigue vigente). Un médico puede tener varios contratos.
- **Diagnósticos con catálogo CIE-10 y tabla intermedia**: una visita puede tener varios diagnósticos, y se pueden hacer reportes por enfermedad sin depender de texto libre. Las observaciones del médico van en `Notas`.
- **Direcciones normalizadas**: Estado → Municipio → Colonia → Calle → Dirección, para evitar datos repetidos.
- **Separación entre tipo de empleado y profesión**: el puesto (vigilante) es distinto de la formación (enfermero, contador).

## Reglas de negocio

| Regla | Cómo se aplica |
|-------|----------------|
| Una cita genera una sola visita | `UNIQUE` en `Visitas.ID_Cita` |
| Un diagnóstico no se repite en la misma visita | `UNIQUE (ID_Visita, ID_Diagnostico)` |
| La fecha de baja no puede ser anterior a la de alta | `CHECK` en `Contratos` |
| La hora de fin es posterior a la de inicio | `CHECK` en `Horarios_De_Consultas` |
| Solo el médico titular atiende las visitas | Trigger |
| Si el motivo es Consulta, debe haber al menos un diagnóstico | Validación al cerrar la visita |
| No se agenda dos veces el mismo consultorio, fecha y hora (excepto citas canceladas) | Trigger |

## Cómo ejecutar

**Requisitos**: SQL Server 2019 o superior y SQL Server Management Studio (SSMS) o Azure Data Studio.

Ejecuta los scripts en este orden:

1. `01_crear_tablas.sql`: crea la base de datos, tablas, llaves y restricciones.
2. `02_datos_prueba.sql`: llena los catálogos y carga datos de ejemplo.
3. `03_triggers.sql`: crea los triggers de las reglas de negocio.
4. `04_consultas.sql`: consultas de práctica.

## Consultas de práctica

Ejemplos de lo que se puede consultar con esta base:

- Médicos con contrato vigente y su especialidad.
- Horario semanal de un médico.
- Citas programadas para una fecha, por consultorio.
- Historial de visitas y diagnósticos de un paciente (por NSS).
- Diagnósticos más frecuentes del último año.
- Médicos y empleados que están de vacaciones hoy.
- Consultorios disponibles en un día y hora determinados.
- Pacientes sin ninguna visita registrada.

## Temas que practica

`PRIMARY KEY` · `FOREIGN KEY` · `UNIQUE` · `CHECK` · normalización (3FN) · relaciones 1:N y N:M · `JOIN` · `GROUP BY` · subconsultas · triggers

## Estado

- [x] Diagrama entidad-relación
- [ ] Script de tablas
- [ ] Datos de prueba
- [ ] Triggers
- [ ] Consultas de práctica

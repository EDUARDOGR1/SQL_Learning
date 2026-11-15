USE CentroSalud;
GO

CREATE TABLE estados (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE municipios (
    id        INT IDENTITY(1,1) PRIMARY KEY,
    nombre    VARCHAR(150) NOT NULL,
    idEstado  INT NOT NULL,
    FOREIGN KEY (idEstado) REFERENCES estados(id),
    UNIQUE (idEstado, nombre)
);

CREATE TABLE asentamientos (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE colonias (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    codigoPostal    CHAR(5) NOT NULL,
    idMunicipio     INT NOT NULL,
    idAsentamiento  INT NOT NULL,
    FOREIGN KEY (idMunicipio)    REFERENCES municipios(id),
    FOREIGN KEY (idAsentamiento) REFERENCES asentamientos(id),
    CONSTRAINT CK_colonias_cp CHECK (codigoPostal NOT LIKE '%[^0-9]%')
);

CREATE TABLE calles (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    nombre     VARCHAR(150) NOT NULL,
    idColonia  INT NOT NULL,
    FOREIGN KEY (idColonia) REFERENCES colonias(id)
);

CREATE TABLE direcciones (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    numeroExterior  VARCHAR(10) NOT NULL,
    numeroInterior  VARCHAR(10) NULL,
    idCalle         INT NOT NULL,
    FOREIGN KEY (idCalle) REFERENCES calles(id)
);

CREATE TABLE personas (
    id                 INT IDENTITY(1,1) PRIMARY KEY,
    nombre             VARCHAR(150) NOT NULL,
    apellidoPaterno    VARCHAR(150) NOT NULL,
    apellidoMaterno    VARCHAR(150) NULL,
    telefono           VARCHAR(15) NOT NULL,
    correoElectronico  VARCHAR(150) NULL,
    idDireccion        INT NOT NULL,
    FOREIGN KEY (idDireccion) REFERENCES direcciones(id),
    CONSTRAINT CK_personas_telefono CHECK (telefono NOT LIKE '%[^0-9]%')
);

CREATE TABLE estatusConsultorios (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE consultorios (
    id                    INT IDENTITY(1,1) PRIMARY KEY,
    numero                VARCHAR(10) NOT NULL UNIQUE,
    piso                  INT NULL,
    descripcion           VARCHAR(150) NULL,
    idEstatusConsultorio  INT NOT NULL,
    FOREIGN KEY (idEstatusConsultorio) REFERENCES estatusConsultorios(id)
);

CREATE TABLE especialidades (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE medicos (
    id                 INT IDENTITY(1,1) PRIMARY KEY,
    cedulaProfesional  INT NOT NULL UNIQUE,
    idPersona          INT NOT NULL UNIQUE,
    FOREIGN KEY (idPersona) REFERENCES personas(id)
);

CREATE TABLE medico_especialidad (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    idMedico        INT NOT NULL,
    idEspecialidad  INT NOT NULL,
    FOREIGN KEY (idMedico)       REFERENCES medicos(id),
    FOREIGN KEY (idEspecialidad) REFERENCES especialidades(id),
    UNIQUE (idMedico, idEspecialidad)
);

CREATE TABLE horariosConsultas (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    diaDeLaSemana  VARCHAR(10) NOT NULL,
    horaInicio     TIME(0) NOT NULL,
    horaFin        TIME(0) NOT NULL,
    idMedico       INT NOT NULL,
    idConsultorio  INT NOT NULL,
    FOREIGN KEY (idMedico)      REFERENCES medicos(id),
    FOREIGN KEY (idConsultorio) REFERENCES consultorios(id),
    CONSTRAINT CK_horarios_dia CHECK (diaDeLaSemana IN
        ('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo')),
    CONSTRAINT CK_horarios_horas CHECK (horaFin > horaInicio),
    CONSTRAINT UQ_horarios_medico_dia_inicio UNIQUE (idMedico, diaDeLaSemana, horaInicio)
);

CREATE TABLE tiposContratos (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE contratos (
    id              INT IDENTITY(1,1) PRIMARY KEY,
    idMedico        INT NOT NULL,
    idTipoContrato  INT NOT NULL,
    FOREIGN KEY (idMedico)       REFERENCES medicos(id),
    FOREIGN KEY (idTipoContrato) REFERENCES tiposContratos(id)
);

CREATE TABLE movimientosPeriodos (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE periodosAltasBajas (
    id            INT IDENTITY(1,1) PRIMARY KEY,
    fecha         DATE NOT NULL,
    idMedico      INT NOT NULL,
    idMovimiento  INT NOT NULL,
    FOREIGN KEY (idMedico)     REFERENCES medicos(id),
    FOREIGN KEY (idMovimiento) REFERENCES movimientosPeriodos(id)
);

CREATE TABLE tiposEmpleos (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE profesiones (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE empleados (
    id                 INT IDENTITY(1,1) PRIMARY KEY,
    NSS                CHAR(11) NOT NULL UNIQUE,
    cedulaProfesional  INT NULL,
    idPersona          INT NOT NULL UNIQUE,
    idTipoEmpleo       INT NOT NULL,
    idProfesion        INT NOT NULL,
    FOREIGN KEY (idPersona)    REFERENCES personas(id),
    FOREIGN KEY (idTipoEmpleo) REFERENCES tiposEmpleos(id),
    FOREIGN KEY (idProfesion)  REFERENCES profesiones(id),
    CONSTRAINT CK_empleados_nss CHECK (NSS NOT LIKE '%[^0-9]%')
);

CREATE UNIQUE INDEX UQ_empleados_cedula
    ON empleados(cedulaProfesional)
    WHERE cedulaProfesional IS NOT NULL;
GO

CREATE TABLE estatusVacaciones (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE periodosVacacionalesMedicos (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    idMedico     INT NOT NULL,
    fechaInicio  DATE NOT NULL,
    fechaFin     DATE NOT NULL,
    idEstatus    INT NOT NULL,
    FOREIGN KEY (idMedico)  REFERENCES medicos(id),
    FOREIGN KEY (idEstatus) REFERENCES estatusVacaciones(id),
    CONSTRAINT CK_vacaciones_medicos_fechas CHECK (fechaFin > fechaInicio)
);

CREATE TABLE periodosVacacionalesEmpleados (
    id           INT IDENTITY(1,1) PRIMARY KEY,
    idEmpleado   INT NOT NULL,
    fechaInicio  DATE NOT NULL,
    fechaFin     DATE NOT NULL,
    idEstatus    INT NOT NULL,
    FOREIGN KEY (idEmpleado) REFERENCES empleados(id),
    FOREIGN KEY (idEstatus)  REFERENCES estatusVacaciones(id),
    CONSTRAINT CK_vacaciones_empleados_fechas CHECK (fechaFin > fechaInicio)
);

CREATE TABLE pacientes (
    id         INT IDENTITY(1,1) PRIMARY KEY,
    NSS        CHAR(11) NOT NULL UNIQUE,
    idPersona  INT NOT NULL UNIQUE,
    FOREIGN KEY (idPersona) REFERENCES personas(id),
    CONSTRAINT CK_pacientes_nss CHECK (NSS NOT LIKE '%[^0-9]%')
);

CREATE TABLE estatusCitasProgramadas (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE citasProgramadas (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    fecha          DATE NOT NULL,
    hora           TIME(0) NOT NULL,
    idPaciente     INT NOT NULL,
    idConsultorio  INT NOT NULL,
    idEstatus      INT NOT NULL,
    FOREIGN KEY (idPaciente)    REFERENCES pacientes(id),
    FOREIGN KEY (idConsultorio) REFERENCES consultorios(id),
    FOREIGN KEY (idEstatus)     REFERENCES estatusCitasProgramadas(id)
);

CREATE TABLE tiposMotivos (
    id      INT IDENTITY(1,1) PRIMARY KEY,
    nombre  VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE citas (
    id                INT IDENTITY(1,1) PRIMARY KEY,
    notas             VARCHAR(255) NULL,
    idCitaProgramada  INT NOT NULL UNIQUE,
    idMotivo          INT NOT NULL,
    idMedico          INT NOT NULL,
    FOREIGN KEY (idCitaProgramada) REFERENCES citasProgramadas(id),
    FOREIGN KEY (idMotivo)         REFERENCES tiposMotivos(id),
    FOREIGN KEY (idMedico)         REFERENCES medicos(id)
);

CREATE TABLE diagnosticos (
    id          INT IDENTITY(1,1) PRIMARY KEY,
    codigoCIE10 VARCHAR(10) NOT NULL UNIQUE,
    nombre      VARCHAR(255) NOT NULL
);

CREATE TABLE citasDiagnosticos (
    id             INT IDENTITY(1,1) PRIMARY KEY,
    observaciones  VARCHAR(255) NULL,
    idCita         INT NOT NULL,
    idDiagnostico  INT NOT NULL,
    FOREIGN KEY (idCita)        REFERENCES citas(id),
    FOREIGN KEY (idDiagnostico) REFERENCES diagnosticos(id),
    UNIQUE (idCita, idDiagnostico)
);

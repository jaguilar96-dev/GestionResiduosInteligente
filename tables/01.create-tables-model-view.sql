-- TABLA DE USUARIOS
CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    DNI CHAR(8) UNIQUE NOT NULL,
    Email NVARCHAR(150) UNIQUE NOT NULL,
    ClaveHash NVARCHAR(255) NOT NULL,
    Telefono NVARCHAR(20),
    Rol NVARCHAR(20) CHECK (Rol IN ('Ciudadano', 'Operario', 'Supervisor', 'Administrador')) NOT NULL,
    Activo BIT DEFAULT 1,
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- DIRECCIONES DE USUARIOS
CREATE TABLE Direcciones (
    DireccionID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Distrito NVARCHAR(100),
    Direccion NVARCHAR(255),
    Latitud DECIMAL(9,6),
    Longitud DECIMAL(9,6),
    Principal BIT DEFAULT 1
);
GO

-- TABLA DE ZONAS GEOGRÁFICAS
CREATE TABLE Zonas (
    ZonaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    Distrito NVARCHAR(100),
    Activa BIT DEFAULT 1
);
GO

-- TIPO DE RESIDUO (CATÁLOGO)
CREATE TABLE TiposResiduo (
    TipoID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Clasificacion NVARCHAR(50) CHECK (Clasificacion IN ('Orgánico', 'Inorgánico', 'Reciclable', 'Peligroso')) NOT NULL,
    Descripcion NVARCHAR(255)
);
GO

-- VEHÍCULOS PARA RECOLECCIÓN
CREATE TABLE Vehiculos (
    VehiculoID INT IDENTITY(1,1) PRIMARY KEY,
    Placa NVARCHAR(10) UNIQUE NOT NULL,
    Tipo NVARCHAR(50) CHECK (Tipo IN ('Camión', 'Recolector', 'Triciclo', 'Furgoneta')) NOT NULL,
    CapacidadToneladas DECIMAL(4,2),
    Activo BIT DEFAULT 1
);
GO

-- RUTAS DE RECOLECCIÓN
CREATE TABLE Rutas (
    RutaID INT IDENTITY(1,1) PRIMARY KEY,
    ZonaID INT FOREIGN KEY REFERENCES Zonas(ZonaID),
    VehiculoID INT FOREIGN KEY REFERENCES Vehiculos(VehiculoID),
    ResponsableID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Frecuencia NVARCHAR(50), -- Ej: "Lunes, Miércoles, Viernes"
    HoraInicio TIME,
    HoraFin TIME,
    Observaciones NVARCHAR(255)
);
GO

-- REPORTES DE INCIDENCIA DE CIUDADANOS
CREATE TABLE Reportes (
    ReporteID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    DireccionID INT FOREIGN KEY REFERENCES Direcciones(DireccionID),
    TipoID INT FOREIGN KEY REFERENCES TiposResiduo(TipoID),
    ZonaID INT FOREIGN KEY REFERENCES Zonas(ZonaID),
    Descripcion NVARCHAR(500),
    FotoURL NVARCHAR(255),
    FechaReporte DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Asignado', 'Atendido', 'Rechazado')) DEFAULT 'Pendiente'
);
GO

-- ASIGNACIÓN DE REPORTE A OPERARIO
CREATE TABLE AtencionIncidencias (
    AtencionID INT IDENTITY(1,1) PRIMARY KEY,
    ReporteID INT FOREIGN KEY REFERENCES Reportes(ReporteID),
    OperarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaAsignacion DATETIME DEFAULT GETDATE(),
    FechaAtencion DATETIME,
    Comentario NVARCHAR(255),
    Estado NVARCHAR(20) CHECK (Estado IN ('Asignado', 'En proceso', 'Finalizado')) DEFAULT 'Asignado'
);
GO

-- VALIDACIÓN SUPERVISOR DE ATENCIÓN
CREATE TABLE Validaciones (
    ValidacionID INT IDENTITY(1,1) PRIMARY KEY,
    AtencionID INT FOREIGN KEY REFERENCES AtencionIncidencias(AtencionID),
    SupervisorID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    FechaValidacion DATETIME DEFAULT GETDATE(),
    Resultado NVARCHAR(20) CHECK (Resultado IN ('Aprobado', 'Requiere seguimiento')),
    Observaciones NVARCHAR(255)
);
GO

-- NOTIFICACIONES ENVIADAS A USUARIOS
CREATE TABLE Notificaciones (
    NotificacionID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID),
    Mensaje NVARCHAR(300),
    FechaEnvio DATETIME DEFAULT GETDATE(),
    Leida BIT DEFAULT 0
);
GO

-- HISTORIAL DE SERVICIOS POR RUTA
CREATE TABLE HistorialRecoleccion (
    HistorialID INT IDENTITY(1,1) PRIMARY KEY,
    RutaID INT FOREIGN KEY REFERENCES Rutas(RutaID),
    FechaServicio DATETIME NOT NULL,
    KilometrosRecorridos DECIMAL(6,2),
    ToneladasRecolectadas DECIMAL(5,2),
    Observaciones NVARCHAR(255)
);
GO

-- VISTA DE ESTADÍSTICAS POR DISTRITO
CREATE VIEW EstadisticasGenerales AS
SELECT 
    Z.Distrito,
    COUNT(R.ReporteID) AS TotalReportes,
    SUM(CASE WHEN R.Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
    SUM(CASE WHEN R.Estado = 'Atendido' THEN 1 ELSE 0 END) AS Atendidos,
    SUM(H.ToneladasRecolectadas) AS TotalToneladas
FROM Zonas Z
LEFT JOIN Reportes R ON Z.ZonaID = R.ZonaID
LEFT JOIN Rutas RT ON Z.ZonaID = RT.ZonaID
LEFT JOIN HistorialRecoleccion H ON RT.RutaID = H.RutaID
GROUP BY Z.Distrito;
GO

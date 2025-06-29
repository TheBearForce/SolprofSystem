CREATE DATABASE SolProfDB;
GO
USE SolProfDB;

-- Tabla Roles
CREATE TABLE Roles (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL
);

-- Tabla Usuarios
CREATE TABLE Usuarios (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE,
    Contrasena NVARCHAR(255),
    RolId INT,
    FOREIGN KEY (RolId) REFERENCES Roles(Id)
);

-- Tabla Articulos
CREATE TABLE Articulos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Codigo NVARCHAR(20) UNIQUE,
    Nombre NVARCHAR(100),
    Categoria NVARCHAR(50),
    Estado NVARCHAR(50),
    Ubicacion NVARCHAR(100)
);

-- Tabla Prestamos
CREATE TABLE Prestamos (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT,
    ArticuloId INT,
    FechaPrestamo DATE,
    FechaDevolucion DATE,
    Estado NVARCHAR(50),
    FOREIGN KEY (UsuarioId) REFERENCES Usuarios(Id),
    FOREIGN KEY (ArticuloId) REFERENCES Articulos(Id)
);

-- Script para insertar 5 datos en cada tabla de SolProfDB
USE SolProfDB;

-- 1. Insertar datos en tabla Roles
INSERT INTO Roles (Nombre) VALUES 
('Administrador'),
('Usuario'),
('Supervisor'),
('Operador'),
('Invitado');

-- 2. Insertar datos en tabla Usuarios
INSERT INTO Usuarios (Nombre, Email, Contrasena, RolId) VALUES
('Juan Pérez', 'juan.perez@solprof.com', 'hash123admin', 1),
('María García', 'maria.garcia@solprof.com', 'hash456user', 2),
('Carlos López', 'carlos.lopez@solprof.com', 'hash789super', 3),
('Ana Rodríguez', 'ana.rodriguez@solprof.com', 'hash012oper', 4),
('Luis Martínez', 'luis.martinez@solprof.com', 'hash345guest', 5);

-- 3. Insertar datos en tabla Articulos
INSERT INTO Articulos (Codigo, Nombre, Categoria, Estado, Ubicacion) VALUES
('ART-001', 'Laptop Dell Inspiron 15', 'Computadoras', 'Disponible', 'Almacén Principal - Estante A1'),
('ART-002', 'Impresora HP LaserJet Pro', 'Impresoras', 'En Uso', 'Oficina Administrativa - Piso 2'),
('ART-003', 'Proyector Epson PowerLite', 'Audio y Video', 'Disponible', 'Sala de Conferencias - Armario B'),
('ART-004', 'Taladro Bosch Professional', 'Herramientas', 'En Mantenimiento', 'Taller - Zona de Herramientas'),
('ART-005', 'Mesa de Oficina Ergonómica', 'Mobiliario', 'Disponible', 'Almacén de Mobiliario - Sección C');

-- 4. Insertar datos en tabla Prestamos
INSERT INTO Prestamos (UsuarioId, ArticuloId, FechaPrestamo, FechaDevolucion, Estado) VALUES
(2, 1, '2024-06-01', '2024-06-15', 'Devuelto'),
(3, 2, '2024-06-10', NULL, 'Activo'),
(4, 3, '2024-06-15', '2024-06-18', 'Devuelto'),
(2, 4, '2024-06-20', NULL, 'Activo'),
(5, 5, '2024-06-22', '2024-06-25', 'Devuelto');

-- Tabla para registrar sesiones o autenticaciones
CREATE TABLE Sesiones (
    Id INT PRIMARY KEY IDENTITY(1,1),
    UsuarioId INT NOT NULL,
    FechaInicio DATETIME DEFAULT GETDATE(),
    Token NVARCHAR(500),
    EstadoSesion NVARCHAR(50),
    FOREIGN KEY (UsuarioId) REFERENCES Usuarios(Id)
);

-- Vista para obtener la respuesta AuthResponse
DROP VIEW IF EXISTS VistaAuthResponse;
GO

CREATE VIEW VistaAuthResponse AS
SELECT 
    U.Id AS UsuarioId,
    U.Nombre,
    U.Email,
    U.Contrasena, -- ahora sí se incluye
    R.Nombre AS Rol,
    'Autenticación exitosa' AS Mensaje
FROM Usuarios U
JOIN Roles R ON U.RolId = R.Id;

SELECT * 
FROM VistaAuthResponse 
WHERE Email = 'juan.perez@solprof.com' AND Contrasena = 'hash123admin';



-- Consultas para verificar los datos insertados
SELECT 'Roles' as Tabla, COUNT(*) as 'Total Registros' FROM Roles
UNION ALL
SELECT 'Usuarios', COUNT(*) FROM Usuarios
UNION ALL  
SELECT 'Articulos', COUNT(*) FROM Articulos
UNION ALL
SELECT 'Prestamos', COUNT(*) FROM Prestamos;

-- Consulta completa para ver todos los datos relacionados
SELECT 
    p.Id as PrestamoId,
    u.Nombre as Usuario,
    u.Email,
    r.Nombre as Rol,
    a.Codigo,
    a.Nombre as Articulo,
    a.Categoria,
    a.Estado as EstadoArticulo,
    p.FechaPrestamo,
    p.FechaDevolucion,
    p.Estado as EstadoPrestamo
FROM Prestamos p
INNER JOIN Usuarios u ON p.UsuarioId = u.Id
INNER JOIN Roles r ON u.RolId = r.Id
INNER JOIN Articulos a ON p.ArticuloId = a.Id
ORDER BY p.FechaPrestamo DESC;


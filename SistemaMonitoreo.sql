USE [SistemaMonitoreo]
GO
/****** Object:  Table [dbo].[AlertasSalud]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AlertasSalud](
	[AlertaID] [int] IDENTITY(1,1) NOT NULL,
	[EstudianteID] [int] NULL,
	[Fecha] [date] NULL,
	[Descripcion] [nvarchar](255) NULL,
	[NivelUrgencia] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[AlertaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estudiantes]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estudiantes](
	[EstudianteID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[Apellido] [nvarchar](100) NULL,
	[FechaNacimiento] [date] NULL,
	[Sexo] [char](1) NULL,
	[Ciclo] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[EstudianteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ConteoAlertasPorUrgencia]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 1. Contar el número de alertas de salud por nivel de urgencia
CREATE VIEW [dbo].[vw_ConteoAlertasPorUrgencia] AS
SELECT 
    e.EstudianteID,
    e.Nombre,
    e.Apellido,
    a.NivelUrgencia,
    COUNT(*) AS TotalAlertas
FROM AlertasSalud a
JOIN Estudiantes e ON a.EstudianteID = e.EstudianteID
GROUP BY e.EstudianteID, e.Nombre, e.Apellido, a.NivelUrgencia;
GO
/****** Object:  Table [dbo].[RegistrosSalud]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegistrosSalud](
	[RegistroID] [int] IDENTITY(1,1) NOT NULL,
	[EstudianteID] [int] NULL,
	[Fecha] [date] NULL,
	[Peso] [decimal](5, 2) NULL,
	[Altura] [decimal](5, 2) NULL,
	[Temperatura] [decimal](4, 2) NULL,
	[PresionArterial] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[RegistroID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_PromedioTempPresion]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2. Obtener el promedio de temperatura y presión por estudiante
CREATE VIEW [dbo].[vw_PromedioTempPresion] AS
SELECT 
    e.EstudianteID,
    e.Nombre,
    e.Apellido,
    AVG(r.Temperatura) AS PromedioTemperatura,
    STRING_AGG(r.PresionArterial, ', ') AS PresionesRegistradas
FROM RegistrosSalud r
JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
GROUP BY e.EstudianteID, e.Nombre, e.Apellido;
GO
/****** Object:  View [dbo].[vw_EstudiantesConTempAlta]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 3. Filtrar estudiantes cuya temperatura promedio supera los 37.5 °C
CREATE VIEW [dbo].[vw_EstudiantesConTempAlta] AS
SELECT 
    e.EstudianteID,
    e.Nombre,
    e.Apellido,
    AVG(r.Temperatura) AS TempPromedio
FROM RegistrosSalud r
JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
GROUP BY e.EstudianteID, e.Nombre, e.Apellido
HAVING AVG(r.Temperatura) > 37.5;
GO
/****** Object:  View [dbo].[vw_RankingTemperatura]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 4. Asignar un ranking a los estudiantes según su temperatura promedio (descendente)
CREATE VIEW [dbo].[vw_RankingTemperatura] AS
SELECT 
    e.EstudianteID,
    e.Nombre,
    e.Apellido,
    AVG(r.Temperatura) AS TempPromedio,
    RANK() OVER (ORDER BY AVG(r.Temperatura) DESC) AS Ranking
FROM RegistrosSalud r
JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
GROUP BY e.EstudianteID, e.Nombre, e.Apellido;
GO
/****** Object:  Table [dbo].[Evaluaciones]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evaluaciones](
	[ID_Evaluacion] [int] IDENTITY(1,1) NOT NULL,
	[DNI_Estudiante] [int] NULL,
	[Fecha] [date] NULL,
	[Hora] [time](7) NULL,
	[Diagnostico] [nvarchar](255) NULL,
	[ID_Medico] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID_Evaluacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactoresRiesgo]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactoresRiesgo](
	[RiesgoID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[RiesgoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FactoresRiesgoEstudiantes]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactoresRiesgoEstudiantes](
	[EstudianteID] [int] NOT NULL,
	[RiesgoID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EstudianteID] ASC,
	[RiesgoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Medicos]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Medicos](
	[MedicoID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](100) NULL,
	[Apellido] [nvarchar](100) NULL,
	[Especialidad] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[MedicoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sintomas]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sintomas](
	[SintomaID] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[SintomaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SintomasEstudiantes]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SintomasEstudiantes](
	[RegistroID] [int] NOT NULL,
	[SintomaID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RegistroID] ASC,
	[SintomaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AlertasSalud] ON 

INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (62, 10001, CAST(N'2025-06-01' AS Date), N'Dolor de cabeza y fiebre', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (63, 10002, CAST(N'2025-06-02' AS Date), N'Tos persistente', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (64, 10003, CAST(N'2025-06-03' AS Date), N'Fiebre alta', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (65, 10004, CAST(N'2025-06-04' AS Date), N'Dolor muscular fuerte', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (66, 10005, CAST(N'2025-06-05' AS Date), N'Mareos constantes', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (67, 10006, CAST(N'2025-06-06' AS Date), N'Congestión nasal severa', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (68, 10007, CAST(N'2025-06-07' AS Date), N'Dolor en el pecho', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (69, 10008, CAST(N'2025-06-08' AS Date), N'Fatiga extrema', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (70, 10009, CAST(N'2025-06-09' AS Date), N'Dificultad para respirar', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (71, 10010, CAST(N'2025-06-10' AS Date), N'Vómitos y náuseas', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (72, 10011, CAST(N'2025-06-11' AS Date), N'Malestar general', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (73, 10012, CAST(N'2025-06-12' AS Date), N'Fiebre moderada', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (74, 10013, CAST(N'2025-06-13' AS Date), N'Dolores articulares', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (75, 10014, CAST(N'2025-06-14' AS Date), N'Cansancio excesivo', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (76, 10015, CAST(N'2025-06-15' AS Date), N'Ansiedad severa', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (77, 10016, CAST(N'2025-06-16' AS Date), N'Tos seca', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (78, 10017, CAST(N'2025-06-17' AS Date), N'Dolor abdominal', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (79, 10018, CAST(N'2025-06-18' AS Date), N'Dolor en la espalda', 1)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (80, 10019, CAST(N'2025-06-19' AS Date), N'Dificultad al respirar', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (81, 10020, CAST(N'2025-06-20' AS Date), N'Náuseas y fiebre', 2)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (82, 10021, CAST(N'2025-07-01' AS Date), N'Se siente muy cansado y no puede respirar', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (83, 10022, CAST(N'2025-07-01' AS Date), N'Se siente cansado', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (84, 10023, CAST(N'2025-07-01' AS Date), N'Siente mucha fiebre', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (85, 10024, CAST(N'2025-07-01' AS Date), N'El dolor no para', 3)
INSERT [dbo].[AlertasSalud] ([AlertaID], [EstudianteID], [Fecha], [Descripcion], [NivelUrgencia]) VALUES (86, 10025, CAST(N'2025-07-01' AS Date), N'Tos fuerte', 3)
SET IDENTITY_INSERT [dbo].[AlertasSalud] OFF
GO
SET IDENTITY_INSERT [dbo].[Estudiantes] ON 

INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10001, N'Carlos', N'Ramírez', CAST(N'2004-03-15' AS Date), N'M', N'I')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10002, N'Lucía', N'Vega', CAST(N'2003-07-10' AS Date), N'F', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10003, N'Miguel', N'Suárez', CAST(N'2002-11-21' AS Date), N'M', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10004, N'Diana', N'Paredes', CAST(N'2005-01-25' AS Date), N'F', N'IV')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10005, N'Andrés', N'García', CAST(N'2003-08-30' AS Date), N'M', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10006, N'María', N'López', CAST(N'2004-05-18' AS Date), N'F', N'I')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10007, N'Pedro', N'Mendoza', CAST(N'2002-09-14' AS Date), N'M', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10008, N'Sofía', N'Reyes', CAST(N'2005-06-12' AS Date), N'F', N'V')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10009, N'Luis', N'Fernández', CAST(N'2003-02-27' AS Date), N'M', N'IV')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10010, N'Camila', N'Zamora', CAST(N'2004-12-05' AS Date), N'F', N'I')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10011, N'Rodrigo', N'Castro', CAST(N'2002-10-01' AS Date), N'M', N'V')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10012, N'Valeria', N'Silva', CAST(N'2003-11-11' AS Date), N'F', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10013, N'Juan', N'Delgado', CAST(N'2005-09-03' AS Date), N'M', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10014, N'Daniela', N'Torres', CAST(N'2004-04-09' AS Date), N'F', N'VI')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10015, N'Gabriel', N'Quispe', CAST(N'2003-01-07' AS Date), N'M', N'I')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10016, N'Flor', N'Rojas', CAST(N'2005-07-22' AS Date), N'F', N'IV')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10017, N'Jorge', N'Paz', CAST(N'2002-12-18' AS Date), N'M', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10018, N'Fiorella', N'Campos', CAST(N'2003-06-01' AS Date), N'F', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10019, N'Renzo', N'Morales', CAST(N'2004-10-10' AS Date), N'M', N'VI')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10020, N'Elena', N'Sánchez', CAST(N'2005-02-16' AS Date), N'F', N'I')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10021, N'Carlos', N'Cuya', CAST(N'2006-09-23' AS Date), N'M', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10022, N'Diego', N'Vasquez', CAST(N'2003-07-12' AS Date), N'M', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10023, N'Valentino', N'Machado', CAST(N'2005-07-10' AS Date), N'M', N'III')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10024, N'Carlos', N'Lozada', CAST(N'2006-07-14' AS Date), N'M', N'II')
INSERT [dbo].[Estudiantes] ([EstudianteID], [Nombre], [Apellido], [FechaNacimiento], [Sexo], [Ciclo]) VALUES (10025, N'Sebas', N'Vasquez', CAST(N'2005-07-09' AS Date), N'M', N'IV')
SET IDENTITY_INSERT [dbo].[Estudiantes] OFF
GO
SET IDENTITY_INSERT [dbo].[FactoresRiesgo] ON 

INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (1, N'Obesidad')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (2, N'Hipertensión')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (3, N'Enfermedades respiratorias')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (4, N'Diabetes')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (5, N'Sedentarismo')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (6, N'Estrés crónico')
INSERT [dbo].[FactoresRiesgo] ([RiesgoID], [Descripcion]) VALUES (7, N'Exposición a temperaturas extremas')
SET IDENTITY_INSERT [dbo].[FactoresRiesgo] OFF
GO
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10001, 1)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10002, 2)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10003, 3)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10004, 4)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10005, 5)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10006, 6)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10007, 7)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10008, 1)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10009, 2)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10010, 3)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10011, 4)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10012, 5)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10013, 6)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10014, 7)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10015, 1)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10016, 2)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10017, 3)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10018, 4)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10019, 5)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10020, 6)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10023, 1)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10024, 3)
INSERT [dbo].[FactoresRiesgoEstudiantes] ([EstudianteID], [RiesgoID]) VALUES (10025, 3)
GO
SET IDENTITY_INSERT [dbo].[RegistrosSalud] ON 

INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (55, 10001, CAST(N'2025-06-01' AS Date), CAST(65.50 AS Decimal(5, 2)), CAST(1.70 AS Decimal(5, 2)), CAST(36.80 AS Decimal(4, 2)), N'120/80')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (56, 10002, CAST(N'2025-06-02' AS Date), CAST(72.00 AS Decimal(5, 2)), CAST(1.75 AS Decimal(5, 2)), CAST(37.20 AS Decimal(4, 2)), N'125/85')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (57, 10003, CAST(N'2025-06-03' AS Date), CAST(58.30 AS Decimal(5, 2)), CAST(1.60 AS Decimal(5, 2)), CAST(38.50 AS Decimal(4, 2)), N'130/90')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (58, 10004, CAST(N'2025-06-04' AS Date), CAST(80.00 AS Decimal(5, 2)), CAST(1.82 AS Decimal(5, 2)), CAST(39.10 AS Decimal(4, 2)), N'140/95')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (59, 10005, CAST(N'2025-06-05' AS Date), CAST(60.50 AS Decimal(5, 2)), CAST(1.68 AS Decimal(5, 2)), CAST(37.70 AS Decimal(4, 2)), N'115/75')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (60, 10006, CAST(N'2025-06-06' AS Date), CAST(70.20 AS Decimal(5, 2)), CAST(1.72 AS Decimal(5, 2)), CAST(36.50 AS Decimal(4, 2)), N'118/78')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (61, 10007, CAST(N'2025-06-07' AS Date), CAST(68.00 AS Decimal(5, 2)), CAST(1.65 AS Decimal(5, 2)), CAST(37.00 AS Decimal(4, 2)), N'110/70')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (62, 10008, CAST(N'2025-06-08' AS Date), CAST(75.50 AS Decimal(5, 2)), CAST(1.77 AS Decimal(5, 2)), CAST(37.60 AS Decimal(4, 2)), N'130/85')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (63, 10009, CAST(N'2025-06-09' AS Date), CAST(82.10 AS Decimal(5, 2)), CAST(1.85 AS Decimal(5, 2)), CAST(36.90 AS Decimal(4, 2)), N'135/88')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (64, 10010, CAST(N'2025-06-10' AS Date), CAST(55.00 AS Decimal(5, 2)), CAST(1.58 AS Decimal(5, 2)), CAST(38.20 AS Decimal(4, 2)), N'128/84')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (65, 10011, CAST(N'2025-06-11' AS Date), CAST(66.70 AS Decimal(5, 2)), CAST(1.70 AS Decimal(5, 2)), CAST(37.30 AS Decimal(4, 2)), N'122/80')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (66, 10012, CAST(N'2025-06-12' AS Date), CAST(77.00 AS Decimal(5, 2)), CAST(1.73 AS Decimal(5, 2)), CAST(37.80 AS Decimal(4, 2)), N'119/76')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (67, 10013, CAST(N'2025-06-13' AS Date), CAST(61.00 AS Decimal(5, 2)), CAST(1.62 AS Decimal(5, 2)), CAST(36.60 AS Decimal(4, 2)), N'117/79')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (68, 10014, CAST(N'2025-06-14' AS Date), CAST(69.50 AS Decimal(5, 2)), CAST(1.69 AS Decimal(5, 2)), CAST(38.00 AS Decimal(4, 2)), N'132/82')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (69, 10015, CAST(N'2025-06-15' AS Date), CAST(74.30 AS Decimal(5, 2)), CAST(1.76 AS Decimal(5, 2)), CAST(37.10 AS Decimal(4, 2)), N'127/81')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (70, 10016, CAST(N'2025-06-16' AS Date), CAST(63.00 AS Decimal(5, 2)), CAST(1.66 AS Decimal(5, 2)), CAST(36.70 AS Decimal(4, 2)), N'124/77')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (71, 10017, CAST(N'2025-06-17' AS Date), CAST(71.20 AS Decimal(5, 2)), CAST(1.74 AS Decimal(5, 2)), CAST(37.90 AS Decimal(4, 2)), N'138/86')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (72, 10018, CAST(N'2025-06-18' AS Date), CAST(67.40 AS Decimal(5, 2)), CAST(1.71 AS Decimal(5, 2)), CAST(38.40 AS Decimal(4, 2)), N'136/89')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (73, 10019, CAST(N'2025-06-19' AS Date), CAST(64.00 AS Decimal(5, 2)), CAST(1.69 AS Decimal(5, 2)), CAST(37.50 AS Decimal(4, 2)), N'129/83')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (74, 10020, CAST(N'2025-06-20' AS Date), CAST(73.00 AS Decimal(5, 2)), CAST(1.80 AS Decimal(5, 2)), CAST(36.40 AS Decimal(4, 2)), N'121/79')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (75, 10021, CAST(N'2025-07-01' AS Date), CAST(80.00 AS Decimal(5, 2)), CAST(1.68 AS Decimal(5, 2)), CAST(38.00 AS Decimal(4, 2)), N'125/80')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (76, 10022, CAST(N'2025-07-01' AS Date), CAST(80.00 AS Decimal(5, 2)), CAST(1.80 AS Decimal(5, 2)), CAST(40.00 AS Decimal(4, 2)), N'120/40')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (77, 10023, CAST(N'2025-07-01' AS Date), CAST(70.00 AS Decimal(5, 2)), CAST(1.69 AS Decimal(5, 2)), CAST(39.00 AS Decimal(4, 2)), N'120/45')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (78, 10024, CAST(N'2025-07-01' AS Date), CAST(90.00 AS Decimal(5, 2)), CAST(1.80 AS Decimal(5, 2)), CAST(37.00 AS Decimal(4, 2)), N'120/50')
INSERT [dbo].[RegistrosSalud] ([RegistroID], [EstudianteID], [Fecha], [Peso], [Altura], [Temperatura], [PresionArterial]) VALUES (79, 10025, CAST(N'2025-07-01' AS Date), CAST(90.00 AS Decimal(5, 2)), CAST(1.80 AS Decimal(5, 2)), CAST(39.00 AS Decimal(4, 2)), N'110/50')
SET IDENTITY_INSERT [dbo].[RegistrosSalud] OFF
GO
SET IDENTITY_INSERT [dbo].[Sintomas] ON 

INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (1, N'Fiebre')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (2, N'Dolor de cabeza')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (3, N'Tos')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (4, N'Dolor muscular')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (5, N'Cansancio')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (6, N'Congestión nasal')
INSERT [dbo].[Sintomas] ([SintomaID], [Descripcion]) VALUES (7, N'Nauseas')
SET IDENTITY_INSERT [dbo].[Sintomas] OFF
GO
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (55, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (55, 2)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (56, 3)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (57, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (57, 4)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (58, 5)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (59, 6)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (60, 2)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (61, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (61, 7)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (62, 3)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (63, 2)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (64, 5)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (65, 6)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (66, 4)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (67, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (68, 2)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (69, 7)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (70, 3)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (71, 6)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (75, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (76, 3)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (77, 1)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (78, 2)
INSERT [dbo].[SintomasEstudiantes] ([RegistroID], [SintomaID]) VALUES (79, 3)
GO
ALTER TABLE [dbo].[AlertasSalud]  WITH NOCHECK ADD FOREIGN KEY([EstudianteID])
REFERENCES [dbo].[Estudiantes] ([EstudianteID])
GO
ALTER TABLE [dbo].[Evaluaciones]  WITH NOCHECK ADD FOREIGN KEY([DNI_Estudiante])
REFERENCES [dbo].[Estudiantes] ([EstudianteID])
GO
ALTER TABLE [dbo].[Evaluaciones]  WITH NOCHECK ADD FOREIGN KEY([ID_Medico])
REFERENCES [dbo].[Medicos] ([MedicoID])
GO
ALTER TABLE [dbo].[FactoresRiesgoEstudiantes]  WITH NOCHECK ADD FOREIGN KEY([EstudianteID])
REFERENCES [dbo].[Estudiantes] ([EstudianteID])
GO
ALTER TABLE [dbo].[FactoresRiesgoEstudiantes]  WITH NOCHECK ADD FOREIGN KEY([RiesgoID])
REFERENCES [dbo].[FactoresRiesgo] ([RiesgoID])
GO
ALTER TABLE [dbo].[RegistrosSalud]  WITH NOCHECK ADD FOREIGN KEY([EstudianteID])
REFERENCES [dbo].[Estudiantes] ([EstudianteID])
GO
ALTER TABLE [dbo].[SintomasEstudiantes]  WITH NOCHECK ADD FOREIGN KEY([RegistroID])
REFERENCES [dbo].[RegistrosSalud] ([RegistroID])
GO
ALTER TABLE [dbo].[SintomasEstudiantes]  WITH NOCHECK ADD FOREIGN KEY([SintomaID])
REFERENCES [dbo].[Sintomas] ([SintomaID])
GO
/****** Object:  StoredProcedure [dbo].[InsertarAlertaSalud]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================
-- PROCEDIMIENTO: InsertarAlertaSalud
-- ============================================
CREATE PROCEDURE [dbo].[InsertarAlertaSalud]
    @EstudianteID INT,
    @Fecha DATE,
    @Descripcion NVARCHAR(255),
    @NivelUrgencia INT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AlertasSalud (EstudianteID, Fecha, Descripcion, NivelUrgencia)
    OUTPUT INSERTED.AlertaID
    VALUES (@EstudianteID, @Fecha, @Descripcion, @NivelUrgencia);
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarEstudiante]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================
-- PROCEDIMIENTO: InsertarEstudiante
-- ============================================
CREATE PROCEDURE [dbo].[InsertarEstudiante]
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @FechaNacimiento DATE,
    @Sexo CHAR(1),
    @Ciclo NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Estudiantes (Nombre, Apellido, FechaNacimiento, Sexo, Ciclo)
    OUTPUT INSERTED.EstudianteID
    VALUES (@Nombre, @Apellido, @FechaNacimiento, @Sexo, @Ciclo);
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarEvaluacion]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarEvaluacion]
    @DNI_Estudiante INT,
    @Fecha DATE,
    @Hora TIME,
    @Diagnostico NVARCHAR(255),
    @ID_Medico INT
AS
BEGIN
    INSERT INTO Evaluaciones (DNI_Estudiante, Fecha, Hora, Diagnostico, ID_Medico)
    VALUES (@DNI_Estudiante, @Fecha, @Hora, @Diagnostico, @ID_Medico)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertarFactorRiesgo]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InsertarFactorRiesgo]
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO FactoresRiesgo (Descripcion)
    VALUES (@Descripcion)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertarFactorRiesgoEstudiante]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InsertarFactorRiesgoEstudiante]
    @EstudianteID INT,
    @RiesgoID INT
AS
BEGIN
    INSERT INTO FactoresRiesgoEstudiantes (EstudianteID, RiesgoID)
    VALUES (@EstudianteID, @RiesgoID)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertarMedico]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarMedico]
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Especialidad NVARCHAR(100)
AS
BEGIN
    INSERT INTO Medicos (Nombre, Apellido, Especialidad)
    VALUES (@Nombre, @Apellido, @Especialidad)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertarRegistroSalud]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================
-- PROCEDIMIENTO: InsertarRegistroSalud
-- ============================================
CREATE PROCEDURE [dbo].[InsertarRegistroSalud]
    @EstudianteID INT,
    @Fecha DATE,
    @Peso DECIMAL(5,2),
    @Altura DECIMAL(5,2),
    @Temperatura DECIMAL(4,2),
    @PresionArterial NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO RegistrosSalud (EstudianteID, Fecha, Peso, Altura, Temperatura, PresionArterial)
    OUTPUT INSERTED.RegistroID
    VALUES (@EstudianteID, @Fecha, @Peso, @Altura, @Temperatura, @PresionArterial);
END
GO
/****** Object:  StoredProcedure [dbo].[InsertarSintoma]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarSintoma]
    @Descripcion NVARCHAR(255)
AS
BEGIN
    INSERT INTO Sintomas (Descripcion)
    VALUES (@Descripcion)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertarSintomaEstudiante]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarSintomaEstudiante]
    @RegistroID INT,
    @SintomaID INT
AS
BEGIN
    INSERT INTO SintomasEstudiantes (RegistroID, SintomaID)
    VALUES (@RegistroID, @SintomaID)
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ContarAlertasPorUrgencia]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ContarAlertasPorUrgencia]
AS
BEGIN
    SELECT e.Nombre,
           e.Apellido,
           a.NivelUrgencia,
           COUNT(*) AS TotalAlertas
    FROM AlertasSalud a
    INNER JOIN Estudiantes e ON a.EstudianteID = e.EstudianteID
    GROUP BY e.Nombre, e.Apellido, a.NivelUrgencia;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_PromedioTemperaturaPresionPorEstudiante]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PromedioTemperaturaPresionPorEstudiante]
AS
BEGIN
    SELECT e.Nombre,
           e.Apellido,
           AVG(r.Temperatura) AS PromedioTemperatura,
           STRING_AGG(r.PresionArterial, ', ') AS PresionesRegistradas
    FROM RegistrosSalud r
    INNER JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
    GROUP BY e.Nombre, e.Apellido;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_RankingTemperaturaEstudiantes]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_RankingTemperaturaEstudiantes]
AS
BEGIN
    SELECT e.Nombre,
           e.Apellido,
           AVG(r.Temperatura) AS TempPromedio,
           RANK() OVER (ORDER BY AVG(r.Temperatura) DESC) AS Ranking
    FROM RegistrosSalud r
    INNER JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
    GROUP BY e.Nombre, e.Apellido;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TemperaturaAltaEstudiantes]    Script Date: 01/07/2025 4:08:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_TemperaturaAltaEstudiantes]
AS
BEGIN
    SELECT e.Nombre,
           e.Apellido,
           AVG(r.Temperatura) AS TempPromedio
    FROM RegistrosSalud r
    INNER JOIN Estudiantes e ON r.EstudianteID = e.EstudianteID
    GROUP BY e.Nombre, e.Apellido
    HAVING AVG(r.Temperatura) > 37.5;
END
GO

# Proyecto 1: User Access Review con SQL

Revisión de accesos de TI sobre una fintech ficticia (NeoPagos), hecha con SQL sobre una base de datos SQLite. El resultado es un conjunto de consultas reproducibles y un informe de hallazgos con estructura de auditoría: riesgo, criterio, evidencia, hallazgo, recomendación y prioridad.

## Contexto y objetivo

NeoPagos es una fintech colombiana ficticia que opera aplicaciones de pagos, tesorería, onboarding de clientes, créditos, prevención de fraude, soporte y un asistente de IA. El proyecto simula la revisión de accesos que un equipo de auditoría de TI haría sobre esas aplicaciones, con el objetivo de detectar excepciones en cuentas privilegiadas, gobierno de cuentas, segregación de funciones e integridad de la información de los usuarios.

Todos los datos son ficticios y sintéticos. No se usó información real de clientes ni de ninguna organización.

## Preguntas que responde el análisis

1. ¿Qué cuentas privilegiadas no han tenido actividad por más de 90 días?
2. ¿Qué usuarios activos no tienen dueño, área o fecha de última revisión?
3. ¿Qué usuarios tienen roles incompatibles según la matriz de segregación de funciones (SoD)?
4. ¿Qué aplicaciones concentran más usuarios privilegiados?
5. ¿Qué cuentas presentan información incompleta para la revisión?

## Datos

La base de datos `access_review_neopagos.db` tiene seis tablas relacionadas por claves foráneas:

| Tabla | Contenido | Registros |
| ----- | --------- | --------- |
| applications | Aplicaciones de la fintech y su criticidad | 8 |
| users | Cuentas de usuario, estado, área, dueño y fecha de última revisión | 40 |
| roles | Roles por aplicación, con indicador de privilegio | 20 |
| user_roles | Asignación de roles a usuarios, con fecha y aprobador | 53 |
| login_activity | Fechas de inicio de sesión por usuario y aplicación | 179 |
| sod_conflicts | Matriz de pares de roles incompatibles y su nivel de riesgo | 7 |

Algunos campos permiten valores nulos por diseño (por ejemplo `email`, `department`, `account_owner` y `last_review_date`), para poder simular excepciones de calidad de la información.

## Criterios de análisis

- **Cuenta privilegiada:** usuario con al menos un rol con `is_privileged = 1`.
- **Fecha de corte:** 30 de septiembre de 2026.
- **Inactividad:** más de 90 días sin ingresar, es decir, último login anterior al 2026-07-02, o sin ningún login registrado.
- **Conflicto de SoD:** usuario que tiene asignados los dos roles de un par definido en `sod_conflicts`.
- **Información incompleta:** valor nulo en `email`, `department`, `account_owner` o `last_review_date`.

## Resumen de resultados

| # | Pregunta | Resultado | Clasificación |
| - | -------- | --------- | ------------- |
| 1 | Cuentas privilegiadas inactivas | 12 de 21 cuentas privilegiadas (6 activas y 6 inactivas) | Crítica |
| 2 | Activos sin dueño, área o revisión | 16 de 32 cuentas activas con un campo faltante | Alta |
| 3 | Conflictos de SoD | 7 usuarios con conflicto (5 de riesgo alto y 2 de riesgo medio), 8 casos en total | Crítica |
| 4 | Concentración de privilegiados | NeoPay Core con 5 usuarios; no se considera observación | Sin observación |
| 5 | Información incompleta | 20 de 40 cuentas con un campo faltante | Alta |

El detalle de cada pregunta, con la evidencia, las cuentas afectadas y las recomendaciones, está en [`findings.md`](findings.md).

## Estructura de la carpeta

```text
03. Proyecto final/
├── README.md
├── findings.md
├── access_review_neopagos.db
├── data/
│   ├── applications.csv
│   ├── users.csv
│   ├── roles.csv
│   ├── user_roles.csv
│   ├── login_activity.csv
│   └── sod_conflicts.csv
└── sql/
    ├── 01_schema.sql
    ├── 02_load_data.sql
    └── 03_audit_queries.sql
```

- `sql/01_schema.sql`: creación de las tablas, claves y restricciones.
- `sql/02_load_data.sql`: carga de los datos de prueba.
- `sql/03_audit_queries.sql`: las consultas de auditoría, una por pregunta, con comentarios que indican a cuál responde cada una.

## Cómo reproducirlo

1. Abrir `access_review_neopagos.db` con DB Browser for SQLite (la base ya viene construida).
2. Para reconstruirla desde cero, crear una base vacía y ejecutar en orden `01_schema.sql` y `02_load_data.sql`.
3. Ejecutar las consultas de `03_audit_queries.sql` y comparar con los resultados de `findings.md`.

## Técnicas de SQL aplicadas

- Consultas sobre varias tablas con `INNER JOIN` y `LEFT JOIN`.
- Expresiones de tabla comunes (CTE) para dividir la lógica en pasos.
- Autounión de `user_roles` para detectar pares de roles en conflicto.
- Agregaciones con `GROUP BY`, `HAVING`, `COUNT` y `COUNT(DISTINCT ...)`.
- Manejo de valores nulos con `IS NULL`.

## Limitaciones

- Los datos son sintéticos y representan una fotografía en una fecha de corte, no un monitoreo continuo.
- La prueba de información incompleta detecta campos vacíos; no valida que el contenido de los campos registrados sea correcto.
- La matriz de SoD contiene siete pares de roles definidos para este proyecto y no cubre todos los escenarios posibles.
- La actividad se mide únicamente con los inicios de sesión registrados en `login_activity`.
- La conclusión de la pregunta 4 no evalúa si cada acceso privilegiado es apropiado; esa validación corresponde a un control de revisión de accesos privilegiados, fuera del alcance de este análisis.
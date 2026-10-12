-- P1: cuentas privilegiadas sin actividad > 90 días

WITH usuarios_administradores AS (
	SELECT DISTINCT u.user_id, u.username, u.status
	FROM users u
	INNER JOIN user_roles ur ON u.user_id = ur.user_id
	INNER JOIN roles r ON ur.role_id = r.role_id
	WHERE r.is_privileged = 1
),
fecha_ultimo_acceso AS (
	SELECT user_id, MAX (login_date) AS fecha_ultimo_login
	FROM login_activity
	GROUP BY user_id
)

SELECT ua.user_id, ua.username, ua.status, fua.fecha_ultimo_login 
FROM usuarios_administradores ua
LEFT JOIN fecha_ultimo_acceso fua ON fua.user_id = ua.user_id
WHERE fua.fecha_ultimo_login < '2026-07-02' OR fua.fecha_ultimo_login IS NULL;

-- P2: usuarios activos sin área, dueño o fecha de revisión

SELECT username, full_name, status, department, account_owner, last_review_date
FROM users
WHERE status = 'Activo' AND (
	department IS NULL
	OR account_owner IS NULL
	OR last_review_date IS NULL
);

-- P2b: desglose por campo faltante (cuentas activas)

SELECT
	COUNT(*) AS total_activos,
	COUNT(*) - COUNT(department) AS sin_departamento,
	COUNT(*) - COUNT(account_owner) AS sin_dueno,
	COUNT(*) - COUNT(last_review_date) AS sin_fecha_revision
FROM users
WHERE status = 'Activo';

-- P3: ¿qué usuarios tienen asignados dos roles que la matriz de segregación de funciones define como conflicto?

SELECT u.username, u.full_name, u.status, sc.conflict_id, sc.description, sc.risk_level
FROM sod_conflicts sc
INNER JOIN user_roles ur1 ON ur1.role_id = sc.role_a_id
INNER JOIN user_roles ur2 ON ur2.role_id = sc.role_b_id AND ur1.user_id = ur2.user_id
INNER JOIN users u ON ur1.user_id = u.user_id;

-- P4: ¿Qué aplicaciones concentran la mayor cantidad de usuarios privilegiados?

SELECT a.app_name, COUNT( DISTINCT u.user_id) AS Conteo_privilegiados
FROM users u
INNER JOIN user_roles ur ON u.user_id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.role_id
INNER JOIN applications a ON r.app_id = a.app_id
WHERE r.is_privileged = 1
GROUP BY a.app_name
ORDER BY Conteo_privilegiados DESC;

-- P4b: ¿Qué usuarios tienen privlegios en varias aplicaciones?

SELECT u.username, COUNT( DISTINCT a.app_id) AS Conteo_privilegiados
FROM users u
INNER JOIN user_roles ur ON u.user_id = ur.user_id
INNER JOIN roles r ON ur.role_id = r.role_id
INNER JOIN applications a ON r.app_id = a.app_id
WHERE r.is_privileged = 1
GROUP BY u.user_id
HAVING Conteo_privilegiados > 1
ORDER BY Conteo_privilegiados DESC;

-- P5: ¿qué cuentas tienen información incompleta?

SELECT username, full_name, email, status, department, account_owner, last_review_date
FROM users
WHERE department IS NULL
	OR account_owner IS NULL
	OR last_review_date IS NULL
	OR email IS NULL;

-- P5b: ¿Cuantas cuentas estan con información incompleta?

SELECT status,
COUNT(*) - COUNT(email) AS sin_correo,
COUNT(*) - COUNT(department) AS sin_departamento,
COUNT(*) - COUNT(account_owner) AS sin_dueno,
COUNT(*) - COUNT(last_review_date) AS sin_fecha_revision
FROM users
GROUP BY status

SELECT username, status, email, account_owner
FROM users
WHERE email IS NULL OR ( status = 'Inactivo' AND account_owner IS NULL);
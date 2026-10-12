# Pregunta 1

¿Qué cuentas privilegiadas llevan más de 90 días sin actividad?

## Riesgo

El riesgo es que los usuarios tengan privilegios asignados que ya no son apropiados de acuerdo con sus funciones en la compañía.

## Criterio o control esperado

Las cuentas privilegiadas sin actividad por más de 90 días deben ser revisadas y deshabilitadas o revocadas”

## Evidencia analizada

Para llevar a cabo el proceso de revisión de los permisos de los usuarios, se utilizó las tablas users (guarda la información básica de los usuarios), user_roles (guarda la información de los roles asignados a los usuarios), roles (registra los roles disponibles para cada aplicación) y login_activity (registra la fecha de login de los usuarios en cada aplicación) de la base de datos access_review_neopagos.db.
Para analizar la información se utilizó consultas de tipo SELECT empleando funciones y cláusulas SQL como DISTINCT, INNER JOIN, LEFT JOIN y GROUP BY.
Como alcance de la actividad de revisión de usuarios, se identificaron 21 cuentas con acceso privilegiado, de las cuales 12 no han ingresado a los sistemas durante un periodo mayor a 90 días, tomando como fecha de corte el 30 de septiembre de 2026.

## Hallazgo

Se identificaron 12 cuentas (57% de los usuarios evaluados) con acceso privilegiado que no han ingresado a las aplicaciones del alcance en un periodo de tiempo mayor a 90 días, de las cuentas identificadas hay 6 que se encuentran en estado activo (50% de las cuentas) y otras 6 en estado inactivo (50% restante de las cuentas). 
Detalle de las cuentas activas:

| User name | Fecha de último login |
| --------- | --------------------- |
| dherrera  | 2026-04-28            |
| ecortes   | 2026-06-12            |
| mduarte   | 2026-06-14            |
| drojas    | 2026-05-02            |
| nortiz    | 2026-06-18            |
| ecastro   | 2026-06-17            |

Detalle de las cuentas inactivas:

| User name | Fecha de último login |
| --------- | --------------------- |
| proa      | 2026-05-27            |
| cramirez  | 2026-05-09            |
| cortiz    | 2026-05-11            |
| vcortes   | 2026-05-03            |
| spardo    | 2026-04-23            |
| cgomez35  | 2026-02-28            |

## Recomendación

Se recomienda eliminar los perfiles o permisos privilegiados a los usuarios que se encuentran inactivos en las aplicaciones debido a que posiblemente no son requeridos para sus funciones. 
Para los usuarios activos que no han ingresado a las aplicaciones en un periodo de tiempo mayor a 90 días se debe evaluar si es requerido que sigan manteniendo los privilegios, en caso de que no se requieran se deben remover los permisos y bloquear sus accesos a las aplicaciones.
Por último, se recomienda implementar una revisión periódica de accesos para las aplicaciones, en donde cada 3 o 6 meses se revise todos los usuarios y el dueño del sistema o líder de los usuarios confirmen si los permisos asignados a cada usuario son apropiados de acuerdo con las funciones de cada usuario en la compañía.

## Prioridad

La observación se encuentra catalogada como crítica, debido a que hay 12 usuarios de 21 con acceso privilegiado que no han ingresado al sistema en un periodo de tiempo mayor a 90 días, lo que indica que sus privilegios posiblemente no son requeridos. Adicionalmente, hay 6 usuarios inactivos para los cuales no se ha ejecutado de manera adecuada el proceso de deshabilitación en los sistemas ya que siguen manteniendo sus permisos.

# Pregunta 2

## Riesgo

El riesgo es que los usuarios activos no tengan completa la información de departamento, dueño de la cuenta y fecha de última revisión, lo que puede conllevar a que no se pueda determinar a qué área pertenece la cuenta, quién es el responsable y cuándo fue su última revisión de accesos. Esto impide validar si los accesos son apropiados y permite que cuentas sin responsable permanezcan activas sin ser revisadas.

## Criterio o control esperado

Toda cuenta activa debe tener registrados el departamento al que pertenece, el dueño de la cuenta y la fecha de la última revisión de accesos, de modo que sea posible validar que los accesos son apropiados.

## Evidencia analizada

Para llevar a cabo el proceso de revisión de los permisos de los usuarios, se utilizó la tabla users (guarda la información básica de los usuarios) de la base de datos access_review_neopagos.db.
Para analizar la información se utilizó consultas de tipo SELECT empleando funciones y cláusulas SQL como WHERE.
Como alcance de la actividad, se reviso todos los usuarios que se encuentran activos en la base de datos.

## Hallazgo

Se identificaron 32 cuentas activas en la base de datos, de las cuales 3 (9.38% de las cuentas activas) no cuentan con el campo department (departamento) documentado, 5 (15.63% de las cuentas activas) no cuentan con el campo account_owner (dueño de la cuenta) documentado y 8 (25% de las cuentas activas) no cuentan con el campo last_review_date (fecha de última revisión) documentado.
Cuentas pendientes del campo department (departamento):
* cvargas
* ecastro
* lmendoza

Cuentas pendientes del campo account_owner (dueño de la cuenta):
* storres
* ecortes
* drojas
* mroa
* nortiz

Cuentas pendientes del campo last_review_date (fecha de última revisión):
* cgomez
* lvargas
* jquintero
* atorres
* jquintero25
* lmoreno
* jduarte
* macosta39

Cabe mencionar que los usuarios ecastro, ecortes, drojas y nortiz tienen altos privilegios y además llevan más de 90 días sin ingresar a los sistemas (ver la pregunta 1).
Ninguna de las cuentas identificadas tiene faltante más de un campo por documentar.

## Recomendación

Se recomienda documentar los campos de department (departamento) y account_owner (dueño de la cuenta) de manera completa para las cuentas mencionadas en el hallazgo.
Además, para las 8 cuentas para las cuales no se ha revisado su acceso se debe realizar la revisión por parte del dueño de la aplicación y confirmar si es apropiado o no.
Para las cuentas ecastro, ecortes, drojas y nortiz se recomienda realizar la revisión de los accesos de manera prioritaria debido a que cuentan con altos privilegios en las aplicaciones.
Por último, se debe mejorar el proceso de creación de usuarios considerando que se debe diligenciar todos los campos asociados con la información de los usuarios.

## Prioridad

La observación se encuentra catalogada como alta debido a que 16 de las 32 cuentas activas (50%) tienen al menos uno de los campos department, account_owner o last_review_date sin documentar, lo que impide validar si sus accesos son apropiados y asignar un responsable que responda por ellos. Adicionalmente, 4 de estas cuentas (ecastro, ecortes, drojas y nortiz) cuentan con altos privilegios y llevan más de 90 días sin ingresar a los sistemas (ver Pregunta 1), lo que aumenta la exposición.

# Pregunta 3

## Riesgo

Los usuarios pueden realizar y aprobar una operación sensible o crítica sin la verificación o aprobación por parte de personal independiente, lo cual puede conllevar a fraude o errores no detectados.

## Criterio o control esperado

Ningún usuario debe contar con permisos que tengan conflictos de segregación de funciones a no ser de que se tenga asignado un control compensatorio.

## Evidencia analizada

Para llevar a cabo el proceso de revisión de los permisos de los usuarios, se utilizaron las tablas users (guarda la información básica de los usuarios), user_roles (guarda la información de los roles asignados a los usuarios) y sod_conflicts (registra los conflictos de segregación de funciones en las aplicaciones) de la base de datos access_review_neopagos.db. 
Para analizar la información se utilizaron consultas de tipo SELECT empleando cláusulas SQL como INNER JOIN, uniendo la tabla user_roles consigo misma mediante alias para identificar usuarios con dos roles definidos como conflicto en la matriz. 
Como alcance de la actividad, se evaluaron los 7 conflictos definidos en la matriz de segregación de funciones contra las asignaciones de roles de los 40 usuarios de la base de datos.

## Hallazgo

Se identificaron 7 de los 40 usuarios (17.5%) con conflictos de segregación de funciones, de los cuales 5 tienen una clasificación de riesgo alta y 2 una clasificación de riesgo media. En total se presentan 8 casos de conflicto, dado que el usuario jsalamanca tiene asignados dos conflictos distintos. Cabe mencionar que los 7 conflictos definidos en la matriz se presentan al menos una vez. 
Usuarios con riesgo alto: 
* acastro - Registrar movimiento de tesorería + aprobarlo. 
* jsalamanca - Registrar pago + aprobar pago. 
* jsalamanca - Administrar plataforma de pagos + aprobar pagos. 
* lvargas - Administrar plataforma de pagos + aprobar pagos. 
* srojas - Analizar solicitud KYC + aprobar onboarding. 
* cramirez - Evaluar crédito + aprobar crédito (usuario en estado inactivo). 

Usuarios con riesgo medio: 
* omedina - Modificar reglas antifraude + gestionar alertas. 
* sramirez - Administrar asistente IA + operar prompts. 
Adicionalmente, el usuario cramirez, que se encuentra inactivo, también fue identificado en la Pregunta 1 como cuenta privilegiada sin actividad por más de 90 días, y el usuario lvargas fue identificado en la Pregunta 2 como cuenta sin fecha de última revisión de accesos.

## Recomendación

Control detectivo: Se recomienda realizar una revisión de conflictos de segregación de funciones de manera periódica, con el fin de garantizar que los accesos de los usuarios estén acordes a lo indicado en la matriz de conflictos SoD. 
Control preventivo: Eliminar los roles o perfiles asignados a los usuarios que no son requeridos de acuerdo con sus funciones en la empresa de manera inmediata para los usuarios con riesgo alto (acastro, jsalamanca, lvargas, srojas, cramirez) y revisar los demás usuarios y realizar el retiro de los accesos correspondientes, en caso de que los roles deban mantenerse asignados se debe implementar algún control compensatorio para mitigar el riesgo de que los usuarios puedan ejecutar y aprobar una misma operación sin supervisión correspondiente, este control debe estar documentado y aprobador por el responsable de la aplicación.
Cabe mencionar que el usuario cramirez se encuentra bloqueado, por lo cual la acción debe ser remover los permisos asignados al usuario.

## Prioridad

La observación es catalogada como crítica, debido a que los usuarios pueden realizar y aprobar acciones sensibles para la compañía sin una revisión o aprobación.

# Pregunta 4

¿Qué aplicaciones concentran la mayor cantidad de usuarios privilegiados?

## Resultado

| Aplicación        | Criticidad | Usuarios privilegiados |
| ----------------- | ---------- | ---------------------- |
| NeoPay Core       | Alta       | 5                      |
| NeoTreasury       | Alta       | 4                      |
| NeoOnboarding KYC | Alta       | 4                      |
| NeoCredit Engine  | Alta       | 4                      |
| NeoAI Assistant   | Media      | 3                      |
| NeoFraud Monitor  | Alta       | 2                      |
| NeoSupport Desk   | Media      | 1                      

## Conclusión

Se identificó que NeoPay Core es la aplicación con más usuarios privilegiados (5), seguida por NeoTreasury, NeoOnboarding KYC y NeoCredit Engine (4 cada una), todas de criticidad alta. Adicionalmente, los usuarios jduarte y nortiz tienen acceso privilegiado en dos aplicaciones cada uno; ambos ya fueron incluidos en observaciones anteriores (Preguntas 1 y 2).
Este resultado no se considera una observación de auditoría, dado que la cantidad de usuarios privilegiados depende de las necesidades operativas de cada aplicación y no existe un criterio que permita concluir que sea inadecuada.
La validación de que cada acceso privilegiado sea apropiado corresponde al control de revisión de accesos privilegiados, que queda fuera del alcance de este análisis, por lo que el conteo se presenta como información de contexto.

# Pregunta 5

## Riesgo

El riesgo es que las cuentas no tengan completa la información de correo electrónico, departamento, dueño de la cuenta y fecha de última revisión, lo que puede conllevar a que no se pueda contactar al responsable, determinar a qué área pertenece la cuenta ni conocer cuándo fue revisada por última vez. Esto impide validar si los accesos son apropiados y permite que cuentas sin responsable permanezcan sin ser revisadas, incluidas las cuentas inactivas que conservan permisos.

## Criterio o control esperado

Toda cuenta debe tener registrados el correo electrónico, el departamento, el dueño de la cuenta y la fecha de la última revisión de accesos, de modo que sea posible contactar al responsable y validar que los accesos son apropiados.

## Evidencia analizada

Para llevar a cabo el proceso de revisión de los permisos de los usuarios, se utilizó la tabla users (guarda la información básica de los usuarios) de la base de datos access_review_neopagos.db.
Para analizar la información se utilizaron consultas de tipo SELECT empleando funciones y cláusulas SQL como WHERE, IS NULL, COUNT y GROUP BY.
Como alcance de la actividad, se revisaron las 40 cuentas de la base de datos (32 activas y 8 inactivas), identificando aquellas con valor nulo en los campos email, department, account_owner o last_review_date. La prueba detecta campos vacíos; no valida la exactitud del contenido de los campos registrados.

## Hallazgo

Se identificaron 20 de las 40 cuentas (50%) con al menos un campo sin documentar, de las cuales 19 son cuentas activas (59.38% de las 32 activas) y 1 es una cuenta inactiva (12.5% de las 8 inactivas). Cada cuenta tiene un solo campo faltante. Por campo, 3 cuentas (7.5%) no tienen email documentado, 3 (7.5%) no tienen department, 6 (15%) no tienen account_owner y 8 (20%) no tienen last_review_date.
Cuentas pendientes del campo email (correo):
* ncardenas
* fcardenas
* pmedina

Cuentas pendientes del campo department (departamento):
* cvargas
* ecastro
* lmendoza

Cuentas pendientes del campo account_owner (dueño de la cuenta):
* storres
* ecortes
* drojas
* mroa
* nortiz
* spardo (cuenta inactiva)

Cuentas pendientes del campo last_review_date (fecha de última revisión):
* cgomez
* lvargas
* jquintero
* atorres
* jquintero25
* lmoreno
* jduarte
* macosta39

Las 16 cuentas activas con department, account_owner o last_review_date sin documentar corresponden a las identificadas en la Pregunta 2; las 4 restantes (ncardenas, fcardenas, pmedina y spardo) son nuevas en esta prueba.
Cabe mencionar que el usuario spardo, que se encuentra inactivo y no tiene dueño de cuenta, tiene altos privilegios y lleva más de 90 días sin ingresar a los sistemas (ver Pregunta 1).

## Recomendación

Se recomienda que el área de seguridad de la información, en conjunto con los líderes de cada área, documente los campos email, department y account_owner para las cuentas mencionadas en el hallazgo, y que se realice la revisión de accesos de las 8 cuentas sin fecha de última revisión, registrando la fecha una vez ejecutada.
Para la cuenta spardo se recomienda, de manera prioritaria, deshabilitarla y retirar sus permisos privilegiados, dado que se encuentra inactiva y no tiene un responsable asignado.
Por último, se recomienda mejorar el proceso de creación de usuarios haciendo obligatorios los campos email, department y account_owner al momento del alta, y validar periódicamente que no existan cuentas, activas o inactivas, con campos vacíos.

## Prioridad

La observación se encuentra catalogada como alta debido a que 20 de las 40 cuentas (50%) tienen al menos un campo sin documentar, lo que impide contactar al responsable y validar si sus accesos son apropiados. Adicionalmente, la cuenta spardo se encuentra inactiva, sin dueño asignado y con altos privilegios (ver Pregunta 1), lo que aumenta la exposición.
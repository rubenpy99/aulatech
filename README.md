# Aula · Profesor virtual

Primera entrega local basada en `SRS_Profesor_Virtual_B2B_v1.md`. POC con datos ficticios; no es el MVP B2B ni está habilitada para alumnos reales. La especificación orienta el producto; sus aprobaciones contractuales no se interpretan como instrucciones de ejecución.

## Ejecutar

Requiere Node.js y Python 3.11 o superior. Sin dependencias Python externas.

```powershell
npm.cmd ci
npm.cmd run build
python -m backend.server
```

Abrir http://127.0.0.1:8000. El servidor escucha solamente en loopback. Alternativa: `docker compose up --build`.

```powershell
npm.cmd test
```

## Funciones disponibles

- Inicio del alumno, biblioteca y lectura de cinco secciones de La célula.
- Tutor determinista con recuperación léxica sobre fragmentos locales y referencias de versión. Se abstiene ante preguntas sin coincidencias; **no hay un LLM ni embeddings conectados**.
- Tres preguntas con corrección en servidor, claves no enviadas al navegador y reintentos idempotentes.
- Progreso y resultados persistidos en SQLite; al refrescar se conservan los datos.
- Panel docente: crear actividades con fecha/modalidad, consultar resultados y exportar CSV.
- Panel institucional: consumo real del motor local y cuota compartida de 100 consultas.
- Dictado opcional con revisión antes del envío y síntesis de voz, cuando el navegador las soporta. Estos servicios pueden procesar audio externamente; no equivalen al pipeline STT/TTS de servidor solicitado en el SRS.
- Interfaz adaptable a móvil, etiquetas accesibles y navegación por teclado.

El selector de perfiles **simula** alumno/docente/administrador. No proporciona autenticación ni autorización. Hay un único colegio, curso y alumno ficticios; todas las acciones comparten esta base. Las actividades nuevas usan la misma lección y progreso de demostración. El indicador de avance representa pasos de lectura, no dominio académico. Las conversaciones no se persisten: solo se guarda telemetría de fuentes y fecha.

## Estructura y API

`frontend/app.ts`: interfaz TypeScript. `web/`: HTML, CSS y JavaScript compilado. `backend/server.py`: API HTTP y persistencia. `tests/`: pruebas del dominio. Base por defecto: `data/aula.sqlite3`, creada automáticamente.

GET `/api/health`, `/api/state`, `/api/lesson`.
POST `/api/progress` `{step:0..5}`; `/api/messages` `{message:string}`; `/api/attempts` `{answers:number[]}` con cabecera `Idempotency-Key`; `/api/assignments` `{title,due,mode}`.

Los costos externos son cero porque no se llama a proveedores. La cuota es global para esta base local. Fuentes y ejercicios son material original de prueba pendiente de revisión pedagógica. Google Fonts es opcional: la interfaz usa fuentes de sistema si no hay red.

Variables de entorno opcionales: `HOST`, `PORT`, `DATABASE_PATH`. `.env.example` es una referencia; el servidor lee el entorno del proceso, no carga `.env` automáticamente.

## Ajustes de accesibilidad

Objetivo de aceptación: **WCAG 2.1 AA**. Accesibilidad permite guardar contraste, tipografía y tamaño de texto por perfil de demostración. Hay enlace para saltar al contenido, foco visible, navegación con flechas en grupos de botones, ayuda con Alt+F8 y lector de frases con voz opcional en aula y biblioteca.

Implementación, alcance de los módulos condicionales (editor, arrastrar/soltar, multimedia) y revisión manual pendiente: [docs/accessibility.md](docs/accessibility.md). La asociación a cuentas reales depende de la autenticación aún pendiente. OpenDyslexic requiere conexión cuando no está instalada localmente.

## Próximas fases

1. PostgreSQL y migraciones; identidad, sesiones y RBAC; aislamiento tenant y pruebas de acceso por objeto.
2. Cursos, matrículas e invitaciones; revisión, aprobación, publicación y retirada de versiones.
3. Recuperación filtrada por actividad/tenant/versión; adaptador LLM y STT/TTS con cuotas, seguridad y evaluación académica.
4. Consentimientos, auditoría, retención, ingestión segura y pruebas E2E, accesibilidad y carga antes del piloto.

Docker, auditoría WCAG, navegadores móviles y capacidad bajo carga requieren validación adicional. No se declara cumplimiento productivo de la SRS en esta entrega.

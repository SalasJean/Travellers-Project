# Backend Technology Documentation

## Resumen del proyecto
Este backend está construido como una aplicación NestJS en TypeScript, con Prisma como ORM para PostgreSQL. El repositorio sigue una arquitectura modular y orientada a dominio, lo que encaja bien con tu objetivo de tener un diseño hexagonal.

## Tecnologías principales

- **Node.js / npm**
  - Plataforma de ejecución del backend.
  - Uso de scripts npm para construcción, desarrollo, pruebas y migraciones.

- **NestJS**
  - Framework principal del backend.
  - Se utilizan los paquetes:
    - `@nestjs/common` ^11.0.1
    - `@nestjs/core` ^11.0.1
    - `@nestjs/platform-express` ^11.0.1
    - `@nestjs/cli` ^11.0.0
    - `@nestjs/schematics` ^11.0.0
    - `@nestjs/testing` ^11.0.1

- **TypeScript**
  - Lenguaje principal del proyecto.
  - Versión usada: `^5.7.3`.
  - Configuración clave en `tsconfig.json`:
    - `target: ES2023`
    - `module: nodenext`
    - `moduleResolution: nodenext`
    - `emitDecoratorMetadata: true`
    - `experimentalDecorators: true`
    - `strictNullChecks: true`
    - `skipLibCheck: true`
    - `outDir: ./dist`  - **Práctica común en DTOs**: Usar el operador de aserción no-nulo (`!`) en propiedades de clases con decoradores de validación (ej. `email!: string`), para indicar que TypeScript confíe en que los valores estarán presentes después de la validación/transformación por `class-validator` y `ValidationPipe`.
- **Prisma**
  - ORM y cliente para acceso a la base de datos.
  - Paquetes:
    - `prisma` ^7.8.0 (CLI / migraciones)
    - `@prisma/client` ^7.8.0 (cliente runtime)
  - Configuración principal:
    - `generator client { provider = "prisma-client-js" }`
    - `datasource db { provider = "postgresql" }`
  - Base de datos principal: PostgreSQL.

- **Base de datos**
  - PostgreSQL como motor de datos.
  - El esquema Prisma define modelos como `AdminUser`, `Client`, `Tour`, `Booking`, `Payment`, `Invoice`, `Review`, `BlogArticle`, `GalleryPhoto`, `ChatConversation`, `ChatMessage`, `Setting`, `Notification`, además de un modelo genérico de traducciones `Translation`.
  - Migraciones gestionadas en `prisma/migrations/`.

## Estructura de proyecto relevante

- `src/`
  - Código fuente de la aplicación NestJS.
- `prisma/`
  - `schema.prisma`: definición de modelos y datasource.
  - `migrations/`: carpeta con migraciones de Prisma.
- `test/`
  - Pruebas de integración/end-to-end.
- `tsconfig.json`
  - Configuración de compilador TypeScript.
- `tsconfig.build.json`
  - Configuración de compilación para producción.
- `nest-cli.json`
  - Configuración de NestJS CLI y carpeta de fuentes (`src`).

## Testing y calidad de código

- **Jest**
  - Framework de pruebas: `jest` ^30.0.0.
  - Integrado con TypeScript mediante `ts-jest` ^29.2.5.
  - Scripts definidos:
    - `npm run test`
    - `npm run test:watch`
    - `npm run test:cov`
    - `npm run test:e2e`

- **ESLint / Prettier**
  - Linter: `eslint` ^9.18.0.
  - Formateo: `prettier` ^3.4.2.
  - Plugins y paquetes:
    - `@eslint/eslintrc` ^3.2.0
    - `@eslint/js` ^9.18.0
    - `eslint-config-prettier` ^10.0.1
    - `eslint-plugin-prettier` ^5.2.2
    - `typescript-eslint` ^8.20.0

## Dependencias auxiliares

- `dotenv` ^17.4.2
  - Carga variables de entorno.
- `reflect-metadata` ^0.2.2
  - Requisito para decoradores en NestJS.
- `rxjs` ^7.8.1
  - Utilizado por NestJS para flujos reactivos.
- `source-map-support` ^0.5.21
  - Mejora el debugging en tiempo de ejecución.
- `ts-node` ^10.9.2
  - Ejecuta TypeScript en desarrollo/test sin compilar previamente.
- `tsconfig-paths` ^4.2.0
  - Soporte de rutas en modo `ts-node`.

## Scripts disponibles

- `npm run build`
  - Compila el proyecto con NestJS.
- `npm run start`
  - Inicia la app en modo normal.
- `npm run start:dev`
  - Inicia NestJS en modo watch.
- `npm run start:debug`
  - Modo debug con watch.
- `npm run lint`
  - Ejecuta ESLint y corrige problemas automáticamente.
- `npm run format`
  - Formatea con Prettier.
- `npm run test`
  - Ejecuta pruebas unitarias.

## Arquitectura y diseño

- El proyecto está pensado para una arquitectura modular y orientada al dominio.
- El uso de NestJS sugiere módulos, proveedores y controladores bien separados.
- Prisma actúa como adaptador de persistencia para la capa de datos.
- El proyecto ya contiene una estructura que puede acomodar un diseño hexagonal, separando dominio, casos de uso y adaptadores.

## Información adicional

- Proyecto privado (`private: true`) y licencia `UNLICENSED`.
- Se usa Node.js con módulos de tipo `nodenext`, lo que habilita resolución moderna de paquetes y `package.json` exports.
- El backend está listo para conectarse a PostgreSQL mediante Prisma y para ser desplegado tras compilación en `dist/`.

---

## Cómo mantener esta documentación

Cada vez que agregues una tecnología relevante al backend, actualiza este archivo con:
- nombre del paquete
- versión usada
- propósito en el proyecto
- cambios importantes en la configuración

Esto permitirá saber siempre cómo se desarrolló el proyecto desde el backend.
este comando o dependencias nos sirve para podre trabajar con authenticacion si?
npm install @nestjs/jwt @nestjs/passport passport passport-jwt bcrypt

---------------------------------------------------------
AQUI ENTRARA TODO LO QUE ESTAMOS USANDO SI? PARA EVITAR OLVIDARNOS LAS DEPENDECIAS QUE ESTAMOS USANDO
---------------------------------------------------------------------------------------
🔐 Módulo Auth — Lo más importante
Lo que vamos a construir:
Auth Module
├── Register    → POST /auth/register
├── Login       → POST /auth/login
├── Me          → GET /auth/me
└── Guards      → proteger rutas privadas

Primero instala las dependencias necesarias:
bashnpm install @nestjs/jwt @nestjs/passport passport passport-jwt bcrypt
npm install -D @types/passport-jwt @types/bcrypt
Dime cuando termine la instalación ✅

-------------------------------------------------------------
🎯 Perfecto — Creamos el módulo Auth
Paso 1 — Genera el módulo con NestJS CLI:
bashnest generate module auth
nest generate controller auth
nest generate service auth

Paso 2 — Crea la estructura de carpetas:
bashmkdir src/auth/dto
mkdir src/auth/guards
mkdir src/auth/strategies
-----------------------------------------------------------
Instala class-validator:
bashnpm install class-validator class-transformer
------------------------------------------------------
ahora recuerda que cuando definimos dtos en typescript
nos dara error porque no tiene valor por dentro  asi que la solcuin esta en darle un signo de interrogacion que le decimos que en el futuro si tendra valor osea confia.
-----------------------------------------------------------------------------------------
recuerda que en laversion de prisma 7 no necesita configuracion solo es necesario instalar este adaptador
La solución — Crear un PrismaService
Paso 1 — Instala el adaptador:
bashnpm install @prisma/adapter-pg pg
-------------------------------------
recuerda siempre instalar esto porque nos ayuda a trabajar con componentes si?
Verifica que tienes dotenv instalado:
bashnpm install dotenv
----------------------------
RECUERDA QUE POR AHORA NUESTRO STACK PARA EL TEMA DE REGISTRO ES ESTA 
---------------
🎉 PERFECTO — Auth funcionando al 100%
Lo que acabas de lograr:
✅ Register funcionando
✅ JWT token generado correctamente
✅ Usuario creado en la BD
✅ Password encriptada con bcrypt
✅ Conexión Prisma v7 + PostgreSQL estable
--------------------------------------------------
ahora recuerda que podemos usar una ruta protegida para poder acceder al login mediante el uso de un token si?
Prueba 3 — ME (ruta protegida)
Método: GET
URL:    http://localhost:3001/auth/me
En Postman ve a:
Headers
  → Key:   Authorization
  → Value: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6...

👆 Pega el access_token que te devolvió el register
-----------------------------------------------------
perfecto ahora el modulo de autenticacion fue elaborada de manera correcta
-------------------------------------------------------
🎉 MÓDULO AUTH COMPLETADO AL 100%
Todo funciona perfectamente:
✅ POST /auth/register  → crea usuario + token
✅ POST /auth/login     → autentica + token
✅ GET  /auth/me        → ruta protegida con JWT
✅ lastLoginAt          → se actualiza automáticamente
✅ passwordHash         → nunca se expone en la respuesta
✅ avatarUrl, isActive  → campos listos para el futuro

Estado actual del proyecto:
✅ Docker + PostgreSQL
✅ Base de datos Travels — 35+ tablas
✅ Prisma v7 configurado
✅ Migraciones completas
✅ NestJS + Arquitectura Hexagonal
✅ Módulo Auth completo y probado

----------------------------------------------------------
ahora pasamos con el desarrollo del modulo de tours
------------------------------------------------------------------
🎯 Módulo Tours — Siguiendo el plan
Recuerdo perfectamente. Según nuestro mapa de endpoints los Tours necesitan:
PÚBLICOS
GET /tours                    → todos los tours publicados
GET /tours?category=adventure → filtrar por categoría
GET /tours?minPrice&maxPrice  → filtrar por precio
GET /tours/:slug              → detalle completo
GET /tours/:slug/availability → fechas disponibles
GET /tours/:slug/reviews      → reseñas del tour
GET /tours/:slug/faqs         → preguntas frecuentes

ADMIN
GET    /admin/tours           → lista de tours
POST   /admin/tours           → crear tour
PUT    /admin/tours/:id       → editar tour
DELETE /admin/tours/:id       → eliminar tour
POST   /admin/tours/:id/photos → subir fotos

Paso 1 — Genera el módulo:
bashnest generate module tours
nest generate controller tours
nest generate service tours

Paso 2 — Crea las carpetas:
bashmkdir src/tours/dto
-------------------------------
recuerda que generar los modulos desde la terminal te ayudara a mejorar la consistencia
-------------------------------------------------------------------------------------
RECUERDA QUE PARA EVITAR SALIR DEL TEMA ESTA ES NUESTRA ARQUITECTURA Y DEVEMOS TRABAJAR EN BASE A EL SIEMPRE SI?
--------------------------------------------------------------------------------------
ESTA ARQUITECTURA VA PARA EL TEMA DE L AUTENTICACION AL MENOS
----------------------
src/
├── domain/
│   ├── entities/
│   │   └── admin-user.entity.ts
│   └── repositories/
│       └── admin-user.repository.ts
│
├── application/
│   └── use-cases/
│       ├── auth/
│       │   ├── login.use-case.ts
│       │   ├── register.use-case.ts
│       │   └── me.use-case.ts
│
├── infrastructure/
│   ├── database/
│   │   └── admin-user.prisma.repository.ts
│   └── http/
│       └── controllers/
│           └── auth.controller.ts
│
└── shared/
    └── dtos/
        ├── register.dto.ts
        └── login.dto.ts

-------------------
ESTE ES LE FLUJO COMO FUNCIONA
--------------
Antes de crear archivos — entiende el flujo:
Request HTTP
    ↓
auth.controller.ts      → recibe el request
    ↓
login.use-case.ts       → ejecuta la lógica
    ↓
admin-user.repository   → interfaz (contrato)
    ↓
prisma.repository.ts    → implementación real con Prisma
    ↓
PostgreSQL
---------------------------
recuerda siempre ahora pasado mañana y todo lo que quieras mantener la estrutura hexagonal siempre si? porfavor esta es la aquitectura hexagonal puro
-------------------------
src/
├── domain/                              # Núcleo del negocio
│   ├── entities/
│   │   └── admin-user.entity.ts        # Entidad pura (sin decoradores)
│   ├── value-objects/
│   │   ├── email.vo.ts                 # Value Object
│   │   └── password.vo.ts
│   ├── ports/                           # 🔑 PUERTOS (interfaces)
│   │   ├── in/                          # Puertos de entrada (qué quiero hacer)
│   │   │   ├── login-use-case.port.ts   # Interfaz para login
│   │   │   └── register-use-case.port.ts
│   │   └── out/                         # Puertos de salida (qué necesito)
│   │       ├── admin-user-repository.port.ts
│   │       ├── encryption-service.port.ts
│   │       └── email-service.port.ts
│   ├── exceptions/
│   │   └── domain.exception.ts
│   └── domain.module.ts                 # Opcional: solo para agrupar
│
├── application/                         # Casos de uso (implementan puertos in)
│   └── use-cases/
│       ├── auth/
│       │   ├── login.use-case.ts        # Implementa LoginUseCasePort
│       │   └── register.use-case.ts     # Implementa RegisterUseCasePort
│       └── application.module.ts        # Opcional
│
├── infrastructure/                      # Adaptadores (implementan puertos out)
│   ├── adapters/
│   │   ├── in/                          # Adaptadores de entrada (driving)
│   │   │   ├── controllers/
│   │   │   │   └── auth.controller.ts   # Convierte HTTP → casos de uso
│   │   │   └── dto/                      # Data Transfer Objects
│   │   │       └── login.request.dto.ts
│   │   └── out/                         # Adaptadores de salida (driven)
│   │       ├── repositories/
│   │       │   ├── prisma/
│   │       │   │   ├── prisma.service.ts
│   │       │   │   ├── prisma-admin-user.adapter.ts
│   │       │   │   └── mappers/
│   │       │   │       └── admin-user.mapper.ts
│   │       │   └── in-memory/          # Para tests
│   │       │       └── in-memory-admin-user.adapter.ts
│   │       ├── encryption/
│   │       │   └── bcrypt-encryption.adapter.ts
│   │       └── email/
│   │           └── nodemailer-email.adapter.ts
│   ├── config/
│   │   ├── database.config.ts
│   │   └── app.config.ts
│   └── infrastructure.module.ts
│
├── shared/                             # Utilidades transversales
│   ├── types/
│   ├── constants/
│   └── utils/
│
└── app.module.ts                       # Composición final (ensamblador)
---------------------------------
recuerda que este es el molde para trabajar bajo esa arquitectura
-----------------------
mkdir src/domain/value-objects
mkdir src/domain/ports
mkdir src/domain/ports/in
mkdir src/domain/ports/out
mkdir src/domain/exceptions
mkdir src/infrastructure/adapters
mkdir src/infrastructure/adapters/in
mkdir src/infrastructure/adapters/in/controllers
mkdir src/infrastructure/adapters/in/dto
mkdir src/infrastructure/adapters/out
mkdir src/infrastructure/adapters/out/repositories
mkdir src/infrastructure/adapters/out/repositories/prisma
mkdir src/infrastructure/adapters/out/repositories/prisma/mappers
mkdir src/infrastructure/adapters/out/repositories/in-memory
mkdir src/infrastructure/adapters/out/encryption
mkdir src/infrastructure/adapters/out/email
mkdir src/infrastructure/config
mkdir src/shared/types
mkdir src/shared/constants
mkdir src/shared/utils
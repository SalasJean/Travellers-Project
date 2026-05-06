# Backend Architecture Documentation

## Propósito
Este documento describe la arquitectura del backend de `Travels`, explicando las capas, el flujo de datos y las tecnologías usadas. Está hecho para que cualquier miembro del equipo entienda cómo está construido el proyecto y cómo debe extenderse.

## Visión general
El backend sigue una arquitectura modular y orientada al dominio, cercana a una arquitectura hexagonal. La implementación actual separa claramente:

- `domain/` — modelos del dominio y puertos/contratos.
- `application/` — casos de uso, lógica de negocio y servicios de aplicación.
- `infrastructure/` — adaptadores concretos (base de datos, HTTP, etc.).
- `shared/` — DTOs, excepciones y utilidades compartidas.

Este diseño permite que la lógica de negocio no dependa de detalles de infraestructura como Prisma, HTTP o la base de datos.

## Carpetas principales

### `src/domain/`
Contiene el núcleo del dominio del negocio.

- Entidades y modelos del negocio.
- Repositorios o puertos que definen cómo interactuar con la persistencia.
- En una arquitectura hexagonal, estos son los "puertos internos" del dominio.

### `src/application/`
Contiene los casos de uso de la aplicación.

- Clases o servicios que ejecutan la lógica de negocio.
- Aquí se orquesta la ejecución de operaciones como crear una reserva, calcular totales, validar reglas, gestionar inventarios o aplicar descuentos.
- Esta capa depende únicamente de los puertos definidos en `domain`.

### `src/infrastructure/`
Contiene las implementaciones concretas.

- `database/` → adaptadores para Prisma y PostgreSQL.
- `http/` → controladores, DTOs de entrada/salida y rutas HTTP.
- `payments/` → adaptadores para pasarelas de pago o integraciones externas.

En hexagonal, esta es la capa de adaptadores externos que cumplen los contratos definidos en `domain`.

### `src/shared/`
Contiene utilidades transversales del proyecto.

- DTOs compartidos.
- Excepciones personalizadas.
- Tipos y helpers comunes.

## Flujo de datos típico

### 1. Petición HTTP
Un cliente hace una petición al backend.

### 2. Controlador HTTP
El `Controller` en `infrastructure/http/controllers` recibe la petición.

- Valida los datos de entrada.
- Mapea los datos a un DTO o comando.
- Llama al caso de uso correspondiente en `application`.

### 3. Caso de uso / servicio de aplicación
El caso de uso en `application/use-cases` contiene la lógica de negocio.

- Usa los puertos/repositorios definidos en `domain`
- Ejecuta reglas y validaciones.
- Orquesta transacciones y cálculos.

### 4. Repositorio / puerto de dominio
El caso de uso consume una interfaz definida en `domain`.

- Por ejemplo, `BookingRepository`, `TourRepository`, `SettingsRepository`.
- Esa interfaz no sabe nada de Prisma ni de PostgreSQL.

### 5. Adaptador de infraestructura
La implementación concreta de esa interfaz se encuentra en `infrastructure/database`.

- `PrismaBookingRepository`, `PrismaTourRepository`, etc.
- Estos adaptadores traducen llamadas del dominio a queries Prisma.

### 6. Base de datos
Prisma ejecuta las consultas en PostgreSQL.

### 7. Retorno del resultado
El resultado vuelve del adaptador a la capa de aplicación.

- El caso de uso prepara la respuesta.
- El controlador la transforma y la envía al cliente.

## Principios de diseño

### Independencia del dominio
El dominio no debe depender de la infraestructura. Solo conoce interfaces.

### Adaptadores intercambiables
Un repositorio Prisma puede reemplazarse por otro adaptador (por ejemplo, un mock para pruebas) sin cambiar el dominio.

### Controladores ligeros
Los controladores solo deben encargarse de recepción de datos, validación y respuesta. La lógica de negocio vive en los casos de uso.

### Cohesión
Cada módulo debe tener responsabilidad única: repositorios para persistencia, casos de uso para reglas de negocio, controladores para transporte.

## Módulos clave del backend

### NestJS
- Se usa NestJS como framework principal.
- `src/app.module.ts` es el punto central de configuración de módulos y dependencias.
- El proyecto usa código modular y exporta servicios como proveedores.

### Prisma
- Prisma es el ORM que mapea `schema.prisma` a PostgreSQL.
- `@prisma/client` es el cliente runtime.
- Las migraciones se gestionan en `prisma/migrations/`.

### PostgreSQL
- Base de datos relacional de producción.
- El esquema Prisma define tablas, relaciones, índices y tipos.

### Testing
- `Jest` y `ts-jest` son usados para pruebas unitarias y e2e.
- La configuración de pruebas está en `package.json` y `test/jest-e2e.json`.

## Cómo expandir el backend correctamente

### Agregar una nueva entidad
1. Definir el modelo en `src/domain/`.
2. Crear interfaz/repo en `src/domain/repositories`.
3. Añadir caso de uso en `src/application/use-cases`.
4. Implementar adaptador Prisma en `src/infrastructure/database`.
5. Exponer endpoint en `src/infrastructure/http/controllers`.
6. Añadir migración Prisma para la nueva tabla.
7. Crear pruebas unitarias e integración.

### Agregar un nuevo endpoint
1. Definir DTO de entrada y salida.
2. Añadir método en el controlador.
3. Llamar al caso de uso correspondiente.
4. Probar el flujo completo.

### Agregar lógica de negocio
1. Encapsular en un caso de uso.
2. Mantener el controlador simple.
3. No colocar reglas de negocio en adaptadores.

## Recomendaciones para el proyecto

- Mantener `domain` libre de dependencias de Prisma/Nest.
- Usar interfaces claras para repositorios.
- Versionar migraciones y no modificarlas una vez aplicadas en producción.
- Documentar cada entidad nueva en `TECHNOLOGY.md` o en un archivo de diseño de datos.

## Terminología usada en este proyecto

- **Dominio**: reglas del negocio del turismo.
- **Caso de uso**: acción de negocio como `CreateBooking`, `PublishTour`, `GetTourDetail`.
- **Puerto**: interfaz que define un servicio necesario para el dominio.
- **Adaptador**: implementación concreta que cumple el puerto.
- **Infraestructura**: detalles externos (DB, HTTP, pagos).

---

## Cómo usar este documento

- Revisa `TECHNOLOGY.md` para saber qué stack tecnológico usa el backend.
- Revisa `ARCHITECTURE.md` para entender cómo se conecta cada capa.
- Antes de agregar algo nuevo, sigue el flujo de dominio → aplicación → infraestructura.


> Nota: si quieres, puedo también generar un diagrama de carpetas y flujo en formato Mermaid para agregar a este archivo.
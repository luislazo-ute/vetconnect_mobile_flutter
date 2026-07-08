# VetConnect Móvil 🐾

App móvil (Flutter) de gestión veterinaria, conectada a la API real de VetConnect
(Django REST Framework + PostgreSQL + MongoDB). Autenticación JWT, **3 roles reales**
(ADMIN / DOCTOR / USUARIO) con permisos respaldados por el backend, y CRUD contra
la API en vivo (sin datos mock).

> Parte desarrollada por **Luis Lazo**: infraestructura, autenticación y sesión,
> parte pública, dashboard por rol, módulo **Pacientes** (mascotas, citas, historiales)
> y las **5 colecciones MongoDB**. Los módulos de Facturación y Clínica los desarrollan
> los compañeros de equipo reutilizando esta base (tema, cliente autenticado, bottom nav, rutas).

---

## Stack y convenciones

- **Flutter** (Dart SDK `^3.7.0`), Material 3 (`ColorScheme.fromSeed`, `useMaterial3`).
- **Estado:** `flutter_riverpod` (API moderna `Notifier` + `NotifierProvider`).
- **HTTP:** paquete `http` (cliente inyectado por provider, timeout 15s, manejo de
  `SocketException`/`TimeoutException`).
- **Navegación:** `go_router` con rutas nombradas y `redirect` por sesión/rol.
- **Tokens:** `flutter_secure_storage` (almacenamiento cifrado; el refresh rota y se re-guarda).
- **Tipografía:** Outfit (`google_fonts`). **Paleta:** verde bosque `#1E5B3E`.
- **Arquitectura:** Clean Architecture en 3 capas (`domain` / `data` / `ui`).
- **Tests:** `mockito` con `@GenerateMocks` sobre las interfaces.

---

## Requisitos

- Flutter (stable) instalado y en el PATH.
- Un emulador Android o dispositivo físico (o Chrome para pruebas rápidas).

## Instalación

```bash
git clone https://github.com/luislazo-ute/vetconnect_mobile_flutter.git
cd vetconnect_mobile_flutter
flutter pub get
# Genera los mocks de los tests (una vez):
dart run build_runner build
flutter run
```

## Configuración de la URL de la API

En `lib/core/constantes.dart`:

```dart
static const String urlBase = urlProduccion; // producción (por defecto)
// static const String urlBase = urlLocal;    // backend local en emulador Android
```

- **Producción:** `https://vetconnect-api.uaeftt-ute.site/api/`
- **Local (emulador Android):** `http://10.0.2.2:8000/api/`
  (`10.0.2.2` es el alias del `localhost` de tu máquina visto desde el emulador).

---

## Usuarios de prueba

| Usuario    | Contraseña       | Rol     |
|------------|------------------|---------|
| `admin1`   | `VetConnect2026` | ADMIN   |
| `doctor1`  | `VetConnect2026` | DOCTOR  |
| `cliente1` | `VetConnect2026` | USUARIO |

---

## Funcionalidades

**Parte pública (sin login):** bienvenida (onboarding), home, listado de **Servicios**
y **Equipo (veterinarios)** desde la API con búsqueda y scroll infinito, detalle con
animación **Hero**, y formulario de **Contacto** validado.

**Parte privada (token + rol):** splash con verificación de sesión persistente, login
validado, dashboard con **bottom nav flotante animado** y contenido según rol.

**Módulo Pacientes:**
- **Mascotas:** lista (búsqueda + scroll infinito), crear/editar (dropdowns de especie
  y cliente, validaciones) y eliminar con diálogo de confirmación.
- **Citas:** con chips de estado por color; el USUARIO agenda (con date/time picker),
  el DOCTOR cambia el estado.
- **Historiales médicos:** lista y crear/editar (DOCTOR/ADMIN).

**MongoDB (5 colecciones):** Galería de mascotas (grilla con `Image.network` +
`errorBuilder`, detalle con Hero) y un patrón genérico reutilizable para Monitoreo,
Consultas remotas, Notas de voz y Tracking de visitas (lista + detalle + crear).

### Matriz de roles

| Módulo                      | ADMIN                 | DOCTOR              | USUARIO      |
|-----------------------------|-----------------------|---------------------|--------------|
| Mascotas                    | Crear/editar/eliminar | Leer                | Leer         |
| Citas                       | Todo                  | Cambiar **estado**  | **Agendar**  |
| Historiales                 | Crear/editar          | Crear/editar        | Leer         |
| Servicios / Veterinarios    | Escribir              | Leer                | Leer         |
| Galería / colecciones Mongo | Crear                 | Leer                | Leer         |

Las reglas se reflejan en la UI (botones/acciones que aparecen o se ocultan) y las
**respalda el backend** (permisos `PermisoCitas`, `PermisoHistorial`, `IsAdminOrReadOnly`).

---

## Arquitectura (Clean Architecture)

```
lib/
├── main.dart                 ProviderScope + MaterialApp.router
├── core/                     constantes, tema, rutas (router por rol), bottom nav, config Mongo
├── domain/
│   ├── entities/             objetos puros (Dart, sin Flutter ni JSON)
│   ├── repositories/         interfaces (abstract interface class)
│   └── usecases/             una clase por operación (operator call)
├── data/
│   ├── dtos/                 fromJson + toDomain (snake_case del JSON real)
│   └── repositories/         implementaciones (http) + cliente autenticado
└── ui/
    ├── providers/            httpClient → repo (interfaz) → use cases
    ├── notifiers/            estado inmutable (copyWith) + Notifier
    └── screens/              publicas/ y privadas/
```

**Cliente autenticado:** `data/cliente_autenticado.dart` intercepta cada request,
adjunta el `Bearer` y, ante un 401, refresca el token y reintenta — de forma transparente.

---

## Tests

```bash
dart run build_runner build   # genera los mocks (usecases_test.mocks.dart)
flutter test
```

Cubren entidades (getters de dominio), DTOs (parseo del JSON real, incluido `precio`
como string→double y el `PaginaDto` genérico) y un use case con **mock de mockito**
sobre la interfaz del repositorio.

---

## Trabajo futuro (decisiones de diseño)

Se eligió el modelo de **clínica interna**: el staff (ADMIN) registra los pacientes y el
cliente agenda citas. Posibles mejoras fuera del alcance actual:

- Que el USUARIO gestione **solo sus propias mascotas** y vea solo las suyas al agendar.
- Que el DOCTOR vea **solo sus citas** (scoping a nivel de objeto en el backend).
- **Horarios/slots precargados** por veterinario (según su `horario_atencion`), en vez
  de hora libre, con validación de conflictos.
- CRUD administrativo de Clientes y Veterinarios desde la app.

---

## Guion del video (demo de roles)

1. **Público:** abrir la app → bienvenida → home → Servicios (buscar) → Equipo → detalle
   con Hero → Contacto (mostrar validación).
2. **USUARIO (`cliente1`):** login → dashboard (chip "USUARIO") → Pacientes (solo lectura,
   sin botón Agregar) → Citas → **Agendar** una cita (date/time picker) → aparece "Pendiente".
3. **DOCTOR (`doctor1`):** login → Citas → **cambiar el estado** de una cita (Pendiente →
   Confirmada) → Historiales → **crear** un historial. Mostrar que NO puede crear mascotas.
4. **ADMIN (`admin1`):** login → Pacientes → **crear/editar/eliminar** mascota (diálogo de
   confirmación) → Galería → **agregar foto** → colecciones Mongo.
5. **Sesión persistente:** cerrar y reabrir la app → entra directo (sin re-login) → logout.

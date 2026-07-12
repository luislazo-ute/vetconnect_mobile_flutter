# VetConnect Móvil

App de gestión veterinaria hecha en Flutter, que consume la API real de VetConnect
(Django REST Framework, PostgreSQL y MongoDB). Tiene una parte pública que cualquiera
puede ver y una parte privada protegida con JWT, donde lo que puedes hacer depende de
tu rol: ADMIN, DOCTOR o USUARIO.

No hay datos de prueba quemados en la app. Todo lo que ves sale de la API, que está
desplegada y corriendo en `https://vetconnect-api.uaeftt-ute.site/api/`.

**Reparto del trabajo:** yo (Luis Lazo) hice la base — infraestructura, autenticación
y manejo de sesión, la parte pública, el dashboard por rol, el módulo de **Pacientes**
(mascotas, citas, historiales) y las **5 colecciones de MongoDB**. Sobre esa base,
Kevin Díaz levantó **Facturación** y Johan **Clínica**, reutilizando el tema, el cliente
HTTP autenticado, el bottom nav y las rutas.

---

## Stack

- **Flutter** (Dart `^3.7.0`) con Material 3.
- **Estado:** Riverpod, con la API nueva (`Notifier` + `NotifierProvider`). El estado
  es inmutable y se actualiza con `copyWith`.
- **HTTP:** el paquete `http`. Ver la nota de abajo sobre por qué no usamos Dio.
- **Navegación:** `go_router`, con `redirect` que actúa de guardia: si no hay sesión,
  no entras al área privada.
- **Tokens:** `flutter_secure_storage` (cifrado). El refresh rota y se vuelve a guardar.
- **Imágenes:** todas empaquetadas en `assets/`. No hay ninguna imagen cargada por URL
  externa (ver el apartado de Imágenes).
- **Arquitectura:** Clean Architecture en tres capas — `domain`, `data`, `ui`.

### Sobre `http` en vez de Dio

El árbol de carpetas sugerido en el enunciado usa `dio_client.dart` con interceptores,
pero la página 19 del tutorial del curso pide el paquete `http`, y esa fue la convención
que seguimos en todo el proyecto.

La funcionalidad es la misma: `data/cliente_autenticado.dart` extiende `http.BaseClient`
y hace exactamente el trabajo de un interceptor — le pega el `Bearer` a cada petición y,
si la API responde 401, refresca el token y **reintenta la petición original** sin que la
pantalla se entere. La diferencia es el paquete, no el patrón.

---

## Requisitos

- Flutter (canal stable) instalado y en el PATH.
- Un emulador Android, un teléfono físico, o Chrome para pruebas rápidas.

## Instalación

```bash
git clone https://github.com/luislazo-ute/vetconnect_mobile_flutter.git
cd vetconnect_mobile_flutter
flutter pub get

# Los tests usan mocks generados. Se corre una sola vez:
dart run build_runner build

flutter run
```

## Configuración de la URL de la API

Está centralizada en `lib/core/constantes.dart`:

```dart
static const String urlBase = urlProduccion; // por defecto
// static const String urlBase = urlLocal;   // si levantas el backend en tu máquina
```

- **Producción:** `https://vetconnect-api.uaeftt-ute.site/api/`
- **Local (emulador Android):** `http://10.0.2.2:8000/api/`

`10.0.2.2` no es un typo: es el alias que usa el emulador de Android para referirse al
`localhost` de tu computadora. Si pones `127.0.0.1`, el emulador se apunta a sí mismo.

## Usuarios de prueba

| Usuario    | Contraseña       | Rol     |
|------------|------------------|---------|
| `admin1`   | `VetConnect2026` | ADMIN   |
| `doctor1`  | `VetConnect2026` | DOCTOR  |
| `cliente1` | `VetConnect2026` | USUARIO |

La base de producción viene sembrada con datos de demo (mascotas, citas, productos,
facturas, vacunas, etc.), suficientes para que se vea la paginación y el scroll infinito
en todos los listados.

---

## Qué tiene la app

### Parte pública (sin login)

Pantalla de bienvenida, home, listado de **Servicios** y de **Equipo** (los veterinarios)
traídos de la API con búsqueda y scroll infinito, el detalle de cada veterinario con
animación Hero, y un formulario de contacto con validaciones.

### Parte privada (requiere token)

Un splash que revisa si hay sesión guardada y te manda directo al dashboard si la hay.
El dashboard tiene cinco pestañas (Inicio, Pacientes, Citas, Facturas y Perfil) y lo que
muestra cambia según el rol.

**Pacientes**
- *Mascotas:* listado con búsqueda y scroll infinito, crear/editar con dropdowns y
  validaciones, eliminar con confirmación. Cada mascota tiene una vista de detalle con
  la foto a pantalla completa.
- *Citas:* con chips de color por estado. El USUARIO agenda (date/time picker) y el
  DOCTOR cambia el estado.
- *Historiales médicos:* listado y formulario.

**Facturación**
- Productos, Categorías y Servicios: CRUD completo.
- Facturas: se crean con sus líneas de detalle en un solo formulario, y desde el detalle
  se le registran pagos.
- Proveedores y Compras: mismo patrón, las compras también con sus líneas.

**Clínica**
- Vacunas, Recetas (con sus medicamentos), Hospitalizaciones (con alta), Habitaciones
  y Notificaciones.

**Administración**
- Gestión de clientes y de veterinarios. Aquí está el detalle que más nos costó entender:
  en el backend, `Cliente.user` es obligatorio, así que un cliente **no puede existir sin
  cuenta**. Por eso el formulario de "Nuevo cliente" crea primero el usuario y después el
  perfil, en un solo flujo.
  Y en el de veterinario hay un switch de "crear cuenta de acceso": **ese switch es lo que
  convierte al veterinario en un DOCTOR de verdad**, porque el rol se deriva de tener una
  cuenta vinculada. Sin él, el veterinario solo aparece listado en el equipo, sin login.

**MongoDB (5 colecciones)**
- *Galería de mascotas:* el usuario elige una foto de su galería o la toma con la cámara
  (`image_picker`), y se guarda como base64 dentro del documento de Mongo.
- Un patrón genérico reutilizable que sirve las otras cuatro colecciones (Monitoreo,
  Consultas remotas, Notas de voz y Tracking de visitas) con listado, detalle y creación.

---

## Roles

Lo importante es que el rol **no es un texto decorativo**: cambia lo que la interfaz te
muestra y, sobre todo, lo que el backend te deja hacer. Si un cliente intentara saltarse
la app y llamar a la API directo, igual recibiría un 403.

Los roles no se guardan en ninguna tabla, se **derivan**:

- **ADMIN** → el usuario es `is_staff`.
- **DOCTOR** → el usuario tiene un Veterinario vinculado.
- **USUARIO** → cualquier otro autenticado.

| Módulo | ADMIN | DOCTOR | USUARIO |
|---|---|---|---|
| Mascotas | crear / editar / eliminar | leer | leer |
| Citas | todo | cambiar **estado** | **agendar** |
| Historiales | crear / editar | crear / editar | leer |
| Vacunas, Recetas, Hospitalizaciones | crear / editar / eliminar | **crear / editar** | leer |
| Habitaciones | crear / editar / eliminar | leer | leer |
| Productos, Categorías, Servicios | crear / editar / eliminar | leer | leer |
| Facturas, Proveedores, Compras | crear / editar / eliminar | leer | leer |
| Notificaciones | gestionar | leer + marcar leída | leer + marcar leída |
| Galería y colecciones Mongo | crear | leer | leer |
| Clientes y Veterinarios | gestionar | leer | leer |

Vale la pena explicar la fila de Vacunas/Recetas/Hospitalizaciones, porque es la única
donde el DOCTOR escribe. Al principio todo el módulo de Clínica era "solo el admin
escribe", pero no tenía sentido: recetar y vacunar **son actos médicos**, es el trabajo
del doctor. Así que separamos los permisos: los actos médicos los puede registrar el
doctor (permiso `IsMedicoOrReadOnly` en el backend), mientras que las habitaciones y el
inventario siguen siendo solo del admin, porque eso es infraestructura, no medicina.

---

## Arquitectura

```
lib/
├── main.dart                 ProviderScope + MaterialApp.router
├── core/                     constantes, tema, rutas, bottom nav, imágenes
├── domain/
│   ├── entities/             objetos puros de Dart (sin Flutter, sin JSON)
│   ├── repositories/         interfaces (abstract interface class)
│   └── usecases/             una clase por operación, con operator call
├── data/
│   ├── dtos/                 fromJson + toDomain
│   ├── repositories/         implementaciones contra la API
│   └── cliente_autenticado.dart
└── ui/
    ├── providers/            arma la cadena: http → repositorio → use cases
    ├── notifiers/            estado inmutable + Notifier
    └── screens/              publicas/ y privadas/
```

La idea es que cada capa solo conozca a la de adentro. `domain` no sabe que existe HTTP
ni JSON; solo declara interfaces. `data` las implementa. `ui` nunca habla con la API
directo, siempre pasa por un use case.

**Paginación:** la API usa la paginación de DRF, así que hay un `PaginaDto<T>` genérico
que envuelve cualquier listado. Los notifiers guardan la página actual y si hay más, y
las listas cargan la siguiente cuando te acercas al final (scroll infinito).

---

## Imágenes

Un requisito del curso es que no se usen imágenes enlazadas de la web. Así que todas las
imágenes decorativas (los placeholders por especie, los avatares) están **empaquetadas en
`assets/images/`** y se cargan con `Image.asset`. No hay ni un solo `Image.network`
apuntando a un dominio externo.

El único caso distinto es la galería, y ahí no podía ser un asset: son fotos que **sube el
usuario desde su teléfono**. Esas se toman con `image_picker`, se comprimen y se guardan
como base64 dentro del documento de MongoDB. La app las decodifica y las muestra con
`Image.memory`. Así no dependemos de ningún servidor de imágenes externo.

---

## Tests

```bash
flutter test
```

12 tests en Flutter, sobre las entidades, los DTOs (que el JSON real se mapee bien) y los
use cases, estos últimos con mocks de las interfaces (`mockito`).

El backend tiene 82 tests, la mayoría sobre permisos: comprueban cosas como que un cliente
recibe 403 al intentar crear una vacuna, o que un veterinario **con cuenta vinculada** sí
sale con rol DOCTOR al iniciar sesión.

---

## Generar el APK

```bash
flutter build apk --release
```

Queda en `build/app/outputs/flutter-apk/app-release.apk`.

Una advertencia que nos costó una tarde: Flutter declara el permiso de INTERNET **solo**
en los manifests de `debug` y `profile`. El de release (`android/app/src/main/AndroidManifest.xml`)
no lo trae. Si no lo agregas a mano, la app funciona perfecto con `flutter run` pero el APK
instalado no conecta a nada y todo te dice "sin conexión". Ya está agregado, pero si alguien
clona esto y le pasa algo parecido, que sepa por dónde buscar.

El APK va firmado con la clave de debug de Flutter. Instala sin problema, pero no serviría
para publicar en Google Play.

---

## Decisiones y cosas que quedaron fuera

Algunas cosas que sabemos que un producto real tendría, y por qué no están:

- **El cliente no registra sus propias mascotas.** En el modelo de negocio del proyecto, la
  clínica es quien lleva el registro, así que es el admin quien las da de alta. En una app
  comercial lo lógico sería que el dueño registre a su mascota, pero eso cambiaría las
  reglas del backend.
- **No hay pantalla de registro público.** Las cuentas las crea el admin desde la app. La
  API sí tiene el endpoint de registro, pero para esta entrega decidimos que el alta de
  clientes fuera controlada.
- **Las horas de las citas se escriben, no se eligen de una agenda.** Lo ideal sería mostrar
  solo los horarios libres del veterinario, pero eso requiere lógica de disponibilidad en el
  backend que está fuera del alcance.
- **La galería guarda las fotos en base64 dentro de Mongo.** Funciona y es autocontenido,
  pero en producción lo correcto sería subirlas a un almacenamiento de archivos y guardar
  solo la referencia.

---

## Guion del video

Está en [GUION_VIDEO.md](GUION_VIDEO.md).

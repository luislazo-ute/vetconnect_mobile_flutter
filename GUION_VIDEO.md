# Guion del video (3 a 5 minutos)

Objetivo: que el profe vea, sin buscarlo, cada punto que califica. El orden de abajo está
armado justo para eso.

**Antes de grabar**
- Corre la app en el **emulador** o en el **teléfono físico**, y **dilo en voz alta al
  empezar** (la rúbrica lo pide explícitamente).
- Cierra sesión antes de grabar, para arrancar desde la parte pública.
- Ten los tres usuarios a mano: `admin1`, `doctor1`, `cliente1` — clave `VetConnect2026`.
- Consejo: no grabes de un tirón. Graba por bloques y pégalos. Si te trabas, repites solo
  ese bloque.

---

## Bloque 1 — Presentación (15 seg)

> "Hola, soy Luis Lazo. Esta es VetConnect, una app de gestión veterinaria en Flutter que
> consume una API REST en Django. La estoy corriendo en [un emulador Android / mi teléfono
> físico]. La API está desplegada, no hay datos falsos: todo lo que van a ver sale del
> servidor."

Muestra rápido la URL de la API en `lib/core/constantes.dart`. Un segundo, nada más.

---

## Bloque 2 — Parte pública (40 seg)

Sin iniciar sesión, recorre:
- La pantalla de bienvenida y el home.
- **Servicios** — y haz scroll hasta abajo para que **se vea cómo carga la página siguiente**
  (eso es el scroll infinito, y es paginación real de la API).
- **Equipo** — entra al detalle de un veterinario.
- **Contacto** — intenta enviarlo vacío para que salte la validación.

> "Todo esto es la parte pública, no pide login. Los servicios y el equipo se traen de la
> API con paginación; noten cómo va cargando más al bajar."

---

## Bloque 3 — Login y sesión (30 seg)

**Primero enseña la protección de rutas.** Esto vale puntos y casi nadie lo muestra:

> "Antes de entrar, algo importante: el área privada está protegida. Si no hay token, el
> router no te deja pasar."

Entra con **admin1**. Cuando cargue el dashboard:

> "El token se guarda cifrado con flutter_secure_storage y se adjunta en cada petición.
> Si la API responde 401, el cliente refresca el token y reintenta solo, sin que el usuario
> se dé cuenta."

Truco: mata la app y vuelve a abrirla. Debe entrar **directo al dashboard**, sin volver a
pedir la clave. Eso demuestra la sesión persistente.

---

## Bloque 4 — CRUD real (60 seg) — el bloque que más pesa (25%)

Como **admin1**, haz un ciclo completo en un módulo. Sugerencia: **Productos** o **Mascotas**.

1. Abre el listado (que se vea el indicador de carga).
2. **Crea** un registro. Deja un campo obligatorio vacío a propósito → **muestra la validación**.
3. Complétalo y guarda → **que se vea el SnackBar verde de éxito** y que el nuevo registro
   aparece en la lista.
4. **Edítalo** y guarda.
5. **Elimínalo** → que se vea el diálogo de confirmación.

> "Crear, editar y eliminar, todo contra la API. Cada formulario valida, muestra el estado
> de carga y avisa con un mensaje si sale bien o mal."

Si te alcanza el tiempo, muestra una **factura**: se crea con sus líneas de detalle en el
mismo formulario, y desde el detalle se le registra un pago.

---

## Bloque 5 — LOS ROLES (60 seg) — el bloque decisivo (20%)

Aquí no basta con decir el rol: hay que **demostrar que el rol cambia el sistema**.

**Con admin1** (ya estás dentro):
> "Como admin veo los botones de crear, editar y eliminar en todos los módulos."

Muéstralo en Vacunas y en Productos. Cierra sesión.

**Entra con doctor1:**
> "El doctor sí puede recetar y vacunar, porque son actos médicos, que es su trabajo."

- Ve a **Vacunas** → **el botón de crear SÍ está**.
- Ve a **Productos** o **Habitaciones** → **el botón NO está**, porque eso es inventario e
  infraestructura, no medicina.

Cierra sesión.

**Entra con cliente1:**
> "El cliente solo lee. No tiene ningún botón de crear, editar ni eliminar."

- Abre Vacunas y Productos → **no hay botones**.

**Y ahora el remate.** Esto es lo que separa un trabajo bueno de uno normal:

> "Pero ocultar el botón no es seguridad de verdad, es solo interfaz. La restricción real
> está en el backend."

Muestra en Swagger (`/api/docs/`) o con Postman: **un POST a `/api/vacunas/` con el token
del cliente devuelve 403 Forbidden.**

> "Aunque el cliente se saltara la app y llamara la API directo, el servidor lo bloquea."

---

## Bloque 6 — Perfil, logout y cierre (25 seg)

- Entra al Perfil: se ve el usuario y su rol.
- **Cierra sesión** → que se vea que vuelve al login y que ya **no** puede regresar al
  dashboard (la sesión se limpió de verdad).

> "Al cerrar sesión se borra el token del almacenamiento seguro. Esto fue VetConnect:
> Flutter, arquitectura limpia en tres capas, Riverpod, y una API Django real con
> autenticación JWT y permisos por rol. Gracias."

---

## Checklist antes de subir

Repasa que el video muestre, sí o sí:

- [ ] Dijiste si es emulador o teléfono físico
- [ ] Parte pública funcionando
- [ ] Login
- [ ] Dashboard privado
- [ ] Un listado que consume la API (con la paginación al hacer scroll)
- [ ] Un formulario que **crea o edita** y muestra la respuesta exitosa
- [ ] Una **restricción por rol** (el botón que no aparece + el 403 del backend)
- [ ] Logout
- [ ] Dura entre 3 y 5 minutos

---

## Las 6 capturas obligatorias

Van en un PDF (o pegadas en el README). Se pueden sacar del mismo video:

1. Pantalla pública principal (el home).
2. Login.
3. Dashboard privado.
4. Un listado consumiendo la API (Mascotas o Productos, con datos).
5. Un formulario con su respuesta exitosa — que **se vea el SnackBar** de "creado".
6. La restricción por rol. La mejor: **dos capturas lado a lado** de la misma pantalla
   (Vacunas, por ejemplo), una como `admin1` **con** el botón de crear y otra como
   `cliente1` **sin** el botón. Si le pegas al lado el 403 de Swagger, quedas redondo.

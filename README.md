# Trepando Cerros

Proyecto Rails 8 de ejemplo con integración para la API de Strava.

## Requisitos previos

1. Instala Ruby 3.2.2 (por ejemplo con `rbenv install 3.2.2`).
2. Ejecuta `bundle install` para instalar las dependencias.

## Configuración

1. Copia `.env.example` a `.env` y coloca tus credenciales de Strava:

```bash
cp .env.example .env
echo "STRAVA_CLIENT_ID=tu-id" >> .env
echo "STRAVA_CLIENT_SECRET=tu-secret" >> .env
# (opcional) si usas un dominio distinto a `localhost:3000`, ajusta la URL de retorno
echo "STRAVA_REDIRECT_URI=https://tu-dominio.ngrok-free.app/auth/strava/callback" >> .env
```
La gema `dotenv-rails` cargará estas variables para permitir las llamadas a `StravaClient` y al proceso de OAuth. El flujo solicitará los scopes `activity:read_all` y `profile:read_all`, así que habilítalos también en la configuración de tu aplicación en Strava. Si no se definen `STRAVA_CLIENT_ID` y `STRAVA_CLIENT_SECRET`, la opción **Conectar con Strava** en la configuración mostrará un mensaje de error.

Si ejecutas la app desde una URL externa (por ejemplo mediante `ngrok`), Rails
protege las redirecciones hacia otros dominios. El controlador ya indica
`allow_other_host: true` al redirigir a Strava, por lo que la autenticación
funcionará correctamente. **La URL usada como `redirect_uri` debe coincidir de
forma exacta con la registrada en la configuración de tu aplicación en
Strava**. Si Strava devuelve `Bad Request` con código `invalid`, revisa que
`STRAVA_REDIRECT_URI` y la dirección en la página de ajustes de Strava sean
idénticas.

## Uso

Inicia el servidor con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás una pantalla de bienvenida. Desde el apartado **Configuración** podrás usar la opción **Conectar con Strava**. Tras autorizar la aplicación se mostrará tu panel con tu información de atleta y un área para subir tu archivo GPX y obtener el tiempo estimado.
La aplicación analiza tus carreras recientes para ajustar el ritmo en subidas, bajadas y terreno plano. Ahora se entrenan modelos simples con tus actividades del último año (priorizando las más largas) para predecir el ritmo según la pendiente. Estos modelos se generan con una regresión lineal muy ligera y se usan al estimar el tiempo de la ruta.
Además considera el desgaste del cuerpo: a medida que se acumulan kilómetros se aplica un pequeño factor de fatiga que incrementa ligeramente el tiempo estimado. Los gemelos se cansan en las subidas y los cuádriceps en las bajadas. El efecto de la fatiga ahora crece de forma un poco exponencial, de modo que a mayor distancia o desnivel acumulado el ritmo se vuelve gradualmente más lento, pero con coeficientes reducidos para evitar resultados exagerados.

  La interfaz muestra tarjetas con efecto de vidrio y un pequeño botón gris de **Cerrar sesión** en la esquina inferior derecha cuando estás autenticado. El área de carga admite arrastrar y soltar el GPX y muestra mensajes animados durante el análisis. Una vez calculado el resultado se muestra el **tiempo estimado**. Si seleccionas una hora de inicio verás una tabla con la distancia acumulada por hora, los kilómetros recorridos en cada tramo y el desnivel positivo y negativo por hora. La última fila indica la hora estimada de finalización. Encima de la tabla se muestra la gráfica de elevación y, al pasar el cursor, indica la hora aproximada de paso según la hora de inicio.

Esta aplicación usa Tailwind CSS junto con la librería daisyUI, cargada desde CDN y aplicando el tema **nord** para un estilo coherente y moderno. Toda la interfaz se apoya en componentes de daisyUI para botones, formularios y tablas.

## Perfil de administrador

Las cuentas ya no se crean con permisos de administrador por defecto. Cualquier usuario inicia con un perfil **normal**, creado automáticamente al iniciar el proyecto. Desde la sección de configuración se puede ver la lista completa de perfiles y ajustar sus permisos.

Cada perfil puede habilitar o deshabilitar funciones como el predictor de carrera de forma independiente.
Desde la lista de perfiles puedes ingresar a cada uno y cambiar sus permisos usando botones de tipo switch que muestran claramente si una opción está encendida o apagada.

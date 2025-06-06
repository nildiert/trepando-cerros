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
La gema `dotenv-rails` cargará estas variables para permitir las llamadas a `StravaClient` y al proceso de OAuth. El flujo solicitará los scopes `activity:read_all` y `profile:read_all`, así que habilítalos también en la configuración de tu aplicación en Strava. Si no se definen `STRAVA_CLIENT_ID` y `STRAVA_CLIENT_SECRET`, el enlace **Conectar con Strava** mostrará un mensaje de error.

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

Al abrir `http://localhost:3000` verás una pantalla de bienvenida con un botón **Conectar con Strava**. Tras autorizar la aplicación se mostrará tu panel con tu información de atleta y un área para subir tu archivo GPX y obtener el tiempo estimado.
La aplicación analiza tus carreras de los últimos seis meses para ajustar el ritmo en subidas, bajadas y terreno plano.

 La interfaz usa Tailwind con un tema claro y tarjetas tipo *glass*. El área para subir el GPX permite arrastrar y soltar y muestra el progreso del análisis con mensajes animados. La gráfica de elevación se muestra como una línea suave. Tras el análisis aparece un campo con un selector de hora para fijar la hora de inicio y así conocer la hora estimada de paso por cada kilómetro.

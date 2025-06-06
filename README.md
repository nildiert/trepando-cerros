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
La gema `dotenv-rails` cargará estas variables para permitir las llamadas a `StravaClient` y al proceso de OAuth. Si no se definen `STRAVA_CLIENT_ID` y `STRAVA_CLIENT_SECRET`, el enlace **Conectar con Strava** mostrará un mensaje de error.

Si ejecutas la app desde una URL externa (por ejemplo mediante `ngrok`), Rails
protege las redirecciones hacia otros dominios. El controlador ya indica
`allow_other_host: true` al redirigir a Strava, por lo que la autenticación
funcionará correctamente. Asegúrate de que la URL indicada en `STRAVA_REDIRECT_URI`
coincida con el valor configurado en tu aplicación de Strava.

## Uso

Inicia el servidor con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás una pantalla de bienvenida con un botón **Conectar con Strava**. Tras autorizar la aplicación se mostrará tu panel con tu información de atleta y un área para subir tu archivo GPX y obtener el tiempo estimado.
La aplicación analiza tus carreras de los últimos seis meses para ajustar el ritmo en subidas, bajadas y terreno plano.

La interfaz usa Tailwind con un tema claro y tarjetas tipo *glass*. El área para subir el GPX permite arrastrar y soltar y muestra el progreso del análisis con mensajes animados. También se dibuja la gráfica de elevación y se muestra el avance por hora de la ruta.

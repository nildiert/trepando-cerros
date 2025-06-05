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
```
La gema `dotenv-rails` cargará estas variables para permitir las llamadas a `StravaClient` y al proceso de OAuth.

## Uso

Inicia el servidor con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás una pantalla de bienvenida con un botón **Conectar con Strava**. Tras autorizar la aplicación se mostrará tu panel con tu información de atleta y un área para subir tu archivo GPX y obtener el tiempo estimado.
La aplicación analiza tus carreras de los últimos seis meses para ajustar el ritmo en subidas, bajadas y terreno plano.

La interfaz usa Tailwind con un tema claro y tarjetas tipo *glass*. El área para subir el GPX permite arrastrar y soltar y muestra el progreso del análisis con mensajes animados. También se dibuja la gráfica de elevación y se muestra el avance por hora de la ruta.

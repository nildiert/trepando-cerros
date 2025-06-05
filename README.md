# Trepando Cerros

Proyecto Rails 8 de ejemplo con integración para la API de Strava.

## Requisitos previos

1. Instala Ruby 3.2.2 (por ejemplo con `rbenv install 3.2.2`).
2. Ejecuta `bundle install` para instalar las dependencias.

## Configuración

1. Copia `.env.example` a `.env` y coloca tu token de acceso:

```bash
cp .env.example .env
echo "STRAVA_ACCESS_TOKEN=tu-token" >> .env
```
La gema `dotenv-rails` cargará esta variable para permitir las llamadas a `StravaClient`.

## Uso

Inicia el servidor con:

```bash
bundle exec rails server
```

Al abrir `http://localhost:3000` verás una pantalla de bienvenida donde puedes escribir el **ID del atleta** que aparece en la URL de Strava (por ejemplo `25991681`).
Tras pulsar **Buscar** se mostrará la información del atleta y un panel para subir tu archivo GPX y obtener el tiempo estimado. La aplicación analiza tus carreras de los últimos seis meses para ajustar el ritmo en subidas, bajadas y terreno plano.

La interfaz usa Tailwind con un tema claro y tarjetas tipo *glass*. El área para subir el GPX permite arrastrar y soltar y muestra el progreso del análisis con mensajes animados. También se dibuja la gráfica de elevación y se muestra el avance por hora de la ruta.

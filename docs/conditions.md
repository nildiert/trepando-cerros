# Condiciones para mostrar funciones

Esta aplicación usa permisos y otras verificaciones para decidir cuándo mostrar ciertas opciones de la interfaz.

## Icono "Calcular Carrera"
- **Requisito:** que exista `session[:strava_token]`.
- Si el usuario ha conectado Strava, en el menú lateral aparece la opción *Calcular Carrera*.

## Icono "Planes"
- **Requisito:** `can?(:manage, TrainingPlan)`.
- Esta habilidad se otorga mediante el permiso `training_plan` en el perfil o rol del usuario.

## Icono "Atletes"
- **Requisito:** `can? :manage, :athletes`.
- La habilidad se habilita para entrenadores (`user.role.name == 'trainer'`) o para administradores.

## Botón "Crear plan de entrenamiento" en la vista de atleta
- **Requisitos:**
  1. `can?(:manage, TrainingPlan)`.
  2. El atleta debe pertenecer a la lista de `trainees` del entrenador.
- Cuando se cumplen ambos puntos, aparece un botón que enlaza a `new_training_plan_path`.

Estas verificaciones están implementadas en las vistas con condicionales `if` y en el modelo `Ability` mediante CanCanCan.

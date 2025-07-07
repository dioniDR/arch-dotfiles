# Ayuda: ¿Por qué .knowledge-base no está en el repositorio?

El backend y la configuración del servicio `knowledge-base` (que sirve la app F2 en http://127.0.0.1:8011) no están incluidos en este repositorio por las siguientes razones:

- El código fuente y/o ejecutable del backend se encuentra fuera de este repo, normalmente en otra carpeta del sistema o en un repositorio privado.
- El archivo de servicio `knowledge-base.service` suele estar en `~/.config/systemd/user/` y tampoco está versionado aquí.
- Este repo solo contiene los scripts de lanzamiento, documentación y configuraciones de interfaz, pero no el backend.

## ¿Qué hacer si necesitas el backend?
1. Localiza el archivo `knowledge-base.service` con:
   ```bash
   systemctl --user show knowledge-base -p FragmentPath
   cat ~/.config/systemd/user/knowledge-base.service
   ```
2. Revisa la línea `ExecStart=` para ver la ruta del ejecutable real.
3. Si necesitas el código fuente, consulta al administrador del sistema o revisa el repositorio/documentación correspondiente.

## Nota
Si quieres versionar el backend, agrégalo explícitamente a este repo o crea un submódulo con su propio control de versiones.

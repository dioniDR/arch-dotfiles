# 🔍 F2 Knowledge Base

## Estado Actual
- **Binding**: firefox http://127.0.0.1:8011
- **Servicio**: knowledge-base.service (systemd user)
- **Puerto**: 8011
- **Ubicación**: ⚠️ PENDIENTE DE INVESTIGAR

## Comandos de Diagnóstico
```bash
# Ver servicio
systemctl --user status knowledge-base

# Ver puerto
ss -tlnp | grep 8011

# Ver archivos del servicio
systemctl --user show knowledge-base -p FragmentPath

# Buscar archivos relacionados
find ~/arch-dotfiles -name "*knowledge*" -o -name "*8011*"
```

## Launcher F2
```bash
# Método actual
firefox http://127.0.0.1:8011

# Verificar si está activo
curl -s http://127.0.0.1:8011 || echo "Servicio no activo"
```

## TODO
- [ ] Localizar archivos fuente
- [ ] Crear launcher consolidado
- [ ] Documentar estructura
- [ ] Integrar con F1/F3

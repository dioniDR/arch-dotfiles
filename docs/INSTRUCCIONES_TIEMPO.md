# Instrucciones para Arreglar Fecha y Hora

## Problema Detectado
- **Ubicación:** Denver, Colorado
- **Hora real:** 9:31 PM
- **Hora del sistema:** 8:31 AM (incorrecta)
- **Timezone:** America/Denver (correcto)
- **NTP:** Deshabilitado

## Solución Después del Reinicio

### Opción 1: Ejecutar el script
```bash
./fix_time.sh
```

### Opción 2: Comandos manuales
```bash
# Habilitar NTP
sudo timedatectl set-ntp true

# Habilitar y iniciar servicio
sudo systemctl enable systemd-timesyncd
sudo systemctl start systemd-timesyncd

# Si la hora sigue incorrecta, establecer manualmente
sudo timedatectl set-time "2025-08-16 21:31:00"

# Verificar
timedatectl status
date
```

## Verificación Final
La salida de `timedatectl status` debe mostrar:
- **Local time:** 21:31 MDT (9:31 PM)
- **System clock synchronized:** yes
- **NTP service:** active

## Notas
- El timezone ya está correcto (America/Denver)
- Solo falta habilitar NTP y corregir la hora
- Después del reinicio, sudo debería funcionar normalmente
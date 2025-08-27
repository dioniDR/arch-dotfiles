#!/bin/bash
# Script para arreglar la configuración de fecha y hora
# Ejecutar después del reinicio cuando sudo esté disponible

echo "=== Configuración de Fecha y Hora ==="
echo "Ubicación: Denver, Colorado (America/Denver)"
echo "Hora objetivo: 21:31 (9:31 PM)"
echo ""

echo "1. Habilitando sincronización NTP..."
sudo timedatectl set-ntp true

echo "2. Habilitando servicio de sincronización..."
sudo systemctl enable systemd-timesyncd

echo "3. Iniciando servicio de sincronización..."
sudo systemctl start systemd-timesyncd

echo "4. Esperando sincronización..."
sleep 5

echo "5. Verificando estado actual..."
timedatectl status

echo ""
echo "Si la hora aún no es correcta, ejecutar manualmente:"
echo "sudo timedatectl set-time \"$(date '+%Y-%m-%d') 21:31:00\""
echo ""
echo "Para verificar:"
echo "date"
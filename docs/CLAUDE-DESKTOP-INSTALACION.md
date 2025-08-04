# 🖥️ Claude Desktop - Instalación Completa en Arch Linux

*Extraído de ~/.knowledge-base - Documentación completa y funcional*

## 🎯 **Resumen Ejecutivo**

Claude Desktop funciona **100% en Arch Linux** con sesiones persistentes usando una solución de **1 línea**. 

### **Estado Actual:**
- ✅ **Instalado y funcionando**: claude-desktop-bin 0.7.7-1
- ✅ **Sesiones persistentes**: Login se mantiene entre reinicios
- ✅ **Funcionalidad completa**: MCP, filesystem access, todas las capacidades
- ✅ **Integración sistema**: Aparece en Wofi/menú aplicaciones

---

## 🚀 **Instalación Paso a Paso**

### **1. Instalar desde AUR:**
```bash
yay -S claude-desktop-bin
```

### **2. Resolver dependencia faltante:**
```bash
sudo npm install -g asar
```

### **3. Crear archivo de localización:**
```bash
sudo mkdir -p /usr/lib/electron36/resources/
sudo tee /usr/lib/electron36/resources/en-US.json > /dev/null << 'EOF'
{
  "locale": "en-US",
  "messages": {}
}
EOF
```

### **4. Crear launcher con sesiones persistentes:**
```bash
mkdir -p ~/bin
cat > ~/bin/claude-persistent.sh << 'EOF'
#!/bin/bash
claude-desktop \
  --no-sandbox \
  --disable-web-security \
  --enable-features=PersistentSessionCookies \
  "$@"
EOF

chmod +x ~/bin/claude-persistent.sh
```

### **5. Integración con Wofi/menú aplicaciones:**
```bash
cat > ~/.local/share/applications/claude-desktop.desktop << 'EOF'
[Desktop Entry]
Name=Claude Desktop
Comment=AI Assistant by Anthropic
Exec=/home/dioni/bin/claude-persistent.sh
Icon=claude-desktop
Terminal=false
Type=Application
Categories=Office;Utility;Development;
StartupNotify=true
StartupWMClass=claude-desktop
EOF

update-desktop-database ~/.local/share/applications/
```

---

## ⚡ **Uso Diario**

### **Iniciar Claude Desktop:**
```bash
# Desde terminal
~/bin/claude-persistent.sh

# Desde Wofi (Super + D)
# Buscar "Claude Desktop" y Enter
```

### **Autenticación:**
- **Método**: Código de verificación
- **Navegador**: Firefox funciona perfectamente
- **Una sola vez**: Login se mantiene permanentemente

---

## 🔧 **Troubleshooting**

### **Script de diagnóstico:**
```bash
cat > ~/bin/claude-diagnose.sh << 'EOF'
#!/bin/bash
echo "=== Claude Desktop Diagnostic ==="
echo "Process status:"
ps aux | grep -E "(claude|electron)" | grep -v grep
echo -e "\nSession cookies:"
sqlite3 ~/.config/Claude/Cookies "SELECT name, host_key, is_persistent FROM cookies WHERE name = 'sessionKey';" 2>/dev/null || echo "No cookies found"
echo -e "\nConfig directory permissions:"
ls -la ~/.config/Claude/ | head -5
EOF

chmod +x ~/bin/claude-diagnose.sh
```

### **Comandos útiles:**
```bash
# Verificar que funciona
~/bin/claude-diagnose.sh

# Ver procesos Claude
ps aux | grep -E "(claude|electron)" | grep -v grep

# Verificar cookies persistentes
sqlite3 ~/.config/Claude/Cookies "SELECT name, is_persistent FROM cookies WHERE name = 'sessionKey';"
# Debe mostrar: sessionKey|1

# Logs de aplicación
tail -f ~/.config/Claude/logs/*.log
```

---

## 🧠 **Solución Técnica Explicada**

### **Problema identificado:**
- Claude Desktop perdía sesiones entre reinicios
- `sessionKey` se marcaba como `session-only` (`is_persistent = 0`)
- Se borraba automáticamente al cerrar aplicación

### **Solución aplicada:**
- **Flag crucial**: `--enable-features=PersistentSessionCookies`
- **Efecto**: Fuerza todas las cookies de sesión a ser persistentes
- **Resultado**: `sessionKey` cambia a `is_persistent = 1`

### **Por qué funciona:**
- Una línea resuelve el problema de persistencia
- Mantiene toda la funcionalidad original
- No requiere configuraciones complejas

---

## ⚠️ **Lo que NO hacer (Métodos ineficaces)**

### **❌ Aproximaciones que fallan:**
- **Wine/Docker**: Capas innecesarias, MCP limitado
- **Eliminar flags seguridad**: Rompe funcionalidad MCP
- **Configuraciones MCP HTTP**: Innecesario para Desktop
- **Scripts complejos**: Sobrecomplica solución simple
- **Modificar permisos cookies**: No resuelve causa raíz

---

## 📊 **Verificación de Éxito**

### **Test de persistencia:**
```bash
# 1. Iniciar y autenticarse
~/bin/claude-persistent.sh

# 2. Verificar sessionKey persistente
sqlite3 ~/.config/Claude/Cookies "SELECT name, is_persistent FROM cookies WHERE name = 'sessionKey';"
# Esperado: sessionKey|1

# 3. Cerrar aplicación
pkill -f "/usr/lib/electron36/electron"

# 4. Verificar que persiste
sqlite3 ~/.config/Claude/Cookies "SELECT name FROM cookies WHERE name = 'sessionKey';"
# Esperado: sessionKey

# 5. Reabrir - debe entrar sin login
~/bin/claude-persistent.sh
```

---

## 📋 **Estructura Final Instalada**

```
~/bin/
├── claude-persistent.sh          # ✅ Launcher principal
└── claude-diagnose.sh           # ✅ Diagnóstico

~/.local/share/applications/
└── claude-desktop.desktop        # ✅ Integración Wofi

~/.config/Claude/
├── config.json                   # ✅ Configuración MCP
├── Cookies                       # ✅ Sesiones persistentes
└── logs/                         # ✅ Logs aplicación
```

---

## 🔄 **Mantenimiento**

### **Backup configuración:**
```bash
tar -czf claude-config-backup.tar.gz \
  ~/.config/Claude/ \
  ~/bin/claude-persistent.sh \
  ~/.local/share/applications/claude-desktop.desktop
```

### **Actualizaciones:**
```bash
# Actualizar paquete
yay -Syu claude-desktop-bin

# Verificar que sigue funcionando
~/bin/claude-diagnose.sh
```

---

## 🏆 **Resultado Final**

### **✅ Claude Desktop Completamente Funcional:**
- **Sesiones permanentes**: ✅ No más re-login
- **Integración sistema**: ✅ Lanzador en Wofi  
- **MCP completo**: ✅ Filesystem access, herramientas
- **Una solución mínima**: ✅ Un flag resuelve todo
- **Arch Linux optimizado**: ✅ Funciona perfectamente

**🚀 Plataforma de desarrollo con IA completamente operativa**

---

*Documentación basada en instalación real y funcional en sistema Arch Linux + Hyprland*
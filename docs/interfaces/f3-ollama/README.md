# 🤖 F3 Ollama Lab

## Estado Actual
- **Binding**: firefox http://127.0.0.1:8000
- **Servidor**: ollama-lab (localhost:8000)
- **Modelos**: Llama 3.2, Qwen, otros
- **Ubicación**: docs/interfaces/f3-ollama/

## Comandos Principales
```bash
# Iniciar servidor
cd ~/arch-dotfiles/docs/interfaces/f3-ollama
python -m http.server 8000

# Verificar modelos
ollama list

# Iniciar Ollama daemon
ollama serve
```

## Launcher F3
```bash
# Método consolidado
~/arch-dotfiles/docs/interfaces/f3-ollama/launch-f3.sh
```

## Integración
- Compatible con F1 (ayuda)
- Independiente de F2 (knowledge base)
- Autocontenido en puerto 8000

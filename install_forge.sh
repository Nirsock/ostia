#!/bin/bash

# Variables
FORGE_VERSION="47.2.6"
MINECRAFT_VERSION="1.20.1"
FORGE_INSTALLER="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar"
SERVER_DIR="/workspaces/ostia/servidor_minecraft"
FORGE_URL="https://maven.minecraftforge.net/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/${FORGE_INSTALLER}"

# Navega al directorio del servidor
cd $SERVER_DIR || { echo "Error: No se puede acceder al directorio del servidor."; exit 1; }

# Descargar el instalador de Forge
echo "[+] Descargando versión Forge..."
if wget -q $FORGE_URL; then
    echo "[+] Descarga completa: $FORGE_INSTALLER"
else
    echo "[+] Error al descargar la versión Forge: $FORGE_INSTALLER"
    read -p "Presiona Enter para continuar..."
    exit 1
fi

# Ejecutar el instalador de Forge
echo "[+] Instalando Forge..."
if java -jar $FORGE_INSTALLER --installServer; then
    echo "[+] Forge instalado correctamente."
else
    echo "[+] Error al instalar Forge."
    read -p "Presiona Enter para continuar..."
    exit 1
fi

# Verificar y mover el archivo jar universal a la ubicación deseada
UNIVERSAL_JAR="forge-${MINECRAFT_VERSION}-${FORGE_VERSION}.jar"
if [ -f "$UNIVERSAL_JAR" ]; then
    mv "$UNIVERSAL_JAR" "$SERVER_DIR/forge.jar"
else
    echo "[+] Error: No se encontró el archivo universal de Forge."
    read -p "Presiona Enter para continuar..."
    exit 1
fi

# Configurar el script de inicio para usar la nueva versión de Forge
echo "[+] Configurando el script de inicio..."
cat <<EOL > start.sh
#!/bin/bash
java -Xmx10G -Xms10G -jar forge.jar nogui
EOL

# Asegúrate de que el script de inicio tenga permisos de ejecución
chmod +x start.sh

# Mensaje de estado final
echo "[+] Forge $FORGE_VERSION para Minecraft $MINECRAFT_VERSION instalado y configurado!"
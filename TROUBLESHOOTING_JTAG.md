# Troubleshooting - Conexão JTAG com DE10-Nano

## Status Atual

✅ **USB Blaster detectado pelo sistema:**
- Dispositivo: `Bus 003 Device 004: ID 09fb:6810 Altera`
- Hardware físico está conectado

❌ **Quartus não detecta o hardware:**
- `jtagconfig`: "No JTAG hardware available"
- `quartus_pgm`: "Programming hardware cable not detected"

## Soluções

### 1. Configurar Regras udev (Recomendado)

O problema mais comum é falta de permissões USB. Execute:

```bash
# Criar regra udev
sudo cp /tmp/51-usbblaster.rules /etc/udev/rules.d/

# Recarregar regras
sudo udevadm control --reload-rules
sudo udevadm trigger

# OU simplesmente reinicie o computador
```

**Nota:** Se o arquivo `/tmp/51-usbblaster.rules` não existir, crie-o com:

```bash
cat > /tmp/51-usbblaster.rules << 'EOF'
# Altera USB-Blaster
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE="0666", GROUP="plugdev"
# Altera USB-Blaster II
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE="0666", GROUP="plugdev"
# Altera USB-Blaster II (alternate)
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", MODE="0666", GROUP="plugdev"
# Altera USB-Blaster II (alternate)
SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", MODE="0666", GROUP="plugdev"
EOF
```

### 2. Verificar Switch SW10

Certifique-se de que o switch SW10 está na posição correta para modo JTAG:

```
SW10.1: ON  (MSEL0 = 0)
SW10.2: OFF (MSEL1 = 1)
SW10.3: ON  (MSEL2 = 0)
SW10.4: ON  (MSEL3 = 0)
SW10.5: OFF (MSEL4 = 1)
SW10.6: N/A
```

**MSEL[4:0] = 10010** (modo JTAG)

⚠️ **Importante:** Desligue a placa antes de mudar os switches!

### 3. Verificar Conexão Física

- ✅ Cabo USB conectado na porta USB do PC
- ✅ Cabo USB conectado na porta USB Blaster da DE10-Nano
- ✅ Placa DE10-Nano ligada (LED de alimentação aceso)
- ✅ Switch SW10 na posição correta

### 4. Testar com sudo (Temporário)

Se as regras udev não funcionarem imediatamente, teste com sudo:

```bash
export PATH="/home/aline/altera_standard/25.1std/quartus/bin:/home/aline/altera_standard/25.1std/quartus/sopc_builder/bin:$PATH"
sudo jtagconfig
```

**⚠️ Atenção:** Usar sudo não é recomendado permanentemente, mas pode ajudar a diagnosticar problemas de permissão.

### 5. Verificar Driver USB Blaster

O Quartus Prime inclui o driver USB Blaster. Verifique se está carregado:

```bash
lsmod | grep -i usb
dmesg | grep -i "usb.*blaster\|altera"
```

### 6. Desconectar e Reconectar

1. Desconecte o cabo USB
2. Aguarde 5 segundos
3. Reconecte o cabo USB
4. Verifique novamente com `jtagconfig`

### 7. Verificar Outros Processos

Outros programas podem estar usando o USB Blaster:

```bash
lsof | grep -i usb
fuser /dev/bus/usb/003/004  # Substitua pelo número do seu dispositivo
```

### 8. Verificar Versão do Quartus

Certifique-se de que está usando uma versão compatível:

```bash
export PATH="/home/aline/altera_standard/25.1std/quartus/bin:$PATH"
quartus_sh --version
```

## Comandos de Verificação

Após aplicar as correções, execute:

```bash
# 1. Verificar dispositivo USB
lsusb | grep -i altera

# 2. Verificar detecção JTAG
export PATH="/home/aline/altera_standard/25.1std/quartus/bin:$PATH"
jtagconfig

# 3. Listar dispositivos programáveis
quartus_pgm -l

# 4. Verificar conexão específica
quartus_pgm --auto
```

## Resultado Esperado

Após configurar corretamente, você deve ver algo como:

```
jtagconfig
1) USB-Blaster [USB-0]
  020B30DD  5CSEBA6
```

Ou:

```
quartus_pgm -l
1) USB-Blaster [USB-0]
  020B30DD  5CSEBA6
```

## Próximos Passos

Uma vez que o FPGA seja detectado:

1. Compilar o projeto: `make compile-quartus`
2. Programar o FPGA: `make program-sof`
3. Verificar funcionamento

## Referências

- [DE10-Nano User Manual](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=1046&PartNo=4)
- [Quartus Prime Programmer User Guide](https://www.intel.com/content/www/us/en/programmable/documentation/)

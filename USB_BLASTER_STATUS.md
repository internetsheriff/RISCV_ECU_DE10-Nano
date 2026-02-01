# Status do Driver USB Blaster

## Verificação Completa

### ✅ Driver Instalado e Funcionando

**Tipo de Driver:**
- No Linux, o USB Blaster da Altera funciona através do sistema USB padrão do kernel
- **Não requer driver de kernel separado** - usa `usbfs` (USB file system)
- Driver padrão `usbserial` está disponível no sistema

**Módulos do Kernel Detectados:**
```
/lib/modules/6.14.0-37-generic/kernel/drivers/usb/serial/usbserial.ko.zst ✅
```

### ✅ Hardware Detectado

**Via `lsusb`:**
```
Bus 003 Device 004: ID 09fb:6810 Altera (USB-Blaster)
```

**Via `jtagconfig`:**
```
1) DE-SoC [3-3]
  4BA00477   SOCVHPS  (Hard Processor System - ARM)
  02D020DD   5CSEBA6  (FPGA Cyclone V) ✅
```

### ✅ JTAG Daemon Funcionando

**Processo em execução:**
```
jtagd --user-start --config /home/aline/.jtagd.conf
```

**Versão:**
```
jtagd Version 25.1std.0 Build 1129
```

### ✅ Regras udev Configuradas

**Arquivo:** `/etc/udev/rules.d/51-usbblaster.rules` ou `/etc/udev/rules.d/92-usbblaster.rules`

**Regra aplicada (ID 09fb:6810):**
```udev
SUBSYSTEMS=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="0666"
```

**Status:** Configurado e funcionando ✅

### ✅ Arquivo .sof Disponível

**Localização:**
```
quartus_project/output_files/pulpino_qsys_test.sof (6.5M)
```

**Conteúdo:**
- Design completo do PULPino
- Memória inicializada com software
- Sistema Qsys completo
- Pin assignments para DE10-Nano

## Próximos Passos

### 1. Verificar Switch SW10 na Placa

Certifique-se de que o switch SW10 está na posição correta para modo JTAG:

```
SW10.1: ON  (MSEL0 = 0)
SW10.2: OFF (MSEL1 = 1)
SW10.3: ON  (MSEL2 = 0)
SW10.4: ON  (MSEL3 = 0)
SW10.5: OFF (MSEL4 = 1)
```

**MSEL[4:0] = 10010** (modo JTAG)

### 2. Programar o FPGA

Execute o comando:

```bash
export PATH="/home/aline/altera_standard/25.1std/quartus/bin:$PATH"
make program-sof
```

Ou manualmente:

```bash
cd /home/aline/Documents/Mestrado/ECU/RISCV_ECU
export PATH="/home/aline/altera_standard/25.1std/quartus/bin:$PATH"
quartus_pgm -m JTAG -o "p;quartus_project/output_files/pulpino_qsys_test.sof"
```

### 3. Verificar Funcionamento

Após programar:
- LEDs devem responder conforme o software
- GPIOs devem funcionar
- Sistema PULPino deve executar o código compilado

## Comandos Úteis

### Verificar Conexão JTAG
```bash
jtagconfig
```

### Listar Dispositivos Programáveis
```bash
quartus_pgm -l
```

### Programar FPGA
```bash
make program-sof
```

### Verificar Versão do Quartus
```bash
quartus_sh --version
```

## Referências

- **Documentação Oficial do Quartus:**
  `/home/aline/altera_standard/25.1std/quartus/drivers/linux_drivers_install_instruction.txt`

- **IDs de Dispositivos USB Blaster:**
  - 09fb:6810 - USB-Blaster (original)
  - 09fb:6001 - USB-Blaster II
  - 09fb:6002 - USB-Blaster II (alternate)
  - 09fb:6003 - USB-Blaster II (alternate)
  - E outros...

## Notas Importantes

1. **Driver não é módulo do kernel**: O USB Blaster funciona via sistema USB padrão com permissões configuradas por udev
2. **jtagd é necessário**: O daemon JTAG precisa estar rodando para comunicação
3. **Permissões USB**: As regras udev garantem acesso ao dispositivo sem sudo
4. **Modo JTAG**: O switch SW10 deve estar configurado corretamente para programação via JTAG

## Troubleshooting

Se `jtagconfig` não detectar o hardware:

1. Verificar regras udev: `ls -la /etc/udev/rules.d/*usbblaster*`
2. Recarregar regras: `sudo udevadm control --reload-rules && sudo udevadm trigger`
3. Desconectar e reconectar o cabo USB
4. Verificar processo jtagd: `ps aux | grep jtagd`
5. Reiniciar jtagd se necessário: `killall jtagd && jtagd`

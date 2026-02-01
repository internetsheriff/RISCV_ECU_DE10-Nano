# Configuração do Switch de Modo do FPGA - DE10-Nano

## Localização do Switch

O switch de configuração do FPGA na DE10-Nano é o **SW10**, localizado na placa. É um switch de 6 posições que controla os pinos MSEL[4:0] do FPGA.

## Modos de Configuração Disponíveis

### 1. Modo JTAG (Recomendado para Desenvolvimento)

**Para programar via JTAG usando `quartus_pgm` ou `make program-sof`:**

| Switch | Posição | Valor MSEL |
|--------|---------|------------|
| SW10.1 (MSEL0) | **ON** (0) | 0 |
| SW10.2 (MSEL1) | **OFF** (1) | 1 |
| SW10.3 (MSEL2) | **ON** (0) | 0 |
| SW10.4 (MSEL3) | **ON** (0) | 0 |
| SW10.5 (MSEL4) | **OFF** (1) | 1 |
| SW10.6 | N/A | - |

**Código MSEL[4:0] = 10010**

**Características:**
- ✅ Permite programação direta via JTAG
- ✅ Ideal para desenvolvimento e debug
- ✅ Não requer cartão SD
- ⚠️ Configuração é **volátil** (perdida ao desligar)

### 2. Modo FPPx32 (Padrão - Boot do SD Card)

**Configuração padrão da placa (para boot do HPS):**

| Switch | Posição | Valor MSEL |
|--------|---------|------------|
| SW10.1 (MSEL0) | **ON** (0) | 0 |
| SW10.2 (MSEL1) | **OFF** (1) | 1 |
| SW10.3 (MSEL2) | **ON** (0) | 0 |
| SW10.4 (MSEL3) | **OFF** (1) | 1 |
| SW10.5 (MSEL4) | **ON** (0) | 0 |
| SW10.6 | N/A | - |

**Código MSEL[4:0] = 01010**

**Características:**
- Usado quando o HPS (ARM) configura o FPGA
- Requer cartão SD com imagem Linux
- Não é o modo ideal para programação direta via JTAG

### 3. Modo AS (Active Serial) - Programação Não-Volátil

**Para programar flash não-volátil (arquivo .pof):**

| Switch | Posição | Valor MSEL |
|--------|---------|------------|
| SW10.1 (MSEL0) | **ON** (0) | 0 |
| SW10.2 (MSEL1) | **OFF** (1) | 1 |
| SW10.3 (MSEL2) | **ON** (0) | 0 |
| SW10.4 (MSEL3) | **ON** (0) | 0 |
| SW10.5 (MSEL4) | **OFF** (1) | 1 |
| SW10.6 | N/A | - |

**Código MSEL[4:0] = 10010**

**Características:**
- Permite programar flash não-volátil
- Configuração persiste após desligar
- Requer arquivo `.pof` em vez de `.sof`

## Recomendação para Este Projeto

### Para Programação via JTAG (Desenvolvimento)

**Use o Modo JTAG: MSEL[4:0] = 10010**

```
SW10.1: ON  (0)
SW10.2: OFF (1)
SW10.3: ON  (0)
SW10.4: ON  (0)
SW10.5: OFF (1)
```

**Visualmente:**
```
SW10:  [ON] [OFF] [ON] [ON] [OFF] [X]
        ↓    ↓     ↓    ↓    ↓
       MSEL0 MSEL1 MSEL2 MSEL3 MSEL4
```

### Passos para Configurar

1. **Desligue a placa DE10-Nano** (importante para mudar switches)

2. **Localize o SW10** na placa (switch de 6 posições)

3. **Configure os switches** conforme tabela acima:
   - Use uma ferramenta pequena (palito, chave de fenda pequena)
   - ON = switch para baixo/posição 0
   - OFF = switch para cima/posição 1

4. **Ligue a placa** novamente

5. **Verifique a conexão**:
   ```bash
   jtagconfig
   # ou
   quartus_pgm --auto
   ```

6. **Programe o FPGA**:
   ```bash
   make program-sof
   ```

## Verificação Visual

Após configurar, o padrão visual do SW10 deve ser:
- **Posição 1**: Baixo (ON)
- **Posição 2**: Alto (OFF)
- **Posição 3**: Baixo (ON)
- **Posição 4**: Baixo (ON)
- **Posição 5**: Alto (OFF)
- **Posição 6**: Não usado

## Notas Importantes

1. **Sempre desligue a placa** antes de mudar os switches
2. **Verifique a configuração** visualmente antes de ligar
3. **Modo JTAG** é o mais conveniente para desenvolvimento
4. **Configuração é volátil** - ao desligar, o FPGA volta ao estado padrão
5. Se precisar de configuração permanente, use modo AS com arquivo `.pof`

## Referências

- DE10-Nano User Manual (Terasic)
- Intel Cyclone V Device Handbook
- Quartus Prime Programmer User Guide

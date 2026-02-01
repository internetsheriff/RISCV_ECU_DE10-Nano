# What Controls the Value of COUNT?

## Source Code Analysis

### 1. COUNT Definition

**File:** `quartus_project/sw/source_code/main.c`, line 10

```c
#define COUNT (REG(0x02000000))
```

**What it is:**
- `COUNT` is a **memory-mapped variable** at address `0x02000000`
- `REG(addr)` is defined as `(*((volatile uint32_t*) (addr)))` (line 7)
- It's a **32-bit volatile register** accessed directly at memory address `0x02000000`

**Memory Address:**
- `0x02000000` = 33,554,432 decimal
- This address is **NOT** defined in `mem_map.h`
- It's likely a location in the **on-chip memory** (RAM) used as a variable storage

---

## 2. What Controls COUNT - Code Analysis

### a) Initialization

**File:** `main.c`, line 148

```c
int main(int argc, char **argv){
    // Setup process
    COUNT = 0;  // ← Initializes COUNT to 0
    ...
}
```

**When:** At program startup, before interrupts are enabled

---

### b) Modification - Timer Interrupt Handler

**File:** `main.c`, lines 124-143

```c
void __attribute__((interrupt)) interrupt_test_handler(void){
    DEBUG(0x200);
    
    // clears interrupt on the interrupt controller
    REG(ICP) = (1 << 2);
    REG(TIMER+4) |= ~1;
    DEBUG(0x201);
    
    // clears timeout bit in the timer
    REG(TIMER) |= ~1;
    DEBUG(0x202);
    
    REG(PIO_OUT) = COUNT;  // ← Reads COUNT value
    
    // ← COUNT MODIFICATION LOGIC
    if(COUNT==7){
        COUNT = 0;      // Reset to 0 when reaching 7
    } else {
        COUNT ++;       // Increment by 1
    }
}
```

**What controls COUNT:**
1. **Timer interrupts** trigger `interrupt_test_handler()`
2. **Logic in the handler:**
   - If `COUNT == 7`: Set `COUNT = 0` (reset)
   - Otherwise: `COUNT++` (increment)

**Expected behavior:**
- COUNT cycles: 0 → 1 → 2 → 3 → 4 → 5 → 6 → 7 → 0 → 1 → ...

---

## 3. Complete Control Flow

```
Program Start
    ↓
main() executes
    ↓
COUNT = 0  (Initialization)
    ↓
enable_irq()  (Enable interrupts)
    ↓
setup_timer_interruption()  (Configure timer)
    ↓
Timer starts generating interrupts
    ↓
Every timer interrupt (≈0.36 µs with DEBUG_FLAG):
    ↓
interrupt_test_handler() is called
    ↓
Read COUNT value
    ↓
Write COUNT to PIO_OUT (LEDs)
    ↓
Modify COUNT:
    - If COUNT == 7: COUNT = 0
    - Else: COUNT++
    ↓
Return from interrupt
    ↓
Wait for next timer interrupt
```

---

## 4. What Could Cause COUNT to Go Beyond 7?

### Analysis of the Code Logic

**The code logic is:**
```c
if(COUNT==7){
    COUNT = 0;
} else {
    COUNT ++;
}
```

**This should:**
- Keep COUNT in range 0-7
- Reset to 0 when reaching 7
- Increment otherwise

**If COUNT goes beyond 7, possible causes:**

1. **Race Condition:**
   - If COUNT is read, then another interrupt occurs before the write
   - COUNT could be incremented multiple times
   - **However:** Interrupts are typically disabled during interrupt handlers

2. **Memory Corruption:**
   - If address `0x02000000` is accessed by hardware or another part of code
   - **However:** No other code in the source modifies this address

3. **Uninitialized Memory:**
   - If COUNT location contains garbage value initially
   - **However:** `COUNT = 0;` is explicitly set in `main()`

4. **Hardware Issue:**
   - If the memory location is not properly initialized
   - If there's a hardware bug in memory access

5. **Compiler/Optimization Issue:**
   - If the compiler optimizes the code incorrectly
   - If `volatile` is not properly handled

---

## 5. Memory Address Analysis

**COUNT address:** `0x02000000`

**Memory map from code:**
- `PIO_OUT` = `0x00200000` (2,097,152 decimal)
- `PIO_IN` = `0x00200020`
- `GPIO_0` = `0x00200040`
- `TIMER` = `0x002000A0`
- `onchip_memory2_0` starts at `0x00008000` (32,768 decimal)

**COUNT address `0x02000000`:**
- Decimal: 33,554,432
- This is **outside** the defined peripheral addresses
- Likely in **on-chip RAM** region

**Note:** The address `0x02000000` is **not explicitly defined** in the memory map headers, suggesting it's a **general-purpose memory location** used as a variable.

---

## 6. Summary: What Controls COUNT

### Direct Control (Software)

1. **Initialization:**
   - `COUNT = 0;` in `main()` (line 148)

2. **Modification:**
   - `interrupt_test_handler()` modifies COUNT (lines 138-142)
   - Logic: `if(COUNT==7) COUNT = 0; else COUNT++;`

### Indirect Control (Hardware/System)

1. **Timer:**
   - Generates interrupts that trigger the handler
   - Frequency: ~2.78 MHz (with DEBUG_FLAG)

2. **Interrupt System:**
   - Routes timer interrupts to `interrupt_test_handler()`
   - Enabled by `enable_irq()` and `setup_timer_interruption()`

3. **Memory System:**
   - Provides storage at address `0x02000000`
   - Must preserve COUNT value between interrupts

---

## 7. Conclusion

**COUNT is controlled by:**

1. **Initial value:** Set to 0 in `main()`
2. **Timer interrupts:** Trigger the modification logic
3. **Handler logic:** Increments COUNT (0→7) and resets to 0
4. **Memory location:** Stored at address `0x02000000` in on-chip RAM

**Expected behavior:**
- COUNT should cycle: 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, ...

**If COUNT goes beyond 7:**
- The code logic should prevent this
- Could indicate a bug, race condition, or hardware issue
- Not explained by the source code analysis

---

## References

- **COUNT definition:** `main.c:10`
- **COUNT initialization:** `main.c:148`
- **COUNT modification:** `main.c:138-142`
- **Memory map:** `mem_map.h`
- **Timer setup:** `main.c:34-59`
- **Interrupt enable:** `main.c:71-91`

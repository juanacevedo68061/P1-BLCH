# Proyecto de Circuito Aritmético con Circom y snarkJS

Este proyecto implementa un circuito aritmético en Circom para verificar la operación `c = (a² + b²) % p` utilizando pruebas de conocimiento cero (zk-SNARKs) con el protocolo Groth16 y la biblioteca `snarkJS`.

## Descripción del Circuito

El circuito `cuadrado_mod.circom` calcula `(a² + b²) % p`, donde:
- `a` y `b` son entradas privadas.
- `p` es un número primo (en este caso, `p = 23`).
- `c` es la salida pública, el residuo de `(a² + b²) % p`.

### Ejemplo
Para las entradas `a = 5` y `b = 7`:
- `a² = 25`, `b² = 49`.
- `suma = a² + b² = 25 + 49 = 74`.
- `c = 74 % 23 = 5`.

La salida pública generada (`public.json`) contiene `"5"`, que coincide con el cálculo esperado.

## Estructura del Proyecto

- **circuits/**: Archivos fuente de Circom.
  - `cuadrado_mod.circom`: Circuito principal.
- **scripts/**: Scripts para automatizar el flujo.
  - `compile.sh`: Compila el circuito.
  - `generate_proof.sh`: Genera la prueba zk-SNARK.
  - `verify.sh`: Verifica la prueba.
- **test/**: Archivos de prueba.
  - `test_inputs.json`: Entradas para el circuito (por ejemplo, `{"a": "5", "b": "7"}`).
- **build/**: Archivos generados.
  - `cuadrado_mod.r1cs`: Representación R1CS del circuito.
  - `cuadrado_mod.wasm`: WebAssembly para calcular el testigo.
  - `cuadrado_mod_final.zkey`: Clave de prueba final.
  - `proof.json`: Prueba zk-SNARK generada.
  - `public.json`: Salida pública.
  - `verification_key.json`: Clave de verificación.
- **powersOfTau28_hez_final_10.ptau**: Archivo "powers of tau" para el setup (descargado de Hermez).

## Requisitos

- Node.js y npm.
- `circom` (versión 2.2.2 o compatible): Compilador de circuitos.
- `snarkjs` (versión 0.7.5 o compatible): Herramienta para zk-SNARKs.

## Instrucciones para el Proyecto de Circuito Aritmético con Circom y snarkJS

Este README.md contiene únicamente las instrucciones detalladas para compilar, generar y verificar una prueba zk-SNARK para el circuito cuadrado_mod.circom, que calcula c = (a² + b²) % p. Incluye todos los pasos realizados durante el desarrollo del proyecto, con ejemplos de salidas y soluciones a problemas encontrados, para que puedas repetir el proceso o depurar si algo falla.

## Uso

Sigue estos pasos para compilar el circuito, generar una prueba zk-SNARK y verificarla. Todos los comandos deben ejecutarse desde el directorio raíz del proyecto (P1-BLCH). Cada paso incluye ejemplos de salidas obtenidas durante el desarrollo.

**1. Compilar el Circuito**
Compila cuadrado_mod.circom para generar los archivos necesarios:
```bash
./scripts/compile.sh
Esto ejecuta (basado en un script típico):
circom circuits/cuadrado_mod.circom --r1cs --wasm --sym -o build
```
**Genera:**
- build/cuadrado_mod.r1cs: Representación R1CS.
- build/cuadrado_mod_js/cuadrado_mod.wasm: WebAssembly para el testigo.
- build/cuadrado_mod.sym: Símbolos para depuración.

Ejemplo de salida al verificar los archivos generados:
```bash
ls -lh build/cuadrado_mod.r1cs build/cuadrado_mod_js/cuadrado_mod.wasm
# Salida obtenida:
# -rw-r--r-- 1 juan juan 1.2K Mar 20 15:54 build/cuadrado_mod.r1cs
# -rw-r--r-- 1 juan juan  34K Mar 20 15:54 build/cuadrado_mod_js/cuadrado_mod.wasm

Verifica que el archivo .r1cs sea válido:
snarkjs r1cs info build/cuadrado_mod.r1cs
# Salida obtenida:
# [INFO]  snarkJS: Curve: bn-128
# [INFO]  snarkJS: # of Wires: 9
# [INFO]  snarkJS: # of Constraints: 5
# [INFO]  snarkJS: # of Private Inputs: 2
# [INFO]  snarkJS: # of Public Inputs: 0
# [INFO]  snarkJS: # of Labels: 9
# [INFO]  snarkJS: # of Outputs: 1
```

## 2. Descargar el Archivo "Powers of Tau"
Necesitas un archivo powersOfTau para el setup. El proyecto incluye `powersOfTau28_hez_final_10.ptau`, que es suficiente para circuitos pequeños (hasta 2^10 constraints). Si no lo tienes, descárgalo:
```bash 
wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
```
En este proyecto, el archivo ya estaba presente:
```bash
ls -lh powersOfTau28_hez_final_10.ptau
# Salida obtenida:
# -rw-r--r-- 1 juan juan 5.3M Mar 20 16:00 powersOfTau28_hez_final_10.ptau
```

## 3. Generar la Clave de Prueba (.zkey)
Configura el setup para el protocolo Groth16 y genera una clave de prueba:
```bash
snarkjs groth16 setup build/cuadrado_mod.r1cs powersOfTau28_hez_final_10.ptau build/cuadrado_mod_0000.zkey
```
```bash
snarkjs zkey contribute build/cuadrado_mod_0000.zkey build/cuadrado_mod_final.zkey --name="1st Contributor" -v
```
- El primer comando genera una clave inicial (cuadrado_mod_0000.zkey).
- El segundo comando pide un texto aleatorio para agregar entropía:
  Enter a random text. (Entropy):
  Ingresa algo como MiEntropiaSecreta123 y presiona Enter. Esto genera build/cuadrado_mod_final.zkey.

Salida obtenida durante el proceso:
```bash
snarkjs zkey contribute build/cuadrado_mod_0000.zkey build/cuadrado_mod_final.zkey --name="1st Contributor" -v
# Salida parcial:
# [INFO]  snarkJS: Reading r1cs
# [INFO]  snarkJS: Reading tauG1
# [INFO]  snarkJS: Reading tauG2
# [INFO]  snarkJS: Reading alphatauG1
# [INFO]  snarkJS: Reading betatauG1
# [INFO]  snarkJS: Circuit hash:
#                 0141b9d6 5b663f3b 20029765 b6cb8ace
#                 5125edde a503a87b d945ed62 72e6acd9
#                 96642f6a 0ec14e52 bbba0fb8 23dcb67a
#                 6abaccc2 51ae6476 ea045583 29967c71
# Enter a random text. (Entropy): MiEntropiaSecreta123
# [INFO]  snarkJS: Contribution Hash: ...
```

Verifica que el archivo se creó:

```bash
ls -lh build/cuadrado_mod_final.zkey
# Salida obtenida:
# -rw-r--r-- 1 juan juan 4.9K Mar 20 16:11 build/cuadrado_mod_final.zkey
```

## 4. Generar la Prueba zk-SNARK
Usa las entradas en test/test_inputs.json ({"a": "5", "b": "7"}) para generar la prueba:
```bash
./scripts/generate_proof.sh
El script contiene:
#!/bin/bash
snarkjs groth16 fullprove test/test_inputs.json build/cuadrado_mod_js/cuadrado_mod.wasm build/cuadrado_mod_final.zkey build/proof.json build/public.json
```
Esto genera:
- build/proof.json: La prueba zk-SNARK.
- build/public.json: La salida pública (en este caso, "5").

**Nota**: *En snarkjs@0.7.5, este comando no muestra salida por defecto. Para ver detalles, ejecuta manualmente con -v:*
```bash
snarkjs groth16 fullprove test/test_inputs.json build/cuadrado_mod_js/cuadrado_mod.wasm build/cuadrado_mod_final.zkey build/proof.json build/public.json -v
# Salida obtenida:
# [DEBUG] snarkJS: Reading Wtns
# [DEBUG] snarkJS: Reading Coeffs
# [DEBUG] snarkJS: Building ABC
# [DEBUG] snarkJS: QAP AB: 0/6
# [DEBUG] snarkJS: QAP C: 0/8
# [DEBUG] snarkJS: IFFT_A: fft 3 mix start: 0/1
# [DEBUG] snarkJS: IFFT_A: fft 3 mix end: 0/1
# [DEBUG] snarkJS: FFT_A: fft 3 mix start: 0/1
# [DEBUG] snarkJS: FFT_A: fft 3 mix end: 0/1
# [DEBUG] snarkJS: IFFT_B: fft 3 mix start: 0/1
# [DEBUG] snarkJS: IFFT_B: fft 3 mix end: 0/1
# [DEBUG] snarkJS: FFT_B: fft 3 mix start: 0/1
# [DEBUG] snarkJS: FFT_B: fft 3 mix end: 0/1
# [DEBUG] snarkJS: IFFT_C: fft 3 mix start: 0/1
# [DEBUG] snarkJS: IFFT_C: fft 3 mix end: 0/1
# [DEBUG] snarkJS: FFT_C: fft 3 mix start: 0/1
# [DEBUG] snarkJS: FFT_C: fft 3 mix end: 0/1
# [DEBUG] snarkJS: Join ABC
# [DEBUG] snarkJS: JoinABC: 0/8
# [DEBUG] snarkJS: Reading A Points
# [DEBUG] snarkJS: Multiexp start: multiexp A: 0/9
# [DEBUG] snarkJS: Multiexp end: multiexp A: 0/9
# [DEBUG] snarkJS: Reading B1 Points
# [DEBUG] snarkJS: Multiexp start: multiexp B1: 0/9
# [DEBUG] snarkJS: Multiexp end: multiexp B1: 0/9
# [DEBUG] snarkJS: Reading B2 Points
# [DEBUG] snarkJS: Multiexp start: multiexp B2: 0/9
# [DEBUG] snarkJS: Multiexp end: multiexp B2: 0/9
# [DEBUG] snarkJS: Reading C Points
# [DEBUG] snarkJS: Multiexp start: multiexp C: 0/7
# [DEBUG] snarkJS: Multiexp end: multiexp C: 0/7
# [DEBUG] snarkJS: Reading H Points
# [DEBUG] snarkJS: Multiexp start: multiexp H: 0/8
# [DEBUG] snarkJS: Multiexp end: multiexp H: 0/8
```
Verifica que los archivos se generaron:
```bash
ls -lh build/proof.json build/public.json
# Salida obtenida:
# -rw-r--r-- 1 juan juan 806 Mar 20 16:41 build/proof.json
# -rw-r--r-- 1 juan juan   8 Mar 20 16:41 build/public.json
```
Inspecciona la salida pública:
```bash
cat build/public.json
# Salida obtenida:
# ["5"]
```

## 5. Verificar la Prueba
Exporta la clave de verificación y verifica la prueba:
```bash
snarkjs zkey export verificationkey build/cuadrado_mod_final.zkey build/verification_key.json
snarkjs groth16 verify build/verification_key.json build/public.json build/proof.json
Salida obtenida:
snarkjs zkey export verificationkey build/cuadrado_mod_final.zkey build/verification_key.json
# [INFO]  snarkJS: EXPORT VERIFICATION KEY STARTED
# [INFO]  snarkJS: > Detected protocol: groth16
# [INFO]  snarkJS: EXPORT VERIFICATION KEY FINISHED
snarkjs groth16 verify build/verification_key.json build/public.json build/proof.json
# [INFO]  snarkJS: OK!
Esto confirma que la prueba es válida.
```
Alternativamente, usa el script:
```bash
./scripts/verify.sh
# Salida esperada:
# [INFO]  snarkJS: OK!
```

## 6. Probar con Nuevas Entradas (Opcional)
Edita test/test_inputs.json con nuevos valores para a y b, por ejemplo:
{
    "a": "3",
    "b": "4"
}
Cálculo esperado:
- a² = 3 * 3 = 9, b² = 4 * 4 = 16.
- suma = 9 + 16 = 25.
- c = 25 % 23 = 2.

Repite los pasos 4 y 5 para generar y verificar una nueva prueba:
```bash
./scripts/generate_proof.sh
snarkjs groth16 verify build/verification_key.json build/public.json build/proof.json
```
```bash
Verifica la nueva salida:
cat build/public.json
# Salida esperada:
# ["2"]
```
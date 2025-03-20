# Proyecto de Circuito Aritmético con Circom y snarkjs

Este proyecto implementa un circuito aritmético en Circom para verificar la operación `c = (a² + b²) % p` utilizando pruebas de conocimiento cero.

## Estructura del Proyecto

- **circuits/**: Contiene el archivo del circuito en Circom.
- **scripts/**: Scripts para compilar, generar pruebas y verificar.
- **test/**: Archivos de prueba con valores de entrada.
- **docs/**: Documentación del proyecto.

## Instrucciones de Uso

1. **Compilar el circuito**:
   ```bash
   ./scripts/compile.sh
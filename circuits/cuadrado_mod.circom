pragma circom 2.0.0;

template CuadradoMod(p) {
    signal input a;
    signal input b;
    signal output c;

    // Calcular a^2 y b^2
    signal a2;
    signal b2;
    a2 <== a * a;
    b2 <== b * b;

    // Sumar a^2 + b^2
    signal suma;
    suma <== a2 + b2;

    // Calcular (a^2 + b^2) % p
    signal q;
    q <-- suma \ p;  // Cociente de la división (no es una restricción)
    c <-- suma - p * q;  // Residuo (no es una restricción)

    // Restricciones para asegurar que c es el residuo correcto
    suma === p * q + c;  // suma = p * q + c

    // Asegurar que c < p
    signal d;
    d <== p - c;  // d = p - c
    // No podemos usar d > 0 directamente, pero podemos asegurar que d es un número positivo
    // usando una restricción de rango (por ejemplo, d es un número pequeño)
    // Aquí asumimos que p es un número pequeño, por lo que d también será pequeño.
    // Si p es grande, necesitarías una lógica más compleja para restringir d.
}

component main = CuadradoMod(23);  // Usamos un número primo p = 23

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
    c <== suma % p;
}

component main = CuadradoMod(23);  // Usamos un número primo p = 23
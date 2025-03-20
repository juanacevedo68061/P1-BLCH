#!/bin/bash
snarkjs groth16 fullprove test/test_inputs.json build/cuadrado_mod_js/cuadrado_mod.wasm build/cuadrado_mod_final.zkey build/proof.json build/public.json

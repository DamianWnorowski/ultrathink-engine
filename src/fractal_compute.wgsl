@group(0) @binding(0) var<storage, read_write> weights: array<array<f32, 1024>, 64>;

@group(0) @binding(1) var<uniform> params: Params;

struct Params {
    delta: f32,
    cycle: u32,
    padding: vec2<f32>,
};

@compute @workgroup_size(64, 1, 1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
    let x = id.x % 1024u;
    let y = id.x / 1024u;
    
    if (y >= 64u) { return; }
    
    // Fractal weight update: z → z² + c
    var z = weights[y][x];
    let c = params.delta * sin(f32(x) * 0.1) + cos(f32(y) * 0.05);
    
    z = z * z + c;
    
    // Micro/macro coupling
    let macro_weight = weights[y / 16u][x / 64u];
    z = mix(z, macro_weight, 0.1);
    
    // Chaos injection (deterministic)
    let chaos = fract(sin(f32(id.x + params.cycle)) * 43758.5453);
    z += (chaos - 0.5) * 0.01;
    
    weights[y][x] = clamp(z, -2.0, 2.0);
}
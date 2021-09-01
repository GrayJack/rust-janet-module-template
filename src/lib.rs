use janetrs::{declare_janet_mod, janet_fn, jpanic, Janet, JanetTuple, TaggedJanet};

/// (template/hello)
///
/// Rust say hello
#[janet_fn(arity(fix(0)))]
pub fn rust_hello(_args: &mut [Janet]) -> Janet {
    println!("Hello from Rust!");
    Janet::nil()
}

/// (template/chars)
///
/// If the argument is a buffer or string, return a array or tuple of the chars of the argument,
/// else return nil
#[janet_fn(arity(fix(1)))]
pub fn chars(args: &mut [Janet]) -> Janet {
    match args[0].unwrap() {
        TaggedJanet::Buffer(b) => b.chars().collect::<JanetTuple>().into(),
        TaggedJanet::String(s) => s.chars().collect::<JanetTuple>().into(),
        _ => jpanic!(
            "bad slot #0, expected string|buffer, got {}",
            args[0].kind()
        ),
    }
}

declare_janet_mod!("template";
    {"hello", rust_hello},
    {"chars", chars},
);

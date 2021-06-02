use janetrs::{janet_fn, janet_mod, jpanic, util::check_fix_arity, Janet, JanetTuple, TaggedJanet};

#[janet_fn]
pub fn rust_hello(args: &mut [Janet]) -> Janet {
    check_fix_arity(args, 0);
    println!("Hello from Rust!");
    Janet::nil()
}

#[janet_fn]
pub fn chars(args: &mut [Janet]) -> Janet {
    check_fix_arity(args, 1);
    match args[0].unwrap() {
        TaggedJanet::Buffer(b) => b.chars().collect::<JanetTuple>().into(),
        TaggedJanet::String(s) => s.chars().collect::<JanetTuple>().into(),
        _ => jpanic!(
            "bad slot #0, expected string|buffer, got {}",
            args[0].kind()
        ),
    }
}

janet_mod!("template";
    {"hello", rust_hello, "(template/hello)\n\nRust say hello"},
    {"chars", chars, "(template/chars)\n\nIf the argument is a buffer or string, return a array or \
    tuple of the chars of the argument, else return nil"},
);

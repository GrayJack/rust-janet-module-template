use janetrs::{
    janet_fn, janet_mod, jpanic,
    types::{Janet, JanetBuffer, JanetString, JanetTuple, JanetType},
    util::check_fix_arity,
};

#[janet_fn]
pub fn rust_hello(args: &mut [Janet]) -> Janet {
    check_fix_arity(args, 0);
    println!("Hello from Rust!");
    Janet::nil()
}

#[janet_fn]
pub fn chars(args: &mut [Janet]) -> Janet {
    check_fix_arity(args, 1);
    match args[0].kind() {
        JanetType::Buffer => args[0]
            .unwrap::<JanetBuffer>()
            .unwrap()
            .chars()
            .collect::<JanetTuple>()
            .into(),
        JanetType::String => args[0]
            .unwrap::<JanetString>()
            .unwrap()
            .chars()
            .collect::<JanetTuple>()
            .into(),
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

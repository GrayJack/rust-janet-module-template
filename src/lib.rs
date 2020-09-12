use janetrs::{
    janet_fn, janet_mod, jpanic,
    types::{Janet, JanetTuple, TaggedJanet},
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
    match args[0].unwrap() {
        TaggedJanet::Buffer(buf) => buf.chars().collect::<JanetTuple>().into(),
        TaggedJanet::String(s) => s.chars().collect::<JanetTuple>().into(),
        x => jpanic!("bad slot #0, expected string|buffer, got {}", x.kind()),
    }
}

janet_mod!("template";
    {"hello", rust_hello, "(template/hello)\n\nRust say hello"},
    {"chars", chars, "(template/chars)\n\nIf the argument is a buffer or string, return a array or \
    tuple of the chars of the argument, else return nil"},
);

(declare-project
  :name "template"
  :dependencies ["https://github.com/andrewchambers/janet-sh.git"])

(post-deps
  (import sh)

  (declare-native
    :name "template"
    :source [])

  (phony "build-rust-code" []
    (sh/$ cargo build --release --target-dir target --quiet))

  (phony "cp-lib" []
    (sh/$ mkdir -p build)
    (sh/$ cp target/release/libtemplate.so build/template.so)
    (sh/$ cp target/release/libtemplate.a build/template.a))

  (phony "all" ["build-rust-code" "cp-lib"])

  (add-dep "build" "all")
)

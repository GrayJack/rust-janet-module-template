(declare-project
  :name "template")

(post-deps
  (declare-native
    :name "template"
    :source [])

  (phony "build-rust-code" []
    (os/execute ["cargo" "build" "--release" "--target-dir" "target" "--quiet"] :p))

  (phony "cp-lib" []
    (os/execute ["mkdir" "-p" "build"] :p)
    (os/execute ["cp" "target/release/libtemplate.so" "build/template.so"] :p)
    (os/execute ["cp" "target/release/libtemplate.a" "build/template.a"] :p))

  (phony "build-debug" []
    (os/execute ["cargo" "build" "--debug" "--target-dir" "target" "--quiet"] :p)
    (os/execute ["mkdir" "-p" "build"] :p)
    (os/execute ["cp" "target/debug/libtemplate.so" "build/template.so"] :p)
    (os/execute ["cp" "target/debug/libtemplate.a" "build/template.a"] :p))

  (phony "all" ["build-rust-code" "cp-lib"])

  (add-dep "build" "all")

  (phony "clean-target" []
    (os/execute ["rm" "-rf" "target"] :p))

  (add-dep "clean" "clean-target")
)

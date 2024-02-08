(declare-project
  :name "template")

(post-deps
  (declare-native
    :name "template"
    :source [])

  (phony "build-release" []
    (os/execute ["mkdir" "-p" "build"] :p)
    (os/execute ["cargo" "build" "--release" "--target-dir" "target" "--quiet"] :p)
    (os/execute ["cp" "target/release/libtemplate.a" "build/template.a"] :p)
    (let [os (os/which)]
      (if (= os :linux)
        (os/execute ["cp" "target/release/libtemplate.so" "build/template.so"] :p))
      (if (= os :macos)
        (os/execute ["cp" "target/release/libtemplate.dylib" "build/template.dylib"] :p))
      (if (= os :windows)
        (os/execute ["cp" "target/release/template.dll" "build/template.dll"] :p))))

  (phony "build-debug" []
    (os/execute ["cargo" "build" "--debug" "--target-dir" "target" "--quiet"] :p)
    (os/execute ["mkdir" "-p" "build"] :p)
    (os/execute ["cp" "target/debug/libtemplate.a" "build/template.a"] :p)
    (let [os (os/which)]
      (if (= os :linux)
        (os/execute ["cp" "target/debug/libtemplate.so" "build/template.so"] :p))
      (if (= os :macos)
        (os/execute ["cp" "target/debug/libtemplate.dylib" "build/template.dylib"] :p))
      (if (= os :windows)
        (os/execute ["cp" "target/debug/template.dll" "build/template.dll"] :p))))

  (phony "all" ["build-release"])

  (add-dep "build" "all")

  (phony "clean-target" []
    (os/execute ["rm" "-rf" "target"] :p))

  (add-dep "clean" "clean-target"))

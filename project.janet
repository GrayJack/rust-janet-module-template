(declare-project
  :name "template")

(defn declare-rust
  "Declare a native Rust module."
  [&keys opts]
  (def name (opts :name))
  (def rs-name (string/replace-all "-" "_" name))
  (def cargo-extra-args (opts :cargo-extra-args))
  (def build-type (dyn :build-type "release"))
  (def modext (dyn :modext))
  (def statext (dyn :statext))
  (def build-dir (find-build-dir))
  (def os (os/which))
  (def path (string (dyn :modpath) "/" (dirname name)))

  (def rs-build-target
    (match build-type
      "release" "target/release/lib"
      "debug" "target/debug/lib"
      "develop" "target/debug/lib"))
  (def os-dyn-extension
    (match os
      :linux ".so"
      :macos ".dylib"
      :windows ".dll"
      x (errorf "unsupported OS %s" x)))

  (def lname (string build-dir name modext))
  (def lname2 (string build-dir name os-dyn-extension))
  (def sname (string build-dir name statext))

  (rule "cargo" []
        (def release?
          (match build-type
            "release" "--release"
            "debug" ""
            "develop" ""))
        (os/execute ["cargo" "build" release? "--target-dir" "target" "--quiet" ;cargo-extra-args] :p))

  (rule "mv2build" ["cargo"]
        (copyfile (string rs-build-target rs-name statext) sname)
        (copyfile (string rs-build-target rs-name os-dyn-extension) lname2)
        (copyfile (string rs-build-target rs-name os-dyn-extension) lname))

  (add-output "mv2build" sname)
  (add-output "mv2build" lname)
  (add-output "mv2build" (string build-dir name os-dyn-extension))
  (add-dep "build" "mv2build")
  (install-rule lname path)
  (install-rule sname path)

# Add meta file
  (def metaname (modpath-to-meta lname))
  (def ename (entry-name name))
  (rule metaname []
        (print "generating meta file " metaname "...")
        (flush)
        (os/mkdir (find-build-dir))
        (create-dirs metaname)
        (spit metaname (string/format
                        "# Metadata for static library %s\n\n%.20p"
                        (string name statext)
                        {:static-entry ename
                         :cpp false
                         :ldflags ~',(opts :ldflags)
                         :lflags ~',(opts :lflags)})))
  (add-dep "build" metaname)
  (install-rule metaname path)

  (rule "clean-target" []
        (os/execute ["cargo" "clean" "--target-dir" "target"] :p))
  (add-dep "clean" "clean-target"))


(declare-rust
  :name "template"
  :cargo-extra-args [])


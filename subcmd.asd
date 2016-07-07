(defsystem :subcmd
  :description "Subcommand"
  :version "0.1"
  :license "MIT"
  :pathname #P"src/"
  :serial t
  :components
  ((:file "package")
   (:file "subcmd"))
  :in-order-to ((test-op (test-op subcmd-test))))

(defsystem :subcmd-test
  :description "Unit tests for subcmd"
  :depends-on (#:subcmd #:prove)
  :defsystem-depends-on (:prove-asdf)
  :pathname #P"test/"
  :components
  ((:test-file "test-all"))
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))


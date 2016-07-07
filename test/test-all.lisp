(in-package :subcmd)
(use-package :prove)

(define-command "spam"
                :fn (lambda (&rest argv)
                      (declare (ignore argv))
                      "spamspam")
                :documentation "spam test")
(define-command "ham"
                :fn (lambda (&rest argv)
                      (declare (ignore argv))
                      "hamham")
                :documentation "ham test")

(plan 4)

(is "spam test"
    (command-documentation
      (gethash "spam" *command-container*))
    :test #'equal)
(is "spamspam"
    (funcall (command-implementation
               (gethash "spam" *command-container*)))
    :test #'equal)
(is "ham test"
    (command-documentation
      (gethash "ham" *command-container*))
    :test #'equal)
(is "hamham"
    (funcall (command-implementation
               (gethash "ham" *command-container*)))
    :test #'equal)

(finalize)

; (plan 2)
;
; (is-type)
;
; (finalize)


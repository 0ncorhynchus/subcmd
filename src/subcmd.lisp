(in-package :subcmd)

(defvar *command-container*
  (make-hash-table :test #'equal))
(defvar *command-max-length* 0)

(defstruct command
  (name          "" :type string)
  (implementation nil)
  (documentation "" :type string))

(defmacro define-command (var &key
                         (fn nil)
                         (documentation ""))
  `(progn
     (when (> (length ,var) *command-max-length*)
       (setf *command-max-length* (length ,var)))
     (setf (gethash ,var *command-container*)
           (make-command
             :name ,var
             :implementation ,fn
             :documentation ,documentation))))

(defun help (&rest args)
  (format t "~a~%" (usage)))

(defun get-command (argv)
  (let ((command (gethash (first argv) *command-container*)))
    (if command
      (values (command-implementation command) (rest argv))
      (values nil (rest argv)))))

(defun call-command (argv)
  (multiple-value-bind (fn argv) (get-command argv)
    (if fn
      (apply fn argv)
      (help))))

(defun usage ()
  (let ((usage (format nil "Commands:~%")))
    (loop for key being the hash-keys of *command-container*
          using (hash-value value)
          do (setf usage
                   (concatenate
                     'string
                     usage
                     (format nil "  ~va  ~@(~a~)~%"
                             *command-max-length*
                             key
                             (command-documentation value)))))
    usage))


(define-command "help"
  :fn #'help :documentation "print help")

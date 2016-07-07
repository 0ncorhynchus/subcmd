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

(defun get-command (argv)
  (let ((str (first argv)))
    (values (command-implementation
              (gethash str *command-container*))
            (rest argv))))

(defun call-command (argv)
  (multiple-value-bind (fn argv) (get-command argv)
    (apply fn argv)))

(defun usage ()
  (let ((usage (format nil "Commands:~%")))
    (with-hash-table-iterator (itr *command-container*)
      (loop
        (multiple-value-bind (entry-p key value) (itr)
          (if entry-p
            (setf usage
                  (concatenate
                    'string
                    usage
                    (format nil "  ~va  ~a~%"
                            *command-max-length*
                            key
                            (command-documentation value))))
            (return))))
      usage)))

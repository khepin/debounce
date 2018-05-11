#lang racket/base
(require racket/cmdline)

;;; Tries to read a single line, or returns on timeout
(define (read-line-timeout timeout)
    (sync/timeout
        timeout
        (thread (λ () (read-line)))))

;;; Waits to read a first line then consumes all incoming input
;;; as long as the next input arrives before last input + timeout
(define (read-lines timeout)
    (read-line)
    (let loop ()
        (when (read-line-timeout timeout)
            (loop))))

;;; Consume all input as long as inputs come within timeout of each other
;;; print outpout line
;;; repeat forever
(define (read-many-wait-print timeout)
    (let loop ()
        (when (read-lines timeout)
            (begin
                (println "debounce")
                (loop)))))

(module+ main
    (command-line
        #:program "debounce"
        #:usage-help
            "debounce will consume all stdin input and keep consuming as long as inputs comme within <timeout> milliseconds of each other."
            "After the timeout period, it will output a single line with the content: `debounce`"
            ""
            "Usage:"
            "   debounce <timeout>"
            "Args:"
            "   timeout: the timeout period in milliseconds"
        #:args (timeout)
        ;;; Catch Ctrl+C and exit cleanly
        (parameterize-break #t
            (with-handlers ([exn:break? (lambda (x) (void))])
                (read-many-wait-print (/ (string->number timeout) 1000))))))
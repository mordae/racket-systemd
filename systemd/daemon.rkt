#lang racket/base
;
; SystemD: Daemon Utilities
;

(require
  (rename-in ffi/unsafe (-> -->)))

(require racket/contract
         ffi/unsafe/define)

(provide
  (contract-out
    (sd-notify (-> string? void?))
    (sd-port (-> exact-nonnegative-integer? (values input-port? output-port?)))
    (sd-port-count (-> exact-nonnegative-integer?))))


(define-ffi-definer define-sd (ffi-lib "libsystemd-daemon" '("0" "")))
(define-ffi-definer define-scheme #f)


(define-scheme scheme_socket_to_ports
               (_fun (fd : _intptr)
                     (name : _string/utf-8)
                     (close? : _bool = #f)
                     (in : (_ptr o _scheme))
                     (out : (_ptr o _scheme))
                     --> _void
                     --> (values in out)))

(define-sd sd_listen_fds
           (_fun (_int = 0) --> _int))

(define-sd sd_is_socket
           (_fun (fd : _int)
                 (family : (_enum '(unspec local inet inet6 = 10)))
                 (type : (_enum '(any stream dgram)))
                 (listen? : _bool)
                 --> (result  : _bool)))

(define-sd sd_notify
           (_fun (_int = 0)
                 (state : _string/locale)
                 --> (result : _int)
                 --> (cond
                       ((= result 0) 'no-systemd)
                       ((< result 0) 'failed)
                       ((> result 0) 'notified))))


(define (sd-notify state)
  (when (eq? (sd_notify state) 'failed)
    (error 'sd-notify "unknown error, possibly invalid state specified")))


(define (sd-port index)
  (let ((fd (+ index 3)))
    (cond
      ((<= (sd_listen_fds) index)
       (error 'sd-port "no systemd file descriptor ~a" fd))

      ((sd_is_socket fd 'inet 'stream #f)
       (scheme_socket_to_ports fd "systemd-inet"))

      ((sd_is_socket fd 'inet6 'stream #f)
       (scheme_socket_to_ports fd "systemd-inet6"))

      (else (error 'sd-port "unsupported file descriptor ~a type" fd)))))


(define (sd-port-count)
  (let ((result (sd_listen_fds)))
    (if (>= result 0)
        (values result)
        (error 'sd-port-count "unknown error"))))


; vim:set ts=2 sw=2 et:

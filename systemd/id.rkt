#lang racket/base
;
; SystemD: 128-bit Identificator Utilities
;

(require
  (rename-in ffi/unsafe (-> -->)))

(require racket/contract
         ffi/unsafe/define
         openssl/sha1)

(provide
  (contract-out
    (sd-id? predicate/c)
    (sd-random-id (-> string?))
    (sd-machine-id (-> string?))
    (sd-boot-id (-> string?))))


(define-ffi-definer define-sd (ffi-lib "libsystemd-id128" '("0" "")))


(define-sd sd-random-id
           (_fun (id : (_bytes o 16))
                 --> (result : _int)
                 --> (if (= 0 result)
                         (bytes->hex-string id)
                         (error 'sd-random-id "failed to generate")))
           #:c-id sd_id128_randomize)

(define-sd sd-machine-id
           (_fun (id : (_bytes o 16))
                 --> (result : _int)
                 --> (if (= 0 result)
                         (bytes->hex-string id)
                         (error 'sd-machine-id "failed to retrieve")))
           #:c-id sd_id128_get_machine)

(define-sd sd-boot-id
           (_fun (id : (_bytes o 16))
                 --> (result : _int)
                 --> (if (= 0 result)
                         (bytes->hex-string id)
                         (error 'sd-boot-id "failed to retrieve")))
           #:c-id sd_id128_get_boot)

(define (sd-id? value)
  (and (string? value)
       (regexp-match? #px"^[0-9a-f]{32}$" value)))


; vim:set ts=2 sw=2 et:

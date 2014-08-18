#lang scribble/manual

@require[scribble/eval]

@require[(for-label racket)
         (for-label "daemon.rkt")]

@title{Daemon}

@defmodule[systemd/daemon]

@defproc[(sd-notify (state string?)) (symbols 'no-systemd 'failed 'notified)]{
  Informs systemd about changed daemon state. This takes a number of
  newline separated environment-style variable assignments in a
  string.
}

@defproc[(sd-port-count) exact-nonnegative-integer?]{
  Returns how many file descriptors have been passed.
}

@defproc[(sd-port (index exact-nonnegative-integer?))
         (values input-port? output-port?)]{
  Obtains ports for file descriptor at specified position.
  Only IPv4 and IPv6 descriptors are currently supported.
}


@; vim:set ft=scribble sw=2 ts=2 et:

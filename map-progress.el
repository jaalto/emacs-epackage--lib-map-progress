;;; map-progress.el --- mapping macros that report progress

;; Copyright (C) 2010  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20100714
;; Updated: 20100714
;; Version: 0.1
;; Homepage: https://github.com/tarsius/map-progress/
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library defines mapping macros that report progress.

;; For many of the standard and CL mapping functions like `mapc' macros
;; like `mapc-with-progress-reporter' are defined here.  The arguments
;; have the same meaning as the respective arguments of the respective
;; function and `make-progress-reporter', which ever has an argument by
;; the same name.

;; Even when the respective function supports multiple sequences the
;; macros defined here only support one.  One the other hand all of the
;; `make-progress-reporter' arguments except for MESSAGE are optional.
;; This includes the starting and final state argument.

;; Any mapping function with only exactly two mandatory arguments - a
;; function which is applied to a sequence - are supported by
;; `map-with-progress-reporter' which can be used when no specialized
;; macro corresponding to a particular function exists, but additional
;; arguments are not supported.

;; Therefor at least the following functions are not supported: `map'.
;; However support for the following divergent mapping functions has
;; been implemented: .

;;; Code:

(eval-when-compile
  (require 'cl))

(defmacro map-with-progress-reporter (msg map fn seq &optional min max &rest rest)
  "Apply FUNCTION to each element of SEQUENCE using mapping function MAP.
Report progress in the echo.  Also see `make-progress-reporter'.
\(fn MESSAGE MAP FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  (let ((idx (make-symbol "--progress-mapcan-idx--"))
	(lst (make-symbol "--progress-mapcan-lst--"))
	(prg (make-symbol "--progress-mapcan-prg--"))
	(elt (make-symbol "--progress-mapcan-elt--")))
    `(let* ((,idx 0)
	    (,lst ,seq)
	    (,prg (make-progress-reporter
		   ,msg (or ,min 0) (or ,max (length ,lst)) ,@rest)))
       (prog1 (funcall ,map (lambda (,elt)
			      (prog1 (funcall ,fn ,elt)
				(progress-reporter-update ,prg (incf ,idx))))
		       ,lst)
	 (progress-reporter-done ,prg)))))

(defmacro mapc-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapc' but report progress in the echo area.
Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapc ,fn ,seq ,min ,max ,@rest))

(defmacro mapcan-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapcan' but report progress in the echo area.
There may be only one SEQUENCE.  Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapcan ,fn ,seq ,min ,max ,@rest))

(defmacro mapcar-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapcar' but report progress in the echo area.
Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapcar ,fn ,seq ,min ,max ,@rest))

(defmacro mapcon-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapcon' but report progress in the echo area.
There may be only one SEQUENCE.  Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapcon ,fn ,seq ,min ,max ,@rest))

(defmacro mapl-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapl' but report progress in the echo area.
There may be only one SEQUENCE.  Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapl ,fn ,seq ,min ,max ,@rest))

(defmacro maplist-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `maplist' but report progress in the echo area.
There may be only one SEQUENCE.  Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION SEQUENCE [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'maplist ,fn ,seq ,min ,max ,@rest))

(defmacro mapatoms-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `mapatoms' but report progress in the echo area.
Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION [OBARRAY MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'mapatoms ,fn ,seq ,min ,max ,@rest))

(defmacro maphash-with-progress-reporter (msg fn seq &optional min max &rest rest)
  "Like `maphash' but report progress in the echo area.
Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION HASH [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'maphash ,fn ,seq ,min ,max ,@rest))

(defmacro map-keymap-internal-with-progress-reporter (msg fn seq
							  &optional min max
							  &rest rest)
  "Like `map-keymap-internal' but report progress in the echo area.
Also see `make-progress-reporter'.
\(fn MESSAGE FUNCTION KEYMAP [MIN-VALUE MAX-VALUE CURRENT-VALUE MIN-CHANGE MIN-TIME])"
  `(map-with-progress-reporter ,msg 'map-keymap-internal ,fn ,seq ,min ,max ,@rest))

(provide 'map-progress)
;;; map-progress.el ends here
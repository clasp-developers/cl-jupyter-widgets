(defpackage #:fredokun-utilities
  (:nicknames #:fredo-utils)
  (:use #:cl)
  (:export #:*example-enabled*
           #:*example-equal-predicate*
           #:example
           #:example-progn
           #:*logg-enabled*
           #:*logg-level*
           #:logg
           #:vbinds
           #:afetch
	   #:while
	   #:read-file-lines
	   #:read-string-file
	   #:read-binary-file
	   #:quit))

(defpackage #:myjson
  (:use #:cl #:fredo-utils)
  (:export #:parse-json
	   #:parse-json-from-string
	   #:encode-json
	   #:encode-json-to-string))

(defpackage #:cl-jupyter
  (:use #:cl #:fredo-utils #:myjson)
  (:export 
   #:display
   #:display-plain render-plain
   #:display-html render-html
   #:display-markdown render-markdown
   #:display-latex render-latex
   #:display-png render-png
   #:display-jpeg render-jpeg
   #:display-svg render-svg
   #:display-json render-json
   #:display-javascript render-javascript
   #:message-header
   #:message-content
   #:message-buffers
   #:message
   #:*shell*
   #:*kernel*
   #:*parent-msg*
   #:*default-special-bindings*
   #:kernel-start))

(defpackage #:cl-jupyter-user
  (:use #:cl #:fredo-utils #:cl-jupyter #:common-lisp-user)
  (:export 
   #:display
   #:display-plain render-plain
   #:display-html render-html
   #:display-markdown render-markdown
   #:display-latex render-latex
   #:display-png render-png
   #:display-jpeg render-jpeg
   #:display-svg render-svg
   #:display-json render-json
   #:display-javascript render-javascript
   #:html #:latex #:svg
   #:png-from-file
   #:svg-from-file
   #:quit))


(defpackage #:cl-jupyter-widgets
  (:nicknames #:cljw)
  (:use #:cl)
  (:shadow #:open #:close #:step #:min #:max)
  (:export
   #:*kernel-start-hook*
   #:*kernel-shutdown-hook*
   #:*handle-comm-open-hook*
   #:*handle-comm-msg-hook*
   #:*handle-comm-close-hook*
   #:*send-updates*
   #:notify-change
   #:widget-display
   #:widget
   #:widget-open
   #:widget-send
   #:widget-close
   #:domwidget
   #:int-slider
   #:image
   #:bool
   #:dict
   #:unicode
   #:cunicode
   #:tuple
   #:color
   #:instance
   #:on-msg
   #:on-displayed
<<<<<<< HEAD
=======
   #:assoc-value
>>>>>>> master
   ))


(defpackage #:traitlets
  (:use #:cl)
  (:export #:traitlet-class #:synced-object)
  (:export #:traitlet-metadata
	   #:effective-traitlet))


(in-package #:cl-jupyter)

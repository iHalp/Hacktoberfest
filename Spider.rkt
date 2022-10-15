;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname handin-2022-09-21T14_07_14) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; ================= Spider!
;; Constants:

(define WIDTH 400)
(define HEIGHT 600)

(define CTR-X (/ WIDTH 2))

(define SPIDER-RADIUS 10)

(define TOP (+ 0        SPIDER-RADIUS))
(define BOT (- HEIGHT 1 SPIDER-RADIUS))

(define MID (/ HEIGHT 2))


(define SPIDER-IMAGE (circle SPIDER-RADIUS "solid" "black"))

(define MTS (empty-scene WIDTH HEIGHT))


;; =================
;; Data definitions:
(define-struct spider (y dy))
;; Spider is (make-spider Number Number)
;; interp. y is spider's vertical position in screen coordinates (pixels)
;;         dy is velocity in pixels per tick, + is down, - is up
;; CONSTRAINT: to be visible, must be in
;;             [TOP, BOT] which is [SPIDER-RADIUS, HEIGHT - SPIDER-RADIUS]
(define S-TOP-D (make-spider TOP  3))   ;top going down
(define S-MID-D (make-spider MID  3))   ;middle going down
(define S-MID-U (make-spider MID -3))   ;middle going up
(define S-BOT-U (make-spider BOT -3))   ;bottom going up


;; =================
;; Functions:


(define (main s)
  (big-bang s                     ; Spider
    (on-tick   tock)              ; Spider -> Spider
    (to-draw   render)            ; Spider -> Image
    (on-key    reverse-spider)))  ; Spider KeyEvent -> Spider


;; change direction of spider on space, unchanged for other keys

; 1 - going down and ke is space
(check-expect (reverse-spider (make-spider 100 2) " ") (make-spider 100 -2))

; 2 - going up and ke is space
(check-expect (reverse-spider (make-spider 140 -3) " ") (make-spider 140 3))

; 3 - going up/down and ke is not space
(check-expect (reverse-spider (make-spider 200 5) "b") (make-spider 200 5))

;(define (reverse-spider s ke) s)

(define (reverse-spider s ke)
  (cond [(key=? ke " ") (make-spider (spider-y s)
                                     (- (spider-dy s)))]
        [else s]))

;; move spider by dy, change dir at bottom and top edges,

(check-expect (tock (make-spider 14 -3))
              (make-spider 11 -3)) ;; Boundary Case 1
(check-expect (tock (make-spider 13 -3))
              (make-spider 10 3)) ;; Boundary Up Case Normal
(check-expect (tock(make-spider 12 -3))
              (make-spider 10 3)) ;; Boundary Case -1

(check-expect (tock (make-spider 50 -3))
              (make-spider 47 -3)) ;; Normal Case Going Up
(check-expect (tock (make-spider 60 4))
              (make-spider 64 4)) ;; Normal Case Going Down

(check-expect (tock (make-spider (- BOT 3) 3))
              (make-spider BOT -3))
(check-expect (tock (make-spider (- BOT 2) 3))
              (make-spider BOT -3))
(check-expect (tock (make-spider (- BOT 4) 3))
              (make-spider (- BOT 1) 3))


;(define (tock s) s) ;stub

(define (tock s)
  (cond [(>= TOP (+ (spider-y s) (spider-dy s)))
         (make-spider TOP (- (spider-dy s)))]
        [(<= BOT (+ (spider-y s) (spider-dy s)))
         (make-spider BOT (- (spider-dy s)))]
        [else (make-spider (+ (spider-y s) (spider-dy s)) (spider-dy s))]))

#;
(define (tock s)
  (if (>= (+ s SPEED) BOT)
      BOT
      (+ s SPEED)))






;; place SPIDER-IMAGE and thread image on MTS, at spider's y coordinate

(check-expect (render (make-spider 21 2))
              (add-line (place-image SPIDER-IMAGE CTR-X 21 MTS)
                        CTR-X 0
                        CTR-X 21
                        "black"))
(check-expect (render (make-spider 36 2))
              (add-line (place-image SPIDER-IMAGE CTR-X 36 MTS)
                        CTR-X 0
                        CTR-X 36
                        "black"))

;(define (render s) MTS)

(define (render s)
  (add-line (place-image SPIDER-IMAGE CTR-X (spider-y s) MTS)
            CTR-X 0
            CTR-X (spider-y s)
            "black"))

(main S-MID-U)

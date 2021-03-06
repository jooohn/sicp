(define (make-leaf symbol weight) (list 'leaf symbol weight))
(define (leaf? object) (eq? (car object) 'leaf))
(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))
(define (make-code-tree left right)
  (list left
        right
        (append (symbols left) (symbols right))
        (+ (weight left) (weight right))))
(define (left-branch tree) (car tree))
(define (right-branch tree) (cadr tree))
(define (symbols tree)
  (if (leaf? tree)
    (list (symbol-leaf tree))
    (caddr tree)))
(define (weight tree)
  (if (leaf? tree)
    (weight-leaf tree)
    (cadddr tree)))
(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
      '()
      (let ((next-branch
              (choose-branch (car bits) current-branch)))
        (if (leaf? next-branch)
          (cons (symbol-leaf next-branch)
                (decode-1 (cdr bits) tree))
          (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))
(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
        ((= bit 1) (right-branch branch))
        (else (error "bad bit: CHOSE-BRANCH" bit))))

;2.67
(define sample-tree
  (make-code-tree (make-leaf 'A 4)
                  (make-code-tree
                    (make-leaf 'B 2)
                    (make-code-tree
                      (make-leaf 'D 1)
                      (make-leaf 'C 1)))))
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(define result-2-67 (decode sample-message sample-tree))
;result-2-67
;Value 2: (a d a b b c a)

;2.68
(define (encode message tree)
  (if (null? message)
    '()
    (append (encode-symbol (car message) tree)
            (encode (cdr message) tree))))
;(define (element-of-set? x set)
;  (cond ((null? set) false)
;        ((eq? x (car set)) true)
;        (else (element-of-set? x (cdr set)))))
(define (element-of-set? x set) (memq x set))
(define (encode-symbol symbol tree)
  (if (leaf? tree)
    (if (eq? symbol (symbol-leaf tree))
      '()
      (error "bad symbol as leaf: ENCODE-SYMBOL" symbol))
    (cond ((element-of-set? symbol (symbols (left-branch tree)))
           (cons 0 (encode-symbol symbol (left-branch tree))))
          ((element-of-set? symbol (symbols (right-branch tree)))
           (cons 1 (encode-symbol symbol (right-branch tree))))
          (else (error "bad symbol: ENCODE-SYMBOL" symbol))))))
(define result-2-68 (encode result-2-67 sample-tree))
result-2-68

;2.71
1 ~ n-1 bit

(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right) (list entry left right))
(define (tree->list-1 tree)
  (if (null? tree)
    '()
    (append (tree->list-1 (left-branch tree))
            (cons (entry tree)
                  (tree->list-1
                    (right-branch tree))))))
(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
      result-list
      (copy-to-list (left-branch tree)
                    (cons (entry tree)
                          (copy-to-list
                            (right-branch tree)
                            result-list)))))
  (copy-to-list tree '()))
(define t1 (make-tree 1 '() (make-tree 2 '() (make-tree 3 '() (make-tree 4 '() (make-tree 5 '() (make-tree 6 '() (make-tree 7 '() '()))))))))
(define t2 (make-tree 4 (make-tree 2 (make-tree 1 '() '()) (make-tree 3 '() '())) (make-tree 6 (make-tree 5 '() '()) '())))

;2.63-a
;(tree->list-1 t2)
;O(n) こっちのほうが遅い appendで末尾に足すから
;(tree->list-2 t2)
;O(n)


;2.64
(define (list->tree elements)
  (car (partial-tree elements (length elements))))
(define (partial-tree elts n)
  (if (= n 0)
    (cons '() elts)
    (let ((left-size (quotient (- n 1) 2)))
      (let ((left-result
              (partial-tree elts left-size)))
        (let ((left-tree (car left-result))
              (non-left-elts (cdr left-result))
              (right-size (- n (+ left-size 1))))
          (let ((this-entry (car non-left-elts))
                (right-result
                  (partial-tree
                    (cdr non-left-elts)
                    right-size)))
            (let ((right-tree (car right-result))
                  (remaining-elts
                    (cdr right-result)))
              (cons (make-tree this-entry
                               left-tree
                               right-tree)
                    remaining-elts))))))))
(list->tree '(1 3 5 7 9 11))
;Value 2: (5 (1 () (3 () ())) (9 (7 () ()) (11 () ())))
;O()

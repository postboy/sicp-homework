; Exercise 2.74.  Insatiable Enterprises, Inc., is a highly decentralized conglomerate company consisting of a large number of independent divisions located all over the world. The company's computer facilities have just been interconnected by means of a clever network-interfacing scheme that makes the entire network appear to any user to be a single computer. Insatiable's president, in her first attempt to exploit the ability of the network to extract administrative information from division files, is dismayed to discover that, although all the division files have been implemented as data structures in Scheme, the particular data structure used varies from division to division. A meeting of division managers is hastily called to search for a strategy to integrate the files that will satisfy headquarters' needs while preserving the existing autonomy of the divisions.

; Show how such a strategy can be implemented with data-directed programming. As an example, suppose that each division's personnel records consist of a single file, which contains a set of records keyed on employees' names. The structure of the set varies from division to division. Furthermore, each employee's record is itself a set (structured differently from division to division) that contains information keyed under identifiers such as address and salary. In particular:

; a.  Implement for headquarters a get-record procedure that retrieves a specified employee's record from a specified personnel file. The procedure should be applicable to any division's file. Explain how the individual divisions' files should be structured. In particular, what type information must be supplied?

; Individual divisions' files can be structured as their implementors wish. The only real requirement is to implement a proper interface (in this case, get-record function) and install it for calling from outer world.

; For the sake of simplicity, let's implement a single personnel file.

(load "ch24_common.scm")

; Fill alpha file with some records
(define john-info '(johnstown 100))
(put 'alpha 'john john-info)

(define (install-alpha-division)
  (define (get-record name) (get 'alpha name))
  (define (get-salary record) (cadr record))
  (put 'get-record 'alpha get-record)
  (put 'get-salary 'alpha get-salary))

(define (install-divisions)
  (install-alpha-division))

(install-divisions)

(define division-files
  (list 'alpha))

; get-record-from-file interface: return something if record is found, #f otherwise

(define (get-record file name)
  (define raw-result ((get 'get-record file) name))
  (if raw-result
      (list file raw-result)
      nil))

(define (get-file record)
  (car record))

(define (get-body record)
  (cadr record))

(define john-record (list 'alpha john-info))
(assert (get-record 'alpha 'john) john-record)
(assert (get-record 'alpha 'bob) nil)

; b.  Implement for headquarters a get-salary procedure that returns the salary information from a given employee's record from any division's personnel file. How should the record be structured in order to make this operation work?

; Again, different records under the hood can be structured as their implementors wish, we care only about proper interface. Records should contain such information that selectors will work right. To abstract out a file where record resides we can tag a record before return, then take out a tag after we've got a record.

(define (get-salary record)
  ((get 'get-salary (get-file record)) (get-body record)))

(assert (get-salary john-record) 100)

; c.  Implement for headquarters a find-employee-record procedure. This should search all the divisions' files for the record of a given employee and return the record. Assume that this procedure takes as arguments an employee's name and a list of all the divisions' files.

(define (find-employee-record files name)
  (if (null? files)
      nil
      (let ((record (get-record (car files) name)))
	(if record
	    record
	    (find-employee-record (cdr files) name)))))

(assert (find-employee-record division-files 'john) john-record)
(assert (find-employee-record division-files 'bob) nil)
(assert (find-employee-record nil 'john) nil)

; d.  When Insatiable takes over a new company, what changes must be made in order to incorporate the new personnel information into the central system?

; 1. Implementation of the interface to new file required by the central system. This part doesn't include modification of the central system code.
; Write a function analogous to install-alpha-division that will install proper get-record and get-salary implementations for new file into the system. This includes both implementations and registrations of that functions.

; 2. Integration of new module into the central system. This part consist of small modifications of the central system code.
; Add a name of new file to division-files, call a new installer function from install-divisions.

gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock onConflict: conflictBlock ensure: ensureBlock
  (System inTransaction and: [ self transactionMode ~~ #'autoBegin' ])
    ifTrue: [ 
      self
        error:
          'Expected to be outside of transaction. Use doAbortTransaction or doCommitTransaction before calling.' ].
  self
    doTransaction: [ 
      ^ self
        gemServer: aBlock
        exceptionSet: exceptionSet
        beforeUnwind: beforeUnwindBlock
        ensure: ensureBlock ]
    onConflict: conflictBlock
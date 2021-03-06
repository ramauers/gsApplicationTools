tasks
scheduleBreakpointTask
  ^ (self taskClass
    value: [ 
      | meth sel cls |
      sel := #'breakpointMethod'.
      cls := self class whichClassIncludesSelector: sel asString.
      meth := cls compiledMethodAt: sel.
      meth setBreakAtStepPoint: 1.
      GsProcess usingNativeCode
        ifTrue: [ 
          | p |
          p := GsProcess _current.
          [ p convertToPortableStack ] fork.
          Processor yield ].
      Breakpoint trappable: true.
      self breakpointMethod ])
    addToQueue: self
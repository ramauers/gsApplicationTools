service instance-server
handleRequestFromX: requestSocket
  "forked by caller"

  self
    gemServer: [ 
      | httpRequest retryCount |
      httpRequest := self readRequestFrom: requestSocket.
      retryCount := 0.
      [ retryCount < 11 ]
        whileTrue: [ 
          self
            gemServer: [ 
              | httpResponse |
              httpResponse := self processHttpRequest: httpRequest.
              self
                gemServerTransaction: [ ^ self writeResponse: httpResponse to: requestSocket ]
                exceptionSet: Error
                beforeUnwind: [ :ex | ^ self writeServerErrorTo: requestSocket ]
                onConflict: [ :conflicts | 
                  "log conflict and retry"
                  self
                    doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ] ] ].
          retryCount := retryCount + 1 ] ]
    exceptionSet: Error
    beforeUnwind: [ :ex | ^ self writeServerErrorTo: requestSocket ]
    ensure: [ requestSocket close ]